package Model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Order {

     private int orderId;
    private Account account; // Đại diện cho account_id
    private LocalDateTime orderDate;
    private BigDecimal totalAmount;
    private String shippingAddress;
    private String status;
    private String recipientName;
    private String recipientPhone;
    private String note;
    private Voucher voucher;
    private String orderCode;

    public Order() {
    }

    public Order(int orderId, Account account, LocalDateTime orderDate, BigDecimal totalAmount, String shippingAddress, String status, String recipientName, String recipientPhone, String note, Voucher voucher, String orderCode) {
        this.orderId = orderId;
        this.account = account;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.shippingAddress = shippingAddress;
        this.status = status;
        this.recipientName = recipientName;
        this.recipientPhone = recipientPhone;
        this.note = note;
        this.voucher = voucher;
        this.orderCode = orderCode;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    }

    public LocalDateTime getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(LocalDateTime orderDate) {
        this.orderDate = orderDate;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }

    public String getRecipientPhone() {
        return recipientPhone;
    }

    public void setRecipientPhone(String recipientPhone) {
        this.recipientPhone = recipientPhone;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Voucher getVoucher() {
        return voucher;
    }

    public void setVoucher(Voucher voucher) {
        this.voucher = voucher;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }
    
  
}
