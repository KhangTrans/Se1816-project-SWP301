/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ControllerAdmin;

import db.DBcontext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author Admin
 */
@MultipartConfig
public class ImagesServlet extends HttpServlet {

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
        String type = request.getParameter("type");
        String imageIdParam = request.getParameter("imageId");
        if (imageIdParam == null) {
            imageIdParam = request.getParameter("id"); // fallback
        }
        if (type == null || imageIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
            return;
        }

        int imageId;
        try {
            imageId = Integer.parseInt(imageIdParam);
            System.out.println("Đang xử lý ảnh ID = " + imageId);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid imageId");
            return;
        }

        String sql;
        // Kiểm tra type và chọn bảng phù hợp
        if ("product".equalsIgnoreCase(type)) {
            sql = "SELECT image_url FROM product_images WHERE image_id = ?";
        } else if ("blog".equalsIgnoreCase(type)) {
            sql = "SELECT image_url FROM blog_images WHERE image_id = ?";
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid type");
            return;
        }

        try ( Connection conn = new DBcontext().getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, imageId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Blob blob = rs.getBlob("image_url");
                if (blob == null || blob.length() == 0) {
                    response.sendRedirect(request.getContextPath() + "/avatar/default.png");
                    return;
                }
                System.out.println("Ảnh kích thước: " + blob.length());
                System.out.println("Loại MIME: " + getServletContext().getMimeType("image.jpg"));

                // Thêm header để tránh cache và set MIME
                response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                response.setHeader("Pragma", "no-cache");
                response.setDateHeader("Exapires", 0);
                response.setContentType("image/jpeg"); // Hoặc image/png nếu cần

                byte[] imageBytes = blob.getBytes(1, (int) blob.length());
                response.setContentLength(imageBytes.length); // rất quan trọng

                try ( OutputStream os = response.getOutputStream()) {
                    os.write(imageBytes);
                    os.flush();
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/avatar/default.png");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading image");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");
        String parentIdStr = request.getParameter("parentId");

        if (type == null || parentIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
            return;
        }

        int parentId = Integer.parseInt(parentIdStr);
        boolean isPrimary = Boolean.parseBoolean(request.getParameter("isPrimary"));

        Part imagePart = request.getPart("image");

        if (imagePart == null || imagePart.getSize() == 0) {
            response.getWriter().write("Image file is missing");
            return;
        }

        String insertSQL;
        if ("product".equalsIgnoreCase(type)) {
            insertSQL = "INSERT INTO product_images (product_id, image_url, is_primary) VALUES (?, ?, ?)";
        } else if ("blog".equalsIgnoreCase(type)) {
            insertSQL = "INSERT INTO blog_images (blog_id, image_url, is_primary) VALUES ( ?, ?, ?)";
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid type");
            return;
        }

        try ( Connection conn = new DBcontext().getConnection();  PreparedStatement stmt = conn.prepareStatement(insertSQL)) {

            stmt.setInt(1, parentId);
            InputStream inputStream = imagePart.getInputStream();
            stmt.setBinaryStream(2, inputStream, (int) imagePart.getSize());

            if ("product".equalsIgnoreCase(type)) {
                stmt.setBoolean(3, isPrimary);
            } else if ("blog".equalsIgnoreCase(type)) {
                stmt.setBoolean(3, isPrimary);

            }

            stmt.executeUpdate();
            response.getWriter().write("OK");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("ERROR");
        }

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
