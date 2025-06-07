<%-- 
    Document   : shopAll
    Created on : Jun 6, 2025, 11:58:11 AM
    Author     : PC
--%>

<%@page import="com.sun.javafx.iio.ImageStorage"%>
<%@page import="Model.Product_Images"%>
<%@page import="Model.Products"%>
<%@page import="java.util.List"%>
<%@page import="DAO.ProductDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    ProductDAO dao = new ProductDAO();
    List<Products> list = dao.getAllProduct();
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css"
            rel="stylesheet"
            integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT"
            crossorigin="anonymous"
            />
        <link rel="stylesheet" href="./css/shopAll.css" />
        <title>Document</title>
    </head>
    <body>
        <div class="body-product">
            <!-- Banner -->
            <div
                id="carouselExampleIndicators"
                class="carousel slide banner"
                data-bs-ride="carousel"
                >
                <div class="carousel-indicators">
                    <button
                        type="button"
                        data-bs-target="#carouselExampleIndicators"
                        data-bs-slide-to="0"
                        class="active"
                        aria-current="true"
                        aria-label="Slide 1"
                        ></button>
                    <button
                        type="button"
                        data-bs-target="#carouselExampleIndicators"
                        data-bs-slide-to="1"
                        aria-label="Slide 2"
                        ></button>
                    <button
                        type="button"
                        data-bs-target="#carouselExampleIndicators"
                        data-bs-slide-to="2"
                        aria-label="Slide 3"
                        ></button>
                </div>
                <div class="carousel-inner banner-all-image">
                    <div
                        class="carousel-item active banner-image"
                        data-bs-interval="3000"
                        >
                        <img
                            src="./img/laptop-1.jpg"
                            class="d-block w-100"
                            alt="..."
                            />
                    </div>
                    <div class="carousel-item banner-image" data-bs-interval="3000">
                        <img
                            src="./img/laptop-2.jpg"
                            class="d-block w-100"
                            alt="..."
                            />
                    </div>
                    <div class="carousel-item banner-image" data-bs-interval="3000">
                        <img
                            src="./img/laptop-3.jpg"
                            class="d-block w-100"
                            alt="..."
                            />
                    </div>
                </div>
                <button
                    class="carousel-control-prev"
                    type="button"
                    data-bs-target="#carouselExampleIndicators"
                    data-bs-slide="prev"
                    >
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button
                    class="carousel-control-next"
                    type="button"
                    data-bs-target="#carouselExampleIndicators"
                    data-bs-slide="next"
                    >
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
                        <!-- Dán nội dung SVG ở đây -->
                        <img src="./img/search.svg" alt="Search Icon" width="16" height="16">
                    </span>
                </div>
            </div>

            <div class="product-grid">
                <%
                    for (Products p : list) {
                        List<Product_Images> images = dao.getImagesByProductId(p.getProductId());
                        String base64Image = "";
                        if (images != null && !images.isEmpty()) {
                            for (Product_Images img : images) {
                                if (img.getPrimary() == 1 && img.getImg_url() != null) {
                                    base64Image = java.util.Base64.getEncoder().encodeToString(img.getImg_url());
                                    break;
                                }
                            }
                        }
                %>
                <div class="product-card">
                    <img 
                        src="<%= (base64Image.isEmpty()) ? "img/default-product.png" : "data:image/png;base64," + base64Image%>" 
                        alt="Product Image" 
                        class="product-image" 
                        />
                    <p><strong><%= p.getName()%></strong></p>
                    <p><%= String.format("%,.0f", p.getPrice())%>đ</p>
                </div>
                <% }%>
            </div>


            <div class="pagination">
                <a href="?page=1">previous</a>
                <a class="active" href="?page=2">2</a>
                <a href="?page=3">3</a>
                <a href="?page=4">4</a>
                <a href="?page=5">5</a>
                <span>...</span>
                <a href="?page=99">99</a>
                <a href="?page=3">next</a>
            </div>
        </div>
        <script
            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO"
            crossorigin="anonymous"
        ></script>
    </body>
</html>

