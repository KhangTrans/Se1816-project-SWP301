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

<%
    Products p = (Products) request.getAttribute("product");
    if (p == null) {
%>
<h2>Product not found!</h2>
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
                <button id="favBtn" class="fav" onclick="toggleFavorite('<%= p.getProductId()%>')">
                    <i id="favIcon" class="fa fa-heart <%= isFavorite ? "favorite" : ""%>"></i> Favorite
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

    <!-- Phần hiển thị đánh giá -->
    <div class="product-reviews">
        <h2 class="container" style="color: #46a049; margin-left: 80px">Members Reviews</h2>

        <%
            // Lấy danh sách đánh giá sản phẩm từ request
            List<Review> reviews = (List<Review>) request.getAttribute("productReviews");
            if (reviews != null && !reviews.isEmpty()) {
        %>
        <!-- Carousel Container -->
        <div id="reviewCarousel" class="carousel slide container" data-bs-ride="carousel">
            <div class="carousel-inner" style="width: 70%; margin: 0 auto;">
                <%
                    int reviewCount = reviews.size();
                    // Duyệt qua các đánh giá và tạo các item carousel
                    for (int i = 0; i < reviewCount; i += 2) {
                        String activeClass = (i == 0) ? "active" : ""; // Đánh dấu phần tử đầu tiên là active
                %>
                <div class="carousel-item <%= activeClass%>">
                    <div class="d-flex justify-content-between">
                        <%
                            // Hiển thị 2 đánh giá trong mỗi item
                            for (int j = i; j < i + 2 && j < reviewCount; j++) {
                                Review review = reviews.get(j);
                        %>
                        <div class="review mb-2 p-3 border rounded" style="background-color: #044b12; color: white; width: 48%; margin: 1%;">
                            <div class="reviewer-info d-flex justify-content-between">
                                <span class="reviewer-name"><%= review.getAccount().getUsername()%></span>
                                <span class="review-date text-muted"><%= review.getCreatedAt()%></span>
                            </div>
                            <div class="review-rating my-2">
                                <% for (int k = 1; k <= 5; k++) {%>
                                <i class="fa fa-star <%= review.getRating() >= k ? "text-warning" : "text-muted"%>"></i>
                                <% }%>
                            </div>
                            <div class="review-comment">
                                <p><%= review.getComment()%></p>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } %>
            </div>

            <!-- Nút điều hướng cho carousel -->
            <button class="carousel-control-prev" type="button" data-bs-target="#reviewCarousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#reviewCarousel" data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
            </button>
        </div>

        <% } else { %>
        <p>No reviews yet. Be the first to review this product!</p>
        <% } %>

        <!-- Add Review Form -->
        <%
            Boolean isLoggedIn = (Boolean) request.getAttribute("isLoggedIn");
            Boolean hasPurchased = (Boolean) request.getAttribute("hasPurchased");

            if (isLoggedIn) {
                if (hasPurchased) {
        %>
        <div class="add-review mt-4 container" style="background-color: #0ba960; border-radius: 10px">
            <h3 class="mb-4 mt-3 header-content" style="font-size: 32px;">Add Your Review</h3>
            <form action="<%= request.getContextPath()%>/ProductDetail" method="post">
                <input type="hidden" name="productId" value="<%= p.getProductId()%>">

                <!-- Rating Section -->
                <!-- Rating Section with Star Icons -->
                <div class="mb-3">
                    <label for="rating" class="form-label">Rating:</label>
                    <div id="rating" class="stars">
                        <i class="fa fa-star" data-value="1"></i>
                        <i class="fa fa-star" data-value="2"></i>
                        <i class="fa fa-star" data-value="3"></i>
                        <i class="fa fa-star" data-value="4"></i>
                        <i class="fa fa-star" data-value="5"></i>
                    </div>
                </div>

                <!-- Optional: Hidden Input for Form Submission -->
                <input type="hidden" id="rating-value" name="rating" required>


                <!-- Comment Section -->
                <div class="mb-3">
                    <label for="comment" class="form-label">Your Review:</label>
                    <textarea name="comment" id="comment" rows="4" class="form-control" required></textarea>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="btn btn-primary mb-3">Submit Review</button>
            </form>
        </div>
        <%
        } else {
        %>
        <p class="mt-3" style="color: #46a049; text-align: center">You cannot review this product because you have not purchased it.</p>
        <%
            }
        } else {
        %>
        <p class="mt-3" style="color: #46a049; text-align: center">Please login to leave a review.</p>
        <%
            }
        %>

    </div>

    <% List<Products> relatedProducts = (List<Products>) request.getAttribute("relatedProducts"); %>
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

    function toggleFavorite(productId) {
        var favBtn = document.getElementById('favBtn');
        var favIcon = document.getElementById('favIcon');
        var accountId = '<%= (session.getAttribute("accountId") != null) ? session.getAttribute("accountId") : "null"%>';

        if (accountId === "null") {
            showAlert("Bạn chưa đăng nhập. Vui lòng đăng nhập để thêm vào danh sách yêu thích.");
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
                        favIcon.classList.add('favorite'); // Đổi màu icon khi yêu thích
                    } else {
                        favIcon.classList.remove('favorite'); // Xóa màu icon khi bỏ yêu thích
                    }
                    showAlert(response.message); // Hiển thị thông báo cho người dùng
                } else {
                    showAlert(response.message);
                }
            } else {
                showAlert("Đã xảy ra lỗi khi xử lý yêu cầu.");
            }
        };

        xhr.onerror = function () {
            showAlert("Lỗi kết nối. Vui lòng thử lại.");
        };

        xhr.send(data);
    }

    function showAlert(message) {
        var alertBox = document.getElementById('alertBox');
        var alertMessage = document.getElementById('alertMessage');
        alertMessage.innerHTML = message;
        alertBox.style.display = 'block';
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
// Tạo chức năng tự động cuộn khi có nhiều review
    let scrollContainer = document.querySelector('.reviews-list');
    let scrollAmount = 0;

    function scrollRight() {
        scrollContainer.scrollTo({
            top: 0,
            left: scrollAmount += 300, // Di chuyển 300px mỗi lần
            behavior: 'smooth'
        });
    }

    function scrollLeft() {
        scrollContainer.scrollTo({
            top: 0,
            left: scrollAmount -= 300, // Di chuyển về phía trái 300px mỗi lần
            behavior: 'smooth'
        });
    }

</script>

<style>
    /* Thêm class "favorite" để thay đổi màu sắc */
    .fav i.favorite {
        color: red; /* Đổi màu icon khi đã được yêu thích */
    }

    /* Thêm CSS cho hộp thông báo */
    .alert-box {
        display: none;
        position: fixed;
        top: 10%;
        left: 50%;
        transform: translateX(-50%);
        background-color: green;
        color: white;
        padding: 20px;
        border-radius: 5px;
        font-size: 16px;
        z-index: 1000;
        max-width: 400px;
        width: 100%;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }

    .alert-box .close-btn {
        background: none;
        border: none;
        color: white;
        font-size: 18px;
        cursor: pointer;
        position: absolute;
        top: 5px;
        right: 10px;
    }
    .stars {
        display: flex;
        cursor: pointer;
        font-size: 24px;
        color: #ddd;
    }

    .stars .fa-star {
        margin-right: 5px;
    }

    .stars .fa-star.checked {
        color: #ffcc00; /* Gold color when selected */
    }

</style>

<!-- Alert Box -->
<div id="alertBox" class="alert-box" style="display: none;">
    <span id="alertMessage"></span>
    <button onclick="closeAlert()" class="close-btn">X</button>
</div>

<script src="<%= request.getContextPath()%>/js/cart.js"></script>
<%@include file="/WEB-INF/include/footer.jsp" %>
