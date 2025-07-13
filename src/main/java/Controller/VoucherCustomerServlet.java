/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

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
@WebServlet(name = "VoucherCustomerServlet", urlPatterns = {"/customerVochers"})
public class VoucherCustomerServlet extends HttpServlet {

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
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            int voucherId = Integer.parseInt(request.getParameter("voucherId"));

            // Lấy ID khách hàng từ session (đảm bảo bạn đã lưu khi đăng nhập)
            //HttpSession session = request.getSession();
            HttpSession session = request.getSession(false);
            if (session == null) {
                out.print("{\"status\":\"fail\", \"message\":\"Session null!\"}");
                return;
            }
            Integer accountId = (Integer) session.getAttribute("accountId"); // ✅ đúng với DB

            System.out.println("VoucherCustomerServlet >> accountId from session: " + accountId);

            if (accountId == null) {
                out.print("{\"status\":\"fail\", \"message\":\"Bạn cần đăng nhập để thu thập voucher.\"}");
                return;
            }

            VoucherDao dao = new VoucherDao();
            boolean claimed = dao.claimVoucher(voucherId, accountId);

            if (claimed) {
                out.print("{\"status\":\"success\", \"message\":\"Thu thập thành công!\"}");
            } else {
                out.print("{\"status\":\"info\", \"message\":\"Bạn đã thu thập voucher này rồi.\"}");
            }

        } catch (Exception e) {
            out.print("{\"status\":\"error\", \"message\":\"Lỗi: " + e.getMessage().replace("\"", "\\\"") + "\"}");
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
