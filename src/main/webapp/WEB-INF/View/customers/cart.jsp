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
</style>

<script src="${pageContext.request.contextPath}/js/cart.js"></script>

<div class="cart-page">
    <h2 class="header-content">YOUR SHOPPING CART</h2>

    <div class="cart-container">
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

            <div class="cart-item" id="cart-item-<%= product.getProductId() %>">
                <img src="<%= request.getContextPath() + "/ImagesServlet?type=product&imageId=" + dao.getPrimaryImage(product.getProductId()).getImageId()%>" alt="Product Image" class="product-image" />
                <div class="item-details">
                    <h3><%= product.getName()%></h3>
                    <div class="price">Price: <%= String.format("%,.0f", price)%>₫</div>
                    <div class="quantity">
                        <button onclick="updateQuantity(<%= product.getProductId() %>, 'decrease')">-</button>
                        <strong id="quantity-<%= product.getProductId() %>"><%= quantity%></strong>
                        <button onclick="updateQuantity(<%= product.getProductId() %>, 'increase')">+</button>
                    </div>
                </div>
                <div class="item-actions">
                    <div class="total" id="subtotal-<%= product.getProductId() %>">Total: <%= String.format("%,.0f", price * quantity)%>₫</div>
                    <form action="CartServlet" method="get">
                        <input type="hidden" name="action" value="removeAll"/>
                        <input type="hidden" name="productId" value="<%= product.getProductId()%>"/>
                        <button type="submit">
                            <i class="trash fas fa-trash-alt"></i>
                        </button>
                    </form>
                </div>
            </div>
            <%
                    } else {
                        out.print("<p>Không tìm thấy sản phẩm với ID: " + productId + "</p>");
                    }
                }
            }
            %>
        </div>
        <div class="cart-summary">
            <h4>Subtotal</h4>
            <div class="subtotal"><%= String.format("%,.0f", total)%>₫</div>
            <form action="${pageContext.request.contextPath}/checkout" method="get">
                <input type="submit" value="Continue to checkout" class="checkout-btn" />
            </form>
            <form action="CartServlet" method="post">
                <input type="hidden" name="action" value="clearCart">
                <button type="submit">
                    Clear all carts
                    <i class="trash fas fa-trash-alt"></i>
                </button>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/include/footer.jsp" %>