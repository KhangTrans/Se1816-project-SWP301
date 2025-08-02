package Controller;

import DAO.CartDao;
import DAO.ProductDao;
import Model.CartItem;
import Model.Products;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import org.json.JSONObject;

@WebServlet(name = "CartServlet", urlPatterns = {"/CartServlet"})
public class CartServlet extends HttpServlet {

    private int getCustomerIdFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return -1;
        }
        Integer customerId = (Integer) session.getAttribute("accountId");
        return (customerId != null) ? customerId : -1;
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
                if (isAjax(request)) {
                    updateQuantityAjax(request, response, "increase");
                } else {
                    increaseQuantity(request, response);
                }
                break;
            case "decrease":
                if (isAjax(request)) {
                    updateQuantityAjax(request, response, "decrease");
                } else {
                    decreaseQuantity(request, response);
                }
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
        } else if ("increase".equals(action) || "decrease".equals(action)) {
            updateQuantityAjax(request, response, action);
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("accountId");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (customerId == null) {
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Bạn cần đăng nhập để thêm sản phẩm vào giỏ hàng!\"}");
            return;
        }

        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        try {
            CartDao cartDao = new CartDao();
            cartDao.addOrUpdate(customerId, productId, quantity);

            int totalItems = quantity;
            List<CartItem> cartItems = null;
            try {
                cartItems = cartDao.getCartItems(customerId);
                totalItems = 0;
                for (CartItem item : cartItems) {
                    totalItems += item.getQuantity();
                }
            } catch (SQLException e) {
                e.printStackTrace();
                Integer prevCount = (Integer) session.getAttribute("cartCount");
                totalItems = (prevCount != null ? prevCount : 0) + quantity;
            }

            session.setAttribute("cart", cartItems);
            session.setAttribute("cartCount", totalItems);

            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("status", "added");
            jsonResponse.put("cartCount", totalItems);
            response.getWriter().write(jsonResponse.toString());
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Lỗi khi thêm sản phẩm.\"}");
        }
    }

    private void viewCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int customerId = getCustomerIdFromSession(request);

        if (customerId == -1) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Bạn cần đăng nhập để sử dụng giỏ hàng!\"}");
            return;
        }

        try {
            CartDao dao = new CartDao();
            List<CartItem> cartItems = dao.getCartItems(customerId);

            int totalItems = 0;
            for (CartItem item : cartItems) {
                totalItems += item.getQuantity();
            }
            request.getSession().setAttribute("cartCount", totalItems);
            request.getSession().setAttribute("cart", cartItems);

            if (isAjax(request)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                JSONObject jsonResponse = new JSONObject();
                jsonResponse.put("status", "success");
                jsonResponse.put("cartCount", totalItems);
                jsonResponse.put("cartItems", cartItems);
                response.getWriter().write(jsonResponse.toString());
            } else {
                request.getRequestDispatcher("/WEB-INF/View/customers/cart.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Lỗi khi truy cập giỏ hàng.\"}");
        }
    }

    private void updateQuantityAjax(HttpServletRequest request, HttpServletResponse response, String action) throws IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int customerId = getCustomerIdFromSession(request);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (customerId == -1) {
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Bạn cần đăng nhập để cập nhật giỏ hàng!\"}");
            return;
        }

        try {
            CartDao dao = new CartDao();
            List<CartItem> cart = dao.getCartItems(customerId);
            int newQty = -1;
            double subtotal = 0;
            double cartTotal = 0;
            CartItem itemToUpdate = null;

            // Find the item to update
            for (CartItem item : cart) {
                if (item.getProductId() == productId) {
                    itemToUpdate = item;
                    break;
                }
            }

            if (itemToUpdate == null) {
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Sản phẩm không tồn tại trong giỏ hàng!\"}");
                return;
            }

            newQty = itemToUpdate.getQuantity() + ("increase".equals(action) ? 1 : -1);
            if (newQty > 0) {
                dao.updateQuantity(customerId, productId, newQty);
            } else {
                dao.removeItem(customerId, productId);
                newQty = 0; // Indicate removal
            }

            // Recalculate cart total and fetch updated cart
            cart = dao.getCartItems(customerId);
            int totalItems = 0;
            for (CartItem item : cart) {
                totalItems += item.getQuantity();
                ProductDao productDao = new ProductDao();
                Products product = productDao.getProductById(item.getProductId());
                if (product != null) {
                    cartTotal += product.getPrice() * item.getQuantity();
                    if (item.getProductId() == productId && newQty > 0) {
                        subtotal = product.getPrice() * newQty;
                    }
                }
            }

            HttpSession session = request.getSession();
            session.setAttribute("cart", cart);
            session.setAttribute("cartCount", totalItems);

            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("status", "success");
            jsonResponse.put("quantity", newQty);
            jsonResponse.put("subtotal", subtotal);
            jsonResponse.put("cartTotal", cartTotal);
            jsonResponse.put("cartCount", totalItems);
            response.getWriter().write(jsonResponse.toString());
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Lỗi khi cập nhật số lượng: " + e.getMessage() + "\"}");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Dữ liệu không hợp lệ!\"}");
        }
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int customerId = getCustomerIdFromSession(request);

        try {
            new CartDao().removeItem(customerId, productId);
            response.sendRedirect("CartServlet?action=view");
        } catch (SQLException e) {
            e.printStackTrace();
        }
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