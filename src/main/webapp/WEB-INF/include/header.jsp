<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="jakarta.servlet.http.HttpSession"%>
<%@page import="jakarta.servlet.http.HttpServletRequest"%>
<%
    String username = null;
    String avatar = null;
    if (session != null) {
        username = (String) session.getAttribute("username");
        avatar = (String) session.getAttribute("avatar");
    }
%>
<!-- Header -->
<style>
    .cart-count-badge {
        position: absolute;
        top: 0;
        right: 0;
        background-color: red;
        color: white;
        font-size: 12px;
        padding: 0px 2px;
        border-radius: 50%;
    }
</style>
<header>
    <nav class="navbar navbar-expand-lg fixed-top custom-header"
         style="background-color: rgba(217, 255, 104, 0.6);">
        <div class="container-fluid">
            <a class="navbar-brand" href="<%= request.getContextPath()%>/homepage" style="color: #111">GYM VIETNAM</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/homepage">Home</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/shopAll">Product</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">About</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Contact</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/blogPage">Blogs</a></li>
                    <li class="nav-item">
                        <a class="nav-link position-relative" href="<%= request.getContextPath()%>/CartServlet?action=view">
                            <i class="fa-solid fa-cart-shopping"></i>     
                            <%

                                Object cartCountObj = session.getAttribute("cartCount");
                                int cartCount = cartCountObj != null ? (int) cartCountObj : 0;
                            %>

                            <% if (cartCount > 0) {%>
                            <span class="cart-count-badge">
                                <%= cartCount > 99 ? "99+" : cartCount%>
                            </span>
                            <% } %>                            
                        </a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center"
                           href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <% if (username != null) { %>
                            <%
                                String avatarSrc;
                                if (session.getAttribute("username") != null) {
                                    avatarSrc = request.getContextPath() + "/AvatarServlet?user=" + session.getAttribute("username");
                                } else if (session.getAttribute("avatar") != null) {
                                    avatarSrc = (String) session.getAttribute("avatar");
                                } else {
                                    avatarSrc = request.getContextPath() + "/img/avatar/default.png";
                                }
                            %>
                            <img src="<%= avatarSrc%>" class="rounded-circle" width="30" height="30">
                            <span class="ms-2"><%= username%></span>
                            <% } else { %>
                            Account
                            <% } %>
                        </a>

                        <ul class="dropdown-menu dropdown-menu-end bg-transparent border-0 mt-3">
                            <% if (username != null) {%>
                            <li><a class="btn w-100 mb-2" href="${pageContext.request.contextPath}/profile">Profile</a></li>
                            <li class="btn w-100 mb-2"><a style="text-decoration: none; color: #333" href="<%= request.getContextPath()%>/FavoriteListServlet?page=1">
                                    <i class="fa fa-heart"></i>
                                    <span> My Favorite</span></a>
                            </li>
                            <li><a class="btn w-100" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                                <% } else { %>
                            <li>
                                <button type="button"
                                        class="btn w-100 mb-2"
                                        data-bs-toggle="modal"
                                        data-bs-target="#signupModal">
                                    Sign Up
                                </button>
                            </li>
                            <li>
                                <button type="button"
                                        class="btn w-100"
                                        data-bs-toggle="modal"
                                        data-bs-target="#loginModal">
                                    Sign In
                                </button>
                            </li>
                            <% }%>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</header>
