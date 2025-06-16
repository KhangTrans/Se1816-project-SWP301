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
 * @author Admin
 */
public class CategoryDao extends DBcontext {

    public List<Categories> getAllCategories() throws SQLException {
        List<Categories> list = new ArrayList<>();
        String sql = "SELECT * FROM categories";
        try ( Connection conn = new DBcontext().getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Categories c = new Categories();
                c.setCategory_id(rs.getInt("category_id"));
                c.setName(rs.getString("name"));
                list.add(c);
            }
        }
        return list;
    }

    public void addCategory(Categories c) throws SQLException {
        String sql = "INSERT INTO categories (name) VALUES (?)";
        try ( Connection conn = new DBcontext().getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            ps.executeUpdate();
        }
    }

    public void updateCategory(Categories c) throws SQLException {
        String sql = "UPDATE categories SET name = ? WHERE category_id = ?";
        try ( Connection conn = new DBcontext().getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            ps.setInt(2, c.getCategory_id());
            ps.executeUpdate();
        }
    }

    public void deleteCategory(int id) throws SQLException {
        String sql = "DELETE FROM categories WHERE category_id = ?";
        try ( Connection conn = new DBcontext().getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

}
