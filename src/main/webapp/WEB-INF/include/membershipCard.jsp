<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<!-- Add the exact same CSS as in Trainers.jsp -->
<style>
    .gallery__view-all-container {
        display: flex;
        justify-content: center;
        align-items: center;
        width: auto;
        margin: 20px auto 0;
    }

    .gallery__view-all {
        display: flex;
        justify-content: center;
        align-items: center;
        text-decoration: none;
        color: #d9ff68;
        font-size: 16px;
        font-weight: bold;
        margin-top: 20px;
        width: auto;
        transition: color 0.3s ease;
        padding: 0 20px;
    }

    .gallery__view-all:hover {
        color: #c4ff00; /* Matching hover color */
    }

    .gallery__view-all-text {
        text-align: center;
    }

    .gallery-slider__arrow {
        margin-left: 10px;
        vertical-align: middle;
    }
</style>

<!--===Danh sách các Gói Tập===-->
<div class="content">
    <p class="content__text--bottom">MEMBERSHIP</p>
</div>

<div class="membership-cards-container container d-flex justify-content-center">
    <!-- Duyệt qua tất cả các gói -->
    <%
        // Lấy danh sách các gói từ request
        List<Model.Package> packages = (List<Model.Package>) request.getAttribute("membership_packages");

        // Tạo đối tượng DecimalFormat để định dạng tiền
        DecimalFormat formatter = new DecimalFormat("#,###");

        // Duyệt qua từng gói trong danh sách
        for (Model.Package pkg : packages) {
            String formattedPrice = formatter.format(pkg.getPrice());  // Định dạng giá tiền
%>
    <div class="membership-card">
        <!-- Tên gói -->
        <div class="membership-card__duration"><%= pkg.getName()%></div>

        <!-- Giá gói (đã định dạng) -->
        <div class="membership-card__price"><%= formattedPrice%><sup>₫</sup> <span class="membership-card__price-unit">/ Month</span></div>

        <!-- Mô tả gói (với <br> cho các câu mô tả dài) -->
        <div class="membership-card__description">
            <%= pkg.getDescription().replaceAll("\\. ", ".<br>")%>
        </div>

        <!-- Liên kết đến trang chi tiết gói -->
        <a href="package-details?id=<%= pkg.getId()%>" class="view-details-btn">View details</a>
    </div>
    <%
        }
    %>
</div>        
<!-- === View All Button === -->
<div class="gallery__view-all-container">
    <a href="${pageContext.request.contextPath}/AllPackages" class="gallery__view-all">
        <span class="gallery__view-all-text">View All</span>
        <span class="gallery-slider__arrow">
            <img src="./logo/🦆 icon _nav arrow down_.svg" alt="arrow" width="28" height="16" />
        </span>
    </a>
</div>



