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
            <a class="sidebar__nav-link sidebar__nav-link" href="#" onclick="AdminDashboard.showTable('accountTable')">Accounts</a>
        </li>
        <li class="sidebar__nav-item">
            <a class="sidebar__nav-link" href="#" onclick="AdminDashboard.showTable('staffTable')">Staff</a>
        </li>
        <li class="sidebar__nav-item">
            <a class="sidebar__nav-link" href="#" onclick="AdminDashboard.showTable('productsTable')">Products</a>
        </li>
        
        <li class="sidebar__nav-item">
            <a class="sidebar__nav-link" href="#" onclick="AdminDashboard.showTable('trainersTable')">Trainers</a>
        </li>
    </ul>
    <form method="post" action="LogoutServlet">
        <button type="submit" class="sidebar__logout">LOGOUT</button>
    </form>
</nav>
