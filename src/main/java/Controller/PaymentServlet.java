package Controller;

import DAO.CustomerDao;
import DAO.PackageDao;
import DAO.UserDao;
import Model.Customer;
import Model.Package;
import Model.CustomerMembership;
import Model.MembershipPackage;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;

@MultipartConfig
@WebServlet(name = "PaymentServlet", urlPatterns = {"/payment"})
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String cardIdStr = request.getParameter("cardId");
        String renewParam = request.getParameter("renew"); // ← ADDED THIS LINE
        boolean renewMode = "1".equals(renewParam) || "true".equalsIgnoreCase(renewParam);
        request.setAttribute("renewMode", renewMode);
        HttpSession session = request.getSession(false);

        Integer accountId = null;
        if (session != null) {
            Object accObj = session.getAttribute("accountId");
            if (accObj instanceof Integer) {
                accountId = (Integer) accObj;
            } else if (accObj instanceof String) {
                accountId = Integer.parseInt((String) accObj);
            }
        }

        CustomerMembership activeMembership = null;
        CustomerMembership upcomingMembership = null;

        if (accountId != null) {
            CustomerDao customerDao = new CustomerDao();
            activeMembership = customerDao.getActiveMembershipByAccountId(accountId);
            upcomingMembership = customerDao.getUpcomingMembership(accountId, java.time.LocalDate.now());
            request.setAttribute("activeMembership", activeMembership);
            request.setAttribute("upcomingMembership", upcomingMembership);
        }

        if (cardIdStr != null) {
            int cardId = Integer.parseInt(cardIdStr);
            PackageDao packageDao = new PackageDao();
            Package pkg = packageDao.getPackageById(cardId);

            // Block new purchase if active or upcoming membership exists
            if (!renewMode) {
                if (activeMembership != null && !"cancelled".equalsIgnoreCase(activeMembership.getPaymentStatus())) {
                    if (session != null) {
                        session.setAttribute("membershipError", "You already have an active membership. Please cancel it in your profile before purchasing a new package!");
                    }
                    response.sendRedirect(request.getContextPath() + "/package-details?id=" + cardIdStr);
                    return;
                }
                if (upcomingMembership != null) {
                    if (session != null) {
                        session.setAttribute("membershipError", "You already have an upcoming membership package. You cannot purchase a new package until this one is activated.");
                    }
                    response.sendRedirect(request.getContextPath() + "/package-details?id=" + cardIdStr);
                    return;
                }
            }

            if (pkg != null) {
                request.setAttribute("pkg", pkg);
                request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Package not found!");
                request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("/homepage");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("accountId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Object accObj = session.getAttribute("accountId");
        int accountId;
        if (accObj instanceof Integer) {
            accountId = (Integer) accObj;
        } else if (accObj instanceof String) {
            accountId = Integer.parseInt((String) accObj);
        } else {
            request.setAttribute("error", "Unable to identify the account!");
            request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
            return;
        }

        String cardIdStr = request.getParameter("cardId");
        if (cardIdStr == null || cardIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Package information is missing!");
            request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
            return;
        }
        int packageId = Integer.parseInt(cardIdStr);

        PackageDao packageDao = new PackageDao();
        Package pkg = packageDao.getPackageById(packageId);
        if (pkg == null) {
            request.setAttribute("error", "Package not found!");
            request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
            return;
        }

        CustomerDao customerDao = new CustomerDao();
        UserDao userdao = new UserDao();
        CustomerMembership activeMembership = customerDao.getActiveMembershipByAccountId(accountId);
        String renewParam = request.getParameter("renew");
        boolean renewMode = "1".equals(renewParam) || "true".equalsIgnoreCase(renewParam);

        // If there is an active membership and it is not cancelled
        if (renewMode) {
            // **Renew active membership**
            if (activeMembership != null && "paid".equalsIgnoreCase(activeMembership.getPaymentStatus())) {
                java.time.LocalDate newEnd = activeMembership.getEndDate().plusDays(pkg.getDurationDays());
                customerDao.updateMembershipEndDate(activeMembership.getMembershipId(), newEnd);

                request.setAttribute("success", "Renewal successful! Your package has been extended until " + newEnd + ".");
                request.setAttribute("pkg", pkg);
                request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Active membership not found for renewal.");
                request.setAttribute("pkg", pkg);
                request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
            }
        } else {
            // **New registration as before (do not change old code)**
            if (activeMembership != null && !"cancelled".equalsIgnoreCase(activeMembership.getPaymentStatus())) {
                session.setAttribute("membershipError", "You already have a membership package. Please cancel it in your profile before buying a new one!");
                response.sendRedirect(request.getContextPath() + "/package-details?id=" + cardIdStr);
                return;
            }

            MembershipPackage membershipPackage = packageDao.convertToMembershipPackage(pkg);

            String applyOption = request.getParameter("applyOption");
            java.time.LocalDate newStart;
            if ("applyLater".equals(applyOption) && activeMembership != null && "cancelled".equalsIgnoreCase(activeMembership.getPaymentStatus())) {
                newStart = activeMembership.getEndDate().plusDays(1);
            } else {
                newStart = java.time.LocalDate.now();
                if (activeMembership != null && "cancelled".equalsIgnoreCase(activeMembership.getPaymentStatus())) {
                    customerDao.updateMembershipEndDate(activeMembership.getMembershipId(), newStart.minusDays(1));
                }
            }
            java.time.LocalDate newEnd = newStart.plusDays(pkg.getDurationDays());

            CustomerMembership membership = new CustomerMembership();
            Customer customer = null;
            try {
                customer = userdao.getCustomerByAccountId(accountId);
            } catch (SQLException ex) {
                request.setAttribute("error", "Customer query error: " + ex.getMessage());
                request.setAttribute("pkg", pkg);
                request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
                return;
            }
            if (customer == null) {
                request.setAttribute("error", "Customer information not found!");
                request.setAttribute("pkg", pkg);
                request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
                return;
            }
            if (customer.getAccount() == null) {
                customer.setAccount(new Model.Account());
            }
            customer.getAccount().setAccountId(accountId);

            membership.setCustomer(customer);
            membership.getCustomer().getAccount().setAccountId(accountId);
            membership.setMembershipPackage(membershipPackage);
            membership.setStartDate(newStart);
            membership.setEndDate(newEnd);
            membership.setPaymentStatus("PENDING");

            boolean added = customerDao.addMembership(membership);

            if (added) {
                request.setAttribute("success", "Package registration successful!");
            } else {
                request.setAttribute("error", "An error occurred while saving membership. Please try again!");
            }
            request.setAttribute("pkg", pkg);

            request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
        }
    }
}
