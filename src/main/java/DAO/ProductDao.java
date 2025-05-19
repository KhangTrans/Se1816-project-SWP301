/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import Model.Product;
import db.DBcontext;

/**
 *
 * @author Le Nguyen Hoang Khang - CE191583
 */
public class ProductDao {

    public List<Product> searchAndFilter(String keyword, String categoryName) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.product_id, p.name, p.description, p.price, p.image_url, c.name AS category_name "
                + "FROM products p JOIN categories c ON p.category_id = c.category_id WHERE p.is_active = 1";

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND p.name LIKE ?";
        }
        if (categoryName != null && !categoryName.trim().isEmpty()) {
            sql += " AND c.name = ?";
        }

        DBcontext db = new DBcontext();
        try ( Connection con = db.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            int index = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword.trim() + "%");
            }
            if (categoryName != null && !categoryName.trim().isEmpty()) {
                ps.setString(index++, categoryName.trim());
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("product_id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getDouble("price"));
                p.setImageUrl(rs.getString("image_url"));
                p.setCategoryName(rs.getString("category_name"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
