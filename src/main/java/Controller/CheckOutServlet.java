/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.AccountDao;
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
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Admin
 */
@WebServlet(name = "CheckOutServlet", urlPatterns = {"/checkout"})
public class CheckOutServlet extends HttpServlet {

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
    private String generateReferralCode() {
        // Tạo chuỗi ngẫu nhiên gồm chữ và số (8 ký tự chữ và 4 ký tự số)
        String alphanumeric = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder sb = new StringBuilder();
        Random random = new Random();

        // Tạo phần chữ
        for (int i = 0; i < 4; i++) {
            int index = random.nextInt(alphanumeric.length());
            sb.append(alphanumeric.charAt(index));
        }

        // Tạo phần số
        sb.append(String.format("%08d", random.nextInt(10000))); // Đảm bảo luôn có 4 chữ số

        return sb.toString();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy thông tin thanh toán từ form
        String shippingAddress = request.getParameter("shipping_address");
        String customerName = request.getParameter("customer_name");
        String customerPhone = request.getParameter("customer_phone");

        // Mặc định phương thức thanh toán là "Thanh toán khi nhận hàng"
        String paymentMethod = "cash_on_delivery";

        // Lấy thông tin giỏ hàng từ session
        HttpSession session = request.getSession(false);
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            System.out.println("Giỏ hàng trống");
            response.sendRedirect("CartServlet"); // Giỏ hàng trống
            return;
        }

        // Tính toán tổng số tiền
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (CartItem item : cart) {
            Products product = null;
            try {
                product = new ProductDao().getProductById(item.getProductId());
            } catch (SQLException ex) {
                Logger.getLogger(CheckOutServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            if (product != null && product.getPrice() > 0 && item.getQuantity() > 0) {
                BigDecimal price = BigDecimal.valueOf(product.getPrice());
                BigDecimal quantity = BigDecimal.valueOf(item.getQuantity());
                totalAmount = totalAmount.add(price.multiply(quantity));
            } else {
                System.out.println("Invalid product or quantity for item: " + item.getProductId());
            }
        }

        // Lấy voucher đã chọn từ form
        String voucherIdStr = request.getParameter("voucherId");
        BigDecimal discountAmount = BigDecimal.ZERO;
        Integer voucherId = null;
        if (voucherIdStr != null && !voucherIdStr.isEmpty()) {
            try {
                voucherId = Integer.parseInt(voucherIdStr);

                // Lấy voucher từ cơ sở dữ liệu
                VoucherDao voucherDao = new VoucherDao();
                Voucher voucher = voucherDao.getVoucherById(voucherId);

                if (voucher != null && voucher.isActive()) {
                    // Tính toán giảm giá nếu voucher hợp lệ
                    discountAmount = totalAmount.multiply(BigDecimal.valueOf(voucher.getDiscountPercent()))
                            .divide(BigDecimal.valueOf(100));

                    // Giới hạn giảm giá không vượt quá maxDiscount
                    if (discountAmount.compareTo(voucher.getMaxDiscount()) > 0) {
                        discountAmount = voucher.getMaxDiscount();
                    }
                }
            } catch (NumberFormatException e) {
                // Xử lý nếu voucherId không hợp lệ
                e.printStackTrace();
                response.sendRedirect("cart.jsp?error=invalidVoucherId");
                return;
            } catch (SQLException ex) {
                Logger.getLogger(CheckOutServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        // Tính lại tổng tiền sau khi áp dụng voucher
        BigDecimal finalAmount = totalAmount.subtract(discountAmount);

        // Lưu tổng số tiền và discountAmount vào session
        session.setAttribute("totalAmount", finalAmount);
        session.setAttribute("discountAmount", discountAmount);

        // Lấy thông tin accountId từ session
        Integer accountId = (Integer) session.getAttribute("accountId");
        if (accountId == null) {
            response.sendRedirect("login.jsp?error=notLoggedIn"); // Nếu không có tài khoản đăng nhập
            return;
        }

        // Truy vấn thông tin Account từ database
        Account account = new AccountDao().getAccountById(accountId);
        if (account == null) {
            response.sendRedirect("login.jsp?error=notLoggedIn");
            return;
        }

        // Tạo đơn hàng mới
        Order order = new Order();
        order.setAccount(account);
        order.setTotalAmount(finalAmount);
        order.setShippingAddress(shippingAddress);
        order.setStatus("pending");
        order.setCustomerName(customerName);
        order.setCustomerPhoneNumber(customerPhone);
        String referralCode = generateReferralCode();
        order.setReferralCode(referralCode);

        // Tạo đối tượng DAO
        OrderDao orderDao = new OrderDao();

        try {
            // Thêm đơn hàng vào cơ sở dữ liệu và lấy orderId
            int orderId = orderDao.createOrder(order, voucherId, discountAmount);

            // Thêm các sản phẩm vào bảng order_items
            for (CartItem item : cart) {
                Products product = new ProductDao().getProductById(item.getProductId());
                if (product != null) {
                    OrderItem orderItem = new OrderItem();
                    order.setOrderId(orderId); // Gán orderId vào đối tượng Order
                    orderItem.setOrder(order);  // Gán đối tượng Order vào OrderItem
                    orderItem.setProductId(item.getProductId());
                    orderItem.setQuantity(item.getQuantity());
                    orderItem.setUnitPrice(BigDecimal.valueOf(product.getPrice()));
                    orderDao.addOrderItem(orderItem);
                }
            }

            // Xóa giỏ hàng sau khi thanh toán
            CartDao cartDao = new CartDao();
            cartDao.clearCart(account.getAccountId());
            session.setAttribute("orderId", orderId);
            // Chuyển hướng đến trang xác nhận đơn hàng
            response.sendRedirect("orderconfirm?orderId=" + orderId);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("cart.jsp?error=paymentFailed");
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
