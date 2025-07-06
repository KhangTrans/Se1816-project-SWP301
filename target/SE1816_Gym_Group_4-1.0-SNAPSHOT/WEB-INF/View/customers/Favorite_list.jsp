<%@page import="DAO.FavoriteListDao"%>
<%@page import="DAO.ProductDao"%>
<%@page import="Model.Products"%>
<%@page import="Model.Product_Images"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>

<%
    ProductDao dao = new ProductDao();
    List<Products> productList = (List<Products>) request.getAttribute("favoriteProducts");
    int totalPages = (request.getAttribute("totalPages") != null) ? (Integer) request.getAttribute("totalPages") : 1;
    int currentPage = (request.getAttribute("currentPage") != null) ? (Integer) request.getAttribute("currentPage") : 1;
    Integer accountId = (Integer) session.getAttribute("accountId");
    boolean isFewProducts = (productList != null && productList.size() < 3);
%>

<%@include file="/WEB-INF/include/head.jsp" %>
<%@include file="/WEB-INF/include/header.jsp" %>

<style>
    .alert-box {
        display: none;
        position: fixed;
        top: 10%;
        left: 50%;
        transform: translateX(-50%);
        background-color: #0ba960;
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

    .body-product {
        background: radial-gradient(circle, #000000, #263302, #000000);
        height: 100%;
        min-height: 100vh;
    }

    .header-content {
        margin-top: 10px;
        margin-bottom: 20px;
        font-size: 60px;
        font-weight: bold;
        text-align: center;
        background: linear-gradient(90deg, #010101, #9ddb00);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        color: transparent;
    }

/*    .product-grid {
        padding: 20px;
        max-width: 1200px;
        margin: 0 auto;
    }*/

    .product-grid.few {
        display: flex;
        justify-content: center;
        align-items: center;
        flex-wrap: wrap;
        gap: 20px;
    }

    .product-grid.many {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 20px;
        justify-content: center;
        align-items: center;
    }

/*    .product-card {
        width: 95%;
        border-radius: 16px;
        box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.25);
        overflow: hidden;
        display: flex;
        flex-direction: column;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        color: #fff;
        text-align: center;
        max-width: 280px;
    }*/

    .product-card:hover {
        transform: translateY(-6px);
        box-shadow: 0px 6px 16px rgba(0, 255, 100, 0.3);
    }

/*    .product-image {
        width: 100%;
        height: 280px;
        object-fit: cover;
        background-color: #ccc;
                margin-left: 13px;
                margin-top: 10px;
    }*/

    .product-card p strong {
        display: block;
        font-size: 18px;
        margin-top: 10px;
        color: #ffffff;
    }

    .product-card p:last-child {
        font-size: 16px;
        font-weight: bold;
        color: #88ff88;
        margin: 10px 0 15px;
    }

    .button-container {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 10px;
        margin: 10px auto 15px;
    }

    .btn-detail {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(45deg, #32CD32, #7CFC00);
        color: #fff;
        border: none;
        border-radius: 8px;
        padding: 8px 0;
        font-size: 14px;
        font-weight: 600;
        line-height: 1.5;
        text-decoration: none;
        transition: all 0.3s ease;
        cursor: pointer;
        box-shadow: 0 2px 6px rgba(0, 255, 0, 0.3);
        width: 110px;
        text-align: center;
        box-sizing: border-box;
    }

    .btn-detail:hover {
        background: linear-gradient(45deg, #2E8B57, #32CD32);
        transform: scale(1.05);
        box-shadow: 0 4px 12px rgba(0, 255, 0, 0.5);
    }

    .btn-detail i {
        margin-right: 6px;
    }

    .btn-detail:active {
        transform: scale(0.95);
        box-shadow: 0 2px 4px rgba(0, 255, 0, 0.2);
    }

    .btn-delete-fav {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        background: #fffde7;
        color: #ff9100;
        border: 1px solid #ff9100;
        border-radius: 8px;
        padding: 20px 0;
        font-size: 14px;
        font-weight: 600;
        line-height: 1.5;
        transition: all 0.3s ease;
        width: 110px;
        text-align: center;
        box-sizing: border-box;
    }

    .btn-delete-fav:hover {
        background: #ff9100;
        color: #fff;
        transform: scale(1.05);
        box-shadow: 0 4px 12px rgba(255, 145, 0, 0.5);
    }

    .btn-delete-fav i {
        margin-right: 6px;
    }

    .btn-delete-fav:active {
        transform: scale(0.95);
        box-shadow: 0 2px 4px rgba(255, 145, 0, 0.2);
    }

    .pagination-container {
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #3c3c3c;
        padding: 10px;
        border-radius: 30px;
    }

    .pagination-btn {
        text-decoration: none;
        color: white;
        background-color: #6a6a6a;
        padding: 8px 15px;
        margin: 0 5px;
        border-radius: 20px;
        font-size: 14px;
        transition: background-color 0.3s, color 0.3s;
    }

    .pagination-btn:hover {
        background-color: #45a049;
    }

    .pagination-btn.active {
        background-color: #4CAF50;
        color: white;
        font-weight: bold;
    }

    .pagination-btn.dots {
        color: white;
    }

    .pagination-btn.previous, .pagination-btn.next {
        background-color: #6a6a6a;
    }

    .pagination-btn.previous:hover, .pagination-btn.next:hover {
        background-color: #45a049;
    }

/*    @media (max-width: 1200px) {
        .product-grid.few {
            flex-direction: column;
        }
        .product-grid.many {
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        }
    }

    @media (min-width: 1201px) {
        .product-grid.many {
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        }
        .product-grid.many > .product-card {
            max-width: 280px;
            margin: 0 auto;
        }
    }*/
</style>

<main>
    <h1 class="header-content" style="margin-top: 100px">FAVORITE</h1>

    <div class="product-grid <%= (productList != null && productList.size() < 3) ? "few" : "many"%>" id="product-list">
        <%
            if (productList != null && !productList.isEmpty()) {
                for (Products product : productList) {
        %>
        <div class="product-card" id="product-<%= product.getProductId()%>">
            <%
                Product_Images primaryImage = dao.getPrimaryImage(product.getProductId());
                String imageSrc = (primaryImage != null) ? request.getContextPath() + "/ImagesServlet?type=product&imageId=" + primaryImage.getImageId() : "./img/default-product.jpg";
            %>
            <img src="<%= imageSrc%>" alt="Product Image" class="product-image" />
            <p><strong><%= product.getName()%></strong></p>
            <p><%= String.format("%,.0f", product.getPrice())%>đ</p>
            <div  class="product-actions" style="margin-top:10px; display: flex; margin-left: 13px">
                <button 
                    class="btn btn-cart"
                    type="button"
                    onclick="addToCart('<%= product.getProductId()%>')">
                    <i class="fa fa-cart-plus"></i>
                </button>
                <!-- Nút Mua Ngay -->
                <button 
                    class="cart-icon-btn"
                    onclick="window.location.href = '<%= request.getContextPath()%>/ProductDetail?productId=<%= product.getProductId()%>'"
                    title="Mua ngay">
                    <i class="fa fa-bolt"> Buy Now</i>
                </button>
                <button class="btn-delete-fav" onclick="deleteFavorite('<%= product.getProductId()%>')">
                    <i class="fas fa-trash-alt"></i> Xóa
                </button>
            </div>
        </div>
        <% }
        } else {%>
        <p><%= (request.getAttribute("noFavoriteMessage") != null) ? (String) request.getAttribute("noFavoriteMessage") : "Không có sản phẩm yêu thích nào."%></p>
        <% } %>
    </div>

    <div id="pagination" class="pagination-container">
        <a href="#" class="pagination-btn previous" onclick="changePage('previous')"> < previous </a>
        <% if (totalPages > 0) {
                for (int i = 1; i <= totalPages; i++) {%>
        <a href="#" class="paginatioFn-btn <%= (i == currentPage) ? "active" : ""%>" onclick="changePage(<%= i%>)">
            <%= i%>
        </a>
        <% }
        } else { %>
        <span>No pages available</span>
        <% }%>
        <a href="#" class="pagination-btn next" onclick="changePage('next')"> next > </a>
    </div>
</main>

<div id="alertBox" class="alert-box">
    <span id="alertMessage"></span>
    <button onclick="closeAlert()" class="close-btn">X</button>
</div>

<script>
    function changePage(page) {
        var newPage = (page === 'previous') ? <%= currentPage - 1%> : (page === 'next') ? <%= currentPage + 1%> : page;
        if (newPage < 1 || newPage > <%= totalPages%>)
            return;
        window.location.href = "<%= request.getContextPath()%>/FavoriteListServlet?page=" + newPage;
    }

    function deleteFavorite(productId) {
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "<%= request.getContextPath()%>/FavoriteListServlet", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");

        var accountId = "<%= session.getAttribute("accountId")%>";
        if (!accountId || accountId === "null") {
            showAlert("Bạn chưa đăng nhập. Vui lòng đăng nhập để quản lý danh sách yêu thích.");
            return;
        }

        var data = "action=delete&productId=" + productId + "&accountId=" + accountId;

        xhr.onload = function () {
            if (xhr.status === 200) {
                var response = JSON.parse(xhr.responseText);
                if (response.status === "success") {
                    var productElement = document.getElementById('product-' + productId);
                    if (productElement) {
                        productElement.remove();
                    }
                    showAlert(response.message);
                } else {
                    showAlert(response.message);
                }
            } else {
                showAlert("Đã xảy ra lỗi khi xóa sản phẩm.");
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
</script>

<%@include file="/WEB-INF/include/footer.jsp" %>