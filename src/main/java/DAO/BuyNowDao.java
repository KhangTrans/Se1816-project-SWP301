/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Products;
import Model.Voucher;
import java.math.BigDecimal;
import java.util.Random;

/**
 *
 * @author Le Nguyen Hoang Khang - CE191583
 */
public class BuyNowDao {

    /**
     * Tính tổng tiền và giảm giá khi mua ngay một sản phẩm với voucher (nếu
     * có).
     *
     * @param product Sản phẩm
     * @param quantity Số lượng
     * @param voucher Voucher áp dụng (có thể null)
     * @return Mảng [totalAmount, discount]
     */
    public static BigDecimal[] calculateTotalWithVoucher(Products product, int quantity, Voucher voucher) {
        BigDecimal totalAmount = BigDecimal.valueOf(product.getPrice()).multiply(BigDecimal.valueOf(quantity));
        BigDecimal discount = BigDecimal.ZERO;
        if (voucher != null) {
            discount = totalAmount.multiply(BigDecimal.valueOf(voucher.getDiscountPercent()))
                    .divide(BigDecimal.valueOf(100));
            if (discount.compareTo(voucher.getMaxDiscount()) > 0) {
                discount = voucher.getMaxDiscount();
            }
            totalAmount = totalAmount.subtract(discount);
        }
        return new BigDecimal[]{totalAmount, discount};
    }

    public static String generateReferralCode() {
        // Tạo chuỗi ngẫu nhiên gồm chữ và số (8 ký tự chữ và 4 ký tự số)
        String alphanumeric = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder sb = new StringBuilder();
        Random random = new Random();

        // Tạo phần chữ
        for (int i = 0; i < 8; i++) {
            int index = random.nextInt(alphanumeric.length());
            sb.append(alphanumeric.charAt(index));
        }

        // Tạo phần số
        sb.append(String.format("%04d", random.nextInt(10000))); // Đảm bảo luôn có 4 chữ số

        return sb.toString();
    }
}
