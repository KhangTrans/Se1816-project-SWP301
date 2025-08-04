/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.BuyNowDao;
import DAO.CartDao;
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
import java.util.ArrayList;
import java.util.Arrays;
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
            String[] productIds = request.getParameterValues("productIds[]");
            if (productIds == null || productIds.length == 0) {
                // Handle case when no product IDs are selected
                request.setAttribute("message", "Your cart is empty.");
                request.getRequestDispatcher("/WEB-INF/View/customers/checkout.jsp").forward(request, response);
                return;
            }
            System.out.println("IDDDDD " + Arrays.toString(productIds));
            HttpSession session = request.getSession();
            Integer accountId = (Integer) session.getAttribute("accountId");
            List<CartItem> cart = null;
            CartDao cartDao = new CartDao();
            if (productIds != null && productIds.length > 0) {
                cart = new ArrayList<>();
                for (String cartItemIdStr : productIds) {
                    int cartItemId = Integer.parseInt(cartItemIdStr);
                    CartItem cartItem = cartDao.getCartItemById(cartItemId);  // Lấy CartItem theo cartItemId
                    if (cartItem != null) {
                        cart.add(cartItem);  // Thêm vào danh sách giỏ hàng
                    }
                }
            } else {
                // Nếu không có sản phẩm nào được chọn, lấy tất cả sản phẩm trong giỏ hàng
                cart = cartDao.getCartItems(accountId);
            }
            // Lấy thông tin khách hàng từ form
            String customerName = request.getParameter("customerName");
            String customerPhone = request.getParameter("customerPhone");
            String shippingAddress = request.getParameter("shippingAddress");
            String voucherIdStr = request.getParameter("voucherId");
            System.out.println("cart successss" + cart);
            // Check cart
            if (cart == null || cart.isEmpty()) {
                System.out.println("cart succes" + cart);
                request.setAttribute("message", "Your cart is empty.");
                request.getRequestDispatcher(request.getContextPath() + "/checkout").forward(request, response);
                return;
            }

            // Check tồn kho
            ProductDao productDao = new ProductDao();
            boolean enoughStock = true;
            StringBuilder errorMsg = new StringBuilder();
            for (CartItem item : cart) {
                System.out.println("cARTEO" + cart);
                System.out.println("item  " + item.toString());
                try {
                    Products product = productDao.getProductById(item.getProduct().getProductId());
//                    System.out.println("id " + item.);
                    System.out.println("product" + product);
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
            System.out.println("enoug" + enoughStock);
            if (!enoughStock) {
                request.setAttribute("error", errorMsg.toString());
                request.getRequestDispatcher("/WEB-INF/View/customers/checkout.jsp").forward(request, response);
                return;
            }

            // Tính total, tạo order, giảm tồn kho, voucher...
            double total = 0;
            for (CartItem item : cart) {
                try {
                    Products product = productDao.getProductById(item.getProduct().getProductId());
                    int quantity = item.getQuantity();
                    double price = product.getPrice();
                    total += price * quantity;
                    // Trừ tồn kho
                    productDao.updateProductQuantity(item.getProduct().getProductId(), quantity);
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
                orderItem.setProductId(cartItem.getProduct().getProductId());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setUnitPrice(BigDecimal.valueOf(cartItem.getProduct().getPrice()));
                order.getOrderItems().add(orderItem);
            }
            // Lưu DB
            int orderId = new OrderDao().createOrder(order, voucher != null ? voucher.getVoucherId() : null, BigDecimal.valueOf(discountAmount));
            for (String productId : productIds) {
                cartDao.removeItem(accountId, Integer.parseInt(productId)); // Xóa sản phẩm theo productId
            }
            // Xóa cart khỏi session và DB
//            request.setAttribute("cartItems", cartItems); 
//            request.setAttribute("cartCount", cartItems.size()); // Cập nhật cartCount về 0
//            productDao.clearCart(accountId);

            // Đẩy data sang JSP xác nhận thành công
            System.out.println("Cart final" + cart);
            request.setAttribute("cartItems", cart);  // Set "cartItems" để match ưu tiên ở JSP
            request.setAttribute("cart", cart);
            request.setAttribute("total", total);
            request.setAttribute("customerName", customerName);
            request.setAttribute("customerPhone", customerPhone);
            request.setAttribute("voucher", voucher);
            request.setAttribute("discountAmount", discountAmount);
            request.setAttribute("orderId", orderId);
            request.setAttribute("cartCount", 0); // Đẩy cartCount cho JSP sử dụng nếu cần

            request.getRequestDispatcher("/WEB-INF/View/customers/checkout_success.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(CheckoutSuccessServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
