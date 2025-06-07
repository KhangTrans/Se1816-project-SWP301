package DAO;

import Model.Account;
import db.DBcontext;
import java.io.InputStream;
import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;

public class UserDao extends DBcontext {

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

    public boolean isUsernameExists(String username) throws SQLException {
        String sql = "SELECT 1 FROM accounts WHERE username = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try ( ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean isEmailExists(String email) throws SQLException {
        String sql = "SELECT 1 FROM customers WHERE email = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try ( ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean isPhoneExists(String phone) throws SQLException {
        String sql = "SELECT 1 FROM customers WHERE phone = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, phone);
            try ( ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean login(String username, String password) throws SQLException {
        String sql = "SELECT * FROM accounts WHERE username = ? AND password = ? AND role = 'customer'";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, hashMD5(password));
            try ( ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean quickRegisterIfNotExistsG(String username, String fullName, String email) throws SQLException {
        if (isUsernameExists(username) || isEmailExists(email)) {
            return false;
        }
        String defaultPassword = "googleuser";
        InputStream avatarStream = null;
        String phone = "";
        return registerCustomerBinary(username, defaultPassword, avatarStream, fullName, email, phone);
    }

    public boolean quickRegisterIfNotExistsF(String username, String fullName, String email) throws SQLException {
        if (isUsernameExists(username) || isEmailExists(email)) {
            return false;
        }
        String defaultPassword = "fbuser";
        InputStream avatarStream = null;
        String phone = "";
        return registerCustomerBinary(username, defaultPassword, avatarStream, fullName, email, phone);
    }

    public boolean updatePasswordByEmail(String email, String newPassword) throws SQLException {
        String sql = "UPDATE accounts SET password = ? WHERE account_id = (SELECT account_id FROM customers WHERE email = ?)";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, hashMD5(newPassword));
            stmt.setString(2, email);
            return stmt.executeUpdate() > 0;
        }
    }

    public String getAvatarByUsername(String username) throws SQLException {
        String sql = "SELECT avatar FROM accounts WHERE username = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("avatar");
            }
        }
        return "img/default-avatar.png";
    }

    public Account loginAdminStaff(String username, String password) throws SQLException {
        String sql = "SELECT * FROM accounts WHERE username = ? AND password = ? AND role IN ('admin', 'staff')";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, hashMD5(password));
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Account account = new Account();
                account.setAccountId(rs.getInt("account_id"));
                account.setUsername(rs.getString("username"));
                account.setPassword(rs.getString("password"));
                account.setAvatar(rs.getBytes("avatar"));
                account.setRole(rs.getString("role"));
                account.setCreatedAt(rs.getTimestamp("created_at"));
                return account;
            }
        }
        return null;
    }

    public boolean registerCustomer(String username, String password, InputStream avatarStream,
            String fullName, String email, String phone) throws SQLException {

        String insertAccount = "INSERT INTO accounts (username, password, avatar, role, auth_provider, created_at) "
                + "VALUES (?, ?, ?, 'customer', 'internal', GETDATE())";

        String insertCustomer = "INSERT INTO customers (account_id, full_name, email, phone, customer_code, address) "
                + "VALUES (?, ?, ?, ?, ?, '')";

        try ( Connection conn = getConnection()) {
            conn.setAutoCommit(false);

            try ( PreparedStatement stmtAcc = conn.prepareStatement(insertAccount, Statement.RETURN_GENERATED_KEYS)) {
                stmtAcc.setString(1, username);
                stmtAcc.setString(2, hashMD5(password));

                if (avatarStream != null) {
                    stmtAcc.setBlob(3, avatarStream);
                } else {
                    stmtAcc.setNull(3, Types.BLOB);
                }

                stmtAcc.executeUpdate();

                try ( ResultSet rs = stmtAcc.getGeneratedKeys()) {
                    if (rs.next()) {
                        int accountId = rs.getInt(1);

                        try ( PreparedStatement stmtCus = conn.prepareStatement(insertCustomer)) {
                            stmtCus.setInt(1, accountId);
                            stmtCus.setString(2, fullName);
                            stmtCus.setString(3, email);
                            stmtCus.setString(4, phone);
                            stmtCus.setString(5, "CH" + accountId);
                            stmtCus.executeUpdate();
                        }

                        conn.commit();
                        return true;
                    }
                }

                conn.rollback();
                return false;

            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    public boolean registerCustomerBinary(String username, String password, InputStream avatarStream,
            String fullName, String email, String phone) throws SQLException {

        String insertAccount = "INSERT INTO accounts (username, password, avatar, role, auth_provider, created_at) "
                + "VALUES (?, ?, ?, 'customer', 'internal', GETDATE())";

        String insertCustomer = "INSERT INTO customers (account_id, full_name, email, phone, customer_code, address) "
                + "VALUES (?, ?, ?, ?, ?, '')";

        try ( Connection conn = getConnection()) {
            conn.setAutoCommit(false);

            try ( PreparedStatement stmtAcc = conn.prepareStatement(insertAccount, Statement.RETURN_GENERATED_KEYS)) {
                stmtAcc.setString(1, username);
                stmtAcc.setString(2, hashMD5(password));

                if (avatarStream != null) {
                    stmtAcc.setBlob(3, avatarStream);
                } else {
                    stmtAcc.setNull(3, Types.BLOB);
                }

                stmtAcc.executeUpdate();

                try ( ResultSet rs = stmtAcc.getGeneratedKeys()) {
                    if (rs.next()) {
                        int accountId = rs.getInt(1);

                        try ( PreparedStatement stmtCus = conn.prepareStatement(insertCustomer)) {
                            stmtCus.setInt(1, accountId);
                            stmtCus.setString(2, fullName);
                            stmtCus.setString(3, email);
                            stmtCus.setString(4, phone);
                            stmtCus.setString(5, "CH" + accountId);
                            stmtCus.executeUpdate();
                        }

                        conn.commit();
                        return true;
                    }
                }

                conn.rollback();
                return false;

            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    public List<Account> getAllAccounts() throws SQLException {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT account_id, username, password, avatar, role, created_at FROM accounts";

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql);  ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Account acc = new Account();
                acc.setAccountId(rs.getInt("account_id"));
                acc.setUsername(rs.getString("username"));
                acc.setPassword(rs.getString("password"));
                acc.setAvatar(rs.getBytes("avatar"));  // Có thể bỏ nếu không dùng
                acc.setRole(rs.getString("role"));
                acc.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(acc);
            }
        }

        return list;
    }
    

}
