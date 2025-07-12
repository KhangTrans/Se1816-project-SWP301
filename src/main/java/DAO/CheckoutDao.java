package DAO;

import Model.CartItem;
import Model.Products;
import Model.Categories;
import db.DBcontext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CheckoutDao extends DBcontext {

    // Phương thức lấy thông tin sản phẩm trong giỏ hàng của người dùng
    public List<CartItem> getCartItems(int accountId) {
        List<CartItem> cartItems = new ArrayList<>();
        String query = "SELECT ci.cart_item_id, ci.product_id, ci.quantity, p.name, p.description, p.price, p.stock_quantity, p.active, p.category_id "
                + "FROM cart_items ci "
                + "JOIN products p ON ci.product_id = p.product_id "
                + "WHERE ci.account_id = ?";

        System.out.println("Đang truy vấn giỏ hàng cho accountId: " + accountId);  // Thêm log để kiểm tra accountId

        try ( Connection conn = new DBcontext().getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, accountId); // Đặt giá trị account_id từ tham số
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int cartItemId = rs.getInt("cart_item_id");
                int productId = rs.getInt("product_id");
                int quantity = rs.getInt("quantity");
                String productName = rs.getString("name");
                String description = rs.getString("description");
                double price = rs.getDouble("price");
                int stockQuantity = rs.getInt("stock_quantity");
                boolean active = rs.getBoolean("active");
                int categoryId = rs.getInt("category_id");

                // Tạo đối tượng Categories từ categoryId (giả sử bạn có lớp Categories)
                Categories category = new Categories(categoryId);

                // Tạo đối tượng sản phẩm
                Products product = new Products(productId, productName, description, price, stockQuantity, active, category);

                // Tạo đối tượng CartItem và thêm vào danh sách
                CartItem item = new CartItem(cartItemId, accountId, productId, quantity, product, rs.getTimestamp("added_at").toLocalDateTime());
                cartItems.add(item);

                // Thêm log để kiểm tra dữ liệu sản phẩm trong giỏ hàng
                System.out.println("Sản phẩm trong giỏ hàng: " + productName + ", Số lượng: " + quantity + ", Giá: " + price);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Kiểm tra nếu giỏ hàng có sản phẩm hay không
        if (cartItems.isEmpty()) {
            System.out.println("Giỏ hàng trống.");
        }

        return cartItems;
    }

}
