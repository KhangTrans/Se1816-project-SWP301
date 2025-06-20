<%@page import="DAO.CategoryDao"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Model.Products"%>
<%@page import="DAO.ProductDao"%>
<%
    ProductDao productDao = new ProductDao();
    List<Products> products = productDao.getAllProducts(); // đảm bảo hàm này đã tồn tại trong ProductDao
    // **MỚI**: Load categories và đưa vào request
    CategoryDao categoryDao = new CategoryDao();
    List<Categories> categories = categoryDao.getAllCategories();
    request.setAttribute("categories", categories);
%>

<%@include file="/WEB-INF/View/admin/products/create.jsp" %>
<%@include file="/WEB-INF/View/admin/products/edit.jsp" %>
<%@include file="/WEB-INF/View/admin/products/delete.jsp" %>

<div class="table-container" id="productsTable">
    <div class="table-container__header">
        <h2 class="table-container__title">Product List</h2>
        <p class="table-container__description">Manage product information</p>
    </div>
    <div class="table-container__content" style="overflow-x: auto;">
        <button class="add-button" onclick="openModal('addProductModal')">+ Add Product</button>
        <table class="data-table"  id="productTable">
            <thead>
                <tr>
                    <th>No</th>
                    <th>Image</th>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%-- dữ liệu sẽ được fill bằng JS/AJAX qua reloadProductList() --%>
            </tbody>
        </table>
    </div>
</div>
