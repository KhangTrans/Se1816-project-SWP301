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

@MultipartConfig
@WebServlet(name = "PaymentServlet", urlPatterns = {"/payment"})
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String cardIdStr = request.getParameter("cardId");
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
        if (accountId != null) {
            CustomerDao customerDao = new CustomerDao();
            activeMembership = customerDao.getActiveMembershipByAccountId(accountId);
            request.setAttribute("activeMembership", activeMembership);
        }

        if (cardIdStr != null) {
            int cardId = Integer.parseInt(cardIdStr);
            PackageDao packageDao = new PackageDao();
            Package pkg = packageDao.getPackageById(cardId);

            if (pkg != null) {
                if (activeMembership != null && !"cancelled".equalsIgnoreCase(activeMembership.getPaymentStatus())) {
                    // Báo lỗi qua session và redirect
                    if (session != null) {
                        session.setAttribute("membershipError", "Bạn đã có gói thành viên. Vui lòng hủy ở profile trước khi mua gói mới!");
                    }
                    response.sendRedirect(request.getContextPath() + "/package-details?id=" + cardIdStr);
                    return;
                }
                request.setAttribute("pkg", pkg);
                request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Không tìm thấy gói tập!");
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
            request.setAttribute("error", "Không xác định được tài khoản!");
            request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
            return;
        }

        String cardIdStr = request.getParameter("cardId");
        if (cardIdStr == null || cardIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Thiếu thông tin gói tập!");
            request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
            return;
        }
        int packageId = Integer.parseInt(cardIdStr);

        PackageDao packageDao = new PackageDao();
        Package pkg = packageDao.getPackageById(packageId);
        if (pkg == null) {
            request.setAttribute("error", "Không tìm thấy gói tập!");
            request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
            return;
        }

        CustomerDao customerDao = new CustomerDao();
        UserDao userdao = new UserDao();
        CustomerMembership activeMembership = customerDao.getActiveMembershipByAccountId(accountId);

        // Nếu đã có membership còn hạn và chưa hủy
        if (activeMembership != null && !"cancelled".equalsIgnoreCase(activeMembership.getPaymentStatus())) {
            // Báo lỗi qua session và redirect
            session.setAttribute("membershipError", "Bạn đã có gói thành viên. Vui lòng hủy ở profile trước khi mua gói mới!");
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
        } catch (Exception ex) {
            request.setAttribute("error", "Lỗi truy vấn khách hàng: " + ex.getMessage());
            request.setAttribute("pkg", pkg);
            request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
            return;
        }
        if (customer == null) {
            request.setAttribute("error", "Không tìm thấy thông tin khách hàng!");
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
        membership.setPaymentStatus("PAID");

        boolean added = customerDao.addMembership(membership);

        if (added) {
            request.setAttribute("success", "Đăng ký gói thành công!");
        } else {
            request.setAttribute("error", "Đã có lỗi xảy ra khi ghi membership. Vui lòng thử lại!");
        }
        request.setAttribute("pkg", pkg); // Để vẫn show thông tin gói

        request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
    }
}
