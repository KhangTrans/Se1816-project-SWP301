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
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.math.BigDecimal;

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
     * Retrieves grouped order history for a specific account
     * Orders with the same referral code are grouped together
     *
     * @param accountId The account ID to get order history for
     * @return List of grouped order objects containing order details
     */
    public List<Map<String, Object>> getGroupedOrderHistory(int accountId) {
        List<Map<String, Object>> groupedOrderList = new ArrayList<>();
        List<String> seenReferralCodes = new ArrayList<>();

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
                + "o.order_date, "
                + "pi.image_id " 
                + "FROM orders o "
                + "JOIN order_items oi ON o.order_id = oi.order_id "
                + "JOIN products p ON oi.product_id = p.product_id "
                + "LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1 "
                + "WHERE o.account_id = ? "
                + "ORDER BY o.order_date DESC, o.referral_code";

        try (Connection conn = db.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, accountId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                String referralCode = rs.getString("referral_code");
                
                // Check if we have already seen this referral code
                boolean alreadySeen = false;
                for (String seenCode : seenReferralCodes) {
                    if (seenCode.equals(referralCode)) {
                        alreadySeen = true;
                        break;
                    }
                }
                
                if (!alreadySeen) {
                    // This is the first time we see this referral code, so create a new group
                    Map<String, Object> orderGroup = new HashMap<>();
                    orderGroup.put("orderId", rs.getInt("order_id"));
                    orderGroup.put("referralCode", referralCode);
                    orderGroup.put("productId", rs.getInt("product_id"));
                    orderGroup.put("price", rs.getDouble("unit_price"));
                    orderGroup.put("productName", rs.getString("product_name"));
                    orderGroup.put("quantity", rs.getInt("quantity"));
                    orderGroup.put("customerName", rs.getString("customer_name"));
                    orderGroup.put("customerPhone", rs.getString("customer_phone_number"));
                    orderGroup.put("shippingAddress", rs.getString("shipping_address"));
                    orderGroup.put("status", rs.getString("status"));
                    orderGroup.put("imageId", rs.getInt("image_id"));
                    orderGroup.put("orderDate", rs.getTimestamp("order_date"));
                    orderGroup.put("totalAmount", rs.getBigDecimal("total_amount"));
                    
                    // Calculate total price for this item
                    double price = rs.getDouble("unit_price");
                    int quantity = rs.getInt("quantity");
                    orderGroup.put("totalPrice", price * quantity);
                    
                    // Count how many items are in this referral code group
                    int itemCount = countItemsInReferralCode(referralCode, accountId, conn);
                    orderGroup.put("itemCount", itemCount);
                    
                    // Add to our lists
                    groupedOrderList.add(orderGroup);
                    seenReferralCodes.add(referralCode);
                }
            }

        } catch (SQLException ex) {
            Logger.getLogger(HistoryOrderDao.class.getName()).log(Level.SEVERE, "Error getting grouped order history", ex);
        }

        return groupedOrderList;
    }
    
    // Simple helper method to count items in a referral code
    private int countItemsInReferralCode(String referralCode, int accountId, Connection conn) {
        int count = 0;
        String countSql = "SELECT COUNT(*) FROM orders o "
                + "JOIN order_items oi ON o.order_id = oi.order_id "
                + "WHERE o.referral_code = ? AND o.account_id = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(countSql)) {
            stmt.setString(1, referralCode);
            stmt.setInt(2, accountId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(HistoryOrderDao.class.getName()).log(Level.SEVERE, "Error counting items", ex);
        }
        
        return count;
    }

    /**
     * Gets all order items for a specific referral code (grouped order details)
     *
     * @param referralCode The referral code to get all items for
     * @param accountId The account ID to verify ownership
     * @return List of all order items for the referral code
     */
    public List<Map<String, Object>> getGroupedOrderDetails(String referralCode, int accountId) {
        List<Map<String, Object>> orderItems = new ArrayList<>();

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
                + "o.total_amount, "
                + "pi.image_id "
                + "FROM orders o "
                + "JOIN order_items oi ON o.order_id = oi.order_id "
                + "JOIN products p ON oi.product_id = p.product_id "
                + "LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1 "
                + "WHERE o.referral_code = ? AND o.account_id = ? "
                + "ORDER BY oi.order_item_id";

        try (Connection conn = db.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, referralCode);
            stmt.setInt(2, accountId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> orderItem = new HashMap<>();
                orderItem.put("orderId", rs.getInt("order_id"));
                orderItem.put("referralCode", rs.getString("referral_code"));
                orderItem.put("orderDate", rs.getTimestamp("order_date").toString());
                orderItem.put("productId", rs.getInt("product_id"));
                orderItem.put("productName", rs.getString("product_name"));
                orderItem.put("quantity", rs.getInt("quantity"));
                
                // Store unit price and total price separately
                double unitPrice = rs.getDouble("unit_price");
                int quantity = rs.getInt("quantity");
                orderItem.put("unitPrice", unitPrice);
                orderItem.put("subtotal", unitPrice * quantity);
                
                orderItem.put("customerName", rs.getString("customer_name"));
                orderItem.put("customerPhone", rs.getString("customerPhone"));
                orderItem.put("shippingAddress", rs.getString("shipping_address"));
                orderItem.put("status", rs.getString("status"));
                orderItem.put("imageId", rs.getInt("image_id"));
                orderItem.put("totalAmount", rs.getBigDecimal("total_amount"));
                
                orderItems.add(orderItem);
            }

        } catch (SQLException ex) {
            Logger.getLogger(HistoryOrderDao.class.getName()).log(Level.SEVERE, "Error getting grouped order details", ex);
        }

        return orderItems;
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
                + "o.total_amount, "
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
                orderDetails.put("subtotal", unitPrice * quantity);
                
                orderDetails.put("customerName", rs.getString("customer_name"));
                orderDetails.put("customerPhone", rs.getString("customerPhone"));
                orderDetails.put("shippingAddress", rs.getString("shipping_address"));
                orderDetails.put("status", rs.getString("status"));
                orderDetails.put("imageId", rs.getInt("image_id"));
                orderDetails.put("totalAmount", rs.getBigDecimal("total_amount"));
                
                // Get voucher information if any
                Map<String, Object> voucherInfo = getVoucherInfoForOrder(orderId);
                if (voucherInfo != null) {
                    orderDetails.put("voucherCode", voucherInfo.get("voucherCode"));
                    orderDetails.put("discountAmount", voucherInfo.get("discountAmount"));
                    orderDetails.put("priceAfterDiscount", voucherInfo.get("priceAfterDiscount"));
                } else {
                    // No voucher used
                    orderDetails.put("voucherCode", "No voucher applied");
                    orderDetails.put("discountAmount", 0.0);
                    orderDetails.put("priceAfterDiscount", rs.getBigDecimal("total_amount"));
                }
            }

        } catch (SQLException ex) {
            Logger.getLogger(HistoryOrderDao.class.getName()).log(Level.SEVERE, "Error getting order details", ex);
        }

        return orderDetails;
    }

    /**
     * Gets voucher information for a specific order
     *
     * @param orderId The ID of the order
     * @return Map containing voucher details, or null if no voucher was used
     */
    private Map<String, Object> getVoucherInfoForOrder(int orderId) {
        Map<String, Object> voucherInfo = null;

        String sql = "SELECT "
                + "v.voucher_code, "
                + "ov.discount_amount "
                + "FROM order_vouchers ov "
                + "JOIN vouchers v ON ov.voucher_id = v.voucher_id "
                + "WHERE ov.order_id = ?";

        try (Connection conn = db.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                voucherInfo = new HashMap<>();
                voucherInfo.put("voucherCode", rs.getString("voucher_code"));
                BigDecimal discountAmount = rs.getBigDecimal("discount_amount");
                voucherInfo.put("discountAmount", discountAmount);
                
                // Get the order total before discount
                BigDecimal totalBeforeDiscount = getOrderTotalBeforeDiscount(orderId, conn);
                // Calculate price after discount
                BigDecimal priceAfterDiscount = totalBeforeDiscount.subtract(discountAmount);
                if (priceAfterDiscount.compareTo(BigDecimal.ZERO) < 0) {
                    priceAfterDiscount = BigDecimal.ZERO;
                }
                voucherInfo.put("priceAfterDiscount", priceAfterDiscount);
            }
        } catch (SQLException ex) {
            Logger.getLogger(HistoryOrderDao.class.getName()).log(Level.SEVERE, "Error getting voucher info", ex);
        }

        return voucherInfo;
    }

    /**
     * Gets the total price of an order before discount
     *
     * @param orderId The ID of the order
     * @param conn An existing database connection to reuse
     * @return The total price of the order before discount
     */
    private BigDecimal getOrderTotalBeforeDiscount(int orderId, Connection conn) throws SQLException {
        BigDecimal totalBeforeDiscount = BigDecimal.ZERO;
        
        String sql = "SELECT SUM(oi.quantity * oi.unit_price) as total_before_discount "
                + "FROM order_items oi "
                + "WHERE oi.order_id = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                totalBeforeDiscount = rs.getBigDecimal("total_before_discount");
                if (totalBeforeDiscount == null) {
                    totalBeforeDiscount = BigDecimal.ZERO;
                }
            }
        }
        
        return totalBeforeDiscount;
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
        
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
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
        Connection conn = null;
        boolean success = false;
        
        try {
            conn = db.getConnection();
            conn.setAutoCommit(false);  // Begin transaction
            
            // First, get all order items to return to inventory
            List<OrderItem> orderItems = getOrderItemsForCancellation(orderId, conn);
            
            // Mark the order as cancelled
            String updateOrderSql = "UPDATE orders SET status = 'cancelled' WHERE order_id = ? AND account_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateOrderSql)) {
                stmt.setInt(1, orderId);
                stmt.setInt(2, accountId);
                
                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    // Order was successfully marked as cancelled, now return items to inventory
                    ProductDao productDao = new ProductDao();
                    for (OrderItem item : orderItems) {
                        // Return the quantity back to inventory (subtract negative quantity = add)
                        returnProductToInventory(item.getProductId(), item.getQuantity(), conn);
                    }
                    
                    // Commit the transaction
                    conn.commit();
                    success = true;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(HistoryOrderDao.class.getName()).log(Level.SEVERE, "Error cancelling order", ex);
            // Rollback transaction in case of error
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    Logger.getLogger(HistoryOrderDao.class.getName()).log(Level.SEVERE, "Error during transaction rollback", rollbackEx);
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ex) {
                    Logger.getLogger(HistoryOrderDao.class.getName()).log(Level.SEVERE, "Error closing connection", ex);
                }
            }
        }
        
        return success;
    }

    /**
     * Gets all order items for a cancelled order
     * 
     * @param orderId The ID of the cancelled order
     * @param conn The database connection to use
     * @return List of OrderItem objects
     * @throws SQLException If a database error occurs
     */
    private List<OrderItem> getOrderItemsForCancellation(int orderId, Connection conn) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        
        String sql = "SELECT order_item_id, product_id, quantity FROM order_items WHERE order_id = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setOrderItemId(rs.getInt("order_item_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    items.add(item);
                }
            }
        }
        
        return items;
    }

    /**
     * Returns product quantity back to inventory
     * 
     * @param productId The ID of the product
     * @param quantityToReturn The quantity to return
     * @param conn The database connection to use
     * @throws SQLException If a database error occurs
     */
    private void returnProductToInventory(int productId, int quantityToReturn, Connection conn) throws SQLException {
        String sql = "UPDATE products SET stock_quantity = stock_quantity + ? WHERE product_id = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantityToReturn);
            ps.setInt(2, productId);
            ps.executeUpdate();
        }
    }
}
