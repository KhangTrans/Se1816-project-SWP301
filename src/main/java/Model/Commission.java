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
public class Commission {
    private int commissionId;
    private int orderId;
    private int staffId;
    private java.math.BigDecimal commissionRate;
    private java.math.BigDecimal commissionAmount;
    private java.sql.Timestamp createdAt;

    public Commission() {
    }

    public Commission(int commissionId, int orderId, int staffId, BigDecimal commissionRate, BigDecimal commissionAmount, Timestamp createdAt) {
        this.commissionId = commissionId;
        this.orderId = orderId;
        this.staffId = staffId;
        this.commissionRate = commissionRate;
        this.commissionAmount = commissionAmount;
        this.createdAt = createdAt;
    }

    public int getCommissionId() {
        return commissionId;
    }

    public void setCommissionId(int commissionId) {
        this.commissionId = commissionId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public BigDecimal getCommissionRate() {
        return commissionRate;
    }

    public void setCommissionRate(BigDecimal commissionRate) {
        this.commissionRate = commissionRate;
    }

    public BigDecimal getCommissionAmount() {
        return commissionAmount;
    }

    public void setCommissionAmount(BigDecimal commissionAmount) {
        this.commissionAmount = commissionAmount;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
}
