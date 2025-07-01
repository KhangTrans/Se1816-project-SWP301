/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import db.DBcontext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 *
 * @author Admin
 */
public class OrderDao extends DBcontext {

    public String generateOrderCode() {
        String code;
        do {
            int random = (int) (Math.random() * 1_000_000);
            code = "ORD" + String.format("%06d", random);
        } while (isOrderCodeExists(code)); // Kiểm tra trùng trong DB
        return code;
    }

    public boolean isOrderCodeExists(String code) {
        String sql = "SELECT 1 FROM orders WHERE order_code = ?";
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

}
