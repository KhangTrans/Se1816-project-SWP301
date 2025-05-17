/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.sql.Timestamp;

/**
 *
 * @author Admin
 */
public class Favorite {
    private int requestId;
    private int accountId;
    private int carId;
    private java.sql.Timestamp preferredDate;
    private String message;
    private String status;
    private java.sql.Timestamp createdAt;

    public Favorite() {
    }

    public Favorite(int requestId, int accountId, int carId, Timestamp preferredDate, String message, String status, Timestamp createdAt) {
        this.requestId = requestId;
        this.accountId = accountId;
        this.carId = carId;
        this.preferredDate = preferredDate;
        this.message = message;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public int getCarId() {
        return carId;
    }

    public void setCarId(int carId) {
        this.carId = carId;
    }

    public Timestamp getPreferredDate() {
        return preferredDate;
    }

    public void setPreferredDate(Timestamp preferredDate) {
        this.preferredDate = preferredDate;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
}
