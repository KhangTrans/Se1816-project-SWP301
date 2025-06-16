<%-- 
    Document   : headAdmin
    Created on : May 23, 2025, 2:47:40 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin</title>
        <link rel="icon" href="${pageContext.request.contextPath}/avatar/GYMVIETNAM.png" type="image/png">
        <%
            String contextPath = request.getContextPath();
        %>
        <link rel="stylesheet" href="<%= contextPath%>/css/Admin.css">
    </head>
    <body>