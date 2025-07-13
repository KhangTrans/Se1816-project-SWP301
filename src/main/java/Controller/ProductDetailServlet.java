/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.AccountDao;
import DAO.OrderDao;
import DAO.ProductDao;
import DAO.ReviewDao;
import Model.Account;
import Model.Products;
import Model.Review;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Admin
 */
@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/ProductDetail"})
public class ProductDetailServlet extends HttpServlet {

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

        // Lấy tham số productId từ query (?id=xxx)
        String pidStr = request.getParameter("productId");
        if (pidStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Product ID is required");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(pidStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product ID");
            return;
        }

        // Gọi DAO lấy chi tiết sản phẩm
        ProductDao dao = new ProductDao();
        Products product = dao.getProductByIdDetail(productId);

        if (product == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
            return;
        }

        // Lấy các sản phẩm liên quan
        List<Products> relatedProducts = dao.getRelatedProducts(product.getCategoryId().getCategory_id(), product.getProductId(), 15);

        // Lấy các đánh giá sản phẩm từ ReviewDao
        ReviewDao reviewDao = new ReviewDao();
        List<Review> reviews = reviewDao.getReviewsByProductId(productId);

        // Kiểm tra xem người dùng có đăng nhập không (kiểm tra session)
        Integer accountId = (Integer) request.getSession().getAttribute("accountId");
        boolean isLoggedIn = accountId != null;

        // Kiểm tra xem người dùng đã mua sản phẩm hay chưa
        boolean hasPurchased = false;
        if (isLoggedIn) {
            // Kiểm tra xem người dùng đã mua sản phẩm chưa
            hasPurchased = new OrderDao().hasUserPurchasedProduct(accountId, productId);
        }

        // Đẩy dữ liệu vào request để JSP sử dụng
        request.setAttribute("product", product);
        request.setAttribute("relatedProducts", relatedProducts);
        request.setAttribute("productReviews", reviews);
        request.setAttribute("isLoggedIn", isLoggedIn);
        request.setAttribute("hasPurchased", hasPurchased);  // Truyền trạng thái đã mua vào request

        // Chuyển hướng đến JSP
        request.getRequestDispatcher("/WEB-INF/View/customers/product_detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra xem có sản phẩm không
        String pidStr = request.getParameter("productId");
        System.out.println("product ID: " + pidStr);

        if (pidStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Product ID is required");
            return;
        }

        int productId = Integer.parseInt(pidStr);

        // Lấy thông tin đánh giá từ form
        Integer rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");

        // Lấy accountId từ session
        Integer accountId = (Integer) request.getSession().getAttribute("accountId");
        boolean isLoggedIn = accountId != null;
        // Kiểm tra xem người dùng có đăng nhập không
        if (accountId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Kiểm tra xem người dùng đã mua sản phẩm chưa
        boolean hasPurchased = false;
        if (isLoggedIn) {
            // Kiểm tra xem người dùng đã mua sản phẩm chưa
            hasPurchased = new OrderDao().hasUserPurchasedProduct(accountId, productId);
        }

        // Lấy thông tin sản phẩm từ database
        ProductDao productDao = new ProductDao();
        Products product = productDao.getProductByIdPage(productId); // Truy vấn sản phẩm từ CSDL
        System.out.println("PRODUCT ID: " + product);
        // Lấy thông tin người dùng từ database nếu cần
        AccountDao accountDao = new AccountDao();
        Account account = accountDao.getAccountById(accountId); // Truy vấn người dùng từ CSDL

        Review review = new Review();
        review.setProduct(product);  // Gán đối tượng Product vào Review
        review.setAccount(account);  // Gán đối tượng Account vào Review
        review.setRating(rating);    // Gán đánh giá sao vào Review
        review.setComment(comment);  // Gán bình luận vào Review

        // Lưu đánh giá vào cơ sở dữ liệu
        ReviewDao reviewDao = new ReviewDao();
        boolean success = reviewDao.addReview(review);

        // Nếu lưu thành công, chuyển hướng về trang chi tiết sản phẩm
        if (success) {
            response.sendRedirect(request.getContextPath() + "/ProductDetail?productId=" + productId);
        } else {
            // Nếu có lỗi, chuyển hướng đến trang lỗi
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
