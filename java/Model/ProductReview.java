package Model;

import java.time.LocalDateTime;

public class ProductReview {

    private int reviewId;
    private Products product;     // Liên kết với bảng products (N-1)
    private Customer customer;   // Liên kết với bảng customers (N-1)
    private int rating;           // Giá trị từ 1 đến 5
    private String comment;
    private LocalDateTime createdAt;

    public ProductReview() {
    }

    public ProductReview(int reviewId, Products product, Customer customer, int rating, String comment, LocalDateTime createdAt) {
        this.reviewId = reviewId;
        this.product = product;
        this.customer = customer;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public Products getProduct() {
        return product;
    }

    public void setProduct(Products product) {
        this.product = product;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        if (rating >= 1 && rating <= 5) {
            this.rating = rating;
        } else {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "ProductReview{" +
                "reviewId=" + reviewId +
                ", product=" + (product != null ? product.getProductId() : "null") +
                ", customer=" + (customer != null ? customer.getCustomerId() : "null") +
                ", rating=" + rating +
                ", comment='" + comment + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
