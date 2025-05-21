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
            <a class="navbar-brand" href="#" style="color: #ff7f00">Ô Tô Việt</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item"><a class="nav-link" href="#">Trang chủ</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Giới thiệu</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Liên hệ</a></li>

                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center"
                           href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <% if (username != null) {%>
                            <%
                                String avatarPath = (avatar != null && !avatar.isEmpty()) ? avatar : "/img/avatar/default.png";
                                boolean isAbsoluteUrl = avatarPath.startsWith("http://") || avatarPath.startsWith("https://");
                                String finalAvatarUrl = isAbsoluteUrl ? avatarPath : request.getContextPath() + avatarPath;
                            %>
                            <img src="<%= finalAvatarUrl%>" class="rounded-circle" width="30" height="30" alt="Avatar">

                            <span class="ms-2"><%= username%></span>
                            <% } else { %>
                            Tài khoản
                            <% } %>
                        </a>

                        <ul class="dropdown-menu dropdown-menu-end">
                            <% if (username != null) { %>
                            <li><a class="dropdown-item" href="#">Thông tin cá nhân</a></li>
                            <li><a class="dropdown-item" href="/SE1816_Oto_Group_4/logout">Đăng xuất</a></li>
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
