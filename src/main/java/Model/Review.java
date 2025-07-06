package Model;

import java.sql.Timestamp;
import java.util.Date;

public class Review {
     private int reviewId;       // Mã đánh giá
    private Products product;    // Sản phẩm mà đánh giá liên quan đến
    private Account account;    // Tài khoản người đánh giá
    private int rating;         // Đánh giá sao (1 đến 5)
    private String comment;     // Bình luận của người đánh giá
    private Timestamp createdAt; // Thời gian tạo đánh giá

    public Review() {
    }

    public Review(int reviewId, Products product, Account account, int rating, String comment, Timestamp createdAt) {
        this.reviewId = reviewId;
        this.product = product;
        this.account = account;
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

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }


  
}
