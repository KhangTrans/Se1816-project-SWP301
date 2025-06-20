<%@ page import="java.util.List"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<!--===Danh sách các Gói Tập===-->
<div class="content">
    <p class="content__text--bottom">
        MEMBERSHIP
    </p>
</div>

<div class="membership-cards-container container ">
    <!-- Duyệt qua tất cả các gói -->
    <%
        List<Model.Package> packages = (List<Model.Package>) request.getAttribute("membership_packages");
        for (Model.Package pkg : packages) {
    %>
    <div class="membership-card ">
        <div class="membership-card__duration"><%= pkg.getName()%></div> <!-- Tên gói -->
        <div class="membership-card__price"><%= pkg.getPrice()%><sup>₫</sup> <span class="membership-card__price-unit">/ Month</span></div>
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
