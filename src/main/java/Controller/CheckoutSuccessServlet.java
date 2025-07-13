/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.ProductDao;
import Model.CartItem;
import Model.Products;
import Model.Voucher;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Admin
 */
@WebServlet(name = "CheckoutSuccessServlet", urlPatterns = {"/checkoutsuccess"})
public class CheckoutSuccessServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        double total = 0;
        if (cart == null || cart.isEmpty()) {
            request.setAttribute("message", "Your cart is empty.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/View/customers/checkout.jsp");
            dispatcher.forward(request, response);
            return;
        }

        ProductDao dao = new ProductDao();
        boolean enoughStock = true;
        StringBuilder errorMsg = new StringBuilder();

        // KIỂM TRA TỒN KHO
        for (CartItem item : cart) {
            int productId = item.getProductId();
            int quantity = item.getQuantity();
            Products product = null;
            try {
                product = dao.getProductById(productId);
            } catch (SQLException ex) {
                Logger.getLogger(CheckoutSuccessServlet.class.getName()).log(Level.SEVERE, null, ex);
            }

            if (product == null || product.getStockQuantity() < quantity) {
                enoughStock = false;
                errorMsg.append("Sản phẩm <b>'").append(product != null ? product.getName() : "Không xác định").append("'</b> chỉ còn ")
                        .append(product != null ? product.getStockQuantity() : 0).append(" trong kho.<br>");
            }
        }

        if (!enoughStock) {
            // Nếu thiếu hàng, quay lại trang checkout và báo lỗi
            request.setAttribute("error", errorMsg.toString());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/View/customers/checkout.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Nếu đủ hàng thì tiếp tục các bước sau:
        for (CartItem item : cart) {
            int productId = item.getProductId();
            Products product = null;
            try {
                product = dao.getProductById(productId);
            } catch (SQLException ex) {
                Logger.getLogger(CheckoutSuccessServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            if (product != null) {
                int quantity = item.getQuantity();
                double price = product.getPrice();
                double subtotal = price * quantity;
                total += subtotal;

                // Trừ số lượng trong kho
                try {
                    dao.updateProductStock(productId, product.getStockQuantity() - quantity);
                } catch (SQLException ex) {
                    Logger.getLogger(CheckoutSuccessServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }

        // Kiểm tra và áp dụng voucher nếu có
        Voucher voucher = (Voucher) session.getAttribute("voucher");
        if (voucher != null) {
            BigDecimal discountAmount = BigDecimal.valueOf(total).multiply(BigDecimal.valueOf(voucher.getDiscountPercent() / 100.0));
            if (discountAmount.compareTo(voucher.getMaxDiscount()) > 0) {
                discountAmount = voucher.getMaxDiscount();
            }
            total -= discountAmount.doubleValue();
            request.setAttribute("voucher", voucher);
            request.setAttribute("discountAmount", discountAmount);
        }

        // Lưu thông tin vào session
        String customerName = request.getParameter("customerName");
        String customerPhone = request.getParameter("customerPhone");

        session.setAttribute("customerName", customerName);
        session.setAttribute("customerPhone", customerPhone);

        // Lưu tổng vào request để sử dụng trong JSP
        request.setAttribute("cart", cart);
        request.setAttribute("total", total);
        request.setAttribute("customerName", customerName);
        request.setAttribute("customerPhone", customerPhone);

        // Xóa giỏ hàng khỏi session và DB
        try {
            dao.clearCart((Integer) session.getAttribute("accountId"));
        } catch (SQLException ex) {
            Logger.getLogger(CheckoutSuccessServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        // Chuyển tới trang thành công
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/View/customers/checkout_success.jsp");
        dispatcher.forward(request, response);
    }
}
