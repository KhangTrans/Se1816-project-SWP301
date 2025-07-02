package Model;

import java.math.BigDecimal;

public class OrderItem {

    private int orderItemId;
    private Order order;  // Liên kết với đơn hàng
    private Products product;  // Liên kết với sản phẩm
    private int productId;  // ID sản phẩm
    private int quantity;  // Số lượng sản phẩm
    private BigDecimal unitPrice;  // Giá của từng sản phẩm
    private double price;  // Tổng giá trị sản phẩm (quantity * unitPrice)
    private String productName;  // Tên sản phẩm

    // Constructor
    public OrderItem() {
    }

    public OrderItem(int orderItemId, Order order, Products product, int quantity, BigDecimal unitPrice) {
        this.orderItemId = orderItemId;
        this.order = order;
        this.product = product;
        this.productId = product != null ? product.getProductId() : 0;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.price = unitPrice != null ? unitPrice.doubleValue() * quantity : 0.0;
    }

    // Getters and Setters
    public int getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(int orderItemId) {
        this.orderItemId = orderItemId;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public Products getProduct() {
        return product;
    }

    public void setProduct(Products product) {
        this.product = product;
        if (product != null) {
            this.productId = product.getProductId();
        }
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
        updatePrice();
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
        updatePrice();
    }

    public double getPrice() {
        return price;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    private void updatePrice() {
        if (unitPrice != null) {
            this.price = unitPrice.doubleValue() * quantity;
        }
    }

    @Override
    public String toString() {
        return "OrderItem{" +
                "orderItemId=" + orderItemId +
                ", productName=" + productName +
                ", quantity=" + quantity +
                ", unitPrice=" + unitPrice +
                ", price=" + price +
                '}';
    }
}
