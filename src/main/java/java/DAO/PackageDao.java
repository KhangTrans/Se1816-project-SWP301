package DAO;

import java.sql.*;
import java.util.*;
import Model.Package;
import db.DBcontext;

public class PackageDao extends DBcontext {

    public Package getPackageById(int id) {
        Package pkg = null;
        try {
            Connection conn = getConnection();
            String sql = "SELECT * FROM membership_packages WHERE package_id = ?"; // Đúng tên bảng & khóa chính
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String name = rs.getString("name");
                String description = rs.getString("description");
                int durationDays = rs.getInt("duration_days");
                double price = rs.getDouble("price");
                boolean isActive = rs.getBoolean("is_active");

                // Tạo đối tượng Package phù hợp với model mới
                pkg = new Package(id, name, description, durationDays, price, isActive);
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pkg;
    }

    public List<Package> getAllPackages() {
        List<Package> packages = new ArrayList<>();
        try {
            Connection conn = getConnection();
            String sql = "SELECT * FROM membership_packages";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("package_id");
                String name = rs.getString("name");
                String description = rs.getString("description");
                int durationDays = rs.getInt("duration_days");
                double price = rs.getDouble("price");
                boolean isActive = rs.getBoolean("is_active");

                Package pkg = new Package(id, name, description, durationDays, price, isActive);
                packages.add(pkg);
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return packages;
    }
}

