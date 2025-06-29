/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ControllerAdmin;

import DAO.AccountDao;
import DAO.BlogDao;
import DAO.MemberDao;
import DAO.ProductDao;
import DAO.StaffDao;
import DAO.TrainerDao;
import DAO.VoucherDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Admin
 */
@WebServlet(name = "HomePageAdminServlet", urlPatterns = {"/admin/home"})
public class HomePageAdminServlet extends HttpServlet {

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
        try {
            // Tạo DAO
            AccountDao accountDao = new AccountDao();
            TrainerDao trainerDao = new TrainerDao();
            StaffDao staffDao = new StaffDao();
            ProductDao productDao = new ProductDao();
            MemberDao memberDao = new MemberDao();
            BlogDao blogDao = new BlogDao();
            VoucherDao voucherDao = new VoucherDao();

            // Gán số lượng cho request
            request.setAttribute("accountCount", accountDao.countAccounts());
            request.setAttribute("trainerCount", trainerDao.countTrainers());
            request.setAttribute("staffCount", staffDao.countStaff());
            request.setAttribute("productCount", productDao.countProductsInStock());
            request.setAttribute("memberCount", memberDao.countMembers());
            request.setAttribute("blogCount", blogDao.countBlogs());
            request.setAttribute("voucherCount", voucherDao.countVouchers());

        } catch (Exception e) {
            e.printStackTrace();
        }
        request.getRequestDispatcher("/WEB-INF/View/admin/adminHome.jsp").forward(request, response);
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
