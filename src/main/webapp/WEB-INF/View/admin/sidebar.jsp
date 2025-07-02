<%@page import="java.util.List"%>
<%@page import="Model.Account"%>
<%@page import="DAO.UserDao"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<nav class="sidebar">
    <%
        Account accs = (Account) session.getAttribute("account");
        if (accs != null) {
    %>
    <div class="sidebar__header">
        <div class="sidebar__user">
            <div class="sidebar__avatar">
                <img src="${pageContext.request.contextPath}/AvatarServlet?user=<%= accs.getUsername()%>" alt="Avatar" style="width:40px;height:40px;border-radius:50%;">
            </div>
            <div class="sidebar__greeting">
                WELCOME<br>
                <span class="sidebar__admin-name" id="adminName"><%= accs.getUsername()%></span>
            </div>
        </div>
    </div>
    <%}%>
    <ul class="sidebar__nav">
        <li class="sidebar__nav-item">
            <a class="sidebar__nav-link sidebar__nav-link" href="#" onclick="AdminDashboard.showTable('accountTable')"> 
                <i class="fas fa-user-circle"></i>
                Accounts
            </a>
        </li>
        <li class="sidebar__nav-item">
            <a class="sidebar__nav-link" href="#" onclick="AdminDashboard.showTable('staffsTable')">
                <i class="fas fa-briefcase"></i> 
                Staff
            </a>
        </li>
        <li class="sidebar__nav-item">
            <a class="sidebar__nav-link" href="#" onclick="AdminDashboard.showTable('trainersTable')">
                <i class="fas fa-user-tie"></i>
                Trainers
            </a>
        </li>
        <li class="sidebar__nav-item">
            <a class="sidebar__nav-link" href="#" onclick="AdminDashboard.showTable('customersTable')"> 
                <i class="fas fa-users"></i>
                Members
            </a>
        </li>
        <li class="sidebar__nav-item">
            <a class="sidebar__nav-link" href="#" onclick="AdminDashboard.showTable('productsTable')">
                <i class="fas fa-dumbbell"></i>
                Products
            </a>
        </li>
        <li class="sidebar__nav-item">
            <a class="sidebar__nav-link" href="#" onclick="AdminDashboard.showTable('vouchersTable')">
                <i class="fas fa-ticket-alt"></i>
                Vouchers
            </a>
        </li>


        <li class="sidebar__nav-item">
            <a class="sidebar__nav-link" href="#" onclick="AdminDashboard.showTable('blogTable')">
                <i class="fas fa-blog"></i>
                Blogs
            </a>
        </li>
        <li class="sidebar__nav-item">
            <a class="sidebar__nav-link" href="#" onclick="AdminDashboard.showTable('loginLogsTable')">
                <i class="fas fa-history"></i>
                Login Logs
            </a>
        </li>
        <li class="sidebar__nav-item">
            <a class="sidebar__nav-link" href="#" onclick="AdminDashboard.showTable('ordersTable')">
                <i class="fas fa-ticket-alt"></i>
                Orders
            </a>
        </li>

        <li class="sidebar__nav-item">
            <a class="sidebar__nav-link" href="#" onclick="AdminDashboard.showTable('packagesTable')">
                <i class="fas fa-eye"></i>
                View Packages
            </a>
        </li>
        <li class="sidebar__nav-item">
            <a class="sidebar__nav-link" href="#" onclick="AdminDashboard.showTable('memberPackagesTable')">
                <i class="fas fa-user-check"></i>
                Member Packages
            </a>
        </li>
        <li class="sidebar__nav-item">
            <form method="post" action="LogoutServlet">
                <button type="submit" class="sidebar__nav-link">
                    <i class="fas fa-sign-out-alt"></i> LOGOUT
                </button>
            </form>
        </li>


</nav>
