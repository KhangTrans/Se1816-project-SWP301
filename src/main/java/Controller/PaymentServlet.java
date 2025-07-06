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

        // Lấy id gói tập từ URL
        String cardIdStr = request.getParameter("cardId");
        HttpSession session = request.getSession(false);

        // Lấy accountId từ session
        Integer accountId = null;
        if (session != null) {
            Object accObj = session.getAttribute("accountId");
            if (accObj instanceof Integer) {
                accountId = (Integer) accObj;
            } else if (accObj instanceof String) {
                accountId = Integer.parseInt((String) accObj);
            }
        }

        // Lấy membership đang hoạt động nếu đã login
        CustomerMembership activeMembership = null;
        if (accountId != null) {
            CustomerDao customerDao = new CustomerDao();
            activeMembership = customerDao.getActiveMembershipByAccountId(accountId);
            request.setAttribute("activeMembership", activeMembership);
        }

        String isRenew = request.getParameter("renew");
        if ("1".equals(isRenew)) {
            request.setAttribute("renewMode", true);
        }
        

        if (cardIdStr != null) {
            int cardId = Integer.parseInt(cardIdStr);
            PackageDao packageDao = new PackageDao();
            Package pkg = packageDao.getPackageById(cardId);

            if (pkg != null) {
                // Nếu đã có gói và chưa hủy thì không cho vào trang thanh toán nữa
                if (activeMembership != null && !"cancelled".equalsIgnoreCase(activeMembership.getPaymentStatus())) {
                    if (session != null) {
                        session.setAttribute("membershipError", "Bạn đã có gói thành viên. Vui lòng hủy ở profile trước khi mua gói mới!");
                    }
                    response.sendRedirect(request.getContextPath() + "/homepage");
                    return;
                }
                // Chưa có gói hoặc gói đã huỷ, cho hiện trang đăng ký
                request.setAttribute("pkg", pkg);
                request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
            } else {
                // Không tìm thấy gói tập
                request.setAttribute("error", "Không tìm thấy gói tập!");
                request.getRequestDispatcher("/WEB-INF/View/customers/payment.jsp").forward(request, response);
            }
        } else {
            // Không truyền id gói -> về homepage
            response.sendRedirect(request.getContextPath() + "/homepage");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String renewMode = request.getParameter("renewMode");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"Bạn chưa đăng nhập!\"}");
            return;
        }

        Object accObj = session.getAttribute("accountId");
        if (accObj == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"Bạn chưa đăng nhập!\"}");
            return;
        }

        int accountId;
        if (accObj instanceof Integer) {
            accountId = (Integer) accObj;
        } else if (accObj instanceof String) {
            accountId = Integer.parseInt((String) accObj);
        } else {
            response.getWriter().write("{\"success\":false,\"message\":\"Không xác định được tài khoản!\"}");
            return;
        }

        String cardIdStr = request.getParameter("cardId");

        System.out.println("POST/payment accountId=" + accountId + " cardIdStr=" + cardIdStr);

        // --- BẮT ĐẦU: XỬ LÝ RENEW ---
        if (accountId != 0 && cardIdStr != null && !cardIdStr.trim().isEmpty()) {
            int packageId = Integer.parseInt(cardIdStr);
            PackageDao packageDao = new PackageDao();
            Package pkg = packageDao.getPackageById(packageId);

            if (pkg == null) {
                response.getWriter().write("{\"success\":false,\"message\":\"Không tìm thấy gói tập!\"}");
                return;
            }

            CustomerDao customerDao = new CustomerDao();
            UserDao userdao = new UserDao();
            CustomerMembership activeMembership = customerDao.getActiveMembershipByAccountId(accountId);

            // --------- NẾU LÀ RENEW -------------
            if ("1".equals(renewMode) && activeMembership != null && "paid".equalsIgnoreCase(activeMembership.getPaymentStatus())) {
                // Gia hạn membership: chỉ update ngày kết thúc
                java.time.LocalDate newEnd = activeMembership.getEndDate().plusDays(pkg.getDurationDays());
                boolean updated = customerDao.updateMembershipEndDate(activeMembership.getMembershipId(), newEnd);
                if (updated) {
                    response.getWriter().write("{\"success\":true,\"message\":\"Gia hạn thành công!\"}");
                } else {
                    response.getWriter().write("{\"success\":false,\"message\":\"Không thể gia hạn membership.\"}");
                }
                return;
            }
            // --------- HẾT RENEW -------------
            // Đoạn bên dưới là đăng ký mới membership (giữ nguyên)
            // Nếu đã có membership còn hạn và chưa hủy
            if (activeMembership != null && !"cancelled".equalsIgnoreCase(activeMembership.getPaymentStatus())) {
                response.getWriter().write("{\"success\":false,\"message\":\"Bạn đã có gói thành viên. Vui lòng hủy ở profile trước khi mua gói mới!\"}");
                return;
            }

            // Nếu là "cancelled" thì tiếp tục cho đăng ký!
            MembershipPackage membershipPackage = packageDao.convertToMembershipPackage(pkg);

            // LẤY TÙY CHỌN TỪ FORM (nếu có, nếu không cứ lấy ngay)
            String applyOption = request.getParameter("applyOption");
            java.time.LocalDate newStart;
            if ("applyLater".equals(applyOption) && activeMembership != null && "cancelled".equalsIgnoreCase(activeMembership.getPaymentStatus())) {
                newStart = activeMembership.getEndDate().plusDays(1);
            } else {
                newStart = java.time.LocalDate.now();
                // Nếu áp dụng NGAY thì update end_date membership cũ!
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
                response.getWriter().write("{\"success\":false,\"message\":\"Lỗi truy vấn khách hàng: " + ex.getMessage() + "\"}");
                return;
            }
            if (customer == null) {
                response.getWriter().write("{\"success\":false,\"message\":\"Không tìm thấy thông tin khách hàng!\"}");
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
                response.getWriter().write("{\"success\":true,\"message\":\"Đăng ký gói thành công!\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"Đã có lỗi xảy ra khi ghi membership. Vui lòng thử lại!\"}");
            }
        } else {
            response.getWriter().write("{\"success\":false,\"message\":\"Thiếu thông tin gói tập!\"}");
        }
    }

}
