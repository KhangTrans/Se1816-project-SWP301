/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ControllerAdmin;

import DAO.AccountDao;
import DAO.LoginLogDao;
import DAO.UserDao;
import Model.Account;
import Model.LoginLog;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Admin
 */
@WebServlet(name = "LoginLogServlet", urlPatterns = {"/admin/loginLog"})
public class LoginLogServlet extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<LoginLog> logs = new LoginLogDao().getAllLogs();

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        org.json.JSONArray jsonArray = new org.json.JSONArray();

        for (int i = 0; i < logs.size(); i++) {
            LoginLog log = logs.get(i);
            org.json.JSONObject obj = new org.json.JSONObject();
            obj.put("index", i + 1);
            obj.put("username", log.getAccount().getUsername());
            obj.put("loginTime", log.getLoginTime().toString());
            obj.put("ip", log.getIpAddress());
            obj.put("userAgent", log.getUserAgent());
            jsonArray.put(obj);
        }

        response.getWriter().write(jsonArray.toString());

    }

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

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Account acc = null;
        try {
            acc = new UserDao().loginAndReturnAccount(username, password);
        } catch (SQLException ex) {
            Logger.getLogger(LoginLogServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (acc != null) {
            // Ghi log đăng nhập
            String ip = request.getRemoteAddr();
            String userAgent = request.getHeader("User-Agent");
            new LoginLogDao().insertLog(acc.getAccountId(), ip, userAgent);

            // Lưu session
            HttpSession session = request.getSession();
            session.setAttribute("account", acc);

            // Chuyển đến trang chính admin
            response.sendRedirect("admin/dashboard.jsp");
        } else {
            request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }

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
