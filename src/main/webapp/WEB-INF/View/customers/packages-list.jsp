<%@page import="java.text.DecimalFormat"%>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@include file="/WEB-INF/include/head.jsp" %>
<%@include file="/WEB-INF/include/Login.jsp" %>
<%@include file="/WEB-INF/include/Register.jsp" %>
<%@include file="/WEB-INF/include/forgotPassword.jsp" %>
<%@include file="/WEB-INF/include/header.jsp" %>

<!-- Danh sách các gói tập -->
<div class="content">
    <p class="content__text--bottom">
        ALL MEMBERSHIP PACKAGES
    </p>
</div>

<div class="membership-cards-container container">
    <%
        // Lấy danh sách tất cả các gói tập từ request
        List<Model.Package> packages = (List<Model.Package>) request.getAttribute("membership_packages");
        DecimalFormat formatter = new DecimalFormat("#,###");
        // Kiểm tra nếu có gói tập để hiển thị
        if (packages != null && !packages.isEmpty()) {
            // Duyệt qua từng gói và hiển thị chúng
            for (Model.Package pkg : packages) {
            String formattedPrice = formatter.format(pkg.getPrice());
    %>
    <div class="membership-card">
        <!-- Hiển thị tên gói -->
        <div class="membership-card__duration"><%= pkg.getName() %></div> <!-- Tên gói -->

        <!-- Hiển thị giá gói -->
        <div class="membership-card__price"><%= formattedPrice %><sup>₫</sup> <span class="membership-card__price-unit">/ Month</span></div>

        <!-- Hiển thị mô tả gói -->
        <div class="membership-card__description">
            <%= pkg.getDescription().replaceAll("\\. ", ".<br>") %>
        </div>

        <!-- Liên kết đến trang chi tiết gói -->
        <a href="package-details?id=<%= pkg.getId() %>">Xem chi tiết ></a>
    </div>
    <%
            }
        } else {
    %>
    <!-- Hiển thị thông báo nếu không có gói tập nào -->
    <div class="no-packages-message">
        <p>Hiện tại không có gói tập nào.</p>
    </div>
    <%
        }
    %>
</div>

<%@include file="/WEB-INF/include/footer.jsp" %>
