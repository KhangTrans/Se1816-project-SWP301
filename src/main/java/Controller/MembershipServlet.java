/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Le Nguyen Hoang Khang - CE191583
 */
@WebServlet(name = "MembershipServlet", urlPatterns = {"/MembershipServlet"})
public class MembershipServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet MembershipServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MembershipServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
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
