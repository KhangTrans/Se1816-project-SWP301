/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 *
 * @author Admin
 */
public class SalesOrder {
    private int orderId;
    private int accountId;
    private int carId;
    private java.math.BigDecimal salePrice;
    private java.sql.Timestamp saleDate;
    private int handledBy;

    public SalesOrder() {
    }

    public SalesOrder(int orderId, int accountId, int carId, BigDecimal salePrice, Timestamp saleDate, int handledBy) {
        this.orderId = orderId;
        this.accountId = accountId;
        this.carId = carId;
        this.salePrice = salePrice;
        this.saleDate = saleDate;
        this.handledBy = handledBy;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
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

    public BigDecimal getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(BigDecimal salePrice) {
        this.salePrice = salePrice;
    }

    public Timestamp getSaleDate() {
        return saleDate;
    }

    public void setSaleDate(Timestamp saleDate) {
        this.saleDate = saleDate;
    }

    public int getHandledBy() {
        return handledBy;
    }

    public void setHandledBy(int handledBy) {
        this.handledBy = handledBy;
    }
    
    
}
