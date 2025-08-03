/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.BuyNowDao;
import DAO.OrderDao;
import DAO.ProductDao;
import DAO.VoucherDao;
import Model.Account;
import Model.CartItem;
import Model.Order;
import Model.OrderItem;
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
        try {
            HttpSession session = request.getSession();
            Integer accountId = (Integer) session.getAttribute("accountId");
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

            // Lấy thông tin khách hàng từ form
            String customerName = request.getParameter("customerName");
            String customerPhone = request.getParameter("customerPhone");
            String shippingAddress = request.getParameter("shippingAddress");
            String voucherIdStr = request.getParameter("voucherId");

            // Check cart
            if (cart == null || cart.isEmpty()) {
                request.setAttribute("message", "Your cart is empty.");
                request.getRequestDispatcher("/WEB-INF/View/customers/checkout.jsp").forward(request, response);
                return;
            }

            // Check tồn kho
            ProductDao productDao = new ProductDao();
            boolean enoughStock = true;
            StringBuilder errorMsg = new StringBuilder();
            for (CartItem item : cart) {
                try {
                    Products product = productDao.getProductById(item.getProductId());
                    if (product == null || product.getStockQuantity() < item.getQuantity()) {
                        enoughStock = false;
                        errorMsg.append("Sản phẩm <b>'")
                                .append(product != null ? product.getName() : "Không xác định").append("'</b> chỉ còn ")
                                .append(product != null ? product.getStockQuantity() : 0).append(" trong kho.<br>");
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(CheckoutSuccessServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            if (!enoughStock) {
                request.setAttribute("error", errorMsg.toString());
                request.getRequestDispatcher("/WEB-INF/View/customers/checkout.jsp").forward(request, response);
                return;
            }

            // Tính total, tạo order, giảm tồn kho, voucher...
            double total = 0;
            for (CartItem item : cart) {
                try {
                    Products product = productDao.getProductById(item.getProductId());
                    int quantity = item.getQuantity();
                    double price = product.getPrice();
                    total += price * quantity;
                    // Trừ tồn kho
                    productDao.updateProductQuantity(item.getProductId(), quantity);
                } catch (SQLException ex) {
                    Logger.getLogger(CheckoutSuccessServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            // Voucher xử lý
            Voucher voucher = null;
            double discountAmount = 0;
            if (voucherIdStr != null && !voucherIdStr.isEmpty()) {
                try {
                    int voucherId = Integer.parseInt(voucherIdStr);
                    voucher = new VoucherDao().getVoucherById(voucherId);
                    if (voucher != null && total >= voucher.getMinOrderAmount().doubleValue()) {
                        discountAmount = total * voucher.getDiscountPercent() / 100.0;
                        if (discountAmount > voucher.getMaxDiscount().doubleValue()) {
                            discountAmount = voucher.getMaxDiscount().doubleValue();
                        }
                        total -= discountAmount;
                        // Đánh dấu đã dùng + tăng used_count
                        new VoucherDao().consumeVoucher(voucherId, accountId);
                        new VoucherDao().incrementVoucherUsedCount(voucherId);
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(CheckoutSuccessServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            // Lưu order
            Order order = new Order();
            Account acc = new Account();
            acc.setAccountId(accountId);
            order.setAccount(acc);
            order.setCustomerName(customerName);
            order.setCustomerPhoneNumber(customerPhone);
            order.setShippingAddress(shippingAddress);
            order.setOrderDate(java.time.LocalDateTime.now());
            order.setStatus("pending");
            order.setTotalAmount(BigDecimal.valueOf(total));
            order.setReferralCode(BuyNowDao.generateReferralCode());
            for (CartItem cartItem : cart) {
                OrderItem orderItem = new OrderItem();
                orderItem.setProduct(cartItem.getProduct());
                orderItem.setProductId(cartItem.getProductId());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setUnitPrice(BigDecimal.valueOf(cartItem.getProduct().getPrice()));
                order.getOrderItems().add(orderItem);
            }
            // Lưu DB
            int orderId = new OrderDao().createOrder(order, voucher != null ? voucher.getVoucherId() : null, BigDecimal.valueOf(discountAmount));

            // Xóa cart khỏi session và DB
            session.removeAttribute("cart");
            productDao.clearCart(accountId);

            // Đẩy data sang JSP xác nhận thành công
            request.setAttribute("cart", cart);
            request.setAttribute("total", total);
            request.setAttribute("customerName", customerName);
            request.setAttribute("customerPhone", customerPhone);
            request.setAttribute("voucher", voucher);
            request.setAttribute("discountAmount", discountAmount);
            request.setAttribute("orderId", orderId);

            request.getRequestDispatcher("/WEB-INF/View/customers/checkout_success.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(CheckoutSuccessServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
