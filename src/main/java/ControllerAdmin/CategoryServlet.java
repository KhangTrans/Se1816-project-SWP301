package ControllerAdmin;

import DAO.CategoryDao;
import DAO.ProductDao;
import Model.Categories;
import Model.Product_Images;
import Model.Products;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CategoryServlet extends HttpServlet {

    private CategoryDao categoryDao;
    private ProductDao productDao;

    @Override
    public void init() {
        categoryDao = new CategoryDao();
        productDao = new ProductDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String idParam = request.getParameter("id");

        try {
            // Nếu có id: trả về JSON như cũ (cho edit)
            if (idParam != null && !idParam.trim().isEmpty()) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                int productId = Integer.parseInt(idParam);
                Products product = productDao.getProductById(productId);

                if (product == null) {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write("{\"error\":\"Không tìm thấy sản phẩm\"}");
                    return;
                }

                // Lấy danh sách ảnh sản phẩm
                List<Product_Images> images = productDao.getImagesByProductId(productId);
                List<Map<String, Object>> imageList = new ArrayList<>();
                for (Product_Images img : images) {
                    Map<String, Object> imgMap = new HashMap<>();
                    imgMap.put("imageId", img.getImageId());
                    imgMap.put("isPrimary", img.isIsPrimary());
                    imageList.add(imgMap);
                }

                // Lấy danh sách thể loại
                List<Categories> categories = categoryDao.getAllCategories();

                // Chuẩn bị dữ liệu sản phẩm JSON
                Map<String, Object> productMap = new HashMap<>();
                productMap.put("productId", product.getProductId());
                productMap.put("name", product.getName());
                productMap.put("description", product.getDescription());
                productMap.put("price", product.getPrice());
                productMap.put("stockQuantity", product.getStockQuantity());
                productMap.put("categoryId", product.getCategoryId() != null ? product.getCategoryId().getCategory_id() : null);
                productMap.put("primaryImageId", product.getPrimaryImageId());

                Map<String, Object> result = new HashMap<>();
                result.put("product", productMap);

                // Chuyển đổi categories → danh sách đơn giản cho JSON
                List<Map<String, Object>> categoryList = new ArrayList<>();
                for (Categories cat : categories) {
                    Map<String, Object> catMap = new HashMap<>();
                    catMap.put("categoryId", cat.getCategory_id());
                    catMap.put("name", cat.getName());
                    categoryList.add(catMap);
                }
                result.put("categories", categoryList);
                result.put("images", imageList);

                new Gson().toJson(result, response.getWriter());
                return;
            }

            // Nếu không có id: trả về JSP với list categories (dùng cho add product)
            // (KHÔNG trả JSON mà setAttribute và forward)
            List<Categories> categories = categoryDao.getAllCategories();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/WEB-INF/View/admin/products/create.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"ID không hợp lệ\"}");
        } catch (Exception e) {
            Logger.getLogger(CategoryServlet.class.getName()).log(Level.SEVERE, null, e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Lỗi khi tải dữ liệu sản phẩm\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Tạm thời không xử lý POST ở đây
    }

    @Override
    public String getServletInfo() {
        return "CategoryServlet supports AJAX loading of categories and product info";
    }
}
