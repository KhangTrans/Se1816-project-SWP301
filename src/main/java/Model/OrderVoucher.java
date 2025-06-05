package Model;

import java.math.BigDecimal;

public class OrderVoucher {
    private int id;
    private Order order;          // Mỗi dòng liên kết 1 đơn hàng
    private Voucher voucher;      // Mỗi dòng liên kết 1 voucher
    private BigDecimal discountAmount;

    public OrderVoucher() {}

    public OrderVoucher(int id, Order order, Voucher voucher, BigDecimal discountAmount) {
        this.id = id;
        this.order = order;
        this.voucher = voucher;
        this.discountAmount = discountAmount;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public Voucher getVoucher() {
        return voucher;
    }

    public void setVoucher(Voucher voucher) {
        this.voucher = voucher;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }
}
