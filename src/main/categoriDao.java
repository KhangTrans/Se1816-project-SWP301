/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Categories;
import db.DBcontext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Phương
 */
public class categoriDao extends DBcontext {
    // Phương thức lấy ra tất cả các danh mục

    public List<Categories> getAllCategories() {
        List<Categories> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories"; // Câu lệnh SQL để lấy tất cả các danh mục

        try ( Connection con = getConnection(); // Tạo kết nối đến cơ sở dữ liệu
                  PreparedStatement ps = con.prepareStatement(sql); // Tạo PreparedStatement
                  ResultSet rs = ps.executeQuery()) { // Thực thi câu lệnh SQL

            while (rs.next()) {
                // Lấy dữ liệu từ ResultSet và tạo đối tượng Categori
                int categoryId = rs.getInt("category_id");
                String name = rs.getString("name");
                String description = rs.getString("description");

                // Thêm đối tượng Categori vào danh sách
                Categories category = new Categories(categoryId, name, description);
                categories.add(category);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return categories; // Trả về danh sách các danh mục
    }

    public boolean updateCategory(int categoryId, String name, String description) {
        String sql = "UPDATE categories SET name = ?, description = ? WHERE category_id = ?";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setInt(3, categoryId);

            System.out.println("Executing update: categoryId=" + categoryId + ", name=" + name + ", description=" + description);
            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("SQLException in updateCategory: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Phương thức lấy ra danh mục theo category_id
    public Categories getCategoryById(int categoryId) {
        Categories category = null;
        String sql = "SELECT * FROM categories WHERE category_id = ?"; // Câu lệnh SQL lấy danh mục theo ID

        try ( Connection con = getConnection(); // Tạo kết nối đến cơ sở dữ liệu
                  PreparedStatement ps = con.prepareStatement(sql)) { // Tạo PreparedStatement

            ps.setInt(1, categoryId); // Thiết lập giá trị cho parameter category_id

            try ( ResultSet rs = ps.executeQuery()) { // Thực thi câu lệnh SQL
                if (rs.next()) {
                    // Lấy dữ liệu từ ResultSet và tạo đối tượng Categori
                    String name = rs.getString("name");
                    String description = rs.getString("description");

                    category = new Categories(categoryId, name, description); // Tạo đối tượng Categori
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return category; // Trả về danh mục theo ID, nếu không tìm thấy sẽ trả về null
    }

    public boolean addCategory(String name, String description) {
        String sql = "INSERT INTO categories (name, description) VALUES (?, ?)";
        try ( Connection con = getConnection(); // Tạo kết nối đến cơ sở dữ liệu
                  PreparedStatement ps = con.prepareStatement(sql)) { // Tạo PreparedStatement

            ps.setString(1, name); // Thiết lập giá trị cho parameter name
            ps.setString(2, description); // Thiết lập giá trị cho parameter description

            int rowsAffected = ps.executeUpdate(); // Thực thi câu lệnh SQL

            return rowsAffected > 0; // Trả về true nếu có ít nhất một dòng được thêm vào
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false; // Trả về false nếu không thêm được
    }

    public List<Categories> searchCategoriesByName(String searchTerm) {
        List<Categories> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE name LIKE ?";  // SQL với điều kiện LIKE

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + searchTerm + "%");  // Thêm dấu `%` để tìm kiếm theo từ khóa

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int categoryId = rs.getInt("category_id");
                    String name = rs.getString("name");
                    String description = rs.getString("description");

                    Categories category = new Categories(categoryId, name, description);
                    categories.add(category);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return categories;
    }

}
