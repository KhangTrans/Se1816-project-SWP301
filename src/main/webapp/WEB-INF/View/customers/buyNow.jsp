<%-- 
    Document   : buyNow
    Created on : Jul 16, 2025, 12:23:33 AM
    Author     : Le Nguyen Hoang Khang - CE191583
--%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/head.jsp" %>
<%@include file="/WEB-INF/include/Login.jsp" %>
<%@include file="/WEB-INF/include/Register.jsp" %>
<%@include file="/WEB-INF/include/forgotPassword.jsp" %>
<%@include file="/WEB-INF/include/header.jsp" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<%
    Model.Products p = (Model.Products) request.getAttribute("product");
    List<Model.Voucher> claimedVouchers = (List<Model.Voucher>) request.getAttribute("claimedVouchers");
%>

<style>
    body {
        background: #111;
        color: #fff;
    }
    
    .fas{
        margin-top: 6px;
    }

    .buy-now-detail-container {
        display: flex;
        justify-content: center;
        align-items: center;
        margin: 60px auto;
        max-width: 1200px;
        padding: 0 20px;
    }

    .buy-now-content {
        display: flex;
        width: 100%;
        background: rgba(25, 25, 25, 0.9);
        border-radius: 20px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        overflow: hidden;
        border: 1px solid rgba(217, 255, 104, 0.3);
    }

    .buy-now-image-frame {
        flex: 0 0 45%;
        padding: 40px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        position: relative;
        background: linear-gradient(135deg, #1a1a1a, #252525);
    }

    .product-glow {
        position: absolute;
        width: 100%;
        height: 100%;
        background: radial-gradient(circle at center, rgba(217, 255, 104, 0.15) 0%, rgba(0, 0, 0, 0) 70%);
        z-index: 1;
    }

    .buy-now-image-frame img {
        width: 300px;
        height: 300px;
        object-fit: contain;
        border-radius: 15px;
        position: relative;
        z-index: 2;
        transition: transform 0.3s ease;
        filter: drop-shadow(0 5px 15px rgba(217, 255, 104, 0.3));
    }

    .buy-now-image-frame img:hover {
        transform: scale(1.05);
    }

    .product-info {
        margin-top: 20px;
        text-align: center;
        z-index: 2;
    }

    .product-name {
        font-size: 22px;
        font-weight: bold;
        margin-bottom: 10px;
        color: #fff;
    }

    .product-category {
        color: #d9ff68;
        font-size: 14px;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    .buy-now-form-frame {
        flex: 0 0 55%;
        padding: 40px;
        position: relative;
    }

    .buy-now-form-frame h2 {
        color: #d9ff68;
        margin-bottom: 25px;
        font-size: 32px;
        font-weight: 700;
        letter-spacing: 0.5px;
        text-transform: uppercase;
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

    .input-group {
        margin-bottom: 20px;
        position: relative;
    }

    .input-group label {
        font-weight: 500;
        margin-bottom: 8px;
        color: #fff;
        display: block;
        font-size: 15px;
    }

    .input-group i {
        position: absolute;
        left: 15px;
        top: 41px;
        color: #555;
        font-size: 16px;
    }

    .input-group input,
    .input-group select {
        width: 100%;
        padding: 12px 15px 12px 45px;
        border-radius: 8px;
        border: 1px solid #333;
        background: rgba(255, 255, 255, 0.05);
        color: #fff;
        font-size: 16px;
        transition: all 0.3s ease;
    }

    .input-group input:focus,
    .input-group select:focus {
        border-color: #d9ff68;
        box-shadow: 0 0 0 2px rgba(217, 255, 104, 0.25);
        outline: none;
    }

    .input-group input::placeholder {
        color: #555;
    }


    .input-group.quantity-group {
        display: flex;
        align-items: center;
    }

    .input-group.quantity-group label {
        margin-bottom: 0;
        margin-right: 15px;
    }

    .quantity-controls {
        display: flex;
        align-items: center;
    }

    .qty-btn {
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: rgba(217, 255, 104, 0.15);
        border: none;
        border-radius: 8px;
        color: #d9ff68;
        font-size: 18px;
        cursor: pointer;
        transition: all 0.2s;
    }

    .qty-btn:hover {
        background: rgba(217, 255, 104, 0.3);
    }

    .quantity-input {
        /*width: 60px;*/
        /*text-align: center;*/
        margin: 0 10px;
        padding: 10px 5px;
        border-radius: 8px;
        border: 1px solid #333;
        background: rgba(255, 255, 255, 0.05);
        color: #fff;
        font-size: 16px;
    }

    .buy-button {
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        color: #111;
        border: none;
        border-radius: 10px;
        font-size: 18px;
        padding: 15px 0;
        width: 100%;
        margin-top: 20px;
        font-weight: bold;
        letter-spacing: 1px;
        cursor: pointer;
        transition: all 0.3s;
        text-transform: uppercase;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .buy-button:hover {
        transform: translateY(-3px);
        box-shadow: 0 7px 15px rgba(217, 255, 104, 0.3);
    }

    .buy-button i {
        margin-right: 10px;
        font-size: 20px;
    }

    #pricePreview {
        margin-top: 25px;
        padding: 20px;
        border-radius: 10px;
        background: rgba(0, 0, 0, 0.2);
        border: 1px solid rgba(217, 255, 104, 0.2);
    }

    .price-line {
        display: flex;
        justify-content: space-between;
        margin-bottom: 10px;
    }

    .price-line.total {
        margin-top: 15px;
        padding-top: 15px;
        border-top: 1px dashed rgba(255, 255, 255, 0.1);
    }

    .price-label {
        color: #aaa;
    }

    .price-value {
        font-weight: bold;
    }

    .original-price {
        color: #aaa;
    }

    .discounted-price {
        color: #d9ff68;
        font-size: 20px;
    }

    .voucher-badge {
        display: inline-block;
        padding: 3px 8px;
        background: rgba(217, 255, 104, 0.15);
        border-radius: 4px;
        color: #d9ff68;
        font-size: 12px;
        margin-left: 10px;
    }


    input::-webkit-outer-spin-button,
    input::-webkit-inner-spin-button {
        -webkit-appearance: none;
        margin: 0;
    }

    input[type=number] {
        -moz-appearance: textfield; /* Firefox */
    }


    @media (max-width: 992px) {
        .buy-now-content {
            flex-direction: column;
        }

        .buy-now-image-frame,
        .buy-now-form-frame {
            flex: 0 0 100%;
            width: 100%;
        }
    }
</style>

<div class="buy-now-detail-container">
    <div class="buy-now-content">
        <div class="buy-now-image-frame">
            <div class="product-glow"></div>
            <img src="<%= request.getContextPath() + "/ImagesServlet?type=product&imageId=" + p.getPrimaryImageId()%>" class="product-image" alt="<%= p.getName()%>" />
            <div class="product-info">
                <div class="product-name"><%= p.getName()%></div>
                <div class="product-category"><%= p.getCategoryId().getName()%></div>
            </div>
        </div>

        <div class="buy-now-form-frame">
            <h2>Place Your Order</h2>
            <form action="<%= request.getContextPath()%>/BuyNow" method="post">
                <input type="hidden" name="productId" value="<%= p.getProductId()%>"/>

                <div class="input-group">
                    <label for="fullName">Full name</label>
                    <i class="fas fa-user"></i>
                    <input type="text" id="fullName" name="fullName" placeholder="Enter your full name" required>
                </div>

                <div class="input-group">
                    <label for="phone">Phone number</label>
                    <i class="fas fa-phone-alt"></i>
                    <input type="text" id="phone" name="phone" placeholder="Enter your phone number" required>
                </div>

                <div class="input-group">
                    <label for="address">Delivery address</label>
                    <i class="fas fa-map-marker-alt"></i>
                    <input type="text" id="address" name="address" placeholder="Enter your delivery address" required>
                </div>

                <div class="input-group">
                    <label for="voucherIdDropdown">Apply voucher</label>
                    <i class="fas fa-ticket-alt"></i>
                    <select name="voucherId" id="voucherIdDropdown">
                        <option value="">No voucher</option>
                        <% if (claimedVouchers != null)
                                for (Model.Voucher v : claimedVouchers) {%>
                        <option value="<%= v.getVoucherId()%>"
                                data-discount="<%= v.getDiscountPercent()%>"
                                data-max="<%= v.getMaxDiscount()%>"
                                data-minorder="<%= v.getMinOrderAmount()%>">
                            <%= v.getCode()%> - <%= v.getDiscountPercent()%>% (max: <%= v.getMaxDiscount()%>₫)
                        </option>
                        <% }%>
                    </select>
                </div>

                <div class="input-group">
                    <label for="quantity" style="margin-top: 11px; padding: 22px">Quantity</label>
                    <div class="quantity-controls">
                        <button type="button" class="qty-btn minus-btn" onclick="decrementQty()">-</button>
                        <input type="number" id="quantity" name="quantity" value="1" min="1" max="<%= p.getStockQuantity()%>" class="quantity-input">
                        <button type="button" class="qty-btn plus-btn" onclick="incrementQty(<%= p.getStockQuantity()%>)">+</button>
                    </div>
                </div>

                <div id="pricePreview">
                    <div class="price-line">
                        <span class="price-label">Original price:</span>
                        <span class="price-value original-price"><span id="originPrice"></span>₫</span>
                    </div>
                    <% if (claimedVouchers != null && !claimedVouchers.isEmpty()) { %>
                    <div class="price-line" id="discountLine" style="display: none;">
                        <span class="price-label">Discount:</span>
                        <span class="price-value" style="color: #ff6b6b;"><span id="discountAmount"></span>₫ <span class="voucher-badge">Voucher applied</span></span>
                    </div>
                    <% }%>
                    <div class="price-line total">
                        <span class="price-label">Total price:</span>
                        <span class="price-value discounted-price"><span id="discountedPrice"></span>₫</span>
                    </div>
                </div>

                <button type="submit" class="buy-button">
                    <i class="fas fa-bolt"></i> Complete Order
                </button>
            </form>
        </div>
    </div>
</div>

<script>
    window.productPrice = <%= p.getPrice()%>;
    window.PRODUCT_STOCK = <%= p.getStockQuantity()%>;
    window.APP_CONTEXT_PATH = '<%= request.getContextPath()%>';

    function incrementQty(max) {
        var qtyInput = document.getElementById('quantity');
        var currentValue = parseInt(qtyInput.value) || 0;
        if (currentValue < max) {
            qtyInput.value = currentValue + 1;
            qtyInput.dispatchEvent(new Event('input'));
        }
    }

    function decrementQty() {
        var qtyInput = document.getElementById('quantity');
        var currentValue = parseInt(qtyInput.value) || 0;
        if (currentValue > 1) {
            qtyInput.value = currentValue - 1;
            qtyInput.dispatchEvent(new Event('input'));
        }
    }

    document.addEventListener('DOMContentLoaded', function () {
        const discountLine = document.getElementById('discountLine');
        const discountAmount = document.getElementById('discountAmount');
        const voucherSelect = document.getElementById('voucherIdDropdown');

        const originalUpdatePrice = window.updatePrice;

        // Override the updatePrice function to also update the discount line
        window.updatePrice = function () {
            if (typeof originalUpdatePrice === 'function') {
                originalUpdatePrice();

                // Additional code to show discount amount
                let quantity = parseInt(document.querySelector('input[name="quantity"]').value) || 1;
                let voucherOpt = voucherSelect.options[voucherSelect.selectedIndex];
                let discountPercent = voucherOpt.getAttribute('data-discount');
                let maxDiscount = voucherOpt.getAttribute('data-max');
                let total = productPrice * quantity;

                if (discountPercent && discountLine) {
                    let discount = total * parseInt(discountPercent) / 100;
                    if (maxDiscount) {
                        discount = Math.min(discount, parseFloat(maxDiscount));
                    }

                    discountAmount.textContent = formatMoney(discount);
                    discountLine.style.display = 'flex';
                } else if (discountLine) {
                    discountLine.style.display = 'none';
                }
            }
        };
    });
</script>
<script src="<%= request.getContextPath()%>/js/buyNow.js"></script>
<%@include file="/WEB-INF/include/footer.jsp" %>

