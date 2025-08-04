package Controller;

import DAO.BuyNowDao;
import DAO.CartDao;
import DAO.CustomerDao;
import DAO.OrderDao;
import DAO.ProductDao;
import DAO.VoucherDao;
import Model.Account;
import Model.CartItem;
import Model.Customer;
import Model.Order;
import Model.OrderItem;
import Model.Products;
import Model.Voucher;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@MultipartConfig
@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        if (accountId == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
        // Lấy các cartId đã chọn
        String[] cartItemsToCheckout = request.getParameterValues("cartItemsToCheckout");
        System.out.println("cart" + Arrays.toString(cartItemsToCheckout));
        // LẤY GIỎ HÀNG (như cũ)
        CartDao cartDao = new CartDao();
        List<CartItem> cartItems = null;
        try {
            if (cartItemsToCheckout != null && cartItemsToCheckout.length > 0) {
                cartItems = new ArrayList<>();
                for (String cartItemIdStr : cartItemsToCheckout) {
                    int cartItemId = Integer.parseInt(cartItemIdStr);
                    CartItem cartItem = cartDao.getCartItemById(cartItemId);  // Lấy CartItem theo cartItemId
                    if (cartItem != null) {
                        cartItems.add(cartItem);  // Thêm vào danh sách giỏ hàng
                    }
                }
            } else {
                // Nếu không có sản phẩm nào được chọn, lấy tất cả sản phẩm trong giỏ hàng
                cartItems = cartDao.getCartItems(accountId);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        double total = 0;
        if (cartItems != null) {
            for (CartItem item : cartItems) {
                Products p = item.getProduct();
                if (p != null) {
                    total += p.getPrice() * item.getQuantity();
                }
            }
        }
        request.setAttribute("total", total);

        // LẤY DANH SÁCH VOUCHER ĐÃ CLAIM (luôn luôn set vào request)
        VoucherDao voucherDao = new VoucherDao();
        List<Voucher> claimedVouchers = null;
        System.out.println("vouchers: " + claimedVouchers);
        try {
            claimedVouchers = voucherDao.getAvailableVouchersForCustomer(accountId);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        request.setAttribute("claimedVouchers", claimedVouchers);
        request.setAttribute("cartItems", cartItems);
        System.out.println("Cart item " + cartItems);
        // Forward sang trang checkout JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/View/customers/checkout.jsp");
        dispatcher.forward(request, response);

    }

}
