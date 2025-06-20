package Model;

import java.time.LocalDate;

public class CustomerMembership {

    private int membershipId;
    private Customer customer;  // Quan hệ N-1
    private MembershipPackage membershipPackage;  // Quan hệ N-1
    private LocalDate startDate;
    private LocalDate endDate;
    private String paymentStatus; // "pending", "paid", "cancelled"

    public CustomerMembership() {
    }

    public CustomerMembership(int membershipId, Customer customer, MembershipPackage membershipPackage, LocalDate startDate, LocalDate endDate, String paymentStatus) {
        this.membershipId = membershipId;
        this.customer = customer;
        this.membershipPackage = membershipPackage;
        this.startDate = startDate;
        this.endDate = endDate;
        this.paymentStatus = paymentStatus;
    }

    public int getMembershipId() {
        return membershipId;
    }

    public void setMembershipId(int membershipId) {
        this.membershipId = membershipId;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public MembershipPackage getMembershipPackage() {
        return membershipPackage;
    }

    public void setMembershipPackage(MembershipPackage membershipPackage) {
        this.membershipPackage = membershipPackage;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    @Override
    public String toString() {
        return "CustomerMembership{"
                + "membershipId=" + membershipId
                + ", customer=" + (customer != null ? customer.getCustomerId() : "null")
                + ", membershipPackage=" + (membershipPackage != null ? membershipPackage.getPackageId() : "null")
                + ", startDate=" + startDate
                + ", endDate=" + endDate
                + ", paymentStatus='" + paymentStatus + '\''
                + '}';
    }
}
