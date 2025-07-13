package Controller;

import DAO.CartDao;
import DAO.CustomerDao;
import DAO.ProductDao;
import DAO.VoucherDao;
import Model.CartItem;
import Model.Customer;
import Model.Products;
import Model.Voucher;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        System.out.println("Account ID from session: " + accountId);

        if (accountId == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        // Lấy thông tin giỏ hàng từ DB (JOIN products)
        CartDao cartDao = new CartDao();
        List<CartItem> cartItems = null;
        try {
            cartItems = cartDao.getCartItems(accountId); // Hàm này phải JOIN products!
            System.out.println("Retrieving cart items for account ID: " + accountId);
            if (cartItems != null && !cartItems.isEmpty()) {
                System.out.println("Cart contains " + cartItems.size() + " items.");
            } else {
                System.out.println("Cart is empty.");
            }
        } catch (SQLException ex) {
            Logger.getLogger(CheckoutServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        request.setAttribute("cartItems", cartItems);

        double total = 0;
        if (cartItems != null) {
            for (CartItem item : cartItems) {
                total += item.getProduct().getPrice() * item.getQuantity();
            }
        }

        // Lấy voucher đã thu thập (chưa sử dụng) của user
        VoucherDao voucherDao = new VoucherDao();
        Voucher voucher = null;
        try {
            voucher = voucherDao.getVoucherByCustomer(accountId);
            if (voucher != null) {
                System.out.println("Voucher found: " + voucher.getCode());
            } else {
                System.out.println("No voucher found for account ID: " + accountId);
            }
        } catch (SQLException ex) {
            Logger.getLogger(CheckoutServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (voucher != null) {
            // Áp dụng giảm giá
            BigDecimal discountAmount = BigDecimal.valueOf(total)
                    .multiply(BigDecimal.valueOf(voucher.getDiscountPercent() / 100.0));
            if (discountAmount.compareTo(voucher.getMaxDiscount()) > 0) {
                discountAmount = voucher.getMaxDiscount();
            }
            total -= discountAmount.doubleValue();
            request.setAttribute("voucher", voucher);
            request.setAttribute("discountAmount", discountAmount);
            System.out.println("Applying voucher discount: " + discountAmount);
        } else {
            System.out.println("No discount applied.");
        }

        request.setAttribute("total", total);

        // Lấy thông tin customer
        CustomerDao customerDao = new CustomerDao();
        Customer customer = null;
        try {
            customer = customerDao.getCustomerByAccountId(accountId);
        } catch (SQLException ex) {
            Logger.getLogger(CheckoutServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        request.setAttribute("customer", customer);

        // Lấy danh sách các voucher có sẵn (để hiện phần chọn voucher)
        List<Voucher> availableVouchers = null;
        try {
            availableVouchers = voucherDao.getActiveVouchers();
            System.out.println("Fetching available vouchers...");
            if (availableVouchers != null && !availableVouchers.isEmpty()) {
                System.out.println("Found " + availableVouchers.size() + " available vouchers.");
                for (Voucher v : availableVouchers) {
                    System.out.println("Voucher available: " + v.getCode() + " - Discount: " + v.getDiscountPercent() + "%");
                }
            } else {
                System.out.println("No available vouchers.");
            }
        } catch (SQLException ex) {
            Logger.getLogger(CheckoutServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        request.setAttribute("availableVouchers", availableVouchers);

        // Debug info before forwarding
        System.out.println("Forwarding to checkout.jsp with the following attributes:");
        System.out.println("Total: " + total);
        System.out.println("Voucher: " + (voucher != null ? voucher.getCode() : "No voucher"));

        request.getRequestDispatcher("/WEB-INF/View/customers/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy giỏ hàng từ session
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        double total = 0;
        if (cart == null || cart.isEmpty()) {
            // Giỏ hàng trống, chuyển tiếp đến trang giỏ hàng
            request.setAttribute("message", "Your cart is empty.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/View/customers/checkout.jsp");
            dispatcher.forward(request, response);
        } else {
            // Tính toán tổng giá trị của giỏ hàng
            for (CartItem item : cart) {
                int productId = item.getProductId();
                ProductDao dao = new ProductDao();
                Products product = null;
                try {
                    // Lấy thông tin sản phẩm từ cơ sở dữ liệu
                    product = dao.getProductById(productId);
                } catch (SQLException ex) {
                    Logger.getLogger(CheckoutServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (product != null) {
                    int quantity = item.getQuantity();
                    double price = product.getPrice();
                    double subtotal = price * quantity;
                    total += subtotal;
                }
            }

            // Kiểm tra và áp dụng voucher nếu có
            Voucher voucher = (Voucher) session.getAttribute("voucher"); // Lấy voucher từ session
            if (voucher != null) {
                // Tính toán giảm giá theo voucher
                BigDecimal discountAmount = BigDecimal.ZERO;
                discountAmount = BigDecimal.valueOf(total).multiply(BigDecimal.valueOf(voucher.getDiscountPercent() / 100.0));

                // Đảm bảo giảm không vượt quá giới hạn max_discount
                if (discountAmount.compareTo(voucher.getMaxDiscount()) > 0) {
                    discountAmount = voucher.getMaxDiscount();
                }

                // Cập nhật tổng tiền sau khi áp dụng voucher
                total -= discountAmount.doubleValue();
                session.setAttribute("voucher", voucher);
                session.setAttribute("discountAmount", discountAmount);
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

            // Chuyển tiếp đến trang checkout.jsp
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/View/customers/checkout.jsp");
            dispatcher.forward(request, response);
        }
    }
}
