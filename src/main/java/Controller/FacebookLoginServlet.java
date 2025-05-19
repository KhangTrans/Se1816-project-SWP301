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
import java.io.BufferedReader;
import java.sql.SQLException;
import org.json.JSONObject;

/**
 *
 * @author Admin
 */
public class FacebookLoginServlet extends HttpServlet {

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

        try ( BufferedReader reader = request.getReader()) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            JSONObject profile = new JSONObject(sb.toString());
            String fbId = profile.getString("id");
            String name = profile.optString("name", "No Name");
            String avatar = "https://graph.facebook.com/" + profile.getString("id") + "/picture?type=large"; // ⬅️ ảnh đại diện
            String email = profile.optString("email", "fbuser_" + fbId + "@noemail.com");

            // Tự động lưu vào database nếu chưa có
            UserDao dao = new UserDao();
            dao.quickRegisterIfNotExistsF(email, name, email);

            // Lưu session
            HttpSession session = request.getSession();
            session.setAttribute("username", email);
            session.setAttribute("avatar", avatar);
            session.setAttribute("role", "customer");

            json.put("status", "success");
            json.put("message", "Facebook login success!");

        } catch (Exception e) {
            json.put("status", "error");
            json.put("message", "Facebook login failed: " + e.getMessage());
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
