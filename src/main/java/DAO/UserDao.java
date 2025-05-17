package DAO;

import db.DBcontext;
import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class UserDao extends DBcontext {

    // Mã hóa mật khẩu bằng MD5 (Chỉ dùng demo, khuyên dùng bcrypt trong thực tế)
    public static String hashMD5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(input.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : messageDigest) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }

    // Kiểm tra username đã tồn tại chưa
    public boolean isUsernameExists(String username) throws SQLException {
        String sql = "SELECT 1 FROM accounts WHERE username = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    // Kiểm tra email đã tồn tại chưa
    public boolean isEmailExists(String email) throws SQLException {
        String sql = "SELECT 1 FROM customers WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    // Kiểm tra số điện thoại đã tồn tại chưa
    public boolean isPhoneExists(String phone) throws SQLException {
        String sql = "SELECT 1 FROM customers WHERE phone = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, phone);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    // Đăng ký tài khoản khách hàng
    public boolean registerCustomer(String username, String password, String avatar, String fullName, String email, String phone) throws SQLException {
        String insertAccount = "INSERT INTO accounts (username, password, avatar, role, created_at) VALUES (?, ?, ?, 'customer', GETDATE())";
        String insertCustomer = "INSERT INTO customers (account_id, full_name, email, phone, customer_code, address) VALUES (?, ?, ?, ?, ?, '')";

        Connection conn = null;
        PreparedStatement stmtAcc = null, stmtCus = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            stmtAcc = conn.prepareStatement(insertAccount, Statement.RETURN_GENERATED_KEYS);
            stmtAcc.setString(1, username);
            stmtAcc.setString(2, hashMD5(password));
            stmtAcc.setString(3, avatar);
            stmtAcc.executeUpdate();

            rs = stmtAcc.getGeneratedKeys();
            if (rs.next()) {
                int accountId = rs.getInt(1);
                stmtCus = conn.prepareStatement(insertCustomer);
                stmtCus.setInt(1, accountId);
                stmtCus.setString(2, fullName);
                stmtCus.setString(3, email);
                stmtCus.setString(4, phone);
                stmtCus.setString(5, "C" + accountId); // Tạo customer_code: VD C101
                stmtCus.executeUpdate();

                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (stmtAcc != null) stmtAcc.close();
            if (stmtCus != null) stmtCus.close();
            if (conn != null) conn.close();
        }
    }

    // Đăng nhập tài khoản khách hàng
    public boolean login(String username, String password) throws SQLException {
        String sql = "SELECT * FROM accounts WHERE username = ? AND password = ? AND role = 'customer'";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, hashMD5(password));
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next(); // Đúng user + pass + role thì đăng nhập thành công
            }
        }
    }
}
