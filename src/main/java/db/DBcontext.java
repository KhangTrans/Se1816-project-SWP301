package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBcontext {

    private final String DB_URL = "jdbc:sqlserver://127.0.0.1:1433;databaseName=QuanLy_HeThongBanXeOto;encrypt=false";
    private final String DB_USER = "sa";
    private final String DB_PWD = "123456";

    public Connection getConnection() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PWD);
            if (connection != null) {
                System.out.println("Kết nối tới cơ sở dữ liệu thành công.");
            }
            return connection;
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DBcontext.class.getName()).log(Level.SEVERE, "Không tìm thấy driver!", ex);
            throw new SQLException("Lỗi kết nối CSDL: Driver không tìm thấy.");
        }
    }

    public ResultSet execSelectQuery(String query, Object[] params) throws SQLException {
        Connection conn = getConnection();
        PreparedStatement preparedStatement = conn.prepareStatement(query);
        if (params != null) {
            for (int i = 0; i < params.length; i++) {
                preparedStatement.setObject(i + 1, params[i]);
            }
        }
        System.out.println("Đang thực thi câu lệnh SELECT...");
        return preparedStatement.executeQuery();
    }

    // Thực thi câu lệnh INSERT, UPDATE, DELETE
    public int execQuery(String query, Object[] params) throws SQLException {
        try ( Connection conn = getConnection();  PreparedStatement preparedStatement = conn.prepareStatement(query)) {
            if (params != null) {
                for (int i = 0; i < params.length; i++) {
                    preparedStatement.setObject(i + 1, params[i]);
                }
            }
            System.out.println("Đang thực thi câu lệnh INSERT/UPDATE...");
            return preparedStatement.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Lỗi SQL: " + e.getMessage());
            throw e; // Rethrow exception để có thể xử lý ở nơi gọi
        }
    }

}
