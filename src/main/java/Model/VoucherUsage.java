package Model;

import java.time.LocalDateTime;

public class VoucherUsage {

    private int usageId;
    private Voucher voucher;         // Quan hệ N-1: mỗi usage liên kết tới 1 voucher
    private Customer customer;       // Quan hệ N-1: mỗi usage liên kết tới 1 customer
    private LocalDateTime usedAt;

    public VoucherUsage() {
    }

    public VoucherUsage(int usageId, Voucher voucher, Customer customer, LocalDateTime usedAt) {
        this.usageId = usageId;
        this.voucher = voucher;
        this.customer = customer;
        this.usedAt = usedAt;
    }

    public int getUsageId() {
        return usageId;
    }

    public void setUsageId(int usageId) {
        this.usageId = usageId;
    }

    public Voucher getVoucher() {
        return voucher;
    }

    public void setVoucher(Voucher voucher) {
        this.voucher = voucher;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public LocalDateTime getUsedAt() {
        return usedAt;
    }

    public void setUsedAt(LocalDateTime usedAt) {
        this.usedAt = usedAt;
    }
}
