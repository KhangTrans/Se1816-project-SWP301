package Controller;

import DAO.FavoriteListDao;
import Model.Products;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONObject;

@WebServlet(name = "FavoriteListServlet", urlPatterns = {"/FavoriteListServlet"})
public class FavoriteListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Không tạo session mới
        JSONObject jsonResponse = new JSONObject();

        // Kiểm tra đăng nhập
        if (session == null || session.getAttribute("username") == null) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Bạn chưa đăng nhập. Vui lòng đăng nhập để xem danh sách yêu thích.");
            response.getWriter().write(jsonResponse.toString());
            return;
        }

        Integer accountId = (Integer) session.getAttribute("accountId");
        if (accountId == null) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Account ID không hợp lệ.");
            response.getWriter().write(jsonResponse.toString());
            return;
        }

        String action = request.getParameter("action");
        FavoriteListDao favoriteListDao = new FavoriteListDao();

        try {
            if (action != null && request.getHeader("X-Requested-With") != null) { // Yêu cầu AJAX
                int productId = Integer.parseInt(request.getParameter("productId"));
                if ("add".equals(action)) {
                    boolean success = favoriteListDao.addFavorite(accountId, productId);
                    jsonResponse.put("status", success ? "success" : "error");
                    jsonResponse.put("message", success ? "Sản phẩm đã được thêm vào danh sách yêu thích." : "Không thể thêm sản phẩm vào danh sách yêu thích.");
                } else if ("delete".equals(action)) {
                    boolean success = favoriteListDao.deleteFavorite(accountId, productId);
                    jsonResponse.put("status", success ? "success" : "error");
                    jsonResponse.put("message", success ? "Sản phẩm đã được xóa khỏi danh sách yêu thích." : "Không thể xóa sản phẩm khỏi danh sách yêu thích.");
                }
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(jsonResponse.toString());
            } else { // Yêu cầu GET thông thường (hiển thị danh sách)
                List<Products> favoriteProducts = favoriteListDao.getAllFavorite(accountId);
                if (favoriteProducts == null) {
                    favoriteProducts = new ArrayList<>(); // Tránh null pointer
                }
                request.setAttribute("favoriteProducts", favoriteProducts);
                if (favoriteProducts.isEmpty()) {
                    request.setAttribute("noFavoriteMessage", "Không có sản phẩm yêu thích nào.");
                }
                request.getRequestDispatcher("/WEB-INF/View/customers/Favorite_list.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Dữ liệu không hợp lệ.");
            response.getWriter().write(jsonResponse.toString());
        } catch (Exception e) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Đã xảy ra lỗi. Vui lòng thử lại sau.");
            response.getWriter().write(jsonResponse.toString());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        JSONObject jsonResponse = new JSONObject();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (session == null || session.getAttribute("username") == null) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Bạn chưa đăng nhập. Vui lòng đăng nhập để thêm vào danh sách yêu thích.");
            response.getWriter().write(jsonResponse.toString());
            return;
        }

        Integer accountId = (Integer) session.getAttribute("accountId");
        if (accountId == null) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Account ID không hợp lệ.");
            response.getWriter().write(jsonResponse.toString());
            return;
        }

        String action = request.getParameter("action");
        FavoriteListDao favoriteListDao = new FavoriteListDao();

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            if ("add".equals(action)) {
                boolean success = favoriteListDao.addFavorite(accountId, productId);
                jsonResponse.put("status", success ? "success" : "error");
                jsonResponse.put("message", success ? "Sản phẩm đã được thêm vào danh sách yêu thích." : "Không thể thêm sản phẩm vào danh sách yêu thích.");
            } else if ("delete".equals(action)) {
                boolean success = favoriteListDao.deleteFavorite(accountId, productId);
                jsonResponse.put("status", success ? "success" : "error");
                jsonResponse.put("message", success ? "Sản phẩm đã được xóa khỏi danh sách yêu thích." : "Không thể xóa sản phẩm khỏi danh sách yêu thích.");
            }
            response.getWriter().write(jsonResponse.toString());
        } catch (NumberFormatException e) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Dữ liệu không hợp lệ.");
            response.getWriter().write(jsonResponse.toString());
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Đã xảy ra lỗi. Vui lòng thử lại sau.");
            response.getWriter().write(jsonResponse.toString());
        }
    }

    @Override
    public String getServletInfo() {
        return "Favorite List Servlet";
    }
}
