<%@page import="java.util.List"%>
<%@ page import="Model.Categories" %>
<div class="modal" id="addProductModal" style="display:none;">
    <div class="modal-content">
        <form method="post" action="${pageContext.request.contextPath}/admin/products" 
              enctype="multipart/form-data" 
              onsubmit="return submitFormAjax(this, 'resultAddProduct')">
            <input type="hidden" name="formAction" value="create">
            <div class="modal__header">
                <h2 class="modal__title">Add Product</h2>
                <button type="button" class="modal__close" onclick="closeModal('addProductModal')">&times;</button>
            </div>
            <div class="modal__body">
                <div class="modal__form-group">
                    <label class="modal__label">Name</label>
                    <input type="text" name="name" class="modal__input" required>
                </div>
                <div class="modal__form-group">
                    <label class="modal__label">Description</label>
                    <textarea name="description" class="modal__textarea"></textarea>
                </div>
                <div class="modal__form-group">
                    <label class="modal__label">Price</label>
                    <input type="number" name="price" class="modal__input" step="0.01" min ="50000" max="9999999" required>
                </div>
                <div class="modal__form-group">
                    <label class="modal__label">Stock Quantity</label>
                    <input type="number" name="stockQuantity" class="modal__input" min ="1" max="9999" required>
                </div>
                <div class="modal__form-group">
                    <label class="modal__label">Category</label>
                    <select name="categoryId" class="modal__input" required>
                        <%
                            List<Categories> categoryList = (List<Categories>) request.getAttribute("categories");
                            if (categoryList != null && !categoryList.isEmpty()) {
                                for (Categories cat : categoryList) {
                        %>
                        <option value="<%=cat.getCategory_id()%>"><%=cat.getName()%></option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>


                <div class="modal__form-group">
                    <label class="modal__label">Images</label>
                    <input type="file" name="images" accept=".jpg, .png" class="modal__input" multiple required>
                </div>
                <div id="resultAddProduct"></div>
            </div>
            <div class="modal__footer">
                <button type="submit" class="modal__btn modal__btn--primary">Save</button>
                <button type="button" class="modal__btn modal__btn--secondary" onclick="closeModal('addProductModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>