package DAO;

import Model.MembershipPackage;
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
            String sql = "SELECT * FROM membership_packages WHERE is_active = 1";
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

    public boolean insertPackage(Package pkg) {
        String sql = "INSERT INTO membership_packages (name, description, duration_days, price, is_active) VALUES (?, ?, ?, ?, ?)";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, pkg.getName());
            ps.setString(2, pkg.getDescription());
            ps.setInt(3, pkg.getDurationDays());
            ps.setDouble(4, pkg.getPrice());
            ps.setBoolean(5, pkg.isIsActive()); // chú ý tên hàm

            int row = ps.executeUpdate();
            return row > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePackage(Package pkg) {
        String sql = "UPDATE membership_packages SET name=?, description=?, duration_days=?, price=?, is_active=? WHERE package_id=?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, pkg.getName());
            ps.setString(2, pkg.getDescription());
            ps.setInt(3, pkg.getDurationDays());
            ps.setDouble(4, pkg.getPrice());
            ps.setBoolean(5, pkg.isIsActive());
            ps.setInt(6, pkg.getId());

            int affectedRows = ps.executeUpdate();
            System.out.println("🔁 Rows affected: " + affectedRows);
            return affectedRows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean softDeletePackage(int id) {
        String sql = "UPDATE membership_packages SET is_active = 0 WHERE package_id=?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Package> getTopThreePackages() {
        List<Package> packages = new ArrayList<>();
        String sql = "SELECT TOP 3 * FROM membership_packages WHERE is_active = 1;";  // Lấy 3 gói hoạt động
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                // Lấy dữ liệu từ ResultSet và tạo đối tượng Package
                int id = rs.getInt("package_id");
                String name = rs.getString("name");
                String description = rs.getString("description");
                int durationDays = rs.getInt("duration_days");
                double price = rs.getDouble("price");
                boolean isActive = rs.getBoolean("is_active");

                // Tạo đối tượng Package và thêm vào danh sách
                Package pkg = new Package(id, name, description, durationDays, price, isActive);
                packages.add(pkg);
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return packages;
    }

    public MembershipPackage convertToMembershipPackage(Package pkg) {
        if (pkg == null) {
            return null;
        }
        return new MembershipPackage(
                pkg.getId(),
                pkg.getName(),
                pkg.getDescription(),
                pkg.getDurationDays(),
                pkg.getPrice(),
                pkg.isIsActive()
        );
    }
}
