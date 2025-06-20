/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ControllerAdmin;

import DAO.UserDao;
import Model.Account;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Admin
 */
@MultipartConfig
@WebServlet(name = "AccountServlet", urlPatterns = {"/admin/accounts"})
public class AccountServlet extends HttpServlet {
    private UserDao dao;
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
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
            try {
                List<Account> accounts = dao.getAllAccounts();
                request.setAttribute("accounts", accounts);
                request.getRequestDispatcher("/WEB-INF/View/admin/accounts/list.jsp").forward(request, response);
            } catch (SQLException ex) {
                Logger.getLogger(AccountServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        try {
            UserDao dao = new UserDao();
            switch (action) {
                case "ajaxList": {
                    List<Account> accountList = dao.getAllAccounts();
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    String json = new com.google.gson.Gson().toJson(accountList);
                    response.getWriter().write(json);
                    return;
                }
                case "edit": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Account acc = dao.getAccountById(id);
                    request.setAttribute("account", acc);
                    request.getRequestDispatcher("/WEB-INF/View/admin/accounts/edit.jsp").forward(request, response);
                    break;
                }
                case "delete": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    dao.deleteAccount(id);
                    response.setContentType("text/plain");
                    response.getWriter().write("OK");
                    break;
                }
                default: {
                    List<Account> accountList = dao.getAllAccounts();
                    request.setAttribute("accountList", accountList);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/View/admin/adminHome.jsp");
                    dispatcher.forward(request, response);
                    break;
                }
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý dữ liệu tài khoản.");
        }
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
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        UserDao dao = new UserDao();

        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            String authProvider = request.getParameter("auth_provider");
            if (authProvider == null || authProvider.isEmpty()) {
                authProvider = "internal"; // Mặc định nếu không truyền
            }

            Part avatarPart = null;
            InputStream avatarStream = null;
            try {
                avatarPart = request.getPart("avatar");
                if (avatarPart != null && avatarPart.getSize() > 0) {
                    avatarStream = avatarPart.getInputStream();
                }
            } catch (IllegalStateException | ServletException e) {
                avatarStream = null; // Nếu không có multipart thì bỏ qua
            }

            switch (action) {
                case "create":
                    if (username == null || username.trim().isEmpty()) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.getWriter().write("Username cannot be empty.");
                        return;
                    }

                    if (dao.isUsernameExists(username)) {
                        response.setStatus(HttpServletResponse.SC_CONFLICT);
                        response.getWriter().write("Username already exists.");
                        return;
                    }

                    dao.createAccount(username, password, role, avatarStream, authProvider);
                    response.setContentType("text/plain");
                    response.getWriter().write("OK");
                    break;

                case "update":
                    int accountId = Integer.parseInt(request.getParameter("accountId"));
                    // Kiểm tra nếu người dùng có upload ảnh mới
                    if (avatarPart != null && avatarPart.getSize() > 0) {
                        dao.updateAccount(accountId, username, password, role, avatarStream); // có ảnh mới
                    } else {
                        dao.updateAccount(accountId, username, password, role, null); // không có ảnh → giữ ảnh cũ
                    }

                    response.setContentType("text/plain");
                    response.getWriter().write("OK");
                    break;

                case "delete":
                    int deleteId = Integer.parseInt(request.getParameter("accountId"));
                    dao.deleteAccount(deleteId);
                    response.setContentType("text/plain");
                    response.getWriter().write("OK");
                    break;
                case "ajaxList":
                    List<Account> accountList = dao.getAllAccounts();
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    String json = new com.google.gson.Gson().toJson(accountList);
                    response.getWriter().write(json);
                    break;

                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Không xác định được action.");
            }

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý thêm/sửa tài khoản.");
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
