/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Order;
import Model.OrderItem;
import Model.Products;
import db.DBcontext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Khaang
 */
public class HistoryOrderDao {

    private DBcontext db;

    public HistoryOrderDao() {
        db = new DBcontext();
    }

    /**
     * Retrieves order history for a specific account
     *
     * @param accountId The account ID to get order history for
     * @return List of OrderHistoryItem objects containing order details
     */
    public List<Map<String, Object>> getOrderHistory(int accountId) {
        List<Map<String, Object>> orderHistoryList = new ArrayList<>();

        String sql = "SELECT "
                + "o.order_id, "
                + "o.referral_code, "
                + "p.product_id, "
                + "oi.unit_price, "
                + "p.name AS product_name, "
                + "oi.quantity, "
                + "o.customer_name, "
                + "o.customer_phone_number, "
                + "o.shipping_address, "
                + "o.status, "
                + "o.total_amount, "
                + "pi.image_id "
                + "FROM orders o "
                + "JOIN order_items oi ON o.order_id = oi.order_id "
                + "JOIN products p ON oi.product_id = p.product_id "
                + "LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1 "
                + "WHERE o.account_id = ? "
                + "ORDER BY o.order_date DESC";

        try ( Connection conn = db.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, accountId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> orderItem = new HashMap<>();
                orderItem.put("orderId", rs.getInt("order_id"));
                orderItem.put("referralCode", rs.getString("referral_code"));
                orderItem.put("productId", rs.getInt("product_id"));
                orderItem.put("price", rs.getDouble("unit_price"));
                orderItem.put("productName", rs.getString("product_name"));
                orderItem.put("quantity", rs.getInt("quantity"));
                orderItem.put("customerName", rs.getString("customer_name"));
                orderItem.put("customerPhone", rs.getString("customer_phone_number"));
                orderItem.put("shippingAddress", rs.getString("shipping_address"));
                orderItem.put("status", rs.getString("status"));
                orderItem.put("imageId", rs.getInt("image_id"));
                // Calculate total price for this item
                double price = rs.getDouble("unit_price");
                int quantity = rs.getInt("quantity");
                orderItem.put("totalPrice", price * quantity);
                orderItem.put("totalAmount", rs.getBigDecimal("total_amount"));

                orderHistoryList.add(orderItem);
            }

        } catch (SQLException ex) {
            Logger.getLogger(HistoryOrderDao.class.getName()).log(Level.SEVERE, "Error getting order history", ex);
        }

        return orderHistoryList;
    }

    /**
     * Gets detailed information for a specific order
     *
     * @param orderId The ID of the order to retrieve
     * @param accountId The account ID to verify ownership
     * @return Map containing order details, or null if not found
     */
    public Map<String, Object> getOrderDetails(int orderId, int accountId) {
        Map<String, Object> orderDetails = null;

        String sql = "SELECT "
                + "o.order_id, "
                + "o.referral_code, "
                + "o.order_date, "
                + "p.product_id, "
                + "p.name AS product_name, "
                + "oi.quantity, "
                + "oi.unit_price, "
                + "o.customer_name, "
                + "o.customer_phone_number AS customerPhone, "
                + "o.shipping_address, "
                + "o.status, "
                + "pi.image_id "
                + "FROM orders o "
                + "JOIN order_items oi ON o.order_id = oi.order_id "
                + "JOIN products p ON oi.product_id = p.product_id "
                + "LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1 "
                + "WHERE o.order_id = ? AND o.account_id = ?";

        try ( Connection conn = db.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);
            stmt.setInt(2, accountId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                orderDetails = new HashMap<>();
                orderDetails.put("orderId", rs.getInt("order_id"));
                orderDetails.put("referralCode", rs.getString("referral_code"));
                orderDetails.put("orderDate", rs.getTimestamp("order_date").toString());
                orderDetails.put("productId", rs.getInt("product_id"));
                orderDetails.put("productName", rs.getString("product_name"));
                orderDetails.put("quantity", rs.getInt("quantity"));

                // Store unit price and total price separately
                double unitPrice = rs.getDouble("unit_price");
                int quantity = rs.getInt("quantity");
                orderDetails.put("unitPrice", unitPrice);
                orderDetails.put("totalPrice", unitPrice * quantity);

                orderDetails.put("customerName", rs.getString("customer_name"));
                orderDetails.put("customerPhone", rs.getString("customerPhone"));
                orderDetails.put("shippingAddress", rs.getString("shipping_address"));
                orderDetails.put("status", rs.getString("status"));
                orderDetails.put("imageId", rs.getInt("image_id"));
            }

        } catch (SQLException ex) {
            Logger.getLogger(HistoryOrderDao.class.getName()).log(Level.SEVERE, "Error getting order details", ex);
        }

        return orderDetails;
    }

    /**
     * Gets the total price of an order
     *
     * @param orderId The ID of the order
     * @return The total price of the order
     */
    public double getOrderTotalPrice(int orderId) {
        double totalPrice = 0.0;

        // This query calculates the sum of (quantity * unit_price) for all items in the order
        String sql = "SELECT SUM(oi.quantity * oi.unit_price) as total_price "
                + "FROM order_items oi "
                + "WHERE oi.order_id = ?";

        try ( Connection conn = db.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                totalPrice = rs.getDouble("total_price");
            }

        } catch (SQLException ex) {
            Logger.getLogger(HistoryOrderDao.class.getName()).log(Level.SEVERE, "Error calculating order total price", ex);
        }

        return totalPrice;
    }

    /**
     * Updates customer information for an order
     *
     * @param orderId The ID of the order to update
     * @param accountId The account ID to verify ownership
     * @param customerName New customer name
     * @param customerPhone New customer phone
     * @param shippingAddress New shipping address
     * @return true if update was successful, false otherwise
     */
    public boolean updateOrder(int orderId, int accountId, String customerName, String customerPhone, String shippingAddress) {
        String sql = "UPDATE orders SET "
                + "customer_name = ?, "
                + "customer_phone_number = ?, "
                + "shipping_address = ? "
                + "WHERE order_id = ? AND account_id = ?";

        try ( Connection conn = db.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, customerName);
            stmt.setString(2, customerPhone);
            stmt.setString(3, shippingAddress);
            stmt.setInt(4, orderId);
            stmt.setInt(5, accountId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException ex) {
            Logger.getLogger(HistoryOrderDao.class.getName()).log(Level.SEVERE, "Error updating order", ex);
            return false;
        }
    }

    /**
     * Deletes an order (or marks it as cancelled based on business rules)
     *
     * @param orderId The ID of the order to delete
     * @param accountId The account ID to verify ownership
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteOrder(int orderId, int accountId) {
        // In real-world applications, orders are typically not deleted but marked as cancelled
        String sql = "UPDATE orders SET status = 'cancelled' WHERE order_id = ? AND account_id = ?";

        try ( Connection conn = db.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);
            stmt.setInt(2, accountId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException ex) {
            Logger.getLogger(HistoryOrderDao.class.getName()).log(Level.SEVERE, "Error deleting/cancelling order", ex);
            return false;
        }
    }
}
