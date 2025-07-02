/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Order;
import Model.OrderItem;
import db.DBcontext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.math.BigDecimal;
import java.util.HashMap;
import java.sql.SQLException;

/**
 *
 * @author Admin
 */
public class OrderDao extends DBcontext {

    // Generate unique referral code
    public String generateOrderCode() {
        String code;
        do {
            int random = (int) (Math.random() * 1_000_000);
            code = "REF" + String.format("%06d", random);
        } while (isOrderCodeExists(code)); // Check for duplicates in DB
        return code;
    }

    // Check if referral code exists
    public boolean isOrderCodeExists(String code) {
        String sql = "SELECT 1 FROM orders WHERE referral_code = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try ( ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Count total number of orders
    public int countOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        System.out.println("Executing countOrders SQL: " + sql);
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("Order count: " + count);
                return count;
            }
        } catch (Exception e) {
            System.out.println("Error in countOrders: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // Get sales stats for last 7 days
    public Map<String, Integer> getSalesStatsLast7Days() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT FORMAT(order_date, 'yyyy-MM-dd') AS day, SUM(oi.quantity) AS total_sold "
                + "FROM order_items oi "
                + "JOIN orders o ON oi.order_id = o.order_id "
                + "WHERE o.order_date >= DATEADD(DAY, -6, CAST(GETDATE() AS DATE)) "
                + "GROUP BY FORMAT(order_date, 'yyyy-MM-dd') "
                + "ORDER BY day";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("day"), rs.getInt("total_sold"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    // Get sales stats for last 30 days
    public Map<String, Integer> getSalesStatsLast30Days() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT FORMAT(order_date, 'yyyy-MM-dd') AS day, SUM(oi.quantity) AS total_sold "
                + "FROM order_items oi "
                + "JOIN orders o ON oi.order_id = o.order_id "
                + "WHERE o.order_date >= DATEADD(DAY, -29, CAST(GETDATE() AS DATE)) "
                + "GROUP BY FORMAT(order_date, 'yyyy-MM-dd') "
                + "ORDER BY day";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("day"), rs.getInt("total_sold"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    // Get sales stats for today
    public Map<String, Integer> getSalesStatsToday() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT FORMAT(order_date, 'HH:00') AS hour_slot, SUM(oi.quantity) AS total_sold "
                + "FROM order_items oi "
                + "JOIN orders o ON oi.order_id = o.order_id "
                + "WHERE CAST(order_date AS DATE) = CAST(GETDATE() AS DATE) "
                + "GROUP BY FORMAT(order_date, 'HH:00') "
                + "ORDER BY hour_slot";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String hour = rs.getString("hour_slot");
                int sold = rs.getInt("total_sold");
                map.put(hour, sold);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    /**
     * Get all orders with required details, grouping items by order
     *
     * @return List of orders with their details
     */
    public List<Order> getAllOrders() {
        System.out.println("DEBUG - getAllOrders method called");
        List<Order> orders = new ArrayList<>();
        Map<Integer, Order> orderMap = new LinkedHashMap<>();

        String sql = "SELECT "
                + "o.order_id, "
                + "o.referral_code, "
                + "p.name, "
                + "oi.order_item_id, "
                + "oi.product_id, "
                + "oi.quantity, "
                + "oi.unit_price, "
                + "o.total_amount, "
                + "o.status, "
                + "o.shipping_address, "
                + "o.customer_name, "
                + "o.customer_phone_number, "
                + "o.order_date "
                + "FROM "
                + "orders o "
                + "JOIN "
                + "order_items oi ON o.order_id = oi.order_id "
                + "JOIN "
                + "products p ON oi.product_id = p.product_id "
                + "WHERE "
                + "o.account_id IN (SELECT account_id FROM accounts WHERE role = 'customer') "
                + "ORDER BY "
                + "o.order_date DESC";
        System.out.println("DEBUG - SQL query: " + sql);

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            System.out.println("DEBUG - Query executed, processing results");
            int rowCount = 0;

            while (rs.next()) {
                rowCount++;
                try {
                    int orderId = rs.getInt("order_id");
                    System.out.println("DEBUG - Processing row " + rowCount + " for order ID: " + orderId);

                    // Get order from map or create new if not exists
                    Order order = orderMap.getOrDefault(orderId, new Order());

                    // Set basic order information if not already in map
                    if (!orderMap.containsKey(orderId)) {
                        order.setOrderId(orderId);

                        String status = rs.getString("status");
                        String shipping = rs.getString("shipping_address");
                        String custName = rs.getString("customer_name");
                        String custPhone = rs.getString("customer_phone_number");
                        String refCode = rs.getString("referral_code");
                        BigDecimal total = rs.getBigDecimal("total_amount");

                        order.setStatus(status);
                        order.setShippingAddress(shipping);
                        order.setCustomerName(custName);
                        order.setCustomerPhoneNumber(custPhone);
                        order.setReferralCode(refCode);
                        order.setTotalAmount(total);

                        if (rs.getTimestamp("order_date") != null) {
                            order.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
                        }

                        System.out.println("DEBUG - Order base info set: ID=" + orderId
                                + ", Status=" + status
                                + ", CustomerName=" + custName
                                + ", RefCode=" + refCode);
                    }

                    // Add item to order if product info exists
                    String productName = rs.getString("name");
                    if (productName != null) {
                        List<OrderItem> items = order.getOrderItems();

                        OrderItem item = new OrderItem();
                        item.setOrderItemId(rs.getInt("order_item_id"));
                        item.setProductId(rs.getInt("product_id"));
                        item.setProductName(productName);

                        int qty = rs.getInt("quantity");
                        item.setQuantity(qty);

                        // Set unitPrice from the query result
                        BigDecimal unitPrice = rs.getBigDecimal("unit_price");
                        if (unitPrice != null) {
                            item.setUnitPrice(unitPrice);
                        }

                        // Set relationship with order
                        item.setOrder(order);

                        System.out.println("DEBUG - Added order item: Product=" + productName
                                + ", Quantity=" + qty
                                + ", UnitPrice=" + unitPrice);

                        items.add(item);
                    }

                    orderMap.put(orderId, order);
                } catch (Exception e) {
                    System.out.println("ERROR - Exception processing row " + rowCount + ": " + e.getMessage());
                    e.printStackTrace();
                }
            }

            System.out.println("DEBUG - Processed " + rowCount + " rows from query");
            System.out.println("DEBUG - Found " + orderMap.size() + " unique orders");

            orders.addAll(orderMap.values());

        } catch (Exception e) {
            System.out.println("ERROR in getAllOrders: " + e.getMessage());
            e.printStackTrace();
        }

        // Ensure all orders have non-null orderItems
        for (Order order : orders) {
            if (order.getOrderItems() == null) {
                order.setOrderItems(new ArrayList<OrderItem>());
                System.out.println("DEBUG - Set empty orderItems for order ID: " + order.getOrderId());
            }
        }

        System.out.println("DEBUG - Returning " + orders.size() + " orders");
        return orders;
    }

    /**
     * Update order status
     *
     * @param orderId Order ID to update
     * @param status New status
     * @return true if update successful, false otherwise
     */
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("ERROR in updateOrderStatus: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete an order and related records
     *
     * @param orderId Order ID to delete
     * @return true if deletion successful, false otherwise
     */
    public boolean deleteOrder(int orderId) {
        System.out.println("DEBUG - Starting deleteOrder for orderId: " + orderId);
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            System.out.println("DEBUG - Connection established, autocommit set to false");

            // Xóa order_items trước để tránh lỗi khóa ngoại
            int itemsDeleted = 0;
            try ( PreparedStatement psItems = conn.prepareStatement("DELETE FROM order_items WHERE order_id = ?")) {
                psItems.setInt(1, orderId);
                itemsDeleted = psItems.executeUpdate();
                System.out.println("DEBUG - Deleted " + itemsDeleted + " order items");
            }

            // Xóa order_vouchers nếu có
            try ( PreparedStatement psVouchers = conn.prepareStatement("DELETE FROM order_vouchers WHERE order_id = ?")) {
                psVouchers.setInt(1, orderId);
                int vouchersDeleted = psVouchers.executeUpdate();
                System.out.println("DEBUG - Deleted " + vouchersDeleted + " order vouchers");
            } catch (Exception e) {
                // Bỏ qua nếu không có bảng order_vouchers
                System.out.println("DEBUG - No order_vouchers table or no records to delete: " + e.getMessage());
            }

            // Xóa order
            try ( PreparedStatement psOrder = conn.prepareStatement("DELETE FROM orders WHERE order_id = ?")) {
                psOrder.setInt(1, orderId);
                int orderDeleted = psOrder.executeUpdate();
                System.out.println("DEBUG - Order delete result: " + orderDeleted + " rows affected");

                // Commit nếu thành công
                conn.commit();
                System.out.println("DEBUG - Transaction committed successfully");
                return orderDeleted > 0;
            }
        } catch (Exception e) {
            System.out.println("ERROR in deleteOrder: " + e.getMessage());
            e.printStackTrace();

            // Rollback nếu có lỗi
            if (conn != null) {
                try {
                    conn.rollback();
                    System.out.println("DEBUG - Transaction rolled back due to error");
                } catch (Exception ex) {
                    System.out.println("ERROR in rollback: " + ex.getMessage());
                    ex.printStackTrace();
                }
            }
        } finally {
            // Đảm bảo connection được đóng và autoCommit được reset
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                    System.out.println("DEBUG - Connection closed");
                } catch (Exception e) {
                    System.out.println("ERROR closing connection: " + e.getMessage());
                    e.printStackTrace();
                }
            }
        }
        return false;
    }

    /**
     * Get an order by ID with all details
     *
     * @param orderId Order ID to retrieve
     * @return Order object or null if not found
     */
    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, o.customer_name, o.customer_phone_number, o.referral_code FROM orders o "
                + "WHERE o.order_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(orderId);

                    // Set basic order information
                    try {
                        if (rs.getTimestamp("order_date") != null) {
                            order.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
                        }
                        order.setTotalAmount(new BigDecimal(rs.getDouble("total_amount")));
                        order.setShippingAddress(rs.getString("shipping_address"));
                        order.setStatus(rs.getString("status"));
                        order.setCustomerName(rs.getString("customer_name"));
                        order.setCustomerPhoneNumber(rs.getString("customer_phone_number"));
                        order.setReferralCode(rs.getString("referral_code"));
                    } catch (Exception e) {
                        // Skip if column doesn't exist
                    }

                    // Get order items
                    order.setOrderItems(getOrderItems(orderId));

                    return order;
                }
            }
        } catch (Exception e) {
            System.out.println("ERROR in getOrderById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get order items for a specific order
     *
     * @param orderId Order ID
     * @return List of order items
     */
    private List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();

        String sql = "SELECT oi.order_item_id, oi.product_id, oi.quantity, oi.unit_price, "
                + "p.name AS product_name "
                + "FROM order_items oi "
                + "LEFT JOIN products p ON oi.product_id = p.product_id "
                + "WHERE oi.order_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setOrderItemId(rs.getInt("order_item_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));

                    // Set unitPrice using BigDecimal from database
                    BigDecimal unitPrice = rs.getBigDecimal("unit_price");
                    item.setUnitPrice(unitPrice);

                    // The price will be updated automatically by the setter
                    item.setProductName(rs.getString("product_name"));

                    items.add(item);
                }
            }
        } catch (Exception e) {
            System.out.println("ERROR in getOrderItems: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }

    /**
     * Update an order with optional item quantity update
     *
     * @param orderId Order ID to update
     * @param status New order status
     * @param shippingAddress New shipping address
     * @param customerName New customer name
     * @param customerPhoneNumber New customer phone number
     * @param referralCode New referral code
     * @param orderItemId Optional order item ID to update (can be null if not
     * updating items)
     * @param quantity Optional new quantity for the item (ignored if
     * orderItemId is null)
     * @return true if the update was successful, false otherwise
     */
    public boolean updateOrder(int orderId, String status, String shippingAddress, String customerName,
            String customerPhoneNumber, String referralCode, Integer orderItemId, Integer quantity) {
        System.out.println("DEBUG - Updating order ID: " + orderId
                + (orderItemId != null && orderItemId > 0 ? " with item ID: " + orderItemId : " without item changes"));

        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            // Update order base information
            String sql = "UPDATE orders SET status = ?, shipping_address = ?, customer_name = ?, customer_phone_number = ?, referral_code = ? WHERE order_id = ?";

            try ( PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, status);
                ps.setString(2, shippingAddress);
                ps.setString(3, customerName);
                ps.setString(4, customerPhoneNumber);
                ps.setString(5, referralCode);
                ps.setInt(6, orderId);

                int rowsUpdated = ps.executeUpdate();
                System.out.println("DEBUG - Order base info update result: " + rowsUpdated + " rows affected");

                // Update item quantity if specified
                if (orderItemId != null && orderItemId > 0 && quantity != null && quantity > 0) {
                    String itemSql = "UPDATE order_items SET quantity = ? WHERE order_item_id = ? AND order_id = ?";

                    try ( PreparedStatement itemPs = conn.prepareStatement(itemSql)) {
                        itemPs.setInt(1, quantity);
                        itemPs.setInt(2, orderItemId);
                        itemPs.setInt(3, orderId);

                        int itemsUpdated = itemPs.executeUpdate();
                        System.out.println("DEBUG - Item quantity update result: " + itemsUpdated + " rows affected");

                        // If item updated successfully, update order total amount
                        if (itemsUpdated > 0) {
                            // Calculate new total
                            String totalSql = "UPDATE orders SET total_amount = "
                                    + "(SELECT SUM(quantity * unit_price) FROM order_items WHERE order_id = ?) "
                                    + "WHERE order_id = ?";

                            try ( PreparedStatement totalPs = conn.prepareStatement(totalSql)) {
                                totalPs.setInt(1, orderId);
                                totalPs.setInt(2, orderId);

                                int totalUpdated = totalPs.executeUpdate();
                                System.out.println("DEBUG - Total amount update result: " + totalUpdated + " rows affected");
                            }
                        }
                    }
                }

                // Commit the transaction
                conn.commit();
                System.out.println("DEBUG - Transaction committed successfully");
                return true;
            }
        } catch (Exception e) {
            System.out.println("ERROR in updateOrder: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                    System.out.println("DEBUG - Transaction rolled back due to error");
                } catch (Exception ex) {
                    System.out.println("ERROR during rollback: " + ex.getMessage());
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                    System.out.println("DEBUG - Connection closed");
                } catch (Exception e) {
                    System.out.println("ERROR closing connection: " + e.getMessage());
                    e.printStackTrace();
                }
            }
        }
        return false;
    }

    /**
     * Comprehensive search method for orders that allows filtering by multiple
     * criteria.
     *
     * @param searchTerm Text to search in product name, customer name, or phone
     * (null for no text search)
     * @param status Filter by order status (null for all statuses)
     * @param fromDate Filter by order date from (null for no date filter)
     * @param toDate Filter by order date to (null for no date filter)
     * @return List of orders matching the filter criteria
     */
    public List<Order> searchOrders(String searchTerm, String status, String fromDate, String toDate) {
        System.out.println("DEBUG - searchOrders called with searchTerm='" + searchTerm
                + "', status='" + status + "', fromDate='" + fromDate + "', toDate='" + toDate + "'");

        List<Order> orders = new ArrayList<>();
        Map<Integer, Order> orderMap = new LinkedHashMap<>();

        // Build SQL query
        StringBuilder sql = new StringBuilder(
                "SELECT "
                + "o.order_id, "
                + "o.referral_code, "
                + "p.name, "
                + "oi.order_item_id, "
                + "oi.product_id, "
                + "oi.quantity, "
                + "oi.unit_price, "
                + "o.total_amount, "
                + "o.status, "
                + "o.shipping_address, "
                + "o.customer_name, "
                + "o.customer_phone_number, "
                + "o.order_date "
                + "FROM "
                + "orders o "
                + "LEFT JOIN "
                + "order_items oi ON o.order_id = oi.order_id "
                + "LEFT JOIN "
                + "products p ON oi.product_id = p.product_id "
                + "WHERE 1=1 ");

        List<Object> parameters = new ArrayList<>();

        // Add filter conditions
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append("AND (LOWER(p.name) LIKE LOWER(?) OR "
                    + "LOWER(o.customer_name) LIKE LOWER(?) OR "
                    + "o.customer_phone_number LIKE ? OR "
                    + "CAST(o.order_id AS VARCHAR) LIKE ?) ");
            String searchParam = "%" + searchTerm.trim() + "%";
            parameters.add(searchParam);
            parameters.add(searchParam);
            parameters.add(searchParam);
            parameters.add(searchParam);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND o.status = ? ");
            parameters.add(status);
        }

        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append("AND o.order_date >= ? ");
            parameters.add(fromDate + " 00:00:00");
        }

        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append("AND o.order_date <= ? ");
            parameters.add(toDate + " 23:59:59");
        }

        // Add sorting
        sql.append("ORDER BY o.order_date DESC");

        String sqlQuery = sql.toString();
        System.out.println("DEBUG - Search SQL: " + sqlQuery);

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sqlQuery)) {

            // Set prepared statement parameters
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            try ( ResultSet rs = ps.executeQuery()) {
                int rowCount = 0;

                while (rs.next()) {
                    rowCount++;
                    int orderId = rs.getInt("order_id");

                    // Get or create order
                    Order order = orderMap.getOrDefault(orderId, new Order());

                    if (!orderMap.containsKey(orderId)) {
                        order.setOrderId(orderId);
                        order.setStatus(rs.getString("status"));
                        order.setShippingAddress(rs.getString("shipping_address"));
                        order.setCustomerName(rs.getString("customer_name"));
                        order.setCustomerPhoneNumber(rs.getString("customer_phone_number"));
                        order.setReferralCode(rs.getString("referral_code"));
                        order.setTotalAmount(rs.getBigDecimal("total_amount"));

                        if (rs.getTimestamp("order_date") != null) {
                            order.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
                        }
                    }

                    // Add order item if exists
                    int orderItemId = rs.getInt("order_item_id");
                    if (!rs.wasNull()) {
                        String productName = rs.getString("name");
                        int productId = rs.getInt("product_id");
                        int quantity = rs.getInt("quantity");
                        BigDecimal unitPrice = rs.getBigDecimal("unit_price");

                        OrderItem item = new OrderItem();
                        item.setOrderItemId(orderItemId);
                        item.setProductId(productId);
                        item.setProductName(productName);
                        item.setQuantity(quantity);
                        item.setUnitPrice(unitPrice);
                        item.setOrder(order); // Set bidirectional relationship

                        order.getOrderItems().add(item);
                    }

                    orderMap.put(orderId, order);
                }

                System.out.println("DEBUG - Search found " + rowCount + " rows, " + orderMap.size() + " orders");
            }

            // Add all orders to result list
            orders.addAll(orderMap.values());

            // Ensure all orders have non-null orderItems
            for (Order order : orders) {
                if (order.getOrderItems() == null) {
                    order.setOrderItems(new ArrayList<OrderItem>());
                }
            }

        } catch (Exception e) {
            System.out.println("ERROR in searchOrders: " + e.getMessage());
            e.printStackTrace();
        }

        return orders;
    }

    public boolean hasUserPurchasedProduct(Integer accountId, Integer productId) {
        boolean hasPurchased = false;

        // Cập nhật câu lệnh SQL để truy vấn vào bảng order_items
        String sql = "SELECT COUNT(*) "
                + "FROM order_items oi "
                + "JOIN orders o ON oi.order_id = o.order_id "
                + "WHERE o.account_id = ? "
                + "AND oi.product_id = ? "
                + "AND o.status = 'shipped'"; // Kiểm tra đơn hàng đã hoàn tất (shipped)

        try ( Connection con = getConnection();  PreparedStatement pst = con.prepareStatement(sql)) {

            // Thiết lập các tham số vào câu truy vấn
            pst.setInt(1, accountId);  // Lấy accountId
            pst.setInt(2, productId);   // Lấy productId

            // Thực hiện câu truy vấn và lấy kết quả
            ResultSet rs = pst.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                hasPurchased = true;  // Nếu có kết quả, nghĩa là người dùng đã mua sản phẩm
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return hasPurchased;
    }

}
