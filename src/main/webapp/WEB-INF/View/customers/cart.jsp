<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/head.jsp" %>
<%@include file="/WEB-INF/include/Login.jsp" %>
<%@include file="/WEB-INF/include/Register.jsp" %>
<%@include file="/WEB-INF/include/forgotPassword.jsp" %>
<%@include file="/WEB-INF/include/header.jsp" %>
<%@ page import="Model.CartItem" %>
<%@ page import="Model.Products" %>
<%@ page import="DAO.ProductDao" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<style>
    /* Dark theme styling */
    body {
        background-color: #1a1a1a;
        color: #ffffff;
        font-family: Arial, sans-serif;
    }

    .cart-page {
        background-color: #1a1a1a;
        min-height: 100vh;
        padding: 20px;
    }

    .header-content {
        color: #d9ff68;
        text-align: center;
        font-size: 2.5em;
        font-weight: bold;
        margin-bottom: 30px;
        text-shadow: 0 0 10px rgba(217, 255, 104, 0.3);
    }

    .cart-container {
        max-width: 1200px;
        margin: 0 auto;
        display: flex;
        gap: 30px;
        flex-wrap: wrap;
    }

    .cart-items {
        flex: 2;
        min-width: 300px;
    }

    .cart-item {
        background-color: #2a2a2a;
        border: 1px solid #444;
        border-radius: 10px;
        padding: 20px;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 20px;
        transition: all 0.3s ease;
    }

    .product-checkbox {
        width: 20px;
        height: 20px;
        accent-color: #d9ff68;
        cursor: pointer;
    }

    .cart-item:hover {
        border-color: #d9ff68;
        box-shadow: 0 0 15px rgba(217, 255, 104, 0.2);
    }

    .product-image {
        width: 100px;
        height: 100px;
        object-fit: cover;
        border-radius: 8px;
        border: 2px solid #444;
    }

    .item-details {
        flex: 1;
    }

    .item-details h3 {
        color: #ffffff;
        margin: 0 0 10px 0;
        font-size: 1.2em;
    }

    .price {
        color: #d9ff68;
        font-size: 16px;
        font-weight: bold;
        margin-bottom: 10px;
    }

    .quantity {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .quantity button {
        background-color: #444;
        color: #d9ff68;
        border: 1px solid #d9ff68;
        width: 30px;
        height: 30px;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
        font-weight: bold;
        transition: all 0.3s ease;
    }

    .quantity button:hover {
        background-color: #d9ff68;
        color: #1a1a1a;
    }

    .quantity strong {
        color: #ffffff;
        min-width: 30px;
        text-align: center;
    }

    .item-actions {
        text-align: right;
    }

    .total {
        color: #d9ff68;
        font-size: 18px;
        font-weight: bold;
        margin-bottom: 10px;
    }

    .item-actions button {
        background-color: #c30000;
        color: white;
        border: none;
        padding: 8px 12px;
        border-radius: 5px;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .item-actions button:hover {
        background-color: #ff0000;
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(195, 0, 0, 0.3);
    }

    .cart-summary {
        flex: 1;
        min-width: 300px;
        background-color: #2a2a2a;
        border: 1px solid #444;
        border-radius: 10px;
        padding: 25px;
        height: fit-content;
        position: sticky;
        top: 20px;
    }

    .cart-summary h4 {
        color: #d9ff68;
        margin: 0 0 15px 0;
        font-size: 20px;
        border-bottom: 1px solid rgba(217, 255, 104, 0.3);
        padding-bottom: 10px;
    }

    .subtotal {
        color: #d9ff68;
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 25px;
        text-align: right;
    }

    .checkout-btn {
        width: 100%;
        background-color: #d9ff68;
        color: #1a1a1a;
        border: none;
        padding: 15px;
        border-radius: 8px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        margin-bottom: 15px;
        transition: all 0.3s ease;
        text-transform: uppercase;
    }

    .checkout-btn:hover {
        background-color: #c4e85a;
        transform: translateY(-2px);
        box-shadow: 0 4px 15px rgba(217, 255, 104, 0.3);
    }

    .cart-summary form:last-child button {
        width: 100%;
        background-color: #c30000;
        color: white;
        border: none;
        padding: 12px;
        border-radius: 8px;
        font-size: 14px;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        transition: all 0.3s ease;
    }

    .cart-summary form:last-child button:hover {
        background-color: #ff0000;
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(195, 0, 0, 0.3);
    }

    .trash {
        color: #ffffff;
        font-size: 16px;
    }

    /* Empty cart message */
    .cart-items p {
        background-color: #2a2a2a;
        border: 1px solid #444;
        border-radius: 10px;
        padding: 40px;
        text-align: center;
        color: #ffffff;
        font-size: 18px;
    }

    /* Icon wrapper for cart count */
    .icon-wrapper {
        position: relative;
        display: inline-block;
    }

    .cart-count {
        position: absolute;
        top: 0px;
        right: 0px;
        background-color: red;
        color: white;
        font-size: 12px;
        padding: 0px 2px;
        border-radius: 50%;
    }

    /* Responsive design */
    @media (max-width: 768px) {
        .cart-container {
            flex-direction: column;
        }

        .cart-item {
            flex-direction: column;
            text-align: center;
        }

        .item-actions {
            text-align: center;
        }

        .header-content {
            font-size: 2em;
        }
    }
</style>

<script src="${pageContext.request.contextPath}/js/cart.js"></script>

<div class="cart-page">
    <h2 class="header-content">YOUR SHOPPING CART</h2>

    <div class="cart-container">
        <form action="${pageContext.request.contextPath}/checkout" method="get" id="checkoutForm">
            <div class="cart-items">
                <%
                    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
                    double total = 0;
                    if (cart == null || cart.isEmpty()) {
                %>
                <p>Your cart is empty.</p>
                <%
                } else {
                    for (CartItem item : cart) {
                        int productId = item.getProductId();
                        ProductDao dao = new ProductDao();
                        Products product = dao.getProductById(productId);

                        if (product != null) {
                            int quantity = item.getQuantity();
                            double price = product.getPrice();
                            double subtotal = price * quantity;
                            total += subtotal;
                %>

                <div class="cart-item" id="cart-item-<%= product.getProductId()%>">
                    <input type="checkbox" name="cartItemsToCheckout" value="<%= item.getCartItemId()%>" class="product-checkbox" />
                    <img src="<%= request.getContextPath() + "/ImagesServlet?type=product&imageId=" + dao.getPrimaryImage(product.getProductId()).getImageId()%>" alt="Product Image" class="product-image" />
                    <div class="item-details">
                        <h3><%= product.getName()%></h3>
                        <div class="price">Price: <%= String.format("%,.0f", price)%>₫</div>
                        <div class="quantity">
                            <button type="button" onclick="updateQuantity(<%= product.getProductId()%>, 'decrease')">-</button>
                            <strong id="quantity-<%= product.getProductId()%>"><%= quantity%></strong>
                            <button type="button" onclick="updateQuantity(<%= product.getProductId()%>, 'increase')">+</button>
                        </div>
                    </div>
                    <div class="item-actions">
                        <div class="total" id="subtotal-<%= product.getProductId()%>">Total: <%= String.format("%,.0f", price * quantity)%>₫</div>
                        <form action="CartServlet" method="get">
                            <input type="hidden" name="action" value="removeAll"/>
                            <input type="hidden" name="productId" value="<%= product.getProductId()%>"/>
<!--                            <button type="submit">
                                <i class="trash fas fa-trash-alt"></i>
                            </button>-->
                        </form>
                    </div>
                </div>
                <%
                            } else {
                                out.print("<p>Product not found with ID: " + productId + "</p>");
                            }
                        }
                    }
                %>
            </div>
        </form>
        <div class="cart-summary">
            <h4>Subtotal</h4>
            <div class="subtotal"><%= String.format("%,.0f", total)%>₫</div>
            <button type="submit" form="checkoutForm" class="checkout-btn">Continue to checkout</button>
            <form action="CartServlet" method="post">

            </form>
            <button onclick ="clearCart()">
                Clear all carts
                <i class="trash fas fa-trash-alt"></i>
            </button>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/include/footer.jsp" %>