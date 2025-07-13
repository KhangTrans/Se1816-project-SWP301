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
            List<CartItem> cart = (List<CartItem>) request.getAttribute("cart");
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
    <div class="cart-summary">
        <h4>Subtotal</h4>
        <div class="subtotal"><%= String.format("%,.0f", total)%>₫</div>
        <form action="Payment" method="post">
            <input type="submit" value="Continue to checkout" class="checkout-btn" />
        </form>

        <!-- Move the "clear cart" button here -->
        <form action="CartServlet" method="post" style="margin-top: 20px; text-align: center;">
            <input type="hidden" name="action" value="clearCart">
            <button type="submit" style="color: white; border: none; background-color: red; padding: 10px 20px; border-radius: 5px; display: flex; align-items: center; justify-content: center; gap: 8px;">
                Clear all carts
                <i class="trash fas fa-trash-alt"></i>
            </button>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/include/footer.jsp" %>
