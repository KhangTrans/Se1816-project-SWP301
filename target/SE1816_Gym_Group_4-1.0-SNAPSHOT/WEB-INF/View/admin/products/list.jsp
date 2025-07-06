<%@page import="DAO.CategoryDao"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Model.Products"%>
<%@page import="DAO.ProductDao"%>
<%
    //ProductDao productDao = new ProductDao();
//    List<Products> products = productDao.getAllProducts(); 
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
        <!-- Form tìm kiếm và lọc sản phẩm -->
        <form id="productFilterForm" onsubmit="event.preventDefault(); reloadProductList();" class="row g-2 mb-3 d-flex justify-content-end">
            <!-- Ô tìm kiếm -->
            <div class="col-md-5">
                <input type="text" id="searchKeyword" class="form-control" placeholder="Search product...">
            </div>

            <!-- Dropdown thể loại -->
            <div class="col-md-5">
                <select id="categoryFilter" class="form-select">
                    <option value="">---All Category---</option>
                    <% for (Categories category : categories) {%>
                    <option value="<%= category.getCategory_id()%>"><%= category.getName()%></option>
                    <% }%>
                </select>
            </div>

            <!-- Nút tìm kiếm có icon -->
            <div class="col-md-1 d-flex align-items-center">
                <button type="submit" class="btn btn-success btn-sm d-flex align-items-center justify-content-center"
                        style="width: 34px; height: 34px; padding: 0; margin-left: 20px">
                    <i class="bi bi-search"></i>
                </button>
            </div>

        </form>


    </div>

    <div class="table-container__content" style="overflow-x: auto;">
        <button class="add-button" onclick="openModal('addProductModal')">+ Add Product</button>
        <table class="data-table "  id="productTable">
            <thead>
                <tr>
                    <th style="width: 50px">No</th>
                    <th>Image</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th>Description</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%-- dữ liệu sẽ được fill bằng JS/AJAX qua reloadProductList() --%>
            </tbody>
        </table>
    </div>
</div>

