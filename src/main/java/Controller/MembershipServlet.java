/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Le Nguyen Hoang Khang - CE191583
 */
@MultipartConfig
@WebServlet(name = "MembershipServlet", urlPatterns = {"/MembershipServlet"})
public class MembershipServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuẩn bị data...
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        Integer accountId = null;
        if (session != null) {
            Object accObj = session.getAttribute("accountId");
            if (accObj instanceof Integer) {
                accountId = (Integer) accObj;
            } else if (accObj instanceof String) {
                accountId = Integer.parseInt((String) accObj);
            }
        }

        Model.CustomerMembership activeMembership = null;
        Long daysLeft = null;
        Model.CustomerMembership upcomingMembership = null;

        if (accountId != null) {
            DAO.CustomerDao customerDao = new DAO.CustomerDao();
            activeMembership = customerDao.getActiveMembershipByAccountId(accountId);
            // Tính daysLeft nếu muốn
            if (activeMembership != null && activeMembership.getEndDate() != null) {
                daysLeft = java.time.temporal.ChronoUnit.DAYS.between(java.time.LocalDate.now(), activeMembership.getEndDate());
            }
            // Lấy pending membership kế tiếp (nếu có)
            upcomingMembership = customerDao.getUpcomingMembership(accountId, java.time.LocalDate.now());
            request.setAttribute("activeMembership", activeMembership);
            request.setAttribute("daysLeft", daysLeft);
            request.setAttribute("upcomingMembership", upcomingMembership); 
        }
        DAO.PackageDao packageDao = new DAO.PackageDao();
        List<Model.Package> packages = packageDao.getAllPackages();
        request.setAttribute("membership_packages", packages);

        // Forward về block JSP
        request.getRequestDispatcher("/WEB-INF/include/membershipInfo.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        String action = request.getParameter("action");
        boolean success = false;
        String message = "";

        try {
            int membershipId = Integer.parseInt(request.getParameter("membershipId"));
            DAO.CustomerDao dao = new DAO.CustomerDao();

            if (null == action) {
                message = "Invalid action!";
            } else {
                switch (action) {
                    case "renew":
                        int duration = Integer.parseInt(request.getParameter("packageDuration"));
                        Model.CustomerMembership m = dao.getMembershipById(membershipId);
                        if (m != null && "paid".equalsIgnoreCase(m.getPaymentStatus())) {
                            java.time.LocalDate newEnd = m.getEndDate().plusDays(duration);
                            dao.updateMembershipEndDate(membershipId, newEnd);
                            success = true;
                        } else {
                            message = "Can only renew when package is active";
                        }
                        break;
                    case "delete":
                        m = dao.getMembershipById(membershipId);
                        if (m != null) {
                            if ("pending".equalsIgnoreCase(m.getPaymentStatus())) {
                                success = dao.deleteMembership(membershipId); // xóa luôn bản ghi
                            } else {
                                dao.cancelMembership(membershipId); // cập nhật status = cancelled
                                success = true;
                            }
                        } else {
                            message = "Membership not found!";
                        }
                        break;
                    default:
                        message = "Invalid action!";
                        break;
                }
            }
        } catch (Exception ex) {
            success = false;
            message = ex.getMessage();
        }

        // Trả kết quả về cho AJAX
        response.getWriter().write("{\"success\":" + success + ",\"message\":\"" + message + "\"}");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
