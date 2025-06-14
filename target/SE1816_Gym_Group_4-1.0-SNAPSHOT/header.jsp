<%-- 
    Document   : header
    Created on : May 20, 2025, 10:57:19 PM
    Author     : Khaang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="./css/styles.css">
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="header__container">
                <!-- Logo -->
                <div class="header__logo">
                    <img src="logo.png" alt="Logo"
                         class="header__logo-img" />
                    <span class="header__brand">GYM VIETNAM</span>
                </div>

                <!-- Navigation -->
                <nav class="header__nav">
                    <a href="#SanPhamNoiBat" class="header__link">About</a>
                    <a href="#" class="header__link">Home</a>
                    <a href="#" class="header__link">Shop All</a>
                </nav>

                <!-- Icons -->
                <div class="header__icons">
                    <button class="header__iconlist">
                        <img src="./img/Icon Search.svg" alt="Search">
                    </button>

                    <button class="header__iconlist header__iconlist--cart">
                        <img src="./img/icon cart.svg" alt="Logo">
                    </button>

                    <div class="header__user">
                        <button class="header__avatar" id="userButton">
                            <img src="./img/Icon User.svg" alt="User Icon">
                        </button>

                        <ul class="user-dropdown" id="userDropdown">
                            <li><a href="login.jsp">Đăng nhập</a></li>
                            <li><a href="register.jsp">Đăng ký</a></li>
                        </ul>
                    </div>

                    <!-- <img src="./img/Icon User.svg" alt="User Avatar"
                    class="header__avatar" /> -->
                </div>
            </div>
        </header>
        <script src="js/script.js"></script>

    </body>
</html>
