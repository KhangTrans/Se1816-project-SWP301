package DAO;

import Model.Voucher;
import db.DBcontext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;
import java.time.LocalDate;

public class VoucherDao extends DBcontext {

    public int countVouchers() {
        String sql = "SELECT COUNT(*) FROM vouchers";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Retrieves all vouchers from the database.
     *
     * @return A list of all vouchers.
     * @throws SQLException If a database error occurs.
     */
    public List<Voucher> getAllVouchers() throws SQLException {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM vouchers";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Voucher v = new Voucher();
                v.setVoucherId(rs.getInt("voucher_id"));
                v.setCode(rs.getString("code"));
                v.setDescription(rs.getString("description"));
                v.setDiscountPercent(rs.getInt("discount_percent"));
                v.setMaxDiscount(rs.getBigDecimal("max_discount"));
                v.setUsageLimit(rs.getInt("usage_limit"));
                v.setUsedCount(rs.getInt("used_count"));
                v.setMinOrderAmount(rs.getBigDecimal("min_order_amount"));
                v.setStartDate(rs.getDate("start_date").toLocalDate());
                v.setEndDate(rs.getDate("end_date").toLocalDate());
                v.setActive(rs.getBoolean("is_active"));

                list.add(v);
            }
        }
        return list;
    }

    /**
     * Deletes a voucher by its ID.
     *
     * @param voucherId The ID of the voucher to delete.
     * @throws SQLException If a database error occurs.
     */
    public boolean deleteVoucher(int voucherId) throws SQLException {
        String sql = "DELETE FROM vouchers WHERE voucher_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Updates an existing voucher's information.
     *
     * @param v The Voucher object containing updated information.
     * @throws SQLException If a database error occurs.
     */
    public void updateVoucher(Voucher v) throws SQLException {
        String sql = "UPDATE vouchers SET code = ?, description = ?, discount_percent = ?, max_discount = ?, usage_limit = ?, used_count = ?, min_order_amount = ?, start_date = ?, end_date = ?, is_active = ? WHERE voucher_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getCode());
            ps.setString(2, v.getDescription());
            ps.setInt(3, v.getDiscountPercent());
            ps.setBigDecimal(4, v.getMaxDiscount());
            ps.setInt(5, v.getUsageLimit());
            ps.setInt(6, v.getUsedCount());
            ps.setBigDecimal(7, v.getMinOrderAmount());
            ps.setDate(8, java.sql.Date.valueOf(v.getStartDate()));
            ps.setDate(9, java.sql.Date.valueOf(v.getEndDate()));
            ps.setBoolean(10, v.isActive());
            ps.setInt(11, v.getVoucherId());

            ps.executeUpdate();
        }
    }

    /**
     * Creates a new voucher and returns its generated ID.
     *
     * @param v The Voucher object containing the new voucher's information.
     * @return The ID of the newly created voucher, or -1 if creation fails.
     * @throws SQLException If a database error occurs.
     */
    public int createVoucher(Voucher v) throws SQLException {
        System.out.println("Code: " + v.getCode()); // Log để kiểm tra giá trị
        String sql = "INSERT INTO vouchers (code, description, discount_percent, max_discount, usage_limit, used_count, min_order_amount, start_date, end_date, is_active) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, v.getCode());
            ps.setString(2, v.getDescription());
            ps.setInt(3, v.getDiscountPercent());
            ps.setBigDecimal(4, v.getMaxDiscount());
            ps.setInt(5, v.getUsageLimit());
            ps.setInt(6, v.getUsedCount());
            ps.setBigDecimal(7, v.getMinOrderAmount());
            ps.setDate(8, java.sql.Date.valueOf(v.getStartDate()));
            ps.setDate(9, java.sql.Date.valueOf(v.getEndDate()));
            ps.setInt(10, v.isActive() ? 1 : 0);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                try ( ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int newId = rs.getInt(1); // Lấy ID mới được tạo
                        System.out.println("Voucher mới đã được tạo với ID: " + newId); // Log ID mới
                        return newId;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tạo voucher: " + e.getMessage());
            throw e; // Rethrow exception để xử lý tại tầng trên
        }
        return -1; // Trả về -1 nếu không thể tạo voucher
    }

    /**
     * Retrieves a voucher by its ID.
     *
     * @param id The ID of the voucher to retrieve.
     * @return The Voucher object, or null if not found.
     * @throws SQLException If a database error occurs.
     */
    public Voucher getVoucherById(int id) throws SQLException {
        String sql = "SELECT * FROM vouchers WHERE voucher_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Voucher v = new Voucher();
                v.setVoucherId(rs.getInt("voucher_id"));
                v.setCode(rs.getString("code"));
                v.setDescription(rs.getString("description"));
                v.setDiscountPercent(rs.getInt("discount_percent"));
                v.setMaxDiscount(rs.getBigDecimal("max_discount"));
                v.setUsageLimit(rs.getInt("usage_limit"));
                v.setUsedCount(rs.getInt("used_count"));
                v.setMinOrderAmount(rs.getBigDecimal("min_order_amount"));
                v.setStartDate(rs.getDate("start_date").toLocalDate());
                v.setEndDate(rs.getDate("end_date").toLocalDate());
                v.setActive(rs.getBoolean("is_active"));

                return v;
            }
        }
        return null;
    }

    /**
     * Single comprehensive search method for vouchers that replaces all other
     * search methods. All parameters are optional - pass null for any parameter
     * you don't want to filter by.
     *
     * @param search Text to search in code or description (null for no text
     * search)
     * @param active Filter by active status (true=only active, false=only
     * inactive, null=all)
     * @param fromDate Filter by start date (null for no start date filter)
     * @param toDate Filter by end date (null for no end date filter)
     * @return List of vouchers matching the criteria
     * @throws SQLException If a database error occurs
     */
    public List<Voucher> searchVoucher(String search, Boolean active, LocalDate fromDate, LocalDate toDate) throws SQLException {
        List<Voucher> results = new ArrayList<>();

        // Build the SQL query with optional conditions
        StringBuilder sql = new StringBuilder("SELECT * FROM vouchers WHERE 1=1");

        List<Object> params = new ArrayList<>();

        // Add search condition if provided
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (code LIKE ? OR description LIKE ?)");
            params.add("%" + search.trim() + "%");
            params.add("%" + search.trim() + "%");
        }

        // Add active status condition if specified
        if (active != null) {
            sql.append(" AND is_active = ?");
            params.add(active ? 1 : 0);
        }

        // Add date range conditions if provided
        if (fromDate != null) {
            sql.append(" AND start_date >= ?");
            params.add(java.sql.Date.valueOf(fromDate));
        }

        if (toDate != null) {
            sql.append(" AND end_date <= ?");
            params.add(java.sql.Date.valueOf(toDate));
        }

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                } else if (param instanceof java.sql.Date) {
                    ps.setDate(i + 1, (java.sql.Date) param);
                }
            }

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Voucher voucher = new Voucher();
                    voucher.setVoucherId(rs.getInt("voucher_id"));
                    voucher.setCode(rs.getString("code"));
                    voucher.setDescription(rs.getString("description"));
                    voucher.setDiscountPercent(rs.getInt("discount_percent"));
                    voucher.setMaxDiscount(rs.getBigDecimal("max_discount"));
                    voucher.setUsageLimit(rs.getInt("usage_limit"));
                    voucher.setUsedCount(rs.getInt("used_count"));
                    voucher.setMinOrderAmount(rs.getBigDecimal("min_order_amount"));
                    voucher.setStartDate(rs.getDate("start_date").toLocalDate());
                    voucher.setEndDate(rs.getDate("end_date").toLocalDate());
                    voucher.setActive(rs.getBoolean("is_active"));
                    results.add(voucher);
                }
            }
        }

        return results;
    }

    //=============DUY KHANG==================================//
    public List<Voucher> getActiveVouchers() throws SQLException {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM vouchers WHERE is_active = 1 AND GETDATE() BETWEEN start_date AND end_date";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Voucher v = new Voucher();
                v.setVoucherId(rs.getInt("voucher_id"));
                v.setCode(rs.getString("code"));
                v.setDescription(rs.getString("description"));
                v.setDiscountPercent(rs.getInt("discount_percent"));
                v.setMaxDiscount(rs.getBigDecimal("max_discount"));
                v.setMinOrderAmount(rs.getBigDecimal("min_order_amount"));
                v.setUsageLimit(rs.getInt("usage_limit"));
                v.setUsedCount(rs.getInt("used_count"));
                v.setStartDate(rs.getDate("start_date").toLocalDate());
                v.setEndDate(rs.getDate("end_date").toLocalDate());
                v.setActive(rs.getBoolean("is_active"));
                list.add(v);
            }
        }

        return list;
    }

    public boolean hasUserClaimed(int voucherId, int customerId) throws SQLException {
        String sql = "SELECT 1 FROM voucher_usages WHERE voucher_id = ? AND account_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            ps.setInt(2, customerId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    public boolean claimVoucher(int voucherId, int customerId) throws SQLException {
        if (hasUserClaimed(voucherId, customerId)) {
            return false;
        }

        String sql = "INSERT INTO voucher_usages (voucher_id, account_id) VALUES (?, ?)";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            ps.setInt(2, customerId);
            return ps.executeUpdate() > 0;
        }
    }
}
