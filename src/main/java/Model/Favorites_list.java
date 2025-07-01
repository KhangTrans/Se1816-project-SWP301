/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author ADMIN
 */
public class Favorites_list {

    private int favoriteId;        // ID duy nhất cho mỗi sản phẩm yêu thích
    private Customer customer;     // Liên kết với Customer model
    private Products product;       // Liên kết với Product model

    public Favorites_list() {
    }

    public Favorites_list(int favoriteId, Customer customer, Products product) {
        this.favoriteId = favoriteId;
        this.customer = customer;
        this.product = product;
    }

    public int getFavoriteId() {
        return favoriteId;
    }

    public void setFavoriteId(int favoriteId) {
        this.favoriteId = favoriteId;
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

    @Override
    public String toString() {
        return "Favorites_list{" + "favoriteId=" + favoriteId + ", customer=" + customer + ", product=" + product + '}';
    }
      
}


