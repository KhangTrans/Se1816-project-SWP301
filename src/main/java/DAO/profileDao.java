package DAO;

import Model.Account;
import Model.Customer;
import db.DBcontext;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class profileDao {

    public Customer getCustomerById(int account_id) throws SQLException {
        String sql = "select c.customer_id, c.account_id, c.full_name, c.email, c.phone, c.customer_code, c.address, "
                   + "a.username, a.password, a.role, a.avatar "
                   + "from [dbo].[customers] as c "
                   + "join accounts as a on a.account_id = c.account_id "
                   + "WHERE c.account_id = ?";
        try (Connection conn = new DBcontext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, account_id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Create an Account object first
                Account account = new Account();
                account.setAccountId(rs.getInt("account_id"));
                account.setUsername(rs.getString("username"));
                account.setPassword(rs.getString("password"));
                account.setRole(rs.getString("role"));
                account.setAvatar(rs.getBytes("avatar"));

                // Create a Customer object and set the account
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setAccount(account); // Link the account to the customer
                customer.setFullName(rs.getString("full_name"));
                customer.setEmail(rs.getString("email"));
                customer.setPhone(rs.getString("phone"));
                customer.setCustomerCode(rs.getString("customer_code"));
                customer.setAddress(rs.getString("address"));

                return customer;
            }
        }
        return null; // Return null if no customer found
    }

    public Account getAccountById(int id) throws SQLException {
        String sql = "SELECT account_id, username, password, avatar, role, created_at FROM accounts WHERE account_id = ?";

        try (Connection conn = new DBcontext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
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

        return null; // No account found
    }
    
    public boolean updateCustomer(Customer customer) {
        String query = "UPDATE customers SET full_name = ?, email = ?, phone = ?,address = ? WHERE customer_id = ?";
        try ( Connection conn = new  DBcontext().getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getEmail());
            ps.setString(3, customer.getPhone());
            ps.setString(4, customer.getAddress());
            ps.setInt(5, customer.getCustomerId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public void updateAvatar(int accountId, InputStream avatarStream) throws SQLException{
        String sql = "UPDATE accounts SET avatar = ? WHERE account_id = ?";

        try ( Connection conn = new  DBcontext().getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setBlob(1, avatarStream);
                ps.setInt(2, accountId);
            ps.executeUpdate();
        }
    }
    
    public boolean changePassword(int accountId, String oldPassword, String newPassword) throws SQLException {
//    UserDao udao = new UserDao();
    String sql = "SELECT password FROM accounts WHERE account_id = ?";
    try (Connection conn = new  DBcontext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, accountId);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                String password = rs.getString("password");

                // Kiểm tra mật khẩu cũ có đúng không
                if (password.equals(UserDao.hashMD5(oldPassword))) {
                    // Mật khẩu cũ đúng, tiến hành cập nhật mật khẩu mới
                    String updatePasswordSQL = "UPDATE accounts SET password = ? WHERE account_id = ?";
                    try (PreparedStatement updateStmt = conn.prepareStatement(updatePasswordSQL)) {
                        updateStmt.setString(1, UserDao.hashMD5(newPassword)); // Cập nhật mật khẩu mới
                        updateStmt.setInt(2, accountId);
                        int row = updateStmt.executeUpdate();
                        return row > 0;  // Trả về true nếu cập nhật thành công
                    }
                }
            }
        }
    }
    return false;  // Trả về false nếu mật khẩu cũ sai hoặc có lỗi
}

}
