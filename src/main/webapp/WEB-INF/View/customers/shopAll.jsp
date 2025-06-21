<%@page import="DAO.ProductDao"%>
<%@page import="Model.Product_Images"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Model.Products"%>

<%
    ProductDao dao = new ProductDao();
    List<Products> list = (List<Products>) request.getAttribute("list");
    int totalPages = (Integer) request.getAttribute("totalPages");
    int currentPage = (Integer) request.getAttribute("currentPage");
%>

<%@include file="/WEB-INF/include/head.jsp" %>
<%@include file="/WEB-INF/include/Login.jsp" %>
<%@include file="/WEB-INF/include/Register.jsp" %>
<%@include file="/WEB-INF/include/forgotPassword.jsp" %>
<%@include file="/WEB-INF/include/header.jsp" %>
<main>
    <div class="body-product">
        <!-- Banner -->
        <div id="carouselExampleIndicators" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-indicators">
                <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
                <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="1" aria-label="Slide 2"></button>
                <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="2" aria-label="Slide 3"></button>
            </div>
            <div class="carousel-inner">
                <div class="carousel-item active" data-bs-interval="3000">
                    <img src="./img/Banner-Shop/ban1.jpg" class="d-block w-100" alt="...">
                </div>
                <div class="carousel-item" data-bs-interval="3000">
                    <img src="./img/Banner-Shop/ban2.jpg" class="d-block w-100" alt="...">
                </div>
                <div class="carousel-item" data-bs-interval="3000">
                    <img src="./img/Banner-Shop/ban3.jpg" class="d-block w-100" alt="...">
                </div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
            </button>
        </div>

        <h1 class="header-content">SHOP</h1>
        <div class="filter-bar">
            <span class="filter-title">Sắp Xếp Theo</span>
            <button class="filter-btn">⇅ Giá Cao - Thấp</button>
            <button class="filter-btn">⇅ Giá Thấp - Cao</button>
            <button class="filter-btn">▼ Mục Tiêu & Nhu Cầu</button>

            <div class="search-box">
                <input type="text" placeholder="...Search" />
                <span class="search-icon">
                    <img src="./img/search.svg" alt="Search Icon" width="16" height="16">
                </span>
            </div>
        </div>
        <!-- Grid of Products -->
        <div class="product-grid" id="product-list">
            <% for (Products p : list) {%>
            <div class="product-card">
                <img src="<%= request.getContextPath() + "/ImagesServlet?type=product&imageId=" + dao.getPrimaryImage(p.getProductId()).getImageId()%>" 
                     alt="Product Image" class="product-image" />
                <p><strong><%= p.getName()%></strong></p>
                <p><%= String.format("%,.0f", p.getPrice())%>đ</p>
                <div class="product-actions" style="margin-top:10px; display: flex; margin-left: 13px">
                    <!-- Thêm vào Yêu thích -->
                    <button 
                        class="btn btn-fav"
                        type="button"
                        onclick="addToFavorite('<%= p.getProductId()%>')">
                        <i class="fa fa-heart"></i> Yêu thích
                    </button>
                    <!-- Thêm vào Giỏ hàng -->
                    <button 
                        class="btn btn-cart"
                        type="button"
                        onclick="addToCart('<%= p.getProductId()%>')">
                        <i class="fa fa-shopping-cart"></i> Giỏ hàng
                    </button>
                    <!-- Nút Mua Ngay -->
                    <button 
                        class="btn btn-buy"
                        type="button"
                        onclick="buyNow('<%= p.getProductId()%>')">
                        <i class="fa fa-bolt"></i> Mua ngay
                    </button>
                    <!-- Nút Xem chi tiết -->
                    <a 
                        class="btn btn-detail"
                        href="<%= request.getContextPath()%>/ProductDetail?productId=<%= p.getProductId()%>">
                        <i class="fa fa-info-circle"></i> Xem chi tiết
                    </a>
                </div>
            </div>
            <% } %>
        </div>

        <div id="pagination" class="pagination-container">
            <!-- Nút previous -->
            <a href="#" class="pagination-btn previous" onclick="changePage('previous')"> < previous </a>

            <!-- Hiển thị các nút trang -->
            <% if (totalPages > 0) { %>
            <% for (int i = 1; i <= totalPages; i++) {%>
            <a href="#" class="pagination-btn <%= (i == currentPage) ? "active" : ""%>" onclick="changePage(<%= i%>)">
                <%= i%>
            </a>
            <% } %>
            <% } else { %>
            <span>No pages available</span>
            <% }%>

            <!-- Nút next -->
            <a href="#" class="pagination-btn next" onclick="changePage('next')"> next > </a>
        </div>

    </div>
</main>
<script>
    // Thêm vào danh sách yêu thích (favorite)
    function addToFavorite(productId) {
        // Ví dụ: gọi AJAX, hoặc chỉ thông báo
        // Nếu muốn dùng AJAX, thay thế alert bên dưới thành fetch hoặc $.ajax
        alert('Đã thêm sản phẩm ' + productId + ' vào danh sách yêu thích!');
        // TODO: Gọi AJAX tới /favorite/add nếu có
        // fetch('/favorite/add?productId=' + productId, {method: 'POST'}).then...
    }

    // Thêm vào giỏ hàng (cart)
    function addToCart(productId) {
        // Ví dụ: gọi AJAX, hoặc chỉ thông báo
        alert('Đã thêm sản phẩm ' + productId + ' vào giỏ hàng!');
        // TODO: Gọi AJAX tới /cart/add nếu có
        // fetch('/cart/add?productId=' + productId, {method: 'POST'}).then...
    }
</script>

<%@include file="/WEB-INF/include/footer.jsp" %>
