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
public class CarComparison {
    private int comparisonId;
    private int accountId;
    private int carId1;
    private int carId2;
    private java.sql.Timestamp createdAt;

    public CarComparison() {
    }

    public CarComparison(int comparisonId, int accountId, int carId1, int carId2, Timestamp createdAt) {
        this.comparisonId = comparisonId;
        this.accountId = accountId;
        this.carId1 = carId1;
        this.carId2 = carId2;
        this.createdAt = createdAt;
    }

    public int getComparisonId() {
        return comparisonId;
    }

    public void setComparisonId(int comparisonId) {
        this.comparisonId = comparisonId;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public int getCarId1() {
        return carId1;
    }

    public void setCarId1(int carId1) {
        this.carId1 = carId1;
    }

    public int getCarId2() {
        return carId2;
    }

    public void setCarId2(int carId2) {
        this.carId2 = carId2;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    
}
