package Model;

import java.time.LocalDateTime;

public class Payment {

    private int paymentId;
    private CustomerMembership membership; // Quan hệ N-1
    private double amount;
    private String method;
    private LocalDateTime paymentDate;

    public Payment() {
    }

    public Payment(int paymentId, CustomerMembership membership, double amount, String method, LocalDateTime paymentDate) {
        this.paymentId = paymentId;
        this.membership = membership;
        this.amount = amount;
        this.method = method;
        this.paymentDate = paymentDate;
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public CustomerMembership getMembership() {
        return membership;
    }

    public void setMembership(CustomerMembership membership) {
        this.membership = membership;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public LocalDateTime getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(LocalDateTime paymentDate) {
        this.paymentDate = paymentDate;
    }

    @Override
    public String toString() {
        return "Payment{"
                + "paymentId=" + paymentId
                + ", membershipId=" + (membership != null ? membership.getMembershipId() : "null")
                + ", amount=" + amount
                + ", method='" + method + '\''
                + ", paymentDate=" + paymentDate
                + '}';
    }
}
