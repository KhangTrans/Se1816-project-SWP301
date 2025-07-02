<%@page import="Model.Categories"%>
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
<style>
    .voucher-section {
        padding: 20px;
        background: #fffbe6;
        border-bottom: 1px solid #ddd;
        margin: 20px 0;
    }

    .voucher-title {
        font-size: 22px;
        margin-bottom: 10px;
        color: #ff6600;
    }

    .voucher-container {
        display: flex;
        flex-wrap: wrap;
        gap: 15px;
    }

    .voucher-card {
        border: 1px dashed #ff9900;
        padding: 15px;
        border-radius: 8px;
        background: #fff;
        width: 280px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .voucher-info p {
        margin: 4px 0;
        font-size: 14px;
    }

    .claim-btn {
        background-color: #ff6600;
        color: #fff;
        border: none;
        padding: 6px 12px;
        border-radius: 5px;
        cursor: pointer;
    }

    .btn-success {
        background-color: green !important;
        color: #fff !important;
    }
    .favorite-icon {
        position: absolute;
        top: 15px;
        right: 20px;
        color: #ccc;
        font-size: 20px;
        cursor: pointer;
        transition: color 0.3s;
    }

    .favorite-icon:hover {
        color: red;
    }

</style>
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
        <form action="CartServlet" method="post" style="text-align: center;">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="productId" value="${product.productId}">
            <input type="hidden" name="quantity" value="1">

            <button type="submit" style="background: none; border: none;">
                <i class="fas fa-cart-plus" style="font-size: 24px; color: white;"></i>
            </button>
        </form>
        <%-- Voucher--%>
        <%
            List<Model.Voucher> voucherList = (List<Model.Voucher>) request.getAttribute("voucherList");
        %>

        <div class="voucher-section">
            <h2 class="voucher-title">🎁 VOUCHER ƯU ĐÃI</h2>
            <div class="voucher-container">
                <% if (voucherList != null && !voucherList.isEmpty()) {
                        for (Model.Voucher v : voucherList) {
                %>
                <div class="voucher-card">
                    <div class="voucher-info">
                        <p><strong><%= v.getDiscountPercent()%>% GIẢM</strong></p>
                        <p>Tối đa: <%= v.getMaxDiscount()%>đ - Đơn tối thiểu: <%= v.getMinOrderAmount()%>đ</p>
                    </div>
                    <div class="voucher-action">
                        <button class="claim-btn" onclick="claimVoucher(<%= v.getVoucherId()%>, this)">Claim</button>
                    </div>
                </div>
                <% }
                } else { %>
                <p>Không có voucher khả dụng.</p>
                <% }%>
            </div>
        </div>
        <%--End Voucher--%>

        <h1 class="header-content">SHOP</h1>
        <div class="filter-bar">
            <span class="filter-title">Sắp Xếp Theo</span>
            <form method="get" style="display:inline;">
                <input type="hidden" name="sort" value="desc">
                <input type="hidden" name="page" value="<%=request.getAttribute("currentPage")%>">
                <%-- Nếu có filter category thì thêm input hidden ở đây --%>
                <button type="submit" class="filter-btn <%= "desc".equals(request.getParameter("sort")) ? "active" : ""%>">
                    ⇅ Giá Cao - Thấp
                </button>
            </form>
            <form method="get" style="display:inline;">
                <input type="hidden" name="sort" value="asc">
                <input type="hidden" name="page" value="<%=request.getAttribute("currentPage")%>">
                <button type="submit" class="filter-btn <%= "asc".equals(request.getParameter("sort")) ? "active" : ""%>">
                    ⇅ Giá Thấp - Cao
                </button>
            </form>
            <form method="get" id="categoryForm" style="display:inline;">
                <select name="category" onchange="document.getElementById('categoryForm').submit()" class="filter-btn">
                    <option value="">Tất cả danh mục</option>
                    <%
                        List<Categories> categories = (List<Categories>) request.getAttribute("categories");
                        String selectedCat = request.getParameter("category");
                        if (categories != null) {
                            for (Categories c : categories) {
                    %>
                    <option value="<%=c.getCategory_id()%>" <%= (selectedCat != null && selectedCat.equals(String.valueOf(c.getCategory_id()))) ? "selected" : ""%>>
                        <%=c.getName()%>
                    </option>
                    <%
                            }
                        }
                    %>
                </select>
                <input type="hidden" name="sort" value="<%=request.getParameter("sort") != null ? request.getParameter("sort") : ""%>">
                <input type="hidden" name="page" value="1">
            </form>


            <div class="search-box">
                <form method="get" action="shopAll" style="display: flex; align-items: center;">
                    <input type="text" name="q" placeholder="...Search"
                           value="<%= request.getParameter("q") != null ? request.getParameter("q") : ""%>" />
                    <button type="submit" class="search-icon" style="background: none; border: none; padding: 0;">
                        <img src="./img/Search.svg" alt="Search Icon" width="16" height="16">
                    </button>
                    <input type="hidden" name="sort" value="<%=request.getParameter("sort") != null ? request.getParameter("sort") : ""%>">
                    <input type="hidden" name="category" value="<%=request.getParameter("category") != null ? request.getParameter("category") : ""%>">
                    <input type="hidden" name="page" value="1">
                </form>
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
                    <!-- Thêm vào Giỏ hàng -->
                    <button onclick="addToCart(<%= p.getProductId()%>)" class="btn btn-cart-icon">
                        <i class="fa fa-shopping-cart" style="font-size: 24px; color: white;"></i>
                    </button>
                    <!-- Nút Mua Ngay -->
                    <button 
                        class="cart-icon-btn"
                        onclick="window.location.href = '<%= request.getContextPath()%>/ProductDetail?productId=<%= p.getProductId()%>'"
                        title="Mua ngay">
                        <i class="fa fa-bolt"> Buy Now</i>
                    </button>

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
<!--<script>
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
</script>-->

<script>
    function claimVoucher(voucherId, button) {
        fetch('<%= request.getContextPath()%>/customerVochers', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'voucherId=' + encodeURIComponent(voucherId),
            credentials: 'include' // ✅ cực kỳ quan trọng
        })
                .then(res => res.json())
                .then(data => {
                    alert(data.message);
                    if (data.status === 'success') {
                        button.disabled = true;
                        button.innerText = 'Đã thu thập';
                        button.classList.remove('claim-btn');
                        button.classList.add('btn-success');
                    }
                })
                .catch(err => {
                    alert("Đã xảy ra lỗi.");
                    console.error(err);
                });
    }

</script>

<script src="<%= request.getContextPath()%>/js/cart.js"></script>
<%@include file="/WEB-INF/include/footer.jsp" %>
