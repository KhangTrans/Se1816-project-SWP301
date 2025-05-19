<%-- 
    Document   : shop
    Created on : Jun 6, 2025, 10:59:47 AM
    Author     : Le Nguyen Hoang Khang - CE191583
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Shop All</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        .search-bar { margin-bottom: 20px; }
        .product-card {
            border: 1px solid #ddd; padding: 10px; border-radius: 6px; margin-bottom: 15px;
        }
        .product-image { width: 120px; height: 120px; object-fit: cover; }
    </style>
</head>
<body>

<h1>Shop All</h1>

<form action="shop" method="get" class="search-bar">
    <input type="text" name="search" placeholder="Tìm sản phẩm..." value="${param.search}" />
    <select name="category">
        <option value="">Categories</option>
        <option value="Whey" ${param.category == 'Whey' ? 'selected' : ''}>Whey</option>
        <option value="Creatine" ${param.category == 'Creatine' ? 'selected' : ''}>Creatine</option>
        <option value="Phụ kiện" ${param.category == 'Phụ kiện' ? 'selected' : ''}>Phụ kiện</option>
    </select>
    <button type="submit">Search</button>
</form>

<c:forEach var="product" items="${productList}">
    <div class="product-card">
        <h3>${product.name}</h3>
        <p>Giá: ${product.price}₫</p>
        <p>Danh mục: ${product.categoryName}</p>
        <img src="${product.imageUrl}" class="product-image" alt="${product.name}" />
        <p>${product.description}</p>
    </div>
</c:forEach>

</body>
</html>
