<%@page import="Model.Review"%>
<%@page import="DAO.FavoriteListDao"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Products"%>
<%@page import="Model.Product_Images"%>
<%@page import="java.util.List" %>
<%@include file="/WEB-INF/include/head.jsp" %>
<%@include file="/WEB-INF/include/Login.jsp" %>
<%@include file="/WEB-INF/include/Register.jsp" %>
<%@include file="/WEB-INF/include/forgotPassword.jsp" %>
<%@include file="/WEB-INF/include/header.jsp" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<%
    Products p = (Products) request.getAttribute("product");
    if (p == null) {
%>
<div class="container text-center py-5">
    <h2 class="text-danger">Product not found!</h2>
    <a href="<%=request.getContextPath()%>/shopall" class="btn btn-primary mt-3">Return to Shop</a>
</div>
<%
        return;
    }

    // Kiểm tra xem sản phẩm có phải là yêu thích hay không
    boolean isFavorite = false;
    Integer accountId = (Integer) session.getAttribute("accountId");
    if (accountId != null) {
        // Kiểm tra nếu sản phẩm đã có trong danh sách yêu thích
        isFavorite = new FavoriteListDao().isProductInFavorites(accountId, p.getProductId());
    }
%>

<style>
    body {
        background-color: #111;
        color: #fff;
        font-family: 'Arial', sans-serif;
    }
    
    .page-title {
        
        font-size: 60px; 
        padding: 10px; 
        padding-top: 90px;
        text-align: center;
        margin: 40px 0;
        color: #d9ff68;
        font-weight: 700;
        letter-spacing: 0.5px;
        text-transform: uppercase;
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }
    
    .product-detail-container {
        display: flex;
        flex-direction: row;
        max-width: 1200px;
        margin: 0 auto 60px;
        background: rgba(25, 25, 25, 0.9);
        border-radius: 20px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        overflow: hidden;
        border: 1px solid rgba(217, 255, 104, 0.3);
    }
    
    .image-frame {
        width: 40%;
        padding: 30px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, #1a1a1a, #252525);
        position: relative;
    }
    
    .image-frame::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: radial-gradient(circle at center, rgba(217, 255, 104, 0.1) 0%, rgba(0, 0, 0, 0) 70%);
        z-index: 1;
    }
    
    .product-image {
        width: 100%;
        height: auto;
        object-fit: contain;
        border-radius: 10px;
        margin-bottom: 20px;
        max-height: 400px;
        position: relative;
        z-index: 2;
        transition: transform 0.3s ease;
        filter: drop-shadow(0 5px 15px rgba(217, 255, 104, 0.2));
    }
    
    .product-image:hover {
        transform: scale(1.02);
    }
    
    .product-thumbnails {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        justify-content: center;
        margin-top: 20px;
        position: relative;
        z-index: 2;
    }
    
    .product-thumbnails img {
        width: 60px;
        height: 60px;
        border-radius: 8px;
        object-fit: cover;
        cursor: pointer;
        border: 2px solid transparent;
        transition: all 0.3s ease;
        opacity: 0.7;
    }
    
    .product-thumbnails img:hover {
        border-color: #d9ff68;
        opacity: 1;
        transform: translateY(-3px);
    }
    
    .product-thumbnails img.primary {
        border-color: #d9ff68;
        opacity: 1;
    }
    
    .product-info-detail {
        width: 60%;
        padding: 30px;
        display: flex;
        flex-direction: column;
        justify-content: center;
    }
    
    .product-info-detail h2 {
        color: #d9ff68;
        margin-bottom: 20px;
        font-size: 32px;
        font-weight: 700;
        letter-spacing: 0.5px;
    }
    
    .cat {
        display: flex;
        align-items: center;
        margin-bottom: 15px;
        padding: 8px 15px;
        background: rgba(217, 255, 104, 0.1);
        border-radius: 30px;
        width: fit-content;
    }
    
    .cat i {
        color: #d9ff68;
        margin-right: 8px;
    }
    
    .price {
        font-size: 28px;
        font-weight: 700;
        color: #fff;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
    }
    
    .price i {
        color: #d9ff68;
        margin-right: 10px;
    }
    
    .desc {
        margin-bottom: 25px;
        padding: 20px;
        background: rgba(30, 30, 30, 0.6);
        border-radius: 10px;
        line-height: 1.6;
        border: 1px solid rgba(217, 255, 104, 0.1);
    }
    
    .desc b {
        color: #d9ff68;
        display: block;
        margin-bottom: 10px;
        font-size: 18px;
    }
    
    .product-info-table {
        width: 100%;
        margin-bottom: 25px;
        border-collapse: separate;
        border-spacing: 0 10px;
    }
    
    .product-info-table td {
        padding: 12px 15px;
        background: rgba(30, 30, 30, 0.6);
        border-radius: 8px;
    }
    
    .product-info-table td:first-child {
        font-weight: bold;
        color: #d9ff68;
        width: 100px;
        border-radius: 8px 0 0 8px;
    }
    
    .product-info-table td:last-child {
        border-radius: 0 8px 8px 0;
    }
    
    .product-actions {
        display: flex;
        gap: 15px;
        margin-top: 20px;
    }
    
    .product-actions button {
        padding: 12px 25px;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    
    .product-actions button i {
        margin-right: 8px;
        font-size: 18px;
    }
    
    .product-actions .fav {
        background: rgba(255, 255, 255, 0.1);
        color: #fff;
        flex: 1;
    }
    
    .product-actions .fav:hover {
        background: rgba(255, 255, 255, 0.2);
    }
    
    .product-actions .fav i.favorite {
        color: #ff6b6b;
    }
    
    .product-actions .cart {
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        color: #111;
        flex: 2;
    }
    
    .product-actions .cart:hover {
        transform: translateY(-3px);
        box-shadow: 0 7px 15px rgba(217, 255, 104, 0.3);
    }
    
    /* Product Reviews Section */
    .reviews-section {
        max-width: 1200px;
        margin: 60px auto;
    }
    
    .reviews-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
        padding-bottom: 15px;
        border-bottom: 1px solid rgba(217, 255, 104, 0.2);
    }
    
    .reviews-title {
        color: #d9ff68;
        font-size: 24px;
        font-weight: 700;
        display: flex;
        align-items: center;
    }
    
    .reviews-title i {
        margin-right: 10px;
    }
    
    .reviews-container {
        position: relative;
    }
    
    .review-carousel {
        overflow: hidden;
        border-radius: 15px;
        background: rgba(25, 25, 25, 0.9);
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        border: 1px solid rgba(217, 255, 104, 0.2);
        padding: 20px;
    }
    
    .review-row {
        display: flex;
        gap: 20px;
        margin-bottom: 20px;
    }
    
    .review-card {
        flex: 1;
        background: linear-gradient(135deg, #1a2a3a 0%, #0d1b29 100%);
        border-radius: 12px;
        padding: 20px;
        position: relative;
        overflow: hidden;
        transition: all 0.3s ease;
        border: 1px solid rgba(217, 255, 104, 0.1);
    }
    
    .review-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3);
    }
    
    .review-card::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: radial-gradient(circle at top right, rgba(217, 255, 104, 0.05) 0%, rgba(0, 0, 0, 0) 70%);
        z-index: 0;
    }
    
    .review-header {
        display: flex;
        justify-content: space-between;
        margin-bottom: 15px;
        position: relative;
        z-index: 1;
    }
    
    .reviewer-name {
        font-weight: bold;
        color: #d9ff68;
    }
    
    .review-date {
        color: #aaa;
        font-size: 12px;
    }
    
    .review-rating {
        margin-bottom: 15px;
        position: relative;
        z-index: 1;
    }
    
    .review-rating i {
        color: #555;
        margin-right: 2px;
    }
    
    .review-rating i.text-warning {
        color: #ffcc00;
    }
    
    .review-content {
        position: relative;
        z-index: 1;
        line-height: 1.6;
    }
    
    .review-navigation {
        display: flex;
        justify-content: center;
        margin-top: 20px;
        gap: 10px;
    }
    
    .review-nav-btn {
        width: 40px;
        height: 40px;
        border: none;
        background: rgba(217, 255, 104, 0.1);
        color: #d9ff68;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: all 0.2s ease;
    }
    
    .review-nav-btn:hover {
        background: rgba(217, 255, 104, 0.2);
        transform: scale(1.1);
    }
    
    .no-reviews {
        text-align: center;
        padding: 40px;
        color: #aaa;
        font-style: italic;
        background: rgba(25, 25, 25, 0.5);
        border-radius: 12px;
    }
    
    /* Add Review Section */
    .add-review-section {
        max-width: 1200px;
        margin: 60px auto;
        background: rgba(25, 25, 25, 0.9);
        border-radius: 20px;
        padding: 30px;
        border: 1px solid rgba(217, 255, 104, 0.3);
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
    }
    
    .add-review-header {
        text-align: center;
        margin-bottom: 25px;
    }
    
    .add-review-title {
        color: #d9ff68;
        font-size: 24px;
        font-weight: 700;
        margin-bottom: 10px;
    }
    
    .add-review-form .form-group {
        margin-bottom: 20px;
    }
    
    .add-review-form label {
        display: block;
        margin-bottom: 8px;
        color: #d9ff68;
        font-weight: 500;
    }
    
    .rating-stars {
        display: flex;
        gap: 5px;
        font-size: 24px;
        margin-bottom: 20px;
    }
    
    .rating-stars i {
        cursor: pointer;
        color: #555;
        transition: color 0.2s ease;
    }
    
    .rating-stars i.checked,
    .rating-stars i:hover {
        color: #ffcc00;
    }
    
    .add-review-form textarea {
        width: 100%;
        padding: 15px;
        background: rgba(30, 30, 30, 0.6);
        border: 1px solid rgba(217, 255, 104, 0.2);
        border-radius: 10px;
        color: #fff;
        resize: vertical;
        min-height: 120px;
        font-family: inherit;
        transition: border-color 0.3s ease;
    }
    
    .add-review-form textarea:focus {
        border-color: #d9ff68;
        outline: none;
        box-shadow: 0 0 0 2px rgba(217, 255, 104, 0.15);
    }
    
    .submit-review-btn {
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        color: #111;
        border: none;
        border-radius: 8px;
        padding: 12px 25px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        display: block;
        width: 100%;
        max-width: 200px;
        margin: 0 auto;
        transition: all 0.3s ease;
    }
    
    .submit-review-btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 7px 15px rgba(217, 255, 104, 0.3);
    }
    
    .auth-message {
        text-align: center;
        padding: 30px;
        color: #aaa;
        background: rgba(25, 25, 25, 0.5);
        border-radius: 12px;
        font-style: italic;
    }
    
    /* Related Products Section */
    .related-products-section {
        max-width: 1200px;
        margin: 60px auto;
    }
    
    .related-title {
        text-align: center;
        color: #d9ff68;
        font-size: 28px;
        font-weight: 700;
        margin-bottom: 30px;
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }
    
    .product-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
        gap: 25px;
    }
    
    .product-card {
        background: rgba(25, 25, 25, 0.9);
        border-radius: 15px;
        padding: 20px;
        text-align: center;
        transition: all 0.3s ease;
        border: 1px solid rgba(217, 255, 104, 0.1);
    }
    
    .product-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
        border-color: rgba(217, 255, 104, 0.3);
    }
    
    .product-card img {
        width: 100%;
        height: 200px;
        object-fit: contain;
        margin-bottom: 15px;
        border-radius: 8px;
    }
    
    .product-card p {
        margin: 10px 0;
    }
    
    .product-card p strong {
        color: #d9ff68;
    }
    
    .product-card .btn-detail {
        background: rgba(217, 255, 104, 0.1);
        color: #d9ff68;
        border: none;
        border-radius: 8px;
        padding: 8px 15px;
        margin-right: 5px;
        display: inline-block;
        transition: all 0.2s ease;
    }
    
    .product-card .btn-detail:hover {
        background: rgba(217, 255, 104, 0.2);
    }
    
    .product-card .cart {
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        color: #111;
        border: none;
        border-radius: 8px;
        padding: 8px 15px;
        margin-top: 10px;
        width: 100%;
        cursor: pointer;
        transition: all 0.3s ease;
    }
    
    .product-card .cart:hover {
        transform: translateY(-3px);
        box-shadow: 0 5px 15px rgba(217, 255, 104, 0.3);
    }
    
    /* Alert Box */
    .alert-box {
        position: fixed;
        top: 10%;
        left: 50%;
        transform: translateX(-50%);
        background: rgba(26, 42, 58, 0.95);
        color: #fff;
        padding: 20px 25px;
        border-radius: 10px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        border-left: 4px solid #d9ff68;
        z-index: 1000;
        min-width: 300px;
        max-width: 500px;
        display: none;
    }
    
    .close-btn {
        position: absolute;
        top: 10px;
        right: 10px;
        background: none;
        border: none;
        color: #aaa;
        font-size: 18px;
        cursor: pointer;
        transition: color 0.2s ease;
    }
    
    .close-btn:hover {
        color: #fff;
    }
    
    /* Media queries for responsive layout */
    @media (max-width: 992px) {
        .product-detail-container {
            flex-direction: column;
        }
        
        .image-frame,
        .product-info-detail {
            width: 100%;
        }
        
        .review-row {
            flex-direction: column;
        }
    }
    
    @media (max-width: 768px) {
        .product-grid {
            grid-template-columns: repeat(2, 1fr);
        }
        
        .page-title {
            font-size: 28px;
        }
    }
    
    @media (max-width: 480px) {
        .product-grid {
            grid-template-columns: 1fr;
        }
        
        .product-actions {
            flex-direction: column;
        }
    }
</style>

<h1 class="page-title">Product Detail</h1>

    <div class="product-detail-container">
        <!-- Main Product Image -->
        <div class="image-frame">
            <img id="mainProductImage" 
                 src="<%= request.getContextPath() + "/ImagesServlet?type=product&imageId=" + p.getPrimaryImageId()%>" 
             alt="<%= p.getName() %>" class="product-image"/>

            <!-- Thumbnail images -->
            <div class="product-thumbnails">
                <% for (Product_Images img : p.getImages()) {%>
                <img
                    src="<%= request.getContextPath() + "/ImagesServlet?type=product&imageId=" + img.getImageId()%>"
                    class="<%= img.isIsPrimary() ? "primary" : ""%>"
                alt="<%= p.getName() %> thumbnail"
                    onclick="changeMainImage(this.src)"/>
                <% }%>
            </div>
        </div>

        <!-- Product Info -->
        <div class="product-info-detail">
            <h2><%= p.getName()%></h2>
            <div class="cat">
            <i class="fas fa-tags"></i> <%= p.getCategoryName()%>
            </div>
            <div class="price">
            <i class="fas fa-money-bill-wave"></i>
                <%= String.format("%,.0f", p.getPrice())%>₫
            </div>
            <div class="desc">
            <b>Description:</b>
            <p style="color: white"><%= p.getDescription()%></p>
            </div>
            <table class="product-info-table">
                <tr>
                <td>Status:</td>
                    <td>
                        <% if (p.isActive()) { %>
                    <span style="color: white; font-weight: bold;">Available</span>
                        <% } else { %>
                    <span style="color: white">Out of stock</span>
                        <% }%>
                    </td>
                </tr>
                <tr>
                <td>Stock:</td>
                <td style="color: white"><%= p.getStockQuantity()%> units</td>
                </tr>
            </table>

            <!-- Product Actions -->
            <div class="product-actions">
                <button id="favBtn" class="fav" onclick="toggleFavorite('<%= p.getProductId()%>')">
                <i id="favIcon" class="<%= isFavorite ? "fas" : "far" %> fa-heart <%= isFavorite ? "favorite" : ""%>"></i> Favorite
                </button>
                <button class="cart"
                        onclick="addToCart('<%= p.getProductId()%>')"
                        <%= p.getStockQuantity() < 1 ? "disabled style='opacity:0.5;pointer-events:none;' title=\"Out of stock\"" : ""%>>
                <i class="fas fa-shopping-cart"></i> Add to Cart
                </button>
            </div>
        </div>
    </div>

    <!-- Phần hiển thị đánh giá -->
<div class="reviews-section">
    <div class="reviews-header">
        <h2 class="reviews-title"><i class="fas fa-star"></i> Members Reviews</h2>
    </div>

        <%
            // Lấy danh sách đánh giá sản phẩm từ request
            List<Review> reviews = (List<Review>) request.getAttribute("productReviews");
            if (reviews != null && !reviews.isEmpty()) {
        %>
    <div class="reviews-container">
        <div class="review-carousel">
                <%
                    int reviewCount = reviews.size();
                // Determine how many rows we need
                int rowCount = (reviewCount + 1) / 2;
                
                for (int i = 0; i < rowCount; i++) {
            %>
            <div class="review-row">
                <%
                    // Display up to 2 reviews per row
                    for (int j = i * 2; j < Math.min((i * 2) + 2, reviewCount); j++) {
                                Review review = reviews.get(j);
                        %>
                <div class="review-card">
                    <div class="review-header">
                        <span class="reviewer-name"><%= review.getAccount().getUsername() %></span>
                        <span class="review-date"><%= review.getCreatedAt() %></span>
                            </div>
                    <div class="review-rating">
                        <% for (int k = 1; k <= 5; k++) { %>
                        <i class="fas fa-star <%= review.getRating() >= k ? "text-warning" : "" %>"></i>
                        <% } %>
                    </div>
                    <div class="review-content">
                        <p><%= review.getComment() %></p>
                    </div>
                </div>
                <% } %>
                </div>
                <% } %>
            </div>

        <div class="review-navigation">
            <button class="review-nav-btn" onclick="prevReviews()">
                <i class="fas fa-chevron-left"></i>
            </button>
            <button class="review-nav-btn" onclick="nextReviews()">
                <i class="fas fa-chevron-right"></i>
            </button>
        </div>
    </div>
        <% } else { %>
    <div class="no-reviews">
        <p>No reviews yet. Be the first to review this product!</p>
    </div>
        <% } %>
</div>

        <!-- Add Review Form -->
        <%
            Boolean isLoggedIn = (Boolean) request.getAttribute("isLoggedIn");
            Boolean hasPurchased = (Boolean) request.getAttribute("hasPurchased");

            if (isLoggedIn) {
                if (hasPurchased) {
        %>
<div class="add-review-section">
    <div class="add-review-header">
        <h3 class="add-review-title">Add Your Review</h3>
    </div>
    
    <div class="add-review-form">
            <form action="<%= request.getContextPath()%>/ProductDetail" method="post">
                <input type="hidden" name="productId" value="<%= p.getProductId()%>">

            <div class="form-group">
                <label for="rating">Rating:</label>
                <div class="rating-stars" id="rating">
                    <i class="fas fa-star" data-value="1"></i>
                    <i class="fas fa-star" data-value="2"></i>
                    <i class="fas fa-star" data-value="3"></i>
                    <i class="fas fa-star" data-value="4"></i>
                    <i class="fas fa-star" data-value="5"></i>
                </div>
                <input type="hidden" id="rating-value" name="rating" required>
            </div>

            <div class="form-group">
                <label for="comment">Your Review:</label>
                <textarea name="comment" id="comment" placeholder="Share your experience with this product..." required></textarea>
                </div>

            <button type="submit" class="submit-review-btn">Submit Review</button>
            </form>
    </div>
        </div>
        <%
        } else {
        %>
<div class="add-review-section">
    <div class="auth-message">
        <p>You cannot review this product because you have not purchased it.</p>
    </div>
</div>
        <%
            }
        } else {
        %>
<div class="add-review-section">
    <div class="auth-message">
        <p>Please login to leave a review.</p>
    </div>
</div>
        <%
            }
        %>

<!-- Related Products Section -->
    <% List<Products> relatedProducts = (List<Products>) request.getAttribute("relatedProducts"); %>
    <% if (relatedProducts != null && !relatedProducts.isEmpty()) { %>
<div class="related-products-section">
    <h2 class="related-title">Maybe You Need</h2>
        <div class="product-grid">
            <% for (Products rp : relatedProducts) {%>
            <div class="product-card">
            <img src="<%= request.getContextPath() + "/ImagesServlet?type=product&imageId=" + rp.getPrimaryImageId()%>" 
                 alt="<%= rp.getName() %>">
                <p><strong><%= rp.getName()%></strong></p>
                <p><%= String.format("%,.0f", rp.getPrice())%>₫</p>
            <div>
                <a class="btn-detail"
                    href="<%= request.getContextPath()%>/ProductDetail?productId=<%= rp.getProductId()%>">
                    <i class="fas fa-info-circle"></i> Details
                </a>
                <button class="cart" onclick="addToCart('<%= rp.getProductId()%>')">
                    <i class="fas fa-shopping-cart"></i> Add to Cart
                </button>
            </div>
            </div>
            <% } %>
        </div>
    </div>
    <% }%>

<!-- Alert Box -->
<div id="alertBox" class="alert-box">
    <span id="alertMessage"></span>
    <button onclick="closeAlert()" class="close-btn"><i class="fas fa-times"></i></button>
</div>

<script>
    function changeMainImage(src) {
        const mainImg = document.getElementById("mainProductImage");
        mainImg.setAttribute("src", src);
    }

    function toggleFavorite(productId) {
        var favBtn = document.getElementById('favBtn');
        var favIcon = document.getElementById('favIcon');
        var accountId = '<%= (session.getAttribute("accountId") != null) ? session.getAttribute("accountId") : "null"%>';

        if (accountId === "null") {
            showAlert("You need to be logged in to add to favorites!");
            return;
        }

        var action = favIcon.classList.contains('favorite') ? 'delete' : 'add'; // Kiểm tra trạng thái yêu thích

        var xhr = new XMLHttpRequest();
        xhr.open("POST", "<%= request.getContextPath()%>/FavoriteListServlet", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");

        var data = "action=" + action + "&productId=" + productId + "&accountId=" + accountId;

        xhr.onload = function () {
            if (xhr.status === 200) {
                var response = JSON.parse(xhr.responseText);
                if (response.status === "success") {
                    if (action === 'add') {
                        favIcon.classList.add('favorite');
                        favIcon.classList.remove('far');
                        favIcon.classList.add('fas');
                    } else {
                        favIcon.classList.remove('favorite');
                        favIcon.classList.remove('fas');
                        favIcon.classList.add('far');
                    }
                    showAlert(response.message);
                } else {
                    showAlert(response.message);
                }
            } else {
                showAlert("An error occurred while processing your request.");
            }
        };

        xhr.onerror = function () {
            showAlert("Connection error. Please try again.");
        };

        xhr.send(data);
    }

    function showAlert(message) {
        var alertBox = document.getElementById('alertBox');
        var alertMessage = document.getElementById('alertMessage');
        alertMessage.innerHTML = message;
        alertBox.style.display = 'block';
        
        // Auto hide after 3 seconds
        setTimeout(function() {
            closeAlert();
        }, 3000);
    }

    function closeAlert() {
        document.getElementById('alertBox').style.display = 'none';
    }

    // Handle star rating selection
    document.querySelectorAll('#rating .fa-star').forEach(star => {
        star.addEventListener('click', function () {
            const rating = this.getAttribute('data-value');

            // Update the stars
            document.querySelectorAll('#rating .fa-star').forEach(star => {
                star.classList.remove('checked');
            });
            for (let i = 0; i < rating; i++) {
                document.querySelectorAll('#rating .fa-star')[i].classList.add('checked');
            }

            // Set the value in hidden input
            document.getElementById('rating-value').value = rating;
        });
    });
    
    // Reviews navigation
    let currentReviewPage = 0;
    const reviewRows = document.querySelectorAll('.review-row');
    if (reviewRows.length > 0) {
        showReviewPage(currentReviewPage);
    }
    
    function showReviewPage(pageIndex) {
        reviewRows.forEach((row, index) => {
            row.style.display = index === pageIndex ? 'flex' : 'none';
        });
    }
    
    function nextReviews() {
        if (currentReviewPage < reviewRows.length - 1) {
            currentReviewPage++;
            showReviewPage(currentReviewPage);
        }
    }
    
    function prevReviews() {
        if (currentReviewPage > 0) {
            currentReviewPage--;
            showReviewPage(currentReviewPage);
        }
    }
    
    // Initialize the reviews display
    window.addEventListener('DOMContentLoaded', function() {
        if (reviewRows.length > 0) {
            showReviewPage(0);
        }
    });
</script>

<script src="<%= request.getContextPath()%>/js/cart.js"></script>
<script src="<%= request.getContextPath()%>/js/shopDetail.js"></script>

<%@include file="/WEB-INF/include/footer.jsp" %>
