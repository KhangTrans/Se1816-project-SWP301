/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Account;
import Model.Products;
import Model.Review;
import db.DBcontext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Admin
 */
public class ReviewDao extends DBcontext {

// Phương thức thêm đánh giá vào cơ sở dữ liệu
    public boolean addReview(Review review) {
        String sql = "INSERT INTO product_reviews (product_id, account_id, rating, comment, created_at) "
                + "VALUES (?, ?, ?, ?, GETDATE())";

        try ( Connection con = getConnection();  PreparedStatement pst = con.prepareStatement(sql)) {

            // Set các tham số vào câu truy vấn
            pst.setInt(1, review.getProduct().getProductId());  // ID sản phẩm
            pst.setInt(2, review.getAccount().getAccountId());  // ID tài khoản
            pst.setInt(3, review.getRating());                  // Đánh giá sao
            pst.setString(4, review.getComment());              // Bình luận

            // Thực thi câu lệnh SQL
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;  // Trả về true nếu câu lệnh INSERT thành công
        } catch (SQLException e) {
            e.printStackTrace();
            return false;  // Trả về false nếu có lỗi xảy ra
        }
    }

// Phương thức lấy tất cả các đánh giá của một sản phẩm
    public List<Review> getReviewsByProductId(int productId) {
        List<Review> reviews = new ArrayList<>();

        // Câu lệnh SQL để lấy các thông tin đánh giá từ bảng 'product_reviews'
        String sql = "SELECT r.review_id, r.product_id, r.account_id, r.rating, r.comment, r.created_at, a.username "
                + "FROM product_reviews r "
                + "JOIN accounts a ON r.account_id = a.account_id "
                + "WHERE r.product_id = ?";

        try ( Connection con = getConnection();  PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setInt(1, productId);  // Set productId vào câu truy vấn

            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                // Lấy thông tin từ ResultSet và gán vào đối tượng Review
                Products product = new Products();
                product.setProductId(rs.getInt("product_id"));  // Lấy thông tin sản phẩm từ cơ sở dữ liệu

                Account account = new Account();
                account.setAccountId(rs.getInt("account_id"));
                account.setUsername(rs.getString("username"));

                Review review = new Review();
                review.setReviewId(rs.getInt("review_id"));
                review.setProduct(product);
                review.setAccount(account);
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at"));

                reviews.add(review);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reviews;
    }
}
