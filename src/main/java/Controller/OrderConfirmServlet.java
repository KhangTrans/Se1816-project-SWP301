/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.OrderDao;
import DAO.VoucherDao;
import Model.Order;
import Model.OrderItem;
import Model.Voucher;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.List;

/**
 *
 * @author Admin
 */
@WebServlet(name = "OrderConfirmServlet", urlPatterns = {"/orderconfirm"})
public class OrderConfirmServlet extends HttpServlet {

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
        String orderIdParam = request.getParameter("orderId");
        Integer orderId = null;

        if (orderIdParam != null && !orderIdParam.isEmpty()) {
            try {
                orderId = Integer.parseInt(orderIdParam);
            } catch (NumberFormatException e) {
                response.sendRedirect("cart.jsp?error=invalidOrderId");
                return;
            }
        }

        if (orderId == null) {
            response.sendRedirect("cart.jsp?error=noOrderId");
            return;
        }

        // Lấy thông tin đơn hàng từ cơ sở dữ liệu
        OrderDao orderDao = new OrderDao();
        Order order = orderDao.getOrderById(orderId);

        if (order == null) {
            response.sendRedirect("cart.jsp?error=orderNotFound");
            return;
        }

        // Lấy các sản phẩm trong đơn hàng
        List<OrderItem> orderItems = orderDao.getOrderItemsByOrderId(orderId);
        order.setOrderItems(orderItems);  // Thiết lập các sản phẩm vào đối tượng Order

        // Lấy voucher đã áp dụng
        VoucherDao voucherDao = new VoucherDao();
        Voucher appliedVoucher = voucherDao.getVoucherByReferralCode(order.getReferralCode());
        BigDecimal discountAmount = voucherDao.getDiscountAmountByOrderId(orderId);

        // Thiết lập thông tin vào request để truyền cho JSP
        request.setAttribute("order", order);
        request.setAttribute("voucher", appliedVoucher);
        request.setAttribute("discountAmount", discountAmount); 

        // Forward yêu cầu đến trang xác nhận đơn hàng
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/View/customers/orderConfirmation.jsp");
        dispatcher.forward(request, response);
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
