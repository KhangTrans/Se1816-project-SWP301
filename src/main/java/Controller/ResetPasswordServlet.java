/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.UserDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import org.json.JSONObject;

/**
 *
 * @author Admin
 */
public class ResetPasswordServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JSONObject json = new JSONObject();

        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");

        HttpSession session = request.getSession();
        String storedOtp = (String) session.getAttribute("otp_" + email);

        if (storedOtp == null) {
            json.put("status", "error");
            json.put("message", "OTP has expired or not requested.");
        } else if (!storedOtp.equals(otp)) {
            json.put("status", "error");
            json.put("message", "Incorrect OTP.");
        } else {
            try {
                UserDao dao = new UserDao();
                boolean updated = dao.updatePasswordByEmail(email, newPassword);
                if (updated) {
                    json.put("status", "success");
                    json.put("message", "Password reset successfully!");
                    session.removeAttribute("otp_" + email); // xóa OTP sau khi dùng
                } else {
                    json.put("status", "error");
                    json.put("message", "Failed to update password.");
                }
            } catch (Exception e) {
                json.put("status", "error");
                json.put("message", "Error: " + e.getMessage());
            }
        }

        response.getWriter().write(json.toString());
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
