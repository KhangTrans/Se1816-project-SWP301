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
<!DOCTYPE html>

<!-- Header -->
<header>
    <nav class="navbar navbar-expand-lg fixed-top custom-header">
        <div class="container-fluid">
            <a class="navbar-brand" href="#" style="color: #111">GYM VIETNAM</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item"><a class="nav-link" style="color: #111" href="#">Home</a></li>
                    <li class="nav-item"><a class="nav-link" style="color: #111" href="#">About</a></li>
                    <li class="nav-item"><a class="nav-link" style="color: #111" href="#">Shop All</a></li>

                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center" style="color: #111"
                           href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <% if (username != null) {%>
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
                            Tài khoản
                            <% } %>
                        </a>

                        <ul class="dropdown-menu dropdown-menu-end">
                            <% if (username != null) { %>
                            <li><a class="dropdown-item" href="#">Thông tin cá nhân</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                                <% } else { %>
                            <li>
                                <button type="button"
                                        class="btn btn-primary w-100 mb-2"
                                        data-bs-toggle="modal"
                                        data-bs-target="#signupModal">
                                    Đăng ký
                                </button>
                            </li>
                            <li>
                                <button type="button"
                                        class="btn btn-primary w-100"
                                        data-bs-toggle="modal"
                                        data-bs-target="#loginModal">
                                    Đăng nhập
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
