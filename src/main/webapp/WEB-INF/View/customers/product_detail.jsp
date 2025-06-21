<%-- 
    Document   : product_detail
    Created on : Jun 20, 2025, 11:02:24 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Products"%>
<%@page import="Model.Product_Images"%>
<%@page import="java.util.List" %>
<%@include file="/WEB-INF/include/head.jsp" %>
<%@include file="/WEB-INF/include/Login.jsp" %>
<%@include file="/WEB-INF/include/Register.jsp" %>
<%@include file="/WEB-INF/include/forgotPassword.jsp" %>
<%@include file="/WEB-INF/include/header.jsp" %>
<%
    Products p = (Products) request.getAttribute("product");
    if (p == null) {
%>
<h2>Product not found!</h2>
<%
        return;
    }
%>
<h1 class="header-content" style="margin-top: 80px">Product Detail </h1>

<body style="background: #f6f6f7;">
    <div class="product-detail-container">
        <!-- Main Product Image -->
        <div class="image-frame">
            <img id="mainProductImage" 
                 src="<%= request.getContextPath() + "/ImagesServlet?type=product&imageId=" + p.getPrimaryImageId()%>" 
                 alt="Product Image" class="product-image"/>

            <!-- Thumbnail images -->
            <div class="product-thumbnails">
                <% for (Product_Images img : p.getImages()) {%>
                <img
                    src="<%= request.getContextPath() + "/ImagesServlet?type=product&imageId=" + img.getImageId()%>"
                    class="<%= img.isIsPrimary() ? "primary" : ""%>"
                    alt="Thumbnail"
                    onclick="changeMainImage(this.src)"/>
                <% }%>
            </div>
        </div>

        <!-- Product Info -->
        <div class="product-info-detail">
            <h2><%= p.getName()%></h2>
            <div class="cat">
                <i class="fa fa-tags"></i> <%= p.getCategoryName()%>
            </div>
            <div class="price">
                <i class="fa fa-money-bill-wave"></i>
                <%= String.format("%,.0f", p.getPrice())%>₫
            </div>
            <div class="desc">
                <b>Description:</b> <br>
                <%= p.getDescription()%>
            </div>
            <table class="product-info-table">
                <tr>
                    <td><b>Status:</b></td>
                    <td>
                        <% if (p.isActive()) { %>
                        <span style="color: #46a049; font-weight: bold;">Available</span>
                        <% } else { %>
                        <span style="color: #aaa;">Out of stock</span>
                        <% }%>
                    </td>
                </tr>
                <tr>
                    <td><b>Stock:</b></td>
                    <td><%= p.getStockQuantity()%> units</td>
                </tr>
            </table>

            <!-- Product Actions -->
            <div class="product-actions">
                <button class="fav" onclick="addToFavorite('<%= p.getProductId()%>')">
                    <i class="fa fa-heart"></i> Favorite
                </button>
                <button class="cart" onclick="addToCart('<%= p.getProductId()%>')">
                    <i class="fa fa-shopping-cart"></i> Add to Cart
                </button>
                <button class="buy" onclick="buyNow('<%= p.getProductId()%>')">
                    <i class="fa fa-bolt"></i> Buy Now
                </button>
            </div>
        </div>
    </div>
    <%
        List<Products> relatedProducts = (List<Products>) request.getAttribute("relatedProducts");
    %>

    <% if (relatedProducts != null && !relatedProducts.isEmpty()) { %>
    <div >
        <h1 class="header-content" style="margin-top: 80px">Maybe You Need</h1>
        <div class="product-grid">
            <% for (Products rp : relatedProducts) {%>
            <div class="product-card">
                <img class="product-image" 
                     style="margin-top:10px; display: flex; margin-left: 13px"
                     src="<%= request.getContextPath() + "/ImagesServlet?type=product&imageId=" + rp.getPrimaryImageId()%>" 
                     alt="Product">
                <p><strong><%= rp.getName()%></strong></p>
                <p><%= String.format("%,.0f", rp.getPrice())%>₫</p>
                <!-- Nút Xem chi tiết -->
                <a 
                    class="btn btn-detail"
                    href="<%= request.getContextPath()%>/ProductDetail?productId=<%= rp.getProductId()%>">
                    <i class="fa fa-info-circle"></i> Xem chi tiết
                </a>
            </div>
            <% } %>
        </div>
    </div>
    <% }%>
</body>
<script>
    function changeMainImage(src) {
        const mainImg = document.getElementById("mainProductImage");
        mainImg.setAttribute("src", src);
    }
</script>

<%@include file="/WEB-INF/include/footer.jsp" %>
