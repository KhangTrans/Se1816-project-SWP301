/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author Admin
 */
public class Product_Images {
    private int image_id;
    private int product_id;
    private byte [] img_url;
    private int primary;
    private String time;

    public Product_Images() {
    }

    public Product_Images(int image_id, int product_id, byte[] img_url, int primary, String time) {
        this.image_id = image_id;
        this.product_id = product_id;
        this.img_url = img_url;
        this.primary = primary;
        this.time = time;
    }


    public int getImage_id() {
        return image_id;
    }

    public void setImage_id(int image_id) {
        this.image_id = image_id;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public byte[] getImg_url() {
        return img_url;
    }

    public void setImg_url(byte[] img_url) {
        this.img_url = img_url;
    }

    public int getPrimary() {
        return primary;
    }

    public void setPrimary(int primary) {
        this.primary = primary;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }
    
}
