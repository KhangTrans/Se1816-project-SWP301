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
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">                       
        <link rel="icon" href="${pageContext.request.contextPath}/avatar/GYMVIETNAM.png" type="image/png">
        <%
            String contextPath = request.getContextPath();
        %>
        <link rel="stylesheet" href="<%= contextPath%>/css/Admin.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    </head>
    <body>