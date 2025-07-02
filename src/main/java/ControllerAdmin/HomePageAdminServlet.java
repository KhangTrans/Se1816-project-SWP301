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
import jakarta.servlet.http.HttpSession;

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
            // Lấy tài khoản từ session
            HttpSession session = request.getSession(false);
            Model.Account account = (Model.Account) session.getAttribute("account");

            if (account == null) {
                // Chưa đăng nhập → chuyển hướng
                response.sendRedirect(request.getContextPath() + "/loginAdmin");
                return;
            }

            String role = account.getRole(); // "admin" hoặc "staff"
            request.setAttribute("role", role);

            TrainerDao trainerDao = new TrainerDao();
            ProductDao productDao = new ProductDao();
            MemberDao memberDao = new MemberDao();
            BlogDao blogDao = new BlogDao();
            VoucherDao voucherDao = new VoucherDao();

            // Luôn có
            request.setAttribute("trainerCount", trainerDao.countTrainers());
            request.setAttribute("productCount", productDao.countProductsInStock());
            request.setAttribute("memberCount", memberDao.countMembers());
            request.setAttribute("blogCount", blogDao.countBlogs());
            request.setAttribute("voucherCount", voucherDao.countVouchers());

            // Nếu là admin thì gán thêm
            if ("admin".equalsIgnoreCase(role)) {
                AccountDao accountDao = new AccountDao();
                StaffDao staffDao = new StaffDao();
                request.setAttribute("accountCount", accountDao.countAccounts());
                request.setAttribute("staffCount", staffDao.countStaff());
            }

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
