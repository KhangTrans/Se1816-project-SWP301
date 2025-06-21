/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Account;
import Model.Blog;
import Model.BlogImage;
import Model.Staff;
import db.DBcontext;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import org.checkerframework.checker.units.qual.A;

/**
 *
 * @author Admin
 */
public class BlogDao extends DBcontext {

    public List<Blog> getAllBlogs() throws SQLException {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.*, i.image_id AS imageId "
                + "FROM blogs b "
                + "LEFT JOIN blog_images i ON b.blog_id = i.blog_id AND i.is_primary = 1"; // hoặc cách xác định ảnh chính

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Blog blog = new Blog();
                blog.setBlogId(rs.getInt("blog_id"));
                blog.setTitle(rs.getString("title"));
                blog.setContent(rs.getString("content"));
                blog.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                blog.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                blog.setPrimaryImageId(rs.getInt("imageId")); // Đảm bảo có get/setImageId()
                list.add(blog);
            }
        }
        return list;
    }

    public int createBlog(String title, String content, LocalDateTime created_at, LocalDateTime updated_at, int author_id, boolean is_published) throws SQLException {
        String sql = "INSERT INTO blogs (title, content, created_at, updated_at, author_id, is_published) VALUES(?, ?, ?, ?, ?, ?)";
        try ( Connection conn = new DBcontext().getConnection();  PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setTimestamp(3, Timestamp.valueOf(created_at));
            ps.setTimestamp(4, Timestamp.valueOf(updated_at));
            ps.setInt(5, author_id);
            ps.setBoolean(6, is_published);

            int affectedRows = ps.executeUpdate();  // Kiểm tra số dòng bị ảnh hưởng
            if (affectedRows == 0) {
                throw new SQLException("Không có dòng nào bị ảnh hưởng!");
            }

            // Lấy ID blog vừa tạo
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);  // Trả về ID của blog mới
            }
        }
        return -1;  // Trả về -1 nếu không có ID được tạo
    }

    public Staff getbyID(int id) {
        String sql = "select * from [dbo].[staff] where staff_id = ?";
        try ( Connection conn = new DBcontext().getConnection();  PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String status = rs.getString("status");
                int account_id = rs.getInt("account_id");
                String full_name = rs.getString("full_name");
                String email = rs.getString("email");
                String staff_code = rs.getString("staff_code");
                String phone = rs.getString("phone");
                String position = rs.getString("position");
                UserDao dao = new UserDao();
                Account acc = dao.getAccountById(account_id);
                Staff t = new Staff(id, status, acc, full_name, email, staff_code, phone, position);
                return t;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public List<BlogImage> getImagesByBlog(int blogID) {
        List<BlogImage> b = new ArrayList<>();
        String sql = "select * from [dbo].[blog_images] where blog_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, blogID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int imageId = rs.getInt("image_id");
                int blogId = rs.getInt("blog_id");
                Blog blog = getBlogByID(blogId);
                // Lấy ảnh từ BLOB
                Blob imageBlob = rs.getBlob("image_url");
                byte[] imageBytes = null;
                if (imageBlob != null) {
                    imageBytes = imageBlob.getBytes(1, (int) imageBlob.length());
                }
                LocalDateTime uploadedAt = rs.getTimestamp("uploaded_at").toLocalDateTime();
                boolean isprimary = rs.getBoolean("is_primary");
                b.add(new BlogImage(imageId, blog, imageBytes, uploadedAt, isprimary));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return b;
    }

    public Blog getBlogByID(int id) {
        String sql = "select * from [dbo].[blogs] where blog_id = ?";
        try ( Connection conn = new DBcontext().getConnection();  PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String title = rs.getString("title");
                String content = rs.getString("content");
                LocalDateTime create = rs.getTimestamp("created_at").toLocalDateTime();
                LocalDateTime update = rs.getTimestamp("updated_at").toLocalDateTime();
                int author_id = rs.getInt("author_id");
                Staff s = getbyID(author_id);
                boolean is_pub = rs.getBoolean("is_published");

                Blog b = new Blog(id, title, content, create, update, s);
                return b;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public void insertBlogImage(int blogId, byte[] imageData, boolean isPrimary) throws SQLException, IOException {
        String sql = "INSERT INTO blog_images (blog_id, image_url, uploaded_at, is_primary) VALUES (?, ?, ?, ?)";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, blogId);  // Chèn blogId
            ps.setBytes(2, imageData);  // Chèn dữ liệu hình ảnh
            ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));  // Chèn thời gian tải lên
            ps.setBoolean(4, isPrimary);
            ps.executeUpdate();
        }
    }

    public void setPrimaryImage(int blogId, int imageId) throws SQLException {
        String resetAll = "UPDATE blog_images SET is_primary = 0 WHERE blog_id = ?";
        String setOne = "UPDATE blog_images SET is_primary = 1 WHERE image_id = ?";

        try ( Connection conn = new DBcontext().getConnection()) {
            try ( PreparedStatement ps1 = conn.prepareStatement(resetAll)) {
                ps1.setInt(1, blogId);
                ps1.executeUpdate();
            }

            try ( PreparedStatement ps2 = conn.prepareStatement(setOne)) {
                ps2.setInt(1, imageId);
                ps2.executeUpdate();
            }
        }
    }

    public BlogImage getPrimaryImage(int blogId) {
        String sql = "SELECT image_id FROM blog_images WHERE blog_id = ? AND is_primary = 1";
        try ( Connection conn = new DBcontext().getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, blogId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                BlogImage img = new BlogImage();
                img.setImageId(rs.getInt("image_id"));
                return img;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateBlog(Blog b) throws SQLException {
        String sql = "update blogs set title = ?, content = ?, updated_at = ?, author_id = ? where blog_id = ?";
        try ( Connection conn = new DBcontext().getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getContent());
            ps.setTimestamp(3, Timestamp.valueOf(b.getUpdatedAt()));
            ps.setInt(4, b.getAuthor().getStaffId());
            ps.setInt(5, b.getBlogId());

            ps.executeUpdate();
        }
    }
    public void deleteBlog(int blogId) throws SQLException {
        String sql = "delete from blogs where blog_id = ?";
        try ( Connection conn = new DBcontext().getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, blogId);
            ps.executeUpdate();
        }
    }
    
    public void deleteImageById(int imageId) throws SQLException {
        String sql = "DELETE FROM blog_images WHERE image_id = ?";
        try ( Connection conn = new DBcontext().getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, imageId);
            ps.executeUpdate();
        }
    }
    
    public static void main(String[] args) throws SQLException {
        BlogDao dao = new BlogDao();
        
        System.out.println(dao.getBlogByID(6));
    }

}
