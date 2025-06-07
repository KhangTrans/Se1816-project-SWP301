package DAO;

import java.util.List;
import Model.Product_Images;

public class main {
    public static void main(String[] args) {
        ProductDAO dao = new ProductDAO();
        List<Product_Images> images = dao.getImagesByProductId(6);
        
        if (images == null || images.isEmpty()) {
            System.out.println("Không có ảnh nào cho productId = 4");
        } else {
            System.out.println("Số ảnh lấy được: " + images.size());
            for (Product_Images img : images) {
                byte[] imgData = img.getImg_url();
                System.out.println("Image ID: " + img.getImage_id());
                System.out.println("Product ID: " + img.getProduct_id());
                System.out.println("Is Primary: " + img.getPrimary());
 
                if (imgData != null) {
                    System.out.println("Kích thước ảnh (bytes): " + imgData.length);
                } else {
                    System.out.println("Ảnh null");
                }
                System.out.println("---------------------------");
            }
        }
    }
}
