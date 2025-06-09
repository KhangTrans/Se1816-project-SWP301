<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/View/admin/headAdmin.jsp" %>
<div class="dashboard">
    <%@include file="/WEB-INF/View/admin/sidebar.jsp" %>
    <main class="main-content">
        <div class="main-content__header">
            <h1 class="main-content__title">Admin Dashboard</h1>
            <p class="main-content__subtitle">System and Data Management</p>
        </div>

        <%@include file="/WEB-INF/View/admin/accounts/list.jsp" %>
        <%@include file="/WEB-INF/View/admin/products/list.jsp" %>

    </main>
</div>

<%@include file="/WEB-INF/View/admin/footerAdmin.jsp" %>
