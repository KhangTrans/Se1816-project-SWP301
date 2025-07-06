 /*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Products;
import db.DBcontext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ADMIN
 */
public class FavoriteListDao extends DBcontext {

    // Method to add a product to the favorites list
    public boolean addFavorite(int accountId, int productId) {
        // SQL to check if the product is already in the favorites list for the account
        String checkExistenceSql = "SELECT COUNT(*) FROM favorite_list WHERE account_id = ? AND product_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(checkExistenceSql)) {

            stmt.setInt(1, accountId);
            stmt.setInt(2, productId);

            ResultSet rs = stmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                // Product already exists in the favorites list
                return false;  // Don't add the product if it's already there
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        // SQL to insert the product into the favorites list
        String insertSql = "INSERT INTO favorite_list (account_id, product_id) VALUES (?, ?)";

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(insertSql)) {

            stmt.setInt(1, accountId);
            stmt.setInt(2, productId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;  // Return true if insertion was successful
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Method to remove a product from the favorites list
    public boolean deleteFavorite(int accountId, int productId) {
        // SQL to delete the product from the favorites list
        String deleteSql = "DELETE FROM favorite_list WHERE account_id = ? AND product_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(deleteSql)) {

            stmt.setInt(1, accountId);
            stmt.setInt(2, productId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;  // Return true if deletion was successful
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Method to get all favorite products of a customer by their account ID
    public List<Products> getAllFavorite(int accountId) {
        List<Products> favoriteProducts = new ArrayList<>();

        // SQL to select all favorite products for the account
        String sql = "SELECT p.product_id, p.name, p.description, p.price, p.stock_quantity, p.category_id, p.is_active "
                + "FROM products p "
                + "JOIN favorite_list f ON p.product_id = f.product_id "
                + "JOIN accounts a ON f.account_id = a.account_id "
                + "WHERE a.account_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, accountId);  // Set the account ID for the query

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                // Create a Product object for each row in the result set
                Products product = new Products();
                product.setProductId(rs.getInt("product_id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStockQuantity(rs.getInt("stock_quantity"));
                product.setActive(rs.getBoolean("is_active"));

                // Add the product to the favorites list
                favoriteProducts.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();  // Print the exception if one occurs
        }

        return favoriteProducts;  // Return the list of favorite products
    }

    // Method to check if a product is already in the favorites list
    public boolean isProductInFavorites(int accountId, int productId) {
        String checkExistenceSql = "SELECT COUNT(*) FROM favorite_list WHERE account_id = ? AND product_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(checkExistenceSql)) {

            stmt.setInt(1, accountId);
            stmt.setInt(2, productId);

            ResultSet rs = stmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                // If product exists in the favorites list, return true
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;  // Product not found in the favorites list
    }
}
