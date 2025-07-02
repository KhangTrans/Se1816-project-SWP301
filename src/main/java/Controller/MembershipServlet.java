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
        if (accountId != null) {
            DAO.CustomerDao customerDao = new DAO.CustomerDao();
            activeMembership = customerDao.getActiveMembershipByAccountId(accountId);
            // Tính daysLeft nếu muốn
            if (activeMembership != null && activeMembership.getEndDate() != null) {
                daysLeft = java.time.temporal.ChronoUnit.DAYS.between(java.time.LocalDate.now(), activeMembership.getEndDate());
            }
            request.setAttribute("activeMembership", activeMembership);
            request.setAttribute("daysLeft", daysLeft);
        }
        DAO.PackageDao packageDao = new DAO.PackageDao();
        List<Model.Package> packages = packageDao.getAllPackages();
        request.setAttribute("membership_packages", packages);

        // Forward về block JSP
        request.getRequestDispatcher("/WEB-INF/include/membershipCard.jsp")
                .forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        String action = request.getParameter("action");
        boolean success = false;
        String message = "";

        try {
            int membershipId = Integer.parseInt(request.getParameter("membershipId"));
            DAO.CustomerDao dao = new DAO.CustomerDao();

            if ("renew".equals(action)) {
                int duration = Integer.parseInt(request.getParameter("packageDuration"));
                // Lấy membership hiện tại
                Model.CustomerMembership m = dao.getMembershipById(membershipId);
                if (m != null) {
                    java.time.LocalDate newEnd = m.getEndDate().plusDays(duration);
                    dao.updateMembershipEndDate(membershipId, newEnd);
                    success = true;
                } else {
                    message = "Không tìm thấy membership!";
                }
            } else if ("delete".equals(action)) {
                // Chỉ cần update payment_status thành "cancelled"
                dao.cancelMembership(membershipId);
                success = true;
            } else {
                message = "Action không hợp lệ!";
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
