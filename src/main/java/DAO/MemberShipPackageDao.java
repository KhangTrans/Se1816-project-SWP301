/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Account;
import Model.Customer;
import Model.CustomerMembership;
import Model.MembershipPackage;
import Model.Package;
import db.DBcontext;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ADMIN
 */
public class MemberShipPackageDao extends DBcontext {

    public List<CustomerMembership> getAllCustomerMemberships() {
        List<CustomerMembership> customerMembershipList = new ArrayList<>();
        String sql = "SELECT cm.membership_id, cm.account_id, cm.package_id, cm.start_date, cm.end_date, cm.payment_status, "
                + "a.username, m.name AS package_name "
                + "FROM customer_memberships cm "
                + "JOIN accounts a ON cm.account_id = a.account_id "
                + "JOIN membership_packages m ON cm.package_id = m.package_id";

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql);  ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                CustomerMembership customerMembership = new CustomerMembership();

                // Gán giá trị vào đối tượng CustomerMembership
                customerMembership.setMembershipId(rs.getInt("membership_id"));
                customerMembership.setPaymentStatus(rs.getString("payment_status"));

                // Gán giá trị tài khoản
                Account account = new Account();
                account.setAccountId(rs.getInt("account_id"));
                account.setUsername(rs.getString("username"));
                customerMembership.setAccountId(account);  // Thay vì Customer, bạn có thể gán trực tiếp Account vào

                // Gán gói thành viên
                MembershipPackage membershipPackage = new MembershipPackage();
                membershipPackage.setPackageId(rs.getInt("package_id"));
                membershipPackage.setName(rs.getString("package_name"));
                customerMembership.setMembershipPackage(membershipPackage);

                // Gán ngày bắt đầu và kết thúc
                customerMembership.setStartDate(rs.getDate("start_date").toLocalDate());
                customerMembership.setEndDate(rs.getDate("end_date").toLocalDate());

                // Thêm vào danh sách
                customerMembershipList.add(customerMembership);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customerMembershipList;
    }

    // DAO/MemberShipPackageDao.java
    public boolean editCustomerMembership(int membershipId, String paymentStatus) {
        String sql = "UPDATE customer_memberships SET payment_status = ? WHERE membership_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, paymentStatus);
            stmt.setInt(2, membershipId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    public List<CustomerMembership> searchCustomerMemberships(String username, String packageName, String paymentStatus) {
        List<CustomerMembership> customerMembershipList = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT cm.membership_id, cm.account_id, cm.package_id, cm.start_date, cm.end_date, cm.payment_status, "
                + "a.username, m.name AS package_name "
                + "FROM customer_memberships cm "
                + "JOIN accounts a ON cm.account_id = a.account_id "
                + "JOIN membership_packages m ON cm.package_id = m.package_id "
                + "WHERE 1 = 1");

        if (username != null && !username.isEmpty()) {
            sql.append(" AND a.username LIKE ?");
        }
        if (packageName != null && !packageName.isEmpty()) {
            sql.append(" AND m.name LIKE ?");
        }

        if (paymentStatus != null && !paymentStatus.isEmpty()) {
            sql.append(" AND cm.payment_status = ?");
        }

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            int index = 1;

            if (username != null && !username.isEmpty()) {
                stmt.setString(index++, "%" + username + "%");
            }
            if (packageName != null && !packageName.isEmpty()) {
                stmt.setString(index++, "%" + packageName + "%");
            }

            if (paymentStatus != null && !paymentStatus.isEmpty()) {
                stmt.setString(index++, paymentStatus);
            }

            try ( ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    CustomerMembership customerMembership = new CustomerMembership();

                    // Tạo đối tượng Customer
                    Customer customer = new Customer();
                    customer.setCustomerId(rs.getInt("account_id"));
                    customer.setFullName(rs.getString("username"));

                    // Tạo đối tượng MembershipPackage
                    MembershipPackage membershipPackage = new MembershipPackage();
                    membershipPackage.setPackageId(rs.getInt("package_id"));
                    membershipPackage.setName(rs.getString("package_name"));

                    // Gán vào đối tượng CustomerMembership
                    customerMembership.setMembershipId(rs.getInt("membership_id"));
                    customerMembership.setCustomer(customer);
                    customerMembership.setMembershipPackage(membershipPackage);
                    customerMembership.setStartDate(rs.getDate("start_date").toLocalDate());
                    customerMembership.setEndDate(rs.getDate("end_date").toLocalDate());
                    customerMembership.setPaymentStatus(rs.getString("payment_status"));

                    customerMembershipList.add(customerMembership);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customerMembershipList;
    }

}
