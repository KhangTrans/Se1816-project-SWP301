package Controller;

import DAO.CartDao;
import DAO.ProductDao;
import DAO.CustomerDao;
import Model.CartItem;
import Model.Customer;
import Model.Products;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import org.json.JSONObject;

@WebServlet(name = "CartServlet", urlPatterns = {"/CartServlet"})
public class CartServlet extends HttpServlet {

    private int getCustomerIdFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return -1;  // Trả về -1 nếu session không tồn tại
        }

        Integer customerId = (Integer) session.getAttribute("accountId");
        return (customerId != null) ? customerId : -1;  // Trả về customerId nếu có, nếu không trả về -1
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
        }

        switch (action) {
            case "remove":
                removeFromCart(request, response);
                break;
            case "removeAll":
                removeProductCompletely(request, response);
                break;
            case "clear":
                clearCart(request, response);
                break;
            case "increase":
                increaseQuantity(request, response);
                break;
            case "decrease":
                decreaseQuantity(request, response);
                break;
            default:
                viewCart(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addToCart(request, response);
        } else if ("clearCart".equals(action)) {
            clearCart(request, response);
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();

        // Kiểm tra người dùng đã đăng nhập chưa
        Integer customerId = (Integer) session.getAttribute("accountId");
        if (customerId == null) {
            if (isAjax(request)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                // Trả về JSON báo lỗi yêu cầu đăng nhập
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Bạn cần đăng nhập để thêm sản phẩm vào giỏ hàng!\"}");
            } else {
                // Chuyển tới trang đăng nhập nếu chưa đăng nhập
                response.sendRedirect("Login.jsp");
            }
            return;  // Ngừng hành động thêm sản phẩm vào giỏ hàng
        }

        // Tiếp tục xử lý thêm sản phẩm vào giỏ hàng nếu đã đăng nhập
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        try {
            CartDao cartDao = new CartDao();
            cartDao.addOrUpdate(customerId, productId, quantity);

            // Cập nhật lại số lượng sản phẩm trong giỏ hàng
            List<CartItem> cartItems = cartDao.getCartItems(customerId);
            int totalItems = 0;
            for (CartItem item : cartItems) {
                totalItems += item.getQuantity();
            }

            // Cập nhật số lượng sản phẩm trong giỏ hàng vào session
            session.setAttribute("cartCount", totalItems);

            if (isAjax(request)) {
                // Trả về JSON chứa số lượng giỏ hàng
                JSONObject jsonResponse = new JSONObject();
                jsonResponse.put("status", "added");
                jsonResponse.put("cartCount", totalItems);  // Trả về số lượng giỏ hàng
                response.getWriter().write(jsonResponse.toString());
            } else {
                response.sendRedirect("CartServlet?action=view");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (isAjax(request)) {
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Lỗi khi thêm sản phẩm.\"}");
            } else {
                response.sendRedirect("error.jsp");
            }
        }
    }

    private void viewCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int customerId = getCustomerIdFromSession(request);

        if (customerId == -1) {
            // Người dùng chưa đăng nhập, thông báo lỗi và không chuyển trang
            if (isAjax(request)) {
                // Trả về thông báo lỗi trong dạng JSON
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Bạn cần đăng nhập để sử dụng giỏ hàng.\"}");
            } else {
                // Hiển thị thông báo lỗi cho người dùng nhưng vẫn ở lại trang shopAll
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().write("<script>alert('Bạn cần đăng nhập để sử dụng giỏ hàng!'); window.location.href = '/SE1816_Gym_Group_4/shopAll';</script>");
            }
            return;
        }

        // Tiếp tục xử lý giỏ hàng nếu đã đăng nhập
        try {
            CartDao dao = new CartDao();
            List<CartItem> cartItems = dao.getCartItems(customerId);

            // Tính tổng số sản phẩm trong giỏ hàng
            int totalItems = 0;
            for (CartItem item : cartItems) {
                totalItems += item.getQuantity();
            }
            request.getSession().setAttribute("cartCount", totalItems);

            // Gửi danh sách giỏ hàng về JSP
            request.setAttribute("cart", cartItems);
            request.getRequestDispatcher("/WEB-INF/View/customers/cart.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int customerId = getCustomerIdFromSession(request);

        try {
            new CartDao().removeItem(customerId, productId);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        response.sendRedirect("CartServlet?action=view");
    }

    private void increaseQuantity(HttpServletRequest request, HttpServletResponse response) throws IOException {
        updateQuantity(request, 1);
        response.sendRedirect("CartServlet?action=view");
    }

    private void decreaseQuantity(HttpServletRequest request, HttpServletResponse response) throws IOException {
        updateQuantity(request, -1);
        response.sendRedirect("CartServlet?action=view");
    }

    private void updateQuantity(HttpServletRequest request, int delta) {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int customerId = getCustomerIdFromSession(request);

        try {
            CartDao dao = new CartDao();
            List<CartItem> cart = dao.getCartItems(customerId);
            for (CartItem item : cart) {
                if (item.getProductId() == productId) {
                    int newQty = item.getQuantity() + delta;
                    if (newQty > 0) {
                        dao.updateQuantity(customerId, productId, newQty);
                    } else {
                        dao.removeItem(customerId, productId);
                    }
                    break;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void removeProductCompletely(HttpServletRequest request, HttpServletResponse response) throws IOException {
        removeFromCart(request, response);
    }

    private void clearCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int customerId = getCustomerIdFromSession(request);
        try {
            new CartDao().clearCart(customerId);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        response.sendRedirect("CartServlet?action=view");
    }

    private boolean isAjax(HttpServletRequest request) {
        return "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
    }
}
