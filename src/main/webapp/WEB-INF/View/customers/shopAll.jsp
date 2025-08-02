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
    Integer accountId = (session != null) ? (Integer) session.getAttribute("accountId") : null;

%>

<%@include file="/WEB-INF/include/head.jsp" %>
<%@include file="/WEB-INF/include/Login.jsp" %>
<%@include file="/WEB-INF/include/Register.jsp" %>
<%@include file="/WEB-INF/include/forgotPassword.jsp" %>
<%@include file="/WEB-INF/include/header.jsp" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<style>
    body {
        background-color: #111;
        color: #fff;
        font-family: 'Arial', sans-serif;
        margin: 0;
        padding: 0;
        position: relative;
        overflow-x: hidden;
    }

    /* Green wave effect for sides */
    body::before,
    body::after {
        content: '';
        position: fixed;
        top: 0;
        width: 200px;
        height: 100%;
        background: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 800' preserveAspectRatio='none'%3E%3Cpath d='M0,0 Q30,100 0,200 Q30,300 0,400 Q30,500 0,600 Q30,700 0,800' stroke='%2380ff00' fill='none' stroke-width='2' stroke-opacity='0.3' vector-effect='non-scaling-stroke'/%3E%3C/svg%3E") repeat-y;
        z-index: -1;
        opacity: 0.5;
    }

    body::before {
        left: 0;
    }

    body::after {
        right: 0;
        transform: scaleX(-1);
    }

    .body-product {
        width: 100%;
        padding: 20px;
        box-sizing: border-box;
        position: relative;
        min-height: 100vh;
    }

    .content-wrapper {
        width: 100%;
        max-width: 1800px;
        margin: 0 auto;
    }

    /* Banner styling */
    .carousel {
        margin-bottom: 40px;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        width: 100%;
    }

    .carousel-item img {
        height: 450px;
        object-fit: cover;
        width: 100%;
    }

    /* Page title */
    .header-content {
        text-align: center;
        margin: 40px 0 30px;
        color: #d9ff68;
        font-size: 60px;
        font-weight: 700;
        letter-spacing: 0.5px;
        text-transform: uppercase;
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        position: relative;
    }

    .header-content::after {
        content: '';
        position: absolute;
        bottom: -10px;
        left: 50%;
        transform: translateX(-50%);
        width: 150px;
        height: 3px;
        background: linear-gradient(to right, rgba(217, 255, 104, 0), rgba(217, 255, 104, 0.7), rgba(217, 255, 104, 0));
    }

    /* Voucher section */
    .voucher-section {
        padding: 25px;
        background: rgba(25, 25, 25, 0.9);
        border-radius: 12px;
        margin: 40px 0;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        border: 1px solid rgba(217, 255, 104, 0.2);
        position: relative;
    }

    .voucher-section::before {
        content: '';
        position: absolute;
        top: -3px;
        left: -3px;
        right: -3px;
        bottom: -3px;
        background: linear-gradient(45deg, rgba(217, 255, 104, 0.3), transparent, rgba(217, 255, 104, 0.3), transparent);
        border-radius: 15px;
        z-index: -1;
        animation: border-glow 5s linear infinite;
    }

    @keyframes border-glow {
        0% {
            background-position: 0 0;
        }
        100% {
            background-position: 300% 0;
        }
    }

    .voucher-title {
        font-size: 24px;
        margin-bottom: 20px;
        color: #d9ff68;
        text-align: center;
        font-weight: 600;
    }

    .voucher-container {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
        justify-content: center;
    }

    .voucher-card {
        border: 1px dashed rgba(217, 255, 104, 0.5);
        padding: 18px;
        border-radius: 10px;
        background: rgba(30, 30, 30, 0.6);
        width: 280px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        transition: all 0.3s ease;
    }

    .voucher-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 5px 15px rgba(217, 255, 104, 0.1);
    }

    .voucher-info p {
        margin: 5px 0;
        font-size: 14px;
        color: #fff;
    }

    .voucher-info p strong {
        color: #d9ff68;
        font-size: 16px;
    }

    .claim-btn {
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        color: #111;
        border: none;
        padding: 8px 16px;
        border-radius: 6px;
        font-weight: bold;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .claim-btn:hover {
        transform: scale(1.05);
        box-shadow: 0 4px 8px rgba(217, 255, 104, 0.3);
    }

    .btn-success {
        background: rgba(40, 167, 69, 0.8) !important;
        color: #fff !important;
        cursor: default;
    }

    /* Filter bar */
    .filter-bar {
        background: rgba(25, 25, 25, 0.9);
        padding: 15px 20px;
        border-radius: 10px;
        display: flex;
        flex-wrap: wrap;
        align-items: center;
        gap: 15px;
        margin-bottom: 30px;
        border: 1px solid rgba(217, 255, 104, 0.1);
        position: relative;
        z-index: 1;
    }

    .filter-title {
        font-size: 16px;
        font-weight: 600;
        color: #d9ff68;
        margin-right: 10px;
    }

    .filter-btn {
        background: rgba(30, 30, 30, 0.8);
        color: #fff;
        border: 1px solid rgba(255, 255, 255, 0.1);
        padding: 8px 16px;
        border-radius: 6px;
        cursor: pointer;
        transition: all 0.2s ease;
        font-size: 14px;
    }

    .filter-btn:hover,
    .filter-btn.active {
        background: rgba(217, 255, 104, 0.15);
        border-color: rgba(217, 255, 104, 0.5);
        color: #d9ff68;
    }

    .search-box {
        margin-left: auto;
    }

    .search-box input[type="text"] {
        background: rgba(30, 30, 30, 0.8);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 6px;
        padding: 8px 15px;
        color: #fff;
        width: 200px;
        outline: none;
        transition: all 0.2s ease;
    }

    .search-box input[type="text"]:focus {
        border-color: rgba(217, 255, 104, 0.5);
        box-shadow: 0 0 0 2px rgba(217, 255, 104, 0.15);
    }

    .search-icon {
        margin-left: -30px;
        color: #777;
        cursor: pointer;
    }

    /* Product grid */
    .product-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 30px;
        margin-bottom: 40px;
        max-width: 1800px;
        margin-left: auto;
        margin-right: auto;
    }

    .product-card {
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

    .product-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
        border-color: rgba(217, 255, 104, 0.3);
    }

    .product-image {
        width: 100%;
        height: 220px;
        object-fit: contain;
        margin: 0 auto 20px;
        transition: transform 0.3s ease;
        border-radius: 8px;
        display: block;
    }

    .product-card:hover .product-image {
        transform: scale(1.05);
    }

    .product-card p {
        margin: 10px 0;
        color: #fff;
    }

    .product-card p strong {
        color: #d9ff68;
        font-size: 16px;
        display: block;
        margin-bottom: 5px;
    }

    .product-actions {
        display: flex;
        gap: 5px;
        justify-content: center;
        margin-top: auto;
        padding-top: 15px;
        width: calc(100% + 20px);
        margin-left: -10px;
        margin-right: -10px;
    }

    /* Add !important to make sure our styles override any others */
    .cart-icon-btn {
        padding: 10px 5px;
        border: none;
        border-radius: 8px;
        font-size: 13px;
        font-weight: bold;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 3px;
        transition: all 0.3s ease;
        cursor: pointer;
        flex: 1;
        min-width: 70px;
        max-width: none;
        white-space: nowrap;
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

    /* Pagination */
    .pagination-container {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 10px;
        margin: 40px 0;
    }

    .pagination-btn {
        background: rgba(30, 30, 30, 0.8);
        color: #fff;
        border: 1px solid rgba(255, 255, 255, 0.1);
        padding: 10px 15px;
        border-radius: 8px;
        text-decoration: none;
        transition: all 0.2s ease;
        display: inline-block;
        min-width: 40px;
        text-align: center;
    }

    .pagination-btn:hover {
        background: rgba(217, 255, 104, 0.15);
        color: #d9ff68;
        border-color: rgba(217, 255, 104, 0.3);
    }

    .pagination-btn.active {
        background: rgba(217, 255, 104, 0.15);
        color: #d9ff68;
        border-color: rgba(217, 255, 104, 0.5);
        font-weight: bold;
    }

    .pagination-btn.previous,
    .pagination-btn.next {
        padding: 10px 20px;
    }

    .favorite-icon {
        position: absolute;
        top: 15px;
        right: 15px;
        font-size: 20px;
        cursor: pointer;
        color: rgba(255, 255, 255, 0.3);
        transition: all 0.2s ease;
    }

    .favorite-icon:hover {
        color: #ff6b6b;
    }

    /* Adding this Complete Order button style for consistency */
    .complete-order-btn {
        background: #d9ff00;
        color: #000;
        border: none;
        border-radius: 8px;
        padding: 12px 20px;
        font-weight: bold;
        font-size: 16px;
        text-transform: uppercase;
        letter-spacing: 1px;
        cursor: pointer;
        transition: all 0.3s ease;
        width: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        position: relative;
        overflow: hidden;
        box-shadow: 0 4px 12px rgba(217, 255, 0, 0.2);
    }

    .complete-order-btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 15px rgba(217, 255, 0, 0.3);
        background: #e5ff40;
    }

    .complete-order-btn::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
        transition: 0.5s;
    }

    .complete-order-btn:hover::before {
        left: 100%;
    }

    /* New shared button styling with better animation */
    @keyframes shimmer {
        0% {
            background-position: -100% 0;
        }
        100% {
            background-position: 200% 0;
        }
    }

    /* Original button styles */
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

    /* Responsive styles */
    @media (max-width: 1600px) {
        .product-grid {
            grid-template-columns: repeat(4, 1fr);
        }
    }

    @media (max-width: 1200px) {
        .product-grid {
            grid-template-columns: repeat(3, 1fr);
        }
    }

    @media (max-width: 992px) {
        .filter-bar {
            flex-direction: column;
            align-items: flex-start;
        }

        .search-box {
            margin-left: 0;
            width: 100%;
        }

        .search-box input[type="text"] {
            width: 100%;
        }

        .product-grid {
            grid-template-columns: repeat(2, 1fr);
        }
    }

    @media (max-width: 768px) {
        .carousel-item img {
            height: 250px;
        }

        .header-content {
            font-size: 28px;
        }
    }

    @media (max-width: 576px) {
        .product-grid {
            grid-template-columns: 1fr;
        }

        .carousel-item img {
            height: 200px;
        }

        body::before,
        body::after {
            width: 50px;
        }
    }
</style>

<main>
    <script>
        window.IS_LOGGED_IN = <%= (accountId != null) ? "true" : "false"%>;
        window.APP_CONTEXT_PATH = '<%= request.getContextPath()%>';
    </script>
    <div class="body-product">
        <div class="content-wrapper">
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

            <%-- Voucher Section --%>
            <%
                List<Model.Voucher> voucherList = (List<Model.Voucher>) request.getAttribute("voucherList");
            %>

            <div class="voucher-section">
                <h2 class="voucher-title">DISCOUNT VOUCHER</h2>
                <div class="voucher-container">
                    <% if (voucherList != null && !voucherList.isEmpty()) {
                            for (Model.Voucher v : voucherList) {
                    %>
                    <div class="voucher-card">
                        <div class="voucher-info">
                            <p><strong><%= v.getDiscountPercent()%>% OFF</strong></p>
                            <p>Max: <%= v.getMaxDiscount()%>đ - Min Order: <%= v.getMinOrderAmount()%>đ</p>
                        </div>
                        <div class="voucher-action">
                            <button class="claim-btn" onclick="claimVoucher(<%= v.getVoucherId()%>, this)">Claim</button>
                        </div>
                    </div>
                    <% }
                    } else { %>
                    <p style="color: #fff;">No vouchers available.</p>
                    <% }%>
                </div>
            </div>

            <h1 class="header-content">SHOP</h1>

            <%-- Filter Bar --%>
            <div class="filter-bar">
                <!-- Nút Clear Filter -->
                <form method="get" action="shopAll" style="display:inline; margin-left: 10px;">
                    <input type="hidden" name="page" value="1">
                    <button type="submit" class="filter-btn" style="background: #222; color: #d9ff68;">
                        <i class="fas fa-eraser"></i> Clear Filter
                    </button>
                </form>

                <span class="filter-title">Sort By</span>
                <!-- Sort Desc -->
                <form method="get" style="display:inline;">
                    <input type="hidden" name="sort" value="desc">
                    <input type="hidden" name="page" value="1">
                    <input type="hidden" name="category" value="<%= request.getParameter("category") != null ? request.getParameter("category") : ""%>">
                    <input type="hidden" name="q" value="<%= request.getParameter("q") != null ? request.getParameter("q") : ""%>">
                    <button type="submit" class="filter-btn <%= "desc".equals(request.getParameter("sort")) ? "active" : ""%>">
                        <i class="fas fa-sort-amount-down"></i> High Price - Low Price
                    </button>
                </form>

                <!-- Sort Asc -->
                <form method="get" style="display:inline;">
                    <input type="hidden" name="sort" value="asc">
                    <input type="hidden" name="page" value="1">
                    <input type="hidden" name="category" value="<%= request.getParameter("category") != null ? request.getParameter("category") : ""%>">
                    <input type="hidden" name="q" value="<%= request.getParameter("q") != null ? request.getParameter("q") : ""%>">
                    <button type="submit" class="filter-btn <%= "asc".equals(request.getParameter("sort")) ? "active" : ""%>">
                        <i class="fas fa-sort-amount-up"></i> Low Price - High Price
                    </button>
                </form>

                <!-- Category filter -->
                <form method="get" id="categoryForm" style="display:inline;">
                    <select name="category" onchange="document.getElementById('categoryForm').submit()" class="filter-btn">
                        <option value="">All categories</option>
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
                    <input type="hidden" name="sort" value="<%= request.getParameter("sort") != null ? request.getParameter("sort") : ""%>">
                    <input type="hidden" name="q" value="<%= request.getParameter("q") != null ? request.getParameter("q") : ""%>">
                    <input type="hidden" name="page" value="1">
                </form>

                <!-- Search Box -->
                <div class="search-box">
                    <form method="get" action="shopAll" style="display: flex; align-items: center;">
                        <input type="text" name="q" placeholder="Search products..."
                               value="<%= request.getParameter("q") != null ? request.getParameter("q") : ""%>" />
                        <button type="submit" class="search-icon" style="background: none; border: none; padding: 0;">
                            <i class="fas fa-search" style="color: #777;"></i>
                        </button>
                        <input type="hidden" name="sort" value="<%=request.getParameter("sort") != null ? request.getParameter("sort") : ""%>">
                        <input type="hidden" name="category" value="<%=request.getParameter("category") != null ? request.getParameter("category") : ""%>">
                        <input type="hidden" name="page" value="1">
                    </form>
                </div>
            </div>

            <%-- Product Grid --%>
            <div class="product-grid" id="product-list">
                <% for (Products p : list) {
                        int stock = p.getStockQuantity();
                %>
                <div class="product-card">
                    <img src="<%= request.getContextPath() + "/ImagesServlet?type=product&imageId=" + dao.getPrimaryImage(p.getProductId()).getImageId()%>" 
                         alt="<%= p.getName()%>" class="product-image" />
                    <p>
                        <strong><%= p.getName()%></strong>
                        <% if (stock < 1) { %>
                        <span style="display:block; color: #ff6b6b; font-size: 14px; margin-top: 4px; font-weight: bold;">Out of stock</span>                    
                        <% } else {%>
                        <span style="display:block; color: #aaa; font-size: 14px; margin-top: 4px;">In stock: <%= stock%></span> 
                        <% }%>
                    </p>
                    <p style="font-size: 18px; font-weight: 600; color: #d9ff68;"><%= String.format("%,.0f", p.getPrice())%>đ</p>
                    <div class="product-actions">
                        <!-- Add to Cart button -->
                        <button 
                            onclick="addToCart(<%= p.getProductId()%>)" 
                            class="cart-icon-btn neon-button cart"
                            <%= stock < 1 ? "disabled style=\"opacity:0.5;pointer-events:none;\" title=\"Out of stock\"" : ""%>>
                            <i class="fas fa-shopping-cart"></i> Cart
                        </button>
                        <!-- Buy Now button -->
                        <button 
                            class="cart-icon-btn neon-button buy-now btn-buy-now"
                            data-productid="<%= p.getProductId()%>"
                            <%= stock < 1 ? "disabled style='opacity:0.5;pointer-events:none;' title='Out of stock'" : "title='Buy Now'"%>>
                            <i class="fa fa-bolt"></i> Buy Now
                        </button>
                        <!-- Detail button -->
                        <button 
                            class="cart-icon-btn neon-button details"
                            onclick="window.location.href = '<%= request.getContextPath()%>/ProductDetail?productId=<%= p.getProductId()%>'"
                            title="View Details">
                            <i class="fas fa-info-circle"></i> Details
                        </button>
                    </div>
                </div>
                <% }%>
            </div>

            <%-- Pagination --%>
            <div id="pagination" class="pagination-container">
                <input type="hidden" id="totalPages" value="<%= totalPages%>">

                <!-- Previous button -->
                <a href="#" class="pagination-btn previous" onclick="changePageProduct('previous')">
                    <i class="fas fa-chevron-left"></i> Previous
                </a>

                <!-- Page numbers -->
                <% if (totalPages > 0) { %>
                <% for (int i = 1; i <= totalPages; i++) {%>
                <a href="#" class="pagination-btn <%= (i == currentPage) ? "active" : ""%>" onclick="changePageProduct(<%= i%>)">
                    <%= i%>
                </a>
                <% } %>
                <% } else { %>
                <span>No pages available</span>
                <% }%>

                <!-- Next button -->
                <a href="#" class="pagination-btn next" onclick="changePageProduct('next')">
                    Next <i class="fas fa-chevron-right"></i>
                </a>
            </div>
        </div>
    </div>
    <%
        String errorMessage = null;
        if (session.getAttribute("errorMessage") != null) {
            errorMessage = (String) session.getAttribute("errorMessage");
            session.removeAttribute("errorMessage");
        }
    %>
</main>
<script src="<%= request.getContextPath()%>/js/pagination.js"></script>

<script>
                    function claimVoucher(voucherId, button) {
                        fetch('<%= request.getContextPath()%>/customerVochers', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded'
                            },
                            body: 'voucherId=' + encodeURIComponent(voucherId),
                            credentials: 'include'
                        })
                                .then(res => res.json())
                                .then(data => {
                                    alert(data.message);
                                    if (data.status === 'success') {
                                        button.disabled = true;
                                        button.innerText = 'Claimed';
                                        button.classList.remove('claim-btn');
                                        button.classList.add('btn-success');
                                    }
                                })
                                .catch(err => {
                                    alert("An error occurred.");
                                    console.error(err);
                                });
                    }

                    window.ERROR_MESSAGE = <%= (errorMessage != null) ? "\"" + errorMessage.replace("\"", "\\\"") + "\"" : "null"%>;

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

                                        alert("Đã thêm sản phẩm vào giỏ hàng!");
                                    } else if (result === "error") {
                                        alert(data.message);  // Hiển thị thông báo lỗi nếu chưa đăng nhập
                                    } else {
                                        alert("Thêm sản phẩm thất bại.");
                                    }
                                })
                                .catch(err => {
                                    console.error("Lỗi khi gửi yêu cầu Ajax:", err);
                                    alert("Có lỗi xảy ra khi thêm sản phẩm.");
                                });
                    }

                    function viewCart() {
                        fetch("CartServlet?action=view", {
                            method: "GET",
                            headers: {
                                "X-Requested-With": "XMLHttpRequest"
                            }
                        })
                                .then(res => res.json())
                                .then(data => {
                                    if (data.status === "error") {
                                        alert(data.message);  // Hiển thị thông báo lỗi nếu chưa đăng nhập
                                    } else {
                                        window.location.href = "CartServlet?action=view";  // Chuyển đến giỏ hàng nếu đã đăng nhập
                                    }
                                })
                                .catch(err => {
                                    console.error("Lỗi khi gửi yêu cầu Ajax:", err);
                                    alert("Có lỗi xảy ra khi truy cập giỏ hàng.");
                                });
                    }
</script>
<script src="<%= request.getContextPath()%>/js/cart.js"></script>
<script src="<%= request.getContextPath()%>/js/buyNow.js"></script>
<%@include file="/WEB-INF/include/footer.jsp" %>
