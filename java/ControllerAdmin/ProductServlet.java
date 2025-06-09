package ControllerAdmin;

import DAO.ProductDao;
import Model.Products;
import Model.Categories;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

@WebServlet(name = "ProductServlet", urlPatterns = {"/admin/products"})
@MultipartConfig
public class ProductServlet extends HttpServlet {

    private final ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Products product = productDao.getProductById(id);
                request.setAttribute("product", product);
                request.getRequestDispatcher("/WEB-INF/View/admin/products/edit.jsp").forward(request, response);
            } else if ("ajaxList".equals(action)) {
                // Trả JSON để dùng với fetch JavaScript
                List<Products> products = productDao.getAllProducts(); // nên bao gồm cả categoryName
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                new com.google.gson.Gson().toJson(products, response.getWriter());
            } else {
                List<Products> products = productDao.getAllProducts();
                request.setAttribute("products", products);
                request.getRequestDispatcher("/WEB-INF/View/admin/products/list.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi xử lý dữ liệu");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String formAction = request.getParameter("formAction");

        try {
            if ("create".equals(formAction)) {
                // 1. Parse product
                Products product = parseProductFromRequest(request);

                // 2. Tạo sản phẩm mới → lấy product_id
                int productId = productDao.createProduct(product);

                // 3. Lưu các ảnh
                int index = 0;
                for (Part part : request.getParts()) {
                    if (part.getName().equals("images") && part.getSize() > 0) {
                        byte[] imageData = getImageBytes(part);
                        boolean isPrimary = (index == 0);
                        productDao.addProductImage(productId, imageData, isPrimary);
                        index++;
                    }
                }

                response.getWriter().print("created");

            } else if ("update".equals(formAction)) {
                Products product = parseProductFromRequest(request);
                product.setProductId(Integer.parseInt(request.getParameter("productId")));

                // ✅ Cập nhật sản phẩm
                productDao.updateProduct(product);

                // ✅ Cập nhật ảnh chính nếu người dùng upload
                try {
                    Part mainImagePart = request.getPart("mainImage");
                    if (mainImagePart != null && mainImagePart.getSize() > 0) {
                        byte[] mainImageBytes = getImageBytes(mainImagePart);
                        productDao.addProductImage(product.getProductId(), mainImageBytes, true);
                    }
                } catch (IllegalStateException | IOException ex) {
                    System.err.println("Lỗi khi xử lý ảnh chính: " + ex.getMessage());
                }

                // ✅ Thêm ảnh phụ (nếu có)
                for (Part part : request.getParts()) {
                    if ("images".equals(part.getName()) && part.getSize() > 0) {
                        byte[] imageData = getImageBytes(part);
                        productDao.addProductImage(product.getProductId(), imageData, false);
                    }
                }

                response.getWriter().print("updated");
            } else if ("delete".equals(formAction)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                productDao.deleteProduct(productId);
                response.getWriter().print("deleted");

            } else if ("deleteImage".equals(formAction)) {
                int imageId = Integer.parseInt(request.getParameter("imageId"));
                productDao.deleteImageById(imageId);
                response.getWriter().print("image_deleted");

            } else if ("setPrimaryImage".equals(formAction)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int imageId = Integer.parseInt(request.getParameter("imageId"));
                productDao.setPrimaryImage(productId, imageId);
                response.getWriter().print("primary_set");

            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().print("error: " + e.getMessage());
        }
    }

    private Products parseProductFromRequest(HttpServletRequest request) throws Exception {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stockQuantity");
        String categoryStr = request.getParameter("categoryId");
        System.out.println("DEBUG category: " + categoryStr);
        System.out.println("DEBUG price: " + priceStr + ", stock: " + stockStr + ", categoryId: " + categoryStr);

        if (priceStr == null || stockStr == null || categoryStr == null
                || priceStr.equals("") || stockStr.equals("") || categoryStr.equals("") || categoryStr.equals("undefined")) {
            throw new IllegalArgumentException("❌ Dữ liệu không hợp lệ: thiếu price / stock / categoryId.");
        }

        double price = Double.parseDouble(priceStr);
        int stock = Integer.parseInt(stockStr);
        int categoryId = Integer.parseInt(categoryStr);

        Products product = new Products();
        product.setName(name);
        product.setDescription(description);
        product.setPrice(price);
        product.setStockQuantity(stock);
        product.setActive(true);

        Categories category = new Categories();
        category.setCategory_id(categoryId);
        product.setCategoryId(category);

        return product;
    }

    private byte[] getImageBytes(Part part) throws IOException {
        try ( InputStream input = part.getInputStream();  ByteArrayOutputStream output = new ByteArrayOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = input.read(buffer)) != -1) {
                output.write(buffer, 0, bytesRead);
            }
            return output.toByteArray();
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles CRUD operations for products";
    }
}
