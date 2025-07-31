<%@include file="/WEB-INF/View/admin/categori/create.jsp" %>
<%@include file="/WEB-INF/View/admin/categori/edit.jsp" %>

<div class="table-container" id="categoryTableSidebar">
    <div class="table-container__header">
        <h2 class="table-container__title">Category List</h2>
        <p class="table-container__description">Manage Category information</p>
        <div class="row g-2 mb-3 align-items-end d-flex justify-content-end">
            <div class="col-md-5">
                <input type="text" id="searchTermCategory" class="form-control" placeholder="Search by name" onkeyup="loadCategori()">
            </div>
        </div>
    </div>   
    <div class="table-container__content" style="overflow-x: auto;">
        <button class="add-button" onclick="openModal('addCategory')">+ Add Category</button>
        <table class="data-table" id="categoryTable">
            <thead>
                <tr>
                    <th style="width: 60px">No</th>
                    <th style="width: 90px">Category Name</th>
                    <th style="width: 150px">Description</th>
                    <th style="width: 50px">Action</th>
                </tr>
            </thead>
            <tbody id="categoryTableBody">
                <!-- Categories will be inserted here by JavaScript -->
            </tbody>
        </table>
    </div>        
</div>


