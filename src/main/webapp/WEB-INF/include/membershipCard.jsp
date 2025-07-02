<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<!--===Danh sách các Gói Tập===-->
<div class="content">
    <p class="content__text--bottom">
        MEMBERSHIP
    </p>
</div>

<div class="membership-cards-container container">
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
        <a href="package-details?id=<%= pkg.getId()%>">Xem chi tiết ></a>
    </div>
    <%
        }
    %>
</div>        
<!-- === View All Button === -->
<a href="#!" id="view-all-btn" class="gallery__view-all" onclick="window.location.href = '${pageContext.request.contextPath}/AllPackages'">
    <span class="gallery__view-all-text">XEM TẤT CẢ</span>
    <span class="gallery-slider__arrow">
        <img src="./logo/🦆 icon _nav arrow down_.svg" alt="arrow" width="28" height="16" />
    </span>
</a>



