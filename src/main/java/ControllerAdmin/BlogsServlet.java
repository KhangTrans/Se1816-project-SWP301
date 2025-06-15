package ControllerAdmin;

import DAO.BlogDao;
import Model.Blog;
import Model.BlogImage;
import Model.Product_Images;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "BlogsServlet", urlPatterns = {"/admin/blogs"})
@MultipartConfig
public class BlogsServlet extends HttpServlet {

    private final BlogDao blogDao = new BlogDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        try {
            switch (action) {
                case "list": {
                    List<Blog> blogs = blogDao.getAllBlogs();
                    request.setAttribute("blogs", blogs);
                    request.getRequestDispatcher("/WEB-INF/View/admin/blogs/list.jsp").forward(request, response);
                    break;
                }
                case "ajaxList": {
                    try {
                        List<Blog> blogs = blogDao.getAllBlogs();
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");
                        Gson gson = new GsonBuilder()
                                .registerTypeAdapter(LocalDateTime.class, new JsonSerializer<LocalDateTime>() {
                                    @Override
                                    public JsonElement serialize(LocalDateTime src, java.lang.reflect.Type typeOfSrc, JsonSerializationContext context) {
                                        return new JsonPrimitive(src.toString()); // ISO 8601
                                    }
                                })
                                .create();

                        String json = gson.toJson(blogs);
                        response.getWriter().write(json);
                    } catch (Exception e) {
                        e.printStackTrace();
                        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý ajaxList: " + e.getMessage());
                    }
                    break;
                }

                case "edit": {
                    String idParam = request.getParameter("id");
                    System.out.println("ID from URL: " + idParam); // Debug

                    if (idParam != null && !idParam.trim().isEmpty()) {
                        try {
                            int id = Integer.parseInt(idParam);
                            Blog blog = blogDao.getBlogByID(id);

                            if (blog == null) {
                                System.out.println("Blog không tồn tại với ID: " + id); // Debug
                                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy blog");
                                return;
                            }

                            // Lấy ảnh của blog
                            List<BlogImage> images = blogDao.getImagesByBlog(id);
                            List<Map<String, Object>> imageList = new ArrayList<>();
                            for (BlogImage img : images) {
                                Map<String, Object> imgMap = new HashMap<>();
                                imgMap.put("imageId", img.getImageId());
                                imgMap.put("isPrimary", img.isIs_primary());
                                imageList.add(imgMap);
                            }

                            // Chuẩn bị dữ liệu blog
                            Map<String, Object> blogMap = new HashMap<>();
                            blogMap.put("blogId", blog.getBlogId());
                            blogMap.put("title", blog.getTitle());
                            blogMap.put("content", blog.getContent());
                            blogMap.put("primaryImageId", blog.getPrimaryImageId());

                            Map<String, Object> result = new HashMap<>();
                            result.put("blog", blogMap);
                            result.put("images", imageList);

                            new Gson().toJson(result, response.getWriter());
                            return;
                        } catch (NumberFormatException e) {
                            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ");
                        }
                    } else {
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số ID");
                    }
                    break;
                }

                default: {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing the request.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        try {
            if ("create".equalsIgnoreCase(action)) {
                createBlog(request, response);
            } else if ("update".equals(action)) {
                updateBlog(request, response);
            } else if ("delete".equals(action)) {
                int blogId = Integer.parseInt(request.getParameter("blogId"));
                try {
                    blogDao.deleteBlog(blogId);
                } catch (SQLException ex) {
                    Logger.getLogger(BlogsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                response.getWriter().print("deleted");

            } else if ("deleteImage".equals(action)) {
                try {
                    int imageId = Integer.parseInt(request.getParameter("imageId"));
                    blogDao.deleteImageById(imageId);
                    response.getWriter().print("image_deleted");
                } catch (SQLException ex) {
                    Logger.getLogger(BlogsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

            } else if ("setPrimaryImage".equals(action)) {
                    int blogId = Integer.parseInt(request.getParameter("blogId"));
                    int imageId = Integer.parseInt(request.getParameter("imageId"));
                    blogDao.setPrimaryImage(blogId, imageId);
                    response.getWriter().print("primary_set");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Invalid or missing action.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().print("error: " + e.getMessage());
        }
    }

    private void createBlog(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String caption = request.getParameter("caption");
            int authorId = 8; // hardcoded
            boolean isPublished = true;
            LocalDateTime now = LocalDateTime.now();

            if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Missing title or content");
                return;
            }

            int blogId = blogDao.createBlog(title, content, now, now, authorId, isPublished);

            if (blogId > 0) {
                int index = 0;
                for (Part part : request.getParts()) {
                    if ("image".equals(part.getName()) && part.getSize() > 0) {
                        if (index >= 4) { // Kiểm tra nếu số lượng ảnh vượt quá 4
                            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                            response.getWriter().write("Only a maximum of 4 photos can be uploaded.");
                            return; // Dừng xử lý nếu tải lên quá 4 ảnh
                        }
                        byte[] imageData = getImageBytes(part);
                        boolean isPrimary = (index == 0);
                        blogDao.insertBlogImage(blogId, imageData, caption, isPrimary);
                        index++;

                    }
                }
                response.getWriter().write("created");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Failed to create blog");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error: " + e.getMessage());
        }
    }

    private void updateBlog(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            // Lấy thông tin từ request
            String blogIdParam = request.getParameter("blogId");
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String caption = request.getParameter("caption");
            int authorId = 8; // hardcoded
            LocalDateTime now = LocalDateTime.now();

            if (blogIdParam == null || blogIdParam.trim().isEmpty() || title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Missing blog ID, title or content");
                return;
            }

            int blogId = Integer.parseInt(blogIdParam);

            // Tạo đối tượng Blog từ thông tin đã lấy
            Blog blog = new Blog();
            blog.setBlogId(blogId);
            blog.setTitle(title);
            blog.setContent(content);
            blog.setUpdatedAt(now);
            blog.setAuthor(blogDao.getbyID(authorId));

            // Cập nhật blog vào cơ sở dữ liệu
            blogDao.updateBlog(blog);

            // Cập nhật ảnh nếu có
            try {
                Part mainImagePart = request.getPart("mainImage");
                if (mainImagePart != null && mainImagePart.getSize() > 0) {
                    byte[] mainImageBytes = getImageBytes(mainImagePart);
                    blogDao.insertBlogImage(blogId, mainImageBytes, caption, true);
                }
            } catch (IllegalStateException | IOException ex) {
                System.err.println("Lỗi khi xử lý ảnh chính: " + ex.getMessage());
            }

            // ✅ Thêm ảnh phụ (nếu có)
            for (Part part : request.getParts()) {
                if ("images".equals(part.getName()) && part.getSize() > 0) {
                    byte[] imageData = getImageBytes(part);
                    blogDao.insertBlogImage(blogId, imageData, caption, false);
                }
            }

            response.getWriter().write("updated");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error: " + e.getMessage());
        }
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
        return "Handles CRUD operations for blogs";
    }
}
