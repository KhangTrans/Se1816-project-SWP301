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
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/payment")
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

        // Lấy activeMembership cho user hiện tại
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
                request.setAttribute("pkg", pkg);
                request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Không tìm thấy gói tập!");
                request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("membership");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Object accObj = session.getAttribute("accountId");
        if (accObj == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int accountId;
        if (accObj instanceof Integer) {
            accountId = (Integer) accObj;
        } else if (accObj instanceof String) {
            accountId = Integer.parseInt((String) accObj);
        } else {
            response.sendRedirect("login.jsp");
            return;
        }

        String cardIdStr = request.getParameter("cardId");
        if (accountId != 0 && cardIdStr != null) {
            int packageId = Integer.parseInt(cardIdStr);
            PackageDao packageDao = new PackageDao();
            Package pkg = packageDao.getPackageById(packageId);

            if (pkg == null) {
                request.setAttribute("error", "Không tìm thấy gói tập!");
                request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
                return;
            }

            // 🚫 Kiểm tra membership đã tồn tại chưa
            CustomerDao customerDao = new CustomerDao();
            UserDao userdao = new UserDao();
            CustomerMembership activeMembership = customerDao.getActiveMembershipByAccountId(accountId);
            request.setAttribute("activeMembership", activeMembership);

            long daysLeft = 0;
            if (activeMembership != null) {
                java.time.LocalDate now = java.time.LocalDate.now();
                java.time.LocalDate end = activeMembership.getEndDate();
                daysLeft = java.time.temporal.ChronoUnit.DAYS.between(now, end);
                if (daysLeft < 0) {
                    daysLeft = 0;
                }
                request.setAttribute("daysLeft", daysLeft);
            }

            if (activeMembership != null && !"cancelled".equalsIgnoreCase(activeMembership.getPaymentStatus())) {
                // Nếu membership tồn tại và KHÔNG phải "cancelled" thì mới chặn đăng ký mới
                request.setAttribute("pkg", pkg);
                request.setAttribute("error", "Bạn đã có một gói membership đang hoạt động và không thể đăng ký thêm.");
                response.sendRedirect(request.getContextPath() + "/homepage");
                return;
            }
            // Nếu là "cancelled" thì tiếp tục cho đăng ký!

            // ✅ Tiếp tục tạo mới membership nếu hợp lệ
            MembershipPackage membershipPackage = packageDao.convertToMembershipPackage(pkg);

            // LẤY TÙY CHỌN TỪ FORM
            String applyOption = request.getParameter("applyOption"); // Có thể là "applyNow" hoặc "applyLater"
            java.time.LocalDate newStart;
            if ("applyLater".equals(applyOption) && activeMembership != null && "cancelled".equals(activeMembership.getPaymentStatus())) {
                newStart = activeMembership.getEndDate().plusDays(1);
            } else {
                newStart = java.time.LocalDate.now();
                // Nếu áp dụng NGAY thì update end_date membership cũ!
                if (activeMembership != null && "cancelled".equals(activeMembership.getPaymentStatus())) {
                    // Update end_date của gói cũ về ngày hiện tại
                    customerDao.updateMembershipEndDate(activeMembership.getMembershipId(), newStart.minusDays(1));
                }
            }
            java.time.LocalDate newEnd = newStart.plusDays(pkg.getDurationDays());

            CustomerMembership membership = new CustomerMembership();
            Customer customer = null;
            try {
                customer = userdao.getCustomerByAccountId(accountId);
            } catch (SQLException ex) {
                Logger.getLogger(PaymentServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            if (customer == null) {
                System.out.println("DEBUG: customer là null");
                // Có thể chuyển hướng về trang báo lỗi ở đây luôn!
                request.setAttribute("error", "Không tìm thấy thông tin khách hàng!");
                request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
                return;
            }
            if (customer.getAccount() == null) {
                System.out.println("DEBUG: account là null");
                // Có thể tạo mới hoặc báo lỗi, tuỳ ý
                customer.setAccount(new Model.Account());
            }

            System.out.println("membership: " + membership);
            System.out.println("membership.getCustomer(): " + (membership != null ? membership.getCustomer() : "null"));
            System.out.println("membership.getCustomer().getAccount(): "
                    + (membership != null && membership.getCustomer() != null ? membership.getCustomer().getAccount() : "null"));
            customer.getAccount().setAccountId(accountId);
            membership.setCustomer(customer);
            membership.getCustomer().getAccount().setAccountId(accountId);
            membership.setMembershipPackage(membershipPackage);
            membership.setStartDate(newStart);
            membership.setEndDate(newEnd);
            membership.setPaymentStatus("PAID");

            boolean added = customerDao.addMembership(membership);

            if (added) {
                request.setAttribute("pkg", pkg);
                request.setAttribute("success", "Thanh toán thành công! Bạn đã đăng ký gói " + pkg.getName() + ". Sẽ tự động chuyển về trang chủ sau vài giây.");
                request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
            } else {
                request.setAttribute("pkg", pkg);
                request.setAttribute("error", "Đã có lỗi xảy ra khi ghi membership. Vui lòng thử lại!");
                request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}
