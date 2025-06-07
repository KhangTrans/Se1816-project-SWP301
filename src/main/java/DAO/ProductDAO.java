/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Categories;
import Model.Product_Images;
import Model.Products;
import db.DBcontext;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author PC
 */
public class ProductDAO extends DBcontext {

    public List<Products> getAllProduct() {
        List<Products> list = new ArrayList<>();
        String sql = "select * from products";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("product_id");
                String name = rs.getString("name");
                String description = rs.getString("description");
                double price = rs.getDouble("price");
                int stock = rs.getInt("stock_quantity");
                int category_id = rs.getInt("category_id");
                Categories categoris = getCategoriesById(category_id);
                boolean is_active = rs.getBoolean("is_active");
                Products p = new Products(id, name, description, price, stock, is_active, categoris);
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public Categories getCategoriesById(int id) {
        String sql = "select * from [dbo].[categories] where category_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String name = rs.getString("name");
                String description = rs.getString("description");
                Categories c = new Categories(id, name, description);
                return c;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public List<Product_Images> getImagesByProductId(int productID) {
        List<Product_Images> images = new ArrayList<>();
        String sql = "select * from product_images where product_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int imageId = rs.getInt("image_id");
                int productId = rs.getInt("product_id");

                // Lấy ảnh từ BLOB
                Blob imageBlob = rs.getBlob("image_url");
                byte[] imageBytes = null;
                if (imageBlob != null) {
                    imageBytes = imageBlob.getBytes(1, (int) imageBlob.length());
                }

                int isPrimary = rs.getInt("is_primary");
                String uploadedAt = rs.getString("uploaded_at");
                images.add(new Product_Images(imageId, productId, imageBytes, isPrimary, uploadedAt));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return images;
    }

}
