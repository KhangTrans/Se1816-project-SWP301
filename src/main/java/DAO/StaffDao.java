/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Account;
import Model.Staff;
import db.DBcontext;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 *
 * @author Admin
 */
public class StaffDao extends DBcontext {

    public int countStaff() {
        String sql = "SELECT COUNT(*) FROM staff";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

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

    public List<Staff> searchStaffs(String searchTerm, String phone, String status) throws SQLException {
        List<Staff> staffList = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT s.*, a.* FROM staff s JOIN accounts a ON s.account_id = a.account_id WHERE 1=1");

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (a.username LIKE ? OR s.full_name LIKE ?)");
        }
        if (phone != null && !phone.trim().isEmpty()) {
            sql.append(" AND s.phone LIKE ?");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND s.status = ?");
        }

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                String keyword = "%" + searchTerm + "%";
                ps.setString(paramIndex++, keyword);
                ps.setString(paramIndex++, keyword);
            }
            if (phone != null && !phone.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + phone + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(paramIndex++, status);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Staff staff = new Staff();
                staff.setStaffId(rs.getInt("staff_id"));
                staff.setStatus(rs.getString("status"));
                staff.setFullName(rs.getString("full_name"));
                staff.setEmail(rs.getString("email"));
                staff.setStaffCode(rs.getString("staff_code"));
                staff.setPhone(rs.getString("phone"));
                staff.setPosition(rs.getString("position"));

                Account acc = new Account();
                acc.setAccountId(rs.getInt("account_id"));
                acc.setUsername(rs.getString("username"));
                acc.setRole(rs.getString("role"));
                acc.setCreatedAt(rs.getTimestamp("created_at"));
                acc.setAvatar(rs.getBytes("avatar"));
                staff.setAccount(acc);

                staffList.add(staff);
            }
        }
        return staffList;
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

    public void updateStaff(int accountId, String fullName, String email, String phone, String position, String status, InputStream avatarStream) throws SQLException {
        String updateStaffSql = "UPDATE staff SET full_name = ?, email = ?, phone = ?, position = ?, status = ? WHERE account_id = ?";
        String updateAccountSql = "UPDATE accounts SET" + (avatarStream != null ? ", avatar = ?" : "") + " WHERE account_id = ?";

        try ( Connection conn = getConnection()) {
            conn.setAutoCommit(false);

            try (
                     PreparedStatement stmt1 = conn.prepareStatement(updateStaffSql);  PreparedStatement stmt2 = conn.prepareStatement(updateAccountSql)) {
                // Cập nhật bảng staff
                stmt1.setString(1, fullName);
                stmt1.setString(2, email);
                stmt1.setString(3, phone);
                stmt1.setString(4, position);
                stmt1.setString(5, status);
                stmt1.setInt(6, accountId);
                stmt1.executeUpdate();

                // Cập nhật avatar (nếu có) trong account
                if (avatarStream != null) {
                    stmt2.setBlob(1, avatarStream);
                    stmt2.setInt(2, accountId);
                    stmt2.executeUpdate();
                }
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
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
