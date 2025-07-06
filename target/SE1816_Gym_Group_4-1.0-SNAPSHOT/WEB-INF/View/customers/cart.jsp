<%@page import="java.math.BigDecimal"%>
<%@page import="Model.Voucher"%>
<%@page import="DAO.VoucherDao"%>
<%@page import="DAO.ProductDao"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="Model.CartItem" %>
<%@ page import="Model.Products" %>
<%@ include file="/WEB-INF/include/head.jsp" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<style>
    /* Container for the cart */
    .cart-container {
        display: flex;
        justify-content: space-between;
        max-width: 1200px;
        margin: 20px auto;
        background: #fff;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        overflow: hidden;
    }

    /* Left section for items */
    .cart-items {
        width: 70%;
        padding: 20px;
    }

    /* Right section for subtotal */
    .cart-summary {
        width: 30%;
        padding: 20px;
        background: #f9f9f9;
        text-align: right;
    }

    /* Individual item card */
    .cart-item {
        display: flex;
        align-items: center;
        padding: 15px 0;
        border-bottom: 1px solid #ddd;
    }

    .cart-item img {
        width: 80px;
        height: 80px;
        background: #e0e0e0;
        margin-right: 30px;
    }

    .cart-item .item-details {
        flex-grow: 1;
    }

    .cart-item h3 {
        margin: 0 0 5px;
        font-size: 18px;
        color: #333;
    }

    .cart-item p {
        margin: 5px 0;
        color: #777;
        font-size: 14px;
    }

    .cart-item .quantity {
        display: flex;
        align-items: center;
        gap: 5px;
    }

    .cart-item .quantity button {
        width: 30px;
        height: 30px;
        background: linear-gradient(175deg, #010101 -50%, #9DDB00 100%);
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }

    .cart-item .quantity button:hover {
        background: #e64a19;
    }

    .cart-item .price {
        font-size: 18px;
        color: #333;
    }

    /* Subtotal and button */
    .cart-summary h4 {
        margin: 0 0 10px;
        font-size: 18px;
        color: #333;
    }

    .cart-summary .subtotal {
        font-size: 24px;
        color: #4CAF50;
        margin-bottom: 20px;
    }

    .cart-summary .checkout-btn {
        display: block;
        width: 100%;
        padding: 10px;
        background-color: forestgreen;
        color: white;
        border: none;
        border-radius: 5px;
        font-size: 16px;
        cursor: pointer;
    }

    .cart-summary .checkout-btn:hover {
        background: #45a049;
    }

    .cart-summary p {
        font-size: 12px;
        color: #777;
    }
    .header-content {
        margin-top: 10px;
        margin-bottom: 20px;
        font-size: 60px;
        font-weight: bold;
        text-align: center;
        background: linear-gradient(360deg, #64d04e, #9ddb00);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        color: transparent;
    }
    .trash{
        background-color: red;
        border: none;
        color: white;
        padding: 10px;
        border-radius: 5px;
        margin-left: 70px;
    }
    .cart-count-badge {
        position: absolute;
        top: 0;
        right: 0;
        background-color: red;
        color: white;
        font-size: 12px;
        padding: 0px 2px;
        border-radius: 50%;
    }
</style>
<h2 class="header-content" style="margin-top: 80px">YOUR SHOPPING CART</h2>

<div class="cart-container" >
    <div class="cart-items">
        <%
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            double total = 0;
            if (cart == null || cart.isEmpty()) {
        %>
        <p>Your cart is empty.</p>
        <%
        } else {
            // Lặp qua từng sản phẩm trong giỏ hàng
            for (CartItem item : cart) {
                int productId = item.getProductId();  // Lấy productId từ CartItem
                ProductDao dao = new ProductDao();
                Products product = dao.getProductById(productId);  // Lấy thông tin sản phẩm

                if (product != null) {  // Kiểm tra nếu sản phẩm tồn tại
                    int quantity = item.getQuantity();
                    double price = product.getPrice();
                    double subtotal = price * quantity;
                    total += subtotal;
        %>

        <div class="cart-item">
            <img src="<%= request.getContextPath() + "/ImagesServlet?type=product&imageId=" + dao.getPrimaryImage(product.getProductId()).getImageId()%>" alt="Product Image" class="product-image" />
            <div class="item-details">
                <h3><%= product.getName()%></h3>
                <div class="price">Price: <%= String.format("%,.0f", price)%>₫</div>
                <div class="quantity">
                    <form action="CartServlet" method="get" style="display:inline;">
                        <input type="hidden" name="action" value="decrease"/>
                        <input type="hidden" name="productId" value="<%= product.getProductId()%>"/>
                        <button type="submit">-</button>
                    </form>
                    <strong><%= quantity%></strong>
                    <form action="CartServlet" method="get" style="display:inline;">
                        <input type="hidden" name="action" value="increase"/>
                        <input type="hidden" name="productId" value="<%= product.getProductId()%>"/>
                        <button type="submit">+</button>
                    </form>
                </div>
            </div>

            <div style="margin-top: 10px;">
                <div class="total">Total: <%= String.format("%,.0f", price * quantity)%>₫</div>
                <form action="CartServlet" method="get" style="display:inline;">
                    <input type="hidden" name="action" value="removeAll"/>
                    <input type="hidden" name="productId" value="<%= product.getProductId()%>"/>
                    <button type="submit" style="background-color: white;
                            border: none;
                            color: white;
                            padding: 10px;
                            border-radius: 5px;">
                        <i class="trash fas fa-trash-alt"></i>
                    </button>
                </form>
            </div>

        </div>
        <%
                    } else {
                        // Xử lý trường hợp sản phẩm không tìm thấy
                        out.print("<p>Không tìm thấy sản phẩm với ID: " + productId + "</p>");
                    }
                }
            }
        %>
    </div>
    <!-- Thanh toán và nhập thông tin giao hàng -->
    <div class="cart-summary">
        <h4>Subtotal</h4>
        <div class="subtotal">
            <%= String.format("%,.0f", session.getAttribute("totalAmount") != null ? session.getAttribute("totalAmount") : total)%>₫
        </div>

        <!-- Hiển thị số tiền đã giảm từ voucher -->
        <h4>Discount from Voucher</h4>
        <div class="voucher-discount">
            <%
                BigDecimal discountAmount = (BigDecimal) session.getAttribute("discountAmount");
                if (discountAmount == null) {
                    discountAmount = BigDecimal.ZERO; // Nếu không có discountAmount, gán là 0
                }
            %>
            <%= String.format("%,.0f", discountAmount)%>₫
        </div>

        <!-- Hiển thị các voucher mà khách hàng đã thu thập dưới dạng carousel -->
        <h4>Available Vouchers</h4>
        <div id="voucherCarousel" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-inner">
                <%
                    List<Voucher> vouchers = (List<Voucher>) session.getAttribute("vouchers");
                    if (vouchers != null && !vouchers.isEmpty()) {
                        int index = 0;
                        for (Voucher voucher : vouchers) {
                            String activeClass = (index == 0) ? "active" : "";  // Đảm bảo chỉ có 1 slide đầu tiên là active
                %>
                <div class="carousel-item <%= activeClass%>">
                    <div class="voucher">
                        <div class="voucher-code"><%= voucher.getCode()%></div>
                        <div class="voucher-description"><%= voucher.getDescription()%></div>
                        <div class="voucher-discount">
                            Discount: <%= voucher.getDiscountPercent()%>% off, Max Discount: <%= voucher.getMaxDiscount()%>₫
                        </div>
                        <input type="radio" name="voucher" value="<%= voucher.getVoucherId()%>" /> Apply this Voucher
                    </div>
                </div>
                <%
                        index++;
                    }
                } else {
                %>
                <div class="carousel-item active">
                    <p>No vouchers available.</p>
                </div>
                <%
                    }
                %>
            </div>
            <!-- Controls -->
            <button class="carousel-control-prev" type="button" data-bs-target="#voucherCarousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#voucherCarousel" data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
            </button>
        </div>

        <!-- Nút Apply Voucher -->
        <button type="button" id="applyVoucherBtn" class="btn btn-primary">Apply Voucher</button>

        <form id="voucherForm" action="CartServlet" method="POST" style="display:none;">
            <input type="hidden" name="action" value="applyVoucher">
            <input type="hidden" name="voucherId" id="voucherId">
        </form>
        <!-- Form nhập thông tin thanh toán -->
        <form action="checkout" method="POST">
            <h4>Enter Shipping Information</h4>
            <input type="text" name="shipping_address" placeholder="Shipping Address" required class="checkout-input" />
            <input type="text" name="customer_name" placeholder="Your Name" required class="checkout-input" />
            <input type="tel" name="customer_phone" placeholder="Your Phone Number" required class="checkout-input" />
            <div class="checkout-btn-container">
                <input type="submit" value="Proceed to Payment" class="checkout-btn" />
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/include/footer.jsp" %>
<script>
    document.getElementById("applyVoucherBtn").addEventListener("click", function () {
        var selectedVoucher = document.querySelector('input[name="voucher"]:checked');
        if (selectedVoucher) {
            document.getElementById("voucherId").value = selectedVoucher.value;
            document.getElementById("voucherForm").submit();
        } else {
            alert("Please select a voucher to apply!");
        }
    });
</script>
