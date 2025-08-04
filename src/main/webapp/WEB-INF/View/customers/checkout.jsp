<%@page import="Model.Voucher"%>
<%@page import="DAO.CheckoutDao"%>
<%@page import="Model.Customer"%>
<%@page import="DAO.UserDao"%>
<%@ page import="java.util.List" %>
<%@ page import="Model.CartItem" %>
<%@ page import="Model.Products" %>
<%@ page import="DAO.ProductDao" %>
<%@ include file="/WEB-INF/include/head.jsp" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<%
    // L?y bi?n t? request, kh?ng l?y t? session n?a ?? ??ng b? v?i Servlet
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    System.out.println("cart imtem 1: " + cartItems);
    if (cartItems == null) {
        cartItems = (List<CartItem>) request.getAttribute("cart");
    }
    List<Model.Voucher> claimedVouchers = (List<Model.Voucher>) request.getAttribute("claimedVouchers");
    Double total = 0.0;
    StringBuilder stockError = new StringBuilder();
    boolean hasStockError = false;
    ProductDao productDao = new ProductDao();

    if (cartItems != null && !cartItems.isEmpty()) {
        for (CartItem item : cartItems) {
            Products product = item.getProduct();
            int quantity = item.getQuantity();
            int stockQty = 0;
            double price = 0;
            String name = "Unknown";
            if (product != null) {
                price = product.getPrice();
                name = product.getName();
                // L?y s? l??ng t?n kho m?i nh?t t? DB
                Products fresh = productDao.getProductById(product.getProductId());
                if (fresh != null) {
                    stockQty = fresh.getStockQuantity();
                }
                if (quantity > stockQty) {
                    hasStockError = true;
                    stockError.append("Number of products <b>")
                            .append(name)
                            .append("</b> left <b>")
                            .append(stockQty)
                            .append("</b> products. Please select the appropriate quantity.<br>");
                }
            }
            double subtotal = price * quantity;
            total += subtotal;
        }
    }
    System.out.println("checkout" + cartItems);
%>

<style>
    body {
        background-color: #111;
        color: #fff;
        font-family: 'Arial', sans-serif;
    }

    .checkout-container {
        max-width: 1000px;
        margin: 100px auto;
        padding: 0 20px;
    }

    .checkout-content {
        background: rgba(25, 25, 25, 0.9);
        border-radius: 20px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        overflow: hidden;
        border: 1px solid rgba(217, 255, 104, 0.3);
    }

    .checkout-header {
        background: linear-gradient(135deg, rgba(25, 25, 25, 0.9) 0%, rgba(40, 40, 40, 0.9) 100%);
        padding: 25px 40px;
        border-bottom: 1px solid rgba(217, 255, 104, 0.2);
        position: relative;
        overflow: hidden;
    }

    .checkout-header::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: radial-gradient(circle at top right, rgba(217, 255, 104, 0.15) 0%, rgba(0, 0, 0, 0) 70%);
        z-index: 1;
    }

    .checkout-header h1 {
        color: #d9ff68;
        margin: 0;
        font-size: 32px;
        font-weight: 700;
        letter-spacing: 0.5px;
        text-transform: uppercase;
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        position: relative;
        z-index: 2;
        text-align: center;
    }

    .checkout-body {
        padding: 30px;
    }

    .section-title {
        color: #d9ff68;
        font-size: 22px;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .section-title i {
        font-size: 20px;
    }

    .error {
        background-color: rgba(255, 107, 107, 0.2);
        border: 1px solid rgba(255, 107, 107, 0.5);
        color: #ff6b6b;
        padding: 15px;
        border-radius: 8px;
        margin-bottom: 20px;
        font-size: 14px;
        line-height: 1.5;
    }

    .form-row {
        margin-bottom: 20px;
        position: relative;
    }

    .form-row label {
        display: block;
        font-weight: 500;
        margin-bottom: 8px;
        color: #fff;
        font-size: 15px;
    }

    .form-row i {
        position: absolute;
        left: 15px;
        top: 41px;
        color: #555;
        font-size: 16px;
    }

    .form-row input,
    .form-row select {
        width: 100%;
        padding: 12px 15px 12px 45px;
        border-radius: 8px;
        border: 1px solid #333;
        background: rgba(255, 255, 255, 0.05);
        color: #fff;
        font-size: 16px;
        transition: all 0.3s ease;
    }

    .form-row input:focus,
    .form-row select:focus {
        border-color: #d9ff68;
        box-shadow: 0 0 0 2px rgba(217, 255, 104, 0.25);
        outline: none;
    }

    .form-row input::placeholder {
        color: #555;
    }

    .order-table {
        width: 100%;
        border-collapse: collapse;
        margin: 20px 0 30px;
        border-radius: 10px;
        overflow: hidden;
    }

    .order-table th,
    .order-table td {
        padding: 15px;
        text-align: left;
    }

    .order-table th {
        background-color: rgba(26, 42, 58, 0.8);
        color: #d9ff68;
        font-weight: 500;
        text-transform: uppercase;
        font-size: 14px;
        letter-spacing: 0.5px;
    }

    .order-table td {
        background-color: rgba(30, 30, 30, 0.6);
        color: #fff;
        border-bottom: 1px solid rgba(255, 255, 255, 0.05);
    }

    .order-table tr:last-child td {
        border-bottom: none;
    }

    .product-name {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .product-img {
        width: 50px;
        height: 50px;
        border-radius: 8px;
        object-fit: contain;
        background-color: rgba(255, 255, 255, 0.05);
        padding: 5px;
    }

    .price-column {
        text-align: right;
        font-weight: bold;
    }

    .total-section {
        background: rgba(26, 42, 58, 0.4);
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 25px;
        border: 1px solid rgba(217, 255, 104, 0.1);
    }

    .total-row {
        display: flex;
        justify-content: space-between;
        padding: 12px 0;
        border-bottom: 1px dashed rgba(255, 255, 255, 0.1);
        font-size: 16px;
    }

    .total-row:last-child {
        border-bottom: none;
        padding-top: 15px;
        font-size: 20px;
    }

    .total-label {
        color: #d9ff68;
        font-weight: bold;
    }

    .total-value {
        font-weight: bold;
        color: #fff;
    }

    .payment-methods {
        margin-bottom: 30px;
    }

    .payment-option {
        display: flex;
        align-items: center;
        padding: 15px;
        background: rgba(30, 30, 30, 0.6);
        border-radius: 10px;
        border: 1px solid rgba(217, 255, 104, 0.2);
        margin-bottom: 10px;
        transition: all 0.2s ease;
        cursor: pointer;
    }

    .payment-option:hover {
        background: rgba(40, 40, 40, 0.6);
        border-color: rgba(217, 255, 104, 0.4);
    }

    .payment-option input[type="radio"] {
        margin-right: 15px;
        accent-color: #d9ff68;
        width: 18px;
        height: 18px;
    }

    .payment-option-label {
        display: flex;
        align-items: center;
        gap: 15px;
        flex: 1;
    }

    .payment-icon {
        color: #d9ff68;
        font-size: 24px;
    }

    .payment-option-text {
        font-weight: 500;
    }

    .confirm-button {
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

    .confirm-button:hover {
        transform: translateY(-3px);
        box-shadow: 0 7px 15px rgba(217, 255, 104, 0.3);
    }

    .confirm-button i {
        margin-right: 10px;
        font-size: 20px;
    }

    .confirm-button:disabled {
        background: #555;
        cursor: not-allowed;
        transform: none;
        box-shadow: none;
    }

    .empty-cart {
        text-align: center;
        padding: 30px;
        color: #aaa;
        font-size: 18px;
    }

    .empty-cart i {
        display: block;
        font-size: 50px;
        margin-bottom: 20px;
        color: #555;
    }

    @media (max-width: 768px) {
        .checkout-header {
            padding: 20px;
        }

        .checkout-body {
            padding: 20px;
        }

        .order-table th, .order-table td {
            padding: 10px;
        }

        .product-img {
            display: none;
        }

        .form-row i {
            top: 38px;
        }
    }
</style>

<div class="checkout-container">
    <div class="checkout-content">
        <div class="checkout-header">
            <h1>Checkout</h1>
        </div>

        <div class="checkout-body">
            <!-- Hi?n th? th?ng b?o l?i s? l??ng t?n kho -->
            <% if (hasStockError) {%>
            <div class="error"><%= stockError.toString()%></div>
            <% } %>
            
            <% 
System.out.println("Bbbbbb" + cartItems);
if (cartItems != null && !cartItems.isEmpty()) { %>
            <form action="checkoutsuccess" method="post">
                <% for (CartItem item : cartItems) {%>
                <input type="hidden" name="productIds[]" value="<%= item.getCartItemId()%>" />
                <% } %>
                <h2 class="section-title"><i class="fas fa-user-circle"></i> Customer Information</h2>

                <div class="form-row">
                    <label for="customerName">Full Name</label>
                    <i class="fas fa-user"></i>
                    <input type="text" id="customerName" name="customerName" placeholder="Enter your full name" required>
                </div>

                <div class="form-row">
                    <label for="customerPhone">Phone Number</label>
                    <i class="fas fa-phone-alt"></i>
                    <input type="text" id="customerPhone" name="customerPhone" placeholder="Enter your phone number" pattern="09\d{8}" title="Phone number must start with 09 and be followed by 8 digits" required>
                </div>

                <div class="form-row">
                    <label for="shippingAddress">Shipping Address</label>
                    <i class="fas fa-map-marker-alt"></i>
                    <input type="text" id="shippingAddress" name="shippingAddress" placeholder="Enter your delivery address" required>
                </div>

                <div class="form-row">
                    <label for="voucherIdDropdown">Apply Voucher</label>
                    <i class="fas fa-ticket-alt"></i>
                    <select name="voucherId" id="voucherIdDropdown">
                        <option value="">No voucher</option>
                        <% if (claimedVouchers != null)
                                for (Model.Voucher v : claimedVouchers) {%>
                        <option value="<%= v.getVoucherId()%>"
                                data-discount="<%= v.getDiscountPercent()%>"
                                data-max="<%= v.getMaxDiscount()%>"
                                data-minorder="<%= v.getMinOrderAmount()%>">
                            <%= v.getCode()%> - <%= v.getDiscountPercent()%>% (max: <%= v.getMaxDiscount()%>?)
                        </option>
                        <% }%>
                    </select>
                </div>

                <h2 class="section-title"><i class="fas fa-shopping-bag"></i> Order Summary</h2>

                <table class="order-table">
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Quantity</th>
                            <th class="price-column">Price</th>
                            <th class="price-column">Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            System.out.println("Aaaaa " + cartItems);
                            if (cartItems != null && !cartItems.isEmpty()) {
                                for (CartItem item : cartItems) {
                                    Products product = item.getProduct();
                                    int quantity = item.getQuantity();
                                    double price = 0;
                                    String name = "Unknown";
                                    if (product != null) {
                                        price = product.getPrice();
                                        name = product.getName();
                                    }
                                    double subtotal = price * quantity;
                        %>
                        <tr>
                            <td>
                                <div class="product-name">
                                    <img src="<%=request.getContextPath()%>/ImagesServlet?type=product&imageId=<%= product.getPrimaryImageId()%>" class="product-img" alt="<%= name%>">
                                    <%= name%>
                                </div>
                            </td>
                            <td><%= quantity%></td>
                            <td class="price-column"><%= String.format("%,.0f", price)%> VND</td>
                            <td class="price-column">
                                <span class="lineSubtotal" data-price="<%= price%>" data-qty="<%= quantity%>">
                                    <%= String.format("%,.0f", subtotal)%>
                                </span> VND
                            </td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="4" class="empty-cart">
                                <i class="fas fa-shopping-cart"></i>
                                Your cart is empty.
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>

                <div class="total-section">
                    <div class="total-row">
                        <span class="total-label">Subtotal:</span>
                        <span class="total-value" id="subtotalPrice"><%= String.format("%,.0f", total)%> VND</span>
                    </div>
                    <div class="total-row" id="discountRow" style="display: none;">
                        <span class="total-label">Discount:</span>
                        <span class="total-value" id="discountAmount">0 VND</span>
                    </div>
                    <div class="total-row">
                        <span class="total-label">Total:</span>
                        <span class="total-value" id="totalPrice"><%= String.format("%,.0f", total)%> VND</span>
                    </div>
                </div>

                <h2 class="section-title"><i class="fas fa-credit-card"></i> Payment Method</h2>

                <div class="payment-methods">
                    <div class="payment-option">
                        <input type="radio" id="cashOnDelivery" name="paymentMethod" value="cashOnDelivery" checked>
                        <label for="cashOnDelivery" class="payment-option-label">
                            <i class="fas fa-money-bill-wave payment-icon"></i>
                            <span class="payment-option-text">Cash on Delivery</span>
                        </label>
                    </div>
                </div>

                <!-- Ch? cho ph?p submit n?u kh?ng c? l?i s? l??ng t?n kho -->
                <% if (!hasStockError) { %>
                <button type="submit" class="confirm-button">
                    <i class="fas fa-check-circle"></i> Confirm Order
                </button>
                <% } else { %>
                <button type="button" class="confirm-button" disabled>
                    <i class="fas fa-exclamation-circle"></i> Cannot Proceed
                </button>
                <% } %>
            </form>
            <% } else {%>
            <div class="empty-cart">
                <i class="fas fa-shopping-cart"></i>
                <p>Your cart is empty.</p>
                <a href="<%=request.getContextPath()%>/shopAll" class="confirm-button">
                    <i class="fas fa-store"></i> Continue Shopping
                </a>
            </div>
            <% }%>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        var originTotal = <%= total%>;
        var totalSpan = document.getElementById('totalPrice');
        var subtotalSpan = document.getElementById('subtotalPrice');
        var voucherSelect = document.getElementById('voucherIdDropdown');
        var subtotalSpans = document.querySelectorAll('.lineSubtotal');
        var discountRow = document.getElementById('discountRow');
        var discountAmount = document.getElementById('discountAmount');

        function formatMoney(num) {
            return num.toLocaleString('vi-VN', {maximumFractionDigits: 0});
        }

        function updateVoucherDropdown() {
            let total = originTotal;
            for (let i = 0; i < voucherSelect.options.length; i++) {
                let opt = voucherSelect.options[i];
                if (!opt.value)
                    continue;
                let minOrder = parseFloat(opt.getAttribute('data-minorder')) || 0;
                if (total < minOrder) {
                    opt.disabled = true;
                    opt.style.color = '#ccc';
                    opt.title = '??n h?ng c?n t?i thi?u ' + minOrder.toLocaleString('vi-VN') + '? ?? d?ng voucher n?y';
                } else {
                    opt.disabled = false;
                    opt.style.color = '';
                    opt.title = '';
                }
            }
            if (voucherSelect.options[voucherSelect.selectedIndex] && voucherSelect.options[voucherSelect.selectedIndex].disabled) {
                voucherSelect.selectedIndex = 0;
            }
        }

        function updateTotalAndSubtotals() {
            updateVoucherDropdown();
            let voucherOpt = voucherSelect.options[voucherSelect.selectedIndex];
            let discountPercent = voucherOpt.getAttribute('data-discount');
            let maxDiscount = voucherOpt.getAttribute('data-max');
            let total = originTotal;
            let discountedPrice = total;
            let discount = 0;

            if (discountPercent) {
                discount = total * parseInt(discountPercent) / 100;
                if (maxDiscount) {
                    discount = Math.min(discount, parseFloat(maxDiscount));
                }
                discountedPrice = total - discount;

                // Show discount row
                discountAmount.textContent = "- " + formatMoney(discount) + " VND";
                discountRow.style.display = "flex";
            } else {
                discountRow.style.display = "none";
            }

            totalSpan.textContent = formatMoney(discountedPrice) + " VND";

            // T?nh l?i t?ng subtotal theo t? l? gi?m gi? tr?n t?ng
            subtotalSpans.forEach(function (span) {
                let price = parseFloat(span.getAttribute('data-price'));
                let qty = parseInt(span.getAttribute('data-qty'));
                let rawSubtotal = price * qty;
                // T? l? gi?m tr?n t?ng
                let discountRate = discount / total || 0;
                let discountedSubtotal = rawSubtotal - (rawSubtotal * discountRate);
                // N?u kh?ng ch?n voucher th? discountRate = 0
                span.textContent = formatMoney(discountedSubtotal);
            });
        }

        voucherSelect.addEventListener('change', updateTotalAndSubtotals);

        updateTotalAndSubtotals();
    });
</script>

<%@ include file="/WEB-INF/include/footer.jsp" %>
