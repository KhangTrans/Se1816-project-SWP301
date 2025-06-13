/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ControllerAdmin;

import DAO.UserDao;
import Model.Staff;
import com.google.gson.Gson;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Le Nguyen Hoang Khang - CE191583
 */
@WebServlet(name = "StaffServlet", urlPatterns = {"/admin/staffs"})
public class StaffServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();

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
            out.println("<title>Servlet StaffServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet StaffServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

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
        }

        try {
            UserDao dao = new UserDao();
            switch (action) {
                case "ajaxList": {
                    List<Staff> staffList = dao.getAllStaffs();
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    String json = new Gson().toJson(staffList);
                    response.getWriter().write(json);
                    return;
                }
//                case "edit": {
//                    int id = Integer.parseInt(request.getParameter("id"));
//                    Staff staff = dao.getStaffById(id);
//                    request.setAttribute("staff", staff);
//                    request.getRequestDispatcher("/WEB-INF/View/admin/staffs/edit.jsp").forward(request, response);
//                    break;
//                }
//                case "delete": {
//                    int id = Integer.parseInt(request.getParameter("id"));
//                    dao.deleteStaff(id);
//                    response.setContentType("text/plain");
//                    response.getWriter().write("OK");
//                    break;
//                }
                default: {
                    List<Staff> staffList = dao.getAllStaffs();
                    request.setAttribute("staffList", staffList);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/View/admin/staffs/list.jsp");
                    dispatcher.forward(request, response);
                    break;
                }
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý dữ liệu nhân viên.");
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
        processRequest(request, response);
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
