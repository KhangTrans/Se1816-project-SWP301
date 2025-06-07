<%@page contentType="text/html" pageEncoding="UTF-8"%>
<nav class="sidebar">
    <div class="sidebar__header">
        <div class="sidebar__user">
            <div class="sidebar__avatar">A</div>
            <div class="sidebar__greeting">
                WELCOME<br>
                <span class="sidebar__admin-name" id="adminName">ADMIN</span>
            </div>
        </div>
    </div>

    <ul class="sidebar__nav">
        <li class="sidebar__nav-item">
            <a class="sidebar__nav-link" href="admin.jsp">Dashboard</a>
        </li>
        <li class="sidebar__nav-item">
            <a class="sidebar__nav-link" href="accountlist.jsp">Accounts</a>
        </li>
        <!-- Add more links for products.jsp, orders.jsp, etc. -->
    </ul>

    <form method="post" action="LogoutServlet">
        <button type="submit" class="sidebar__logout">LOGOUT</button>
    </form>
</nav>
