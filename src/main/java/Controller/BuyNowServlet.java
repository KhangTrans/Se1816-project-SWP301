package Controller;

import DAO.ProductDao;
import DAO.VoucherDao;
import DAO.OrderDao;
import DAO.BuyNowDao;
import Model.Account;
import Model.Order;
import Model.OrderItem;
import Model.Products;
import Model.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@MultipartConfig
@WebServlet(name = "BuyNowServlet", urlPatterns = {"/BuyNow"})
public class BuyNowServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            HttpSession session = req.getSession(false);
            Integer accountId = (session != null) ? (Integer) session.getAttribute("accountId") : null;
            if (accountId == null) {
                resp.sendRedirect("login.jsp");
                return;
            }

            String productIdStr = req.getParameter("productId");
            Integer productId = (productIdStr != null) ? Integer.valueOf(productIdStr) : null;

            Products product = new ProductDao().getProductByIdDetail(productId);
            List<Voucher> claimedVouchers = new VoucherDao().getAvailableVouchersForCustomer(accountId);

            req.setAttribute("product", product);
            req.setAttribute("claimedVouchers", claimedVouchers);
            req.setAttribute("productId", productId);

            req.getRequestDispatcher("/WEB-INF/View/customers/buyNow.jsp").forward(req, resp);

        } catch (SQLException ex) {
            Logger.getLogger(BuyNowServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(false);
            Integer accountId = (session != null) ? (Integer) session.getAttribute("accountId") : null;
            if (accountId == null) {
                resp.sendRedirect("login.jsp");
                return;
            }

            String productIdStr = req.getParameter("productId");
            Integer productId = (productIdStr != null) ? Integer.valueOf(productIdStr) : null;
            String quantityStr = req.getParameter("quantity");
            int quantity = (quantityStr != null) ? Integer.parseInt(quantityStr) : 1;
            String voucherIdStr = req.getParameter("voucherId");
            Integer voucherId = (voucherIdStr != null && !voucherIdStr.isEmpty()) ? Integer.valueOf(voucherIdStr) : null;

            String customerName = req.getParameter("fullName");
            String customerPhone = req.getParameter("phone");
            String shippingAddress = req.getParameter("address");

            Products product = new ProductDao().getProductByIdDetail(productId);
            VoucherDao voucherDao = new VoucherDao();
            Voucher voucher = null;

            // Nếu có chọn voucher thì check đã dùng chưa
            if (voucherId != null) {
                if (voucherDao.hasUserConsumed(voucherId, accountId)) {
                    req.setAttribute("errorMessage", "you have already used this voucher!");
                    // Load lại dữ liệu cần thiết để render lại trang
                    req.setAttribute("product", product);
                    req.setAttribute("claimedVouchers", voucherDao.getAvailableVouchersForCustomer(accountId));
                    req.setAttribute("productId", productId);
                    req.getRequestDispatcher("/WEB-INF/View/customers/buyNow.jsp").forward(req, resp);

                    return;
                }
                voucher = voucherDao.getVoucherById(voucherId);
            }

            // Kiểm tra điều kiện tối thiểu giá trị đơn hàng trước khi cho dùng voucher
            if (voucher != null) {
                BigDecimal orderTotalBeforeDiscount = BigDecimal.valueOf(product.getPrice()).multiply(BigDecimal.valueOf(quantity));
                if (orderTotalBeforeDiscount.compareTo(voucher.getMinOrderAmount()) < 0) {
                    req.setAttribute("errorMessage", "Order need to be at least " + voucher.getMinOrderAmount().toPlainString() + "₫ to use this voucher!");
                    // Load lại dữ liệu cần thiết để render lại trang
                    req.setAttribute("product", product);
                    req.setAttribute("claimedVouchers", voucherDao.getAvailableVouchersForCustomer(accountId));
                    req.setAttribute("productId", productId);
                    req.getRequestDispatcher("/WEB-INF/View/customers/buyNow.jsp").forward(req, resp);

                    return;
                }
            }

            // Tính tổng tiền và giảm giá
            BigDecimal[] totalAndDiscount = BuyNowDao.calculateTotalWithVoucher(product, quantity, voucher);
            BigDecimal totalAmount = totalAndDiscount[0];
            BigDecimal discountAmount = totalAndDiscount[1];

            //Tạo Order
            Order order = new Order();
            Account acc = new Account();
            acc.setAccountId(accountId);
            order.setAccount(acc);
            order.setCustomerName(customerName);
            order.setCustomerPhoneNumber(customerPhone);
            order.setShippingAddress(shippingAddress);
            order.setOrderDate(java.time.LocalDateTime.now());
            order.setStatus("pending");
            order.setTotalAmount(totalAmount);
            order.setReferralCode(BuyNowDao.generateReferralCode());

            //Tạo OrderItem
            OrderItem item = new OrderItem();
            item.setProduct(product);
            item.setProductId(productId);
            item.setQuantity(quantity);
            item.setUnitPrice(BigDecimal.valueOf(product.getPrice()));
            order.getOrderItems().add(item);

            //Lưu vào DB
            int orderId = new OrderDao().createOrder(order, voucherId, discountAmount);

            //Giảm tồn kho
            new ProductDao().updateProductQuantity(productId, quantity);

            //Nếu có dùng voucher thì cập nhật đã dùng (consumed_at) + tăng used_count
            if (voucherId != null) {
                voucherDao.consumeVoucher(voucherId, accountId);
                voucherDao.incrementVoucherUsedCount(voucherId);
            }

            //Redirect sang trang xác nhận đơn hàng
            resp.sendRedirect("orderconfirm?orderId=" + orderId);

        } catch (SQLException ex) {
            ex.printStackTrace();
            req.setAttribute("errorMessage", "An error occured.");
            req.getRequestDispatcher("/WEB-INF/View/customers/buyNow.jsp").forward(req, resp);

        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý chức năng Mua Ngay - Buy Now";
    }
}
