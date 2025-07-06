/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Account;
import Model.LoginLog;
import db.DBcontext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Admin
 */
public class LoginLogDao extends DBcontext {

    public List<LoginLog> getAllLogs() {
        List<LoginLog> list = new ArrayList<>();
        String sql = "SELECT l.log_id, l.account_id, a.username, l.login_time, l.ip_address, l.user_agent "
                + "FROM login_logs l JOIN accounts a ON l.account_id = a.account_id "
                + "ORDER BY l.login_time DESC";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                // Tạo đối tượng Account
                Account acc = new Account();
                acc.setAccountId(rs.getInt("account_id"));
                acc.setUsername(rs.getString("username"));

                // Tạo đối tượng LoginLog
                LoginLog log = new LoginLog();
                log.setLogId(rs.getInt("log_id"));
                log.setAccount(acc);

                // Chuyển Timestamp sang LocalDateTime
                Timestamp ts = rs.getTimestamp("login_time");
                if (ts != null) {
                    log.setLoginTime(ts.toLocalDateTime());
                }

                log.setIpAddress(rs.getString("ip_address"));
                log.setUserAgent(rs.getString("user_agent"));

                list.add(log);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public void insertLog(int accountId, String ipAddress, String userAgent) {
        String sql = "INSERT INTO login_logs (account_id, ip_address, user_agent) VALUES (?, ?, ?)";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountId);
            stmt.setString(2, ipAddress);
            stmt.setString(3, userAgent);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
