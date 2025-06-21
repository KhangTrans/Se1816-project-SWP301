package Model;

import java.util.ArrayList;
import java.util.List;

public class Products {

    private int productId;
    private String name;
    private String description;
    private double price;
    private int stockQuantity;
    private boolean active;
    private Categories categoryId;
    private String imageUrl;
    private String categoryName;
    private List<Product_Images> images = new ArrayList<>();

    public Products() {
    }

    public Products(int productId, String name, String description, double price,
            int stockQuantity, boolean active, Categories categoryId) {
        this.productId = productId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.active = active;
        this.categoryId = categoryId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    private int primaryImageId; // thêm dòng này

    public int getPrimaryImageId() {
        return primaryImageId;
    }

    public void setPrimaryImageId(int primaryImageId) {
        this.primaryImageId = primaryImageId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Categories getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Categories categoryId) {
        this.categoryId = categoryId;
    }

    public List<Product_Images> getImages() {
        return images;
    }

    public void setImages(List<Product_Images> images) {
        this.images = images;
    }

    public void addImage(Product_Images image) {
        this.images.add(image);
    }

    @Override
    public String toString() {
        return "Products [id=" + productId + ", name=" + name + ", price=" + price + ", active=" + active + "]";
    }
}
