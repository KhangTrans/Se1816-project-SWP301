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
    .body-product {
        background: radial-gradient(circle, #000000, #263302, #000000);
        min-height: 100vh;
        padding-bottom: 50px;
    }

    .header-content {
        padding-top: 100px;
        margin-bottom: 40px;
        font-size: 60px;
        font-weight: bold;
        text-align: center;
        color: #d9ff68;
        font-weight: 700;
        letter-spacing: 0.5px;
        text-transform: uppercase;
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

    .favorites-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
    }

    .favorites-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 30px;
        margin-bottom: 40px;
        max-width: 1800px;
        margin-left: auto;
        margin-right: auto;
    }

    .favorite-card {
        background: rgba(25, 25, 25, 0.9);
        border-radius: 12px;
        padding: 25px;
        text-align: center;
        transition: all 0.3s ease;
        position: relative;
        border: 1px solid rgba(217, 255, 104, 0.1);
        display: flex;
        flex-direction: column;
        height: 100%;
        width: 100%;
        margin: 0 auto;
    }

    .favorite-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
        border-color: rgba(217, 255, 104, 0.3);
    }

    .favorite-image-container {
        position: relative;
        margin-bottom: 20px;
    }

    .favorite-image {
        width: 100%;
        height: 220px;
        object-fit: contain;
        margin: 0 auto 20px;
        transition: transform 0.3s ease;
        border-radius: 8px;
        display: block;
    }

    .favorite-card:hover .favorite-image {
        transform: scale(1.05);
    }

    .favorite-name {
        color: #d9ff68;
        font-size: 16px;
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
    }

    .favorite-price {
        font-size: 18px;
        font-weight: 600;
        color: #d9ff68;
        margin: 10px 0 20px;
    }

    .favorite-actions {
        display: flex;
        gap: 5px;
        justify-content: center;
        margin-top: auto;
        padding-top: 15px;
    }

    /* Cart and Buy Now button styles exactly matching shopAll */
    .cart-icon-btn {
        padding: 10px 20px;
        border: none;
        border-radius: 4px;
        font-size: 13px;
        font-weight: bold;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        transition: all 0.2s ease;
        cursor: pointer;
        flex: 1;
    }

    .cart-icon-btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 15px rgba(217, 255, 0, 0.3);
    }

    .cart-icon-btn:active {
        transform: translateY(0);
        box-shadow: 0 2px 8px rgba(217, 255, 0, 0.2);
    }

    .cart-icon-btn::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
        transition: 0.5s;
    }

    .cart-icon-btn:hover::before {
        left: 100%;
    }

    .cart-icon-btn i {
        font-size: 14px;
    }

    .buy-now-btn, .details-btn {
        background: #d9ff00 !important;
        color: #000 !important;
    }

    .buy-now-btn:hover, .details-btn:hover {
        background: #e5ff40 !important;
    }

    /* Neon button styles from shopAll */
    .neon-button {
        border: none;
        border-radius: 8px;
        font-weight: bold;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 6px;
        cursor: pointer;
        position: relative;
        overflow: hidden;
        transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275),
            box-shadow 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    }

    .neon-button:hover {
        transform: translateY(-3px);
    }

    .neon-button:active {
        transform: translateY(-1px);
    }

    .neon-button.buy-now {
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        color: #111;
        box-shadow: 0 4px 12px rgba(156, 219, 0, 0.2);
    }

    .neon-button.buy-now:hover {
        box-shadow: 0 8px 20px rgba(156, 219, 0, 0.4);
    }

    .neon-button.details {
        background: rgba(30, 30, 30, 0.6);
        color: #fff;
        border: 1px solid rgba(217, 255, 104, 0.3);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    }

    .neon-button.details:hover {
        background: rgba(30, 30, 30, 0.8);
        border-color: rgba(217, 255, 104, 0.5);
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3);
    }

    .neon-button.cart {
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        color: #111;
        box-shadow: 0 4px 12px rgba(156, 219, 0, 0.2);
    }

    .neon-button.cart:hover {
        background: linear-gradient(135deg, #d1ff20 0%, #aaec00 100%);
        box-shadow: 0 8px 20px rgba(156, 219, 0, 0.4);
    }

    /* We can keep the remove button style but update it to match the theme */
    .btn-remove {
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #ff3333;
        color: #fff;
        border: none;
        border-radius: 4px;
        width: 45px;
        height: 38px;
        font-size: 14px;
        cursor: pointer;
        transition: all 0.2s ease;
    }

    .btn-remove:hover {
        background-color: #cc0000;
    }

    .empty-favorites {
        text-align: center;
        color: #ffffff;
        padding: 50px 0;
        font-size: 18px;
    }

    .empty-favorites i {
        font-size: 60px;
        color: #9ddb00;
        margin-bottom: 20px;
        display: block;
    }

    .pagination-container {
        margin-top: 40px;
        display: flex;
        justify-content: center;
        align-items: center;
        background-color: rgba(60, 60, 60, 0.7);
        padding: 15px 20px;
        border-radius: 30px;
        width: fit-content;
        margin-left: auto;
        margin-right: auto;
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
        border: none;
        cursor: pointer;
    }

    .pagination-btn:hover {
        background-color: #9ddb00;
        color: #111;
    }

    .pagination-btn.active {
        background-color: #9ddb00;
        color: #111;
        font-weight: bold;
    }

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
        display: none; /* Hide the close button */
    }

    @media (max-width: 992px) {
        .favorites-grid {
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
        }
    }

    @media (max-width: 576px) {
        .favorites-grid {
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        }

        .favorite-actions {
            flex-direction: column;
            gap: 10px;
        }

        .btn-buy-now {
            width: 100%;
        }

        .btn-cart, .btn-remove {
            margin: 0 auto;
        }
    }
</style>
<script>
    window.IS_LOGGED_IN = <%= (accountId != null) ? "true" : "false"%>;
    window.APP_CONTEXT_PATH = '<%= request.getContextPath()%>';
</script>
<div class="body-product">
    <h1 class="header-content">FAVORITE LIST</h1>

    <div class="favorites-container">
        <div class="favorites-grid" id="product-list">
            <% if (productList != null && !productList.isEmpty()) {
                    for (Products product : productList) {
                        Product_Images primaryImage = dao.getPrimaryImage(product.getProductId());
                        String imageSrc = (primaryImage != null) ? request.getContextPath() + "/ImagesServlet?type=product&imageId=" + primaryImage.getImageId() : "./img/default-product.jpg";
            %>
            <div class="favorite-card" id="product-<%= product.getProductId()%>">
                <%
                    int stock = product.getStockQuantity();
                    boolean isOutOfStock = (stock < 1);
                %>
                <img src="<%= imageSrc%>" alt="<%= product.getName()%>" class="favorite-image">

                <p>
                    <strong class="favorite-name"><%= product.getName()%></strong>
                    <% if (isOutOfStock) { %>
                    <span style="color:#ff6b6b; font-size:13px; margin-top:5px; display:block;">Out of stock</span>
                    <% } else {%>
                    <span style="display:block; color:#aaa; font-size:13px; margin-top:5px;">In stock: <%= stock%></span>
                    <% }%>
                </p>
                <p class="favorite-price"><%= String.format("%,.0f", product.getPrice())%>đ</p>

                <div class="favorite-actions">
                    <button 
                        onclick="addToCart(<%= product.getProductId()%>)" 
                        class="cart-icon-btn neon-button cart"
                        <%= stock < 1 ? "disabled style=\"opacity:0.5;pointer-events:none;\" title=\"Out of stock\"" : ""%>>
                        <i class="fas fa-shopping-cart"></i> Cart
                    </button>

                    <button 
                        class="cart-icon-btn neon-button buy-now btn-buy-now"
                        data-productid="<%= product.getProductId()%>"
                        <%= isOutOfStock ? "disabled style='opacity:0.5;pointer-events:none;' title='Out of stock'" : "title='Buy Now'"%>>
                        <i class="fa fa-bolt"></i> Buy Now
                    </button>

                    <button class="btn-remove" onclick="deleteFavorite('<%= product.getProductId()%>')">
                        <i class="fas fa-trash-alt"></i>
                    </button>
                </div>
            </div>
            <% }
            } else {%>
            <div class="empty-favorites" style="grid-column: 1 / -1;">
                <i class="far fa-heart"></i>
                <p><%= (request.getAttribute("noFavoriteMessage") != null) ? (String) request.getAttribute("noFavoriteMessage") : "Your favorites list is empty."%></p>
            </div>
            <% }%>
        </div>
    </div>
</div>

<div id="alertBox" class="alert-box">
    <span id="alertMessage"></span>
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
            showAlert("Please login to manage your favorites list.");
            return;
        }

        var data = "action=delete&productId=" + productId + "&accountId=" + accountId;

        xhr.onload = function () {
            if (xhr.status === 200) {
                var response = JSON.parse(xhr.responseText);
                if (response.status === "success") {
                    var productElement = document.getElementById('product-' + productId);
                    if (productElement) {
                        productElement.style.opacity = '0';
                        productElement.style.transform = 'scale(0.8)';
                        productElement.style.transition = 'all 0.5s ease';

                        setTimeout(function () {
                            productElement.remove();

                            // Check if there are any products left
                            var remainingProducts = document.querySelectorAll('.favorite-card').length;
                            if (remainingProducts === 0) {
                                var emptyMessage = document.createElement('div');
                                emptyMessage.className = 'empty-favorites';
                                emptyMessage.style.gridColumn = '1 / -1';
                                emptyMessage.innerHTML = '<i class="far fa-heart"></i><p>Your favorites list is empty.</p>';
                                document.getElementById('product-list').appendChild(emptyMessage);
                            }
                        }, 500);
                    }
                    showAlert("The product has been removed from your wishlist.");
                } else {
                    showAlert(response.message);
                }
            } else {
                showAlert("Error removing product from favorites.");
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

        // Auto hide after 1 second
        setTimeout(function () {
            closeAlert();
        }, 1000);
    }

    function closeAlert() {
        document.getElementById('alertBox').style.display = 'none';
    }

    function addToCart(productId) {
        fetch("CartServlet", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
                "X-Requested-With": "XMLHttpRequest"
            },
            body: `action=add&productId=${productId}&quantity=1`
        })
                .then(res => res.json())
                .then(data => {
                    const result = data.status;
                    if (result === "added") {
                        const cartCount = data.cartCount;
                        const cartBadge = document.querySelector('.cart-count-badge');

                        if (cartCount > 0) {
                            cartBadge.textContent = cartCount > 99 ? "99+" : cartCount;
                            cartBadge.style.display = "inline-block";
                        } else {
                            cartBadge.style.display = "none";
                        }

                        alert("Product added to cart!");
                    } else if (result === "error") {
                        alert(data.message);  // Display error message if not logged in
                    } else {
                        alert("Failed to add product.");
                    }
                })
                .catch(err => {
                    console.error("Ajax error");
                    alert("Failed to add product.");
                });
    }

</script>
<script src="<%= request.getContextPath()%>/js/buyNow.js"></script>
<script src="<%= request.getContextPath()%>/js/cart.js"></script>
<%@include file="/WEB-INF/include/footer.jsp" %>