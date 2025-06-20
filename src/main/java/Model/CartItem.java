package Model;

import java.time.LocalDateTime;

public class CartItem {

    private int cartItemId;
    private Customer customer;       // Quan hệ N-1
    private Products product;        // Quan hệ N-1
    private int quantity;
    private LocalDateTime addedAt;

    public CartItem() {
    }

    public CartItem(int cartItemId, Customer customer, Products product, int quantity, LocalDateTime addedAt) {
        this.cartItemId = cartItemId;
        this.customer = customer;
        this.product = product;
        this.quantity = quantity;
        this.addedAt = addedAt;
    }

    public int getCartItemId() {
        return cartItemId;
    }

    public void setCartItemId(int cartItemId) {
        this.cartItemId = cartItemId;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public Products getProduct() {
        return product;
    }

    public void setProduct(Products product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public LocalDateTime getAddedAt() {
        return addedAt;
    }

    public void setAddedAt(LocalDateTime addedAt) {
        this.addedAt = addedAt;
    }

    @Override
    public String toString() {
        return "CartItem{" +
                "cartItemId=" + cartItemId +
                ", customerId=" + (customer != null ? customer.getCustomerId() : "null") +
                ", productId=" + (product != null ? product.getProductId() : "null") +
                ", quantity=" + quantity +
                ", addedAt=" + addedAt +
                '}';
    }
}
