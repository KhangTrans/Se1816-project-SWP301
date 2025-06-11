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
                <%                    int rowIndex = 1;
                    for (Products p : products) {
                %>
                <tr>
                    <td><%= rowIndex++%></td>
                    <td >
                        <%
                            Model.Product_Images img = productDao.getPrimaryImage(p.getProductId());
                            String productImage = (img != null)
                                    ? (request.getContextPath() + "/ImagesServlet?type=product&imageId=" + img.getImageId())
                                    : (request.getContextPath() + "/avatar/default.png");
                        %>
                        <img src="<%= productImage%>" alt="Product Image" style="width:60px;height:60px;border-radius:10px; margin-top: 5px">
                    </td>
                    <td><%= p.getName()%></td>
                    <td><%= p.getDescription()%></td>
                    <td>$<%= p.getPrice()%></td>
                    <td><%= p.getStockQuantity()%></td>
                    <td><%= p.isActive() ? "Active" : "Inactive"%></td>
                    <td>
                        <button class="action-buttons__btn action-buttons__btn--edit" 
                                onclick="openEditProductModal(
                                                '<%= p.getProductId()%>',
                                                '<%= p.getName()%>',
                                                '<%= p.getDescription()%>',
                                                '<%= p.getPrice()%>',
                                                '<%= p.getStockQuantity()%>',
                                                '<%= p.getCategoryId()%>',
                                                '<%= request.getContextPath()%>/ImagesServlet?type=product&imageId=<%= img != null ? img.getImageId() : 0%>'
                                                                )">
                            Edit
                        </button>


                        <button class="action-buttons__btn action-buttons__btn--delete"
                                onclick="openDeleteProductModal('<%= p.getProductId()%>')">
                            Delete
                        </button>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</div>
