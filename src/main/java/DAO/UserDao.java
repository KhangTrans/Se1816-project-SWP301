package DAO;

import Model.Account;
import Model.Staff;
import db.DBcontext;
import java.io.InputStream;
import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

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
        String sql = "SELECT * FROM accounts WHERE username = ? AND password = ? AND role IN ('customer','trainer')";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, hashMD5(password));
            try ( ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public String getUserRole(String username) throws SQLException {
        String sql = "SELECT role FROM accounts WHERE username = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("role");
            }
        }
        return null;
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

    /////////////////////////////////////////
    public Account getAccountById(int id) throws SQLException {
        String sql = "SELECT account_id, username, password, avatar, role, created_at FROM accounts WHERE account_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Account acc = new Account();
                acc.setAccountId(rs.getInt("account_id"));
                acc.setUsername(rs.getString("username"));
                acc.setPassword(rs.getString("password"));
                acc.setAvatar(rs.getBytes("avatar"));
                acc.setRole(rs.getString("role"));
                acc.setCreatedAt(rs.getTimestamp("created_at"));
                return acc;
            }
        }

        return null; // Không tìm thấy account
    }

    public void createAccount(String username, String password, String role, InputStream avatarStream, String authProvider) throws SQLException {
        String sql = "INSERT INTO accounts (username, password, role, created_at, avatar, auth_provider) VALUES (?, ?, ?, GETDATE(), ?, ?)";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, hashMD5(password));
            ps.setString(3, role);

            if (avatarStream != null) {
                ps.setBlob(4, avatarStream); // hoặc ps.setBlob(5, avatarStream);
            } else {
                ps.setNull(4, java.sql.Types.BLOB);
            }
            ps.setString(5, authProvider);
            System.out.println("Creating account with username = " + username);
            System.out.println("Password = " + password);
            System.out.println("Role = " + role);
            System.out.println("AvatarStream = " + (avatarStream != null));

            ps.executeUpdate();
        }
    }

    public Account getAccountByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM accounts WHERE username = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Account acc = new Account();
                    acc.setAccountId(rs.getInt("account_id"));
                    acc.setUsername(rs.getString("username"));
                    acc.setPassword(rs.getString("password"));
                    acc.setRole(rs.getString("role"));
                    acc.setCreatedAt(rs.getTimestamp("created_at"));

                    Blob avatarBlob = rs.getBlob("avatar");
                    if (avatarBlob != null) {
                        acc.setAvatar(avatarBlob.getBytes(1, (int) avatarBlob.length()));
                    }

                    return acc;
                }
            }
        }
        return null;
    }

    public void updateAccount(int accountId, String username, String password, String role, InputStream avatarStream) throws SQLException {
        String sql;
        boolean hasNewAvatar = (avatarStream != null);

        if (hasNewAvatar) {
            sql = "UPDATE accounts SET username = ?, password = ?, role = ?, avatar = ? WHERE account_id = ?";
        } else {
            sql = "UPDATE accounts SET username = ?, password = ?, role = ? WHERE account_id = ?";
        }

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, hashMD5(password)); // Nếu onee-chan dùng hashMD5
            ps.setString(3, role);

            if (hasNewAvatar) {
                ps.setBlob(4, avatarStream);
                ps.setInt(5, accountId);
            } else {
                ps.setInt(4, accountId);
            }

            ps.executeUpdate();
        }
    }

    public void deleteAccount(int accountId) throws SQLException {
        String sql = "DELETE FROM accounts WHERE account_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ps.executeUpdate();
        }
    }

//////////////////////////////////////////////////////
///        HOANG KHANG
/////////////////////////////////////////////////////
    public List<Staff> getAllStaffs() throws SQLException {
        List<Staff> list = new ArrayList<>();
        String sql = "SELECT s.staff_id, s.status, s.full_name, s.email, s.staff_code, s.phone, s.position, a.account_id, a.username, a.role, a.created_at, a.avatar FROM staff s JOIN accounts a ON s.account_id = a.account_id WHERE a.role = 'staff'";

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql);  ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Staff staff = new Staff();
                Account acc = new Account();
                staff.setStaffId(rs.getInt("staff_id"));
                staff.setStatus(rs.getString("status"));
                staff.setFullName(rs.getString("full_name"));
                staff.setEmail(rs.getString("email"));
                staff.setStaffCode(rs.getString("staff_code"));
                staff.setPhone(rs.getString("phone"));
                staff.setPosition(rs.getString("position"));

                acc.setAccountId(rs.getInt("account_id"));
                acc.setUsername(rs.getString("username"));
                acc.setRole(rs.getString("role"));
                acc.setCreatedAt(rs.getTimestamp("created_at"));
                acc.setAvatar(rs.getBytes("avatar"));

                staff.setAccount(acc);
                list.add(staff);
                // In ra hết thông tin sau khi set xong
//                System.out.println("Loaded Staff:");
                System.out.println("  staff_id: " + staff.getStaffId());
//                System.out.println("  status: " + staff.getStatus());
//                System.out.println("  full_name: " + staff.getFullName());
//                System.out.println("  email: " + staff.getEmail());
//                System.out.println("  staff_code: " + staff.getStaffCode());
//                System.out.println("  phone: " + staff.getPhone());
//                System.out.println("  position: " + staff.getPosition());
//
//                System.out.println("  account_id: " + acc.getAccountId());
//                System.out.println("  username: " + acc.getUsername());
//                System.out.println("  role: " + acc.getRole());
//                System.out.println("  created_at: " + acc.getCreatedAt());

            }

        }

        return list;
    }

    public List<Account> getStaffsThatNotStaffYet() {
        List<Account> staffList = new ArrayList<>();
        String sql = "SELECT * FROM accounts "
                + "WHERE role = 'staff' AND account_id NOT IN (SELECT account_id FROM staff)";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Account acc = new Account();
                acc.setAccountId(rs.getInt("account_id"));
                acc.setUsername(rs.getString("username"));
                acc.setRole(rs.getString("role"));
                acc.setCreatedAt(rs.getTimestamp("created_at"));

                staffList.add(acc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffList;
    }

    public void insertStaff(Staff staff) {
        String sql = "INSERT INTO Staff (staff_id, staff_code, full_name, email, phone, position, status, account_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, staff.getStaffId());
            ps.setString(2, staff.getStaffCode());
            ps.setString(3, staff.getFullName());
            ps.setString(4, staff.getEmail());
            ps.setString(5, staff.getPhone());
            ps.setString(6, staff.getPosition());
            ps.setString(7, staff.getStatus());
            ps.setInt(8, staff.getAccount().getAccountId());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Account> getAvailableStaffAccounts() throws SQLException {
        List<Account> accounts = new ArrayList<>();
        String sql
                = "SELECT * FROM accounts "
                + "WHERE role = 'staff' "
                + "AND account_id NOT IN (SELECT account_id FROM staff)";

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql);  ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Account acc = new Account();
                acc.setAccountId(rs.getInt("account_id"));
                acc.setUsername(rs.getString("username"));
                accounts.add(acc);
            }
        }
        return accounts;
    }

    public Account getStaffAccountById(int id) throws SQLException {
        String sql = "SELECT * FROM accounts WHERE account_id = ? AND role = 'staff'";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Account acc = new Account();
                acc.setAccountId(rs.getInt("account_id"));
                acc.setUsername(rs.getString("username"));
                acc.setPassword(rs.getString("password"));
                acc.setAvatar(rs.getBytes("avatar"));
                acc.setRole(rs.getString("role"));
                return acc;
            }
        }
        return null;
    }

    public int getAccountIdByStaffId(int staffId) throws SQLException {
        String sql = "SELECT account_id FROM staff WHERE staff_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, staffId);
            try ( ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("account_id");
                }
            }
        }
        return -1;
    }

    public void addStaff(Staff staff) throws SQLException {
        String sql = "INSERT INTO staff (account_id, staff_code, full_name, email, phone, position, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            String staffCode = "STF" + String.format("%04d", new Random().nextInt(10000));

            stmt.setInt(1, staff.getAccount().getAccountId());
            stmt.setString(2, staffCode); // staff_code
            stmt.setString(3, staff.getFullName());
            stmt.setString(4, staff.getEmail());
            stmt.setString(5, staff.getPhone());
            stmt.setString(6, staff.getPosition());
            stmt.setString(7, staff.getStatus());
            stmt.executeUpdate();
        }
    }

    public void updateStaff(int accountId, String fullName, String phone, String position, String status, InputStream avatarStream) throws SQLException {
        String updateStaffSql = "UPDATE staff SET full_name = ?, phone = ?, position = ?, status = ? WHERE account_id = ?";
        String updateAvatarSql = "UPDATE accounts SET avatar = ? WHERE account_id = ?";

        try ( Connection conn = getConnection()) {
            conn.setAutoCommit(false);

            try (
                     PreparedStatement stmt1 = conn.prepareStatement(updateStaffSql);  PreparedStatement stmt2 = (avatarStream != null) ? conn.prepareStatement(updateAvatarSql) : null) {
                // Cập nhật bảng staff
                stmt1.setString(1, fullName);
                stmt1.setString(2, phone);
                stmt1.setString(3, position);
                stmt1.setString(4, status);
                stmt1.setInt(5, accountId);
                int updatedStaff = stmt1.executeUpdate();
                System.out.println("✅ Rows updated in staff = " + updatedStaff);

                if (avatarStream != null) {
                    stmt2.setBlob(1, avatarStream);
                    stmt2.setInt(2, accountId);
                    int updatedAvatar = stmt2.executeUpdate();
                    System.out.println("✅ Rows updated in account avatar = " + updatedAvatar);
                }

                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                System.err.println("❌ Error during updating staff or avatar: " + e.getMessage());
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public void demoteStaff(int staffId) {
        String deleteStaffSql = "DELETE FROM staff WHERE staff_id = ?";
        String updateRoleSql = "UPDATE accounts SET role = 'customer' WHERE account_id = ?";

        try ( Connection conn = getConnection()) {
            conn.setAutoCommit(false);

            int accountId = getAccountIdByStaffId(staffId);
            if (accountId == -1) {
                System.out.println("❌ Couldn't find account_id for this staff_id = " + staffId);
                return;
            }

            try (
                     PreparedStatement psDeleteStaff = conn.prepareStatement(deleteStaffSql);  PreparedStatement psUpdateRole = conn.prepareStatement(updateRoleSql)) {
                psDeleteStaff.setInt(1, staffId);
                psDeleteStaff.executeUpdate();

                psUpdateRole.setInt(1, accountId);
                psUpdateRole.executeUpdate();
            }

            conn.commit();
            System.out.println("OK");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
