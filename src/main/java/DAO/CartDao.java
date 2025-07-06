package DAO;

import Model.CartItem;
import Model.Customer;
import Model.Products;
import db.DBcontext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDao extends DBcontext {

    // Kiểm tra sản phẩm đã có trong giỏ hàng hay chưa
    public boolean exists(int accountId, int productId) throws SQLException {
        String sql = "SELECT 1 FROM cart_items WHERE account_id = ? AND product_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ps.setInt(2, productId);
            try ( ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Trả về true nếu tồn tại
            }
        }
    }

    // Thêm mới hoặc cập nhật giỏ hàng
    public void addOrUpdate(int accountId, int productId, int quantity) throws SQLException {
        if (exists(accountId, productId)) {
            // Cập nhật số lượng sản phẩm trong giỏ hàng nếu đã tồn tại
            String sql = "UPDATE cart_items SET quantity = quantity + ? WHERE account_id = ? AND product_id = ?";
            try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, quantity);
                ps.setInt(2, accountId);
                ps.setInt(3, productId);
                ps.executeUpdate();
            }
        } else {
            // Thêm mới sản phẩm vào giỏ hàng nếu chưa có
            String sql = "INSERT INTO cart_items (account_id, product_id, quantity, added_at) VALUES (?, ?, ?, GETDATE())";
            try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, accountId);
                ps.setInt(2, productId);
                ps.setInt(3, quantity);
                ps.executeUpdate();
            }
        }
    }

// Lấy danh sách các mục trong giỏ hàng của khách hàng
    public List<CartItem> getCartItems(int accountId) throws SQLException {
        List<CartItem> list = new ArrayList<>();

        String sql = "SELECT ci.cart_item_id, ci.quantity, ci.added_at, "
                + "p.product_id, p.name, p.price, "
                + "img.image_id "
                + "FROM cart_items ci "
                + "JOIN products p ON ci.product_id = p.product_id "
                + "LEFT JOIN product_images img ON p.product_id = img.product_id AND img.is_primary = 1 "
                + "WHERE ci.account_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Products product = new Products();
                    product.setProductId(rs.getInt("product_id"));
                    product.setName(rs.getString("name"));
                    product.setPrice(rs.getDouble("price"));
                    product.setPrimaryImageId(rs.getInt("image_id"));

                    Customer customer = new Customer();
                    customer.setCustomerId(accountId);

                    CartItem item = new CartItem();
                    item.setCartItemId(rs.getInt("cart_item_id"));
                    item.setAccountId(accountId); 
                    item.setProductId(rs.getInt("product_id")); 
                    item.setQuantity(rs.getInt("quantity"));
                    item.setAddedAt(rs.getTimestamp("added_at").toLocalDateTime());

                    list.add(item);
                }
            }
        }
        return list;
    }

    // Cập nhật số lượng giỏ hàng
    public void updateQuantity(int accountId, int productId, int quantity) throws SQLException {
        String sql = "UPDATE cart_items SET quantity = ? WHERE account_id = ? AND product_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, accountId);
            ps.setInt(3, productId);
            ps.executeUpdate();
        }
    }

    // Xóa một sản phẩm khỏi giỏ hàng
    public void removeItem(int accountId, int productId) throws SQLException {
        String sql = "DELETE FROM cart_items WHERE account_id = ? AND product_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ps.setInt(2, productId);
            ps.executeUpdate();
        }
    }

    // Xóa toàn bộ giỏ hàng của khách hàng
    public void clearCart(int accountId) throws SQLException {
        String sql = "DELETE FROM cart_items WHERE account_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ps.executeUpdate();
        }
    }
}
