package Model;

import java.time.LocalDateTime;

public class CartItem {

    private int cartItemId;
    private int accountId;       // Thay đổi thành kiểu int
    private int productId;       // Thay đổi thành kiểu int
    private int quantity;
    private LocalDateTime addedAt;
    private Products product;

    public CartItem() {
    }

    public CartItem(int cartItemId, int accountId, int productId, int quantity, Products product, LocalDateTime addedAt) {
        this.cartItemId = cartItemId;
        this.accountId = accountId;
        this.productId = productId;
        this.quantity = quantity;
        this.product = product;
        this.addedAt = addedAt;
    }

    public Products getProduct() {
        return product;
    }

    public void setProduct(Products product) {
        this.product = product;
    }

    public int getCartItemId() {
        return cartItemId;
    }

    public void setCartItemId(int cartItemId) {
        this.cartItemId = cartItemId;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
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
    }

    public LocalDateTime getAddedAt() {
        return addedAt;
    }

    public void setAddedAt(LocalDateTime addedAt) {
        this.addedAt = addedAt;
    }
}
