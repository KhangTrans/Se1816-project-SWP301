<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/View/admin/blogs/create.jsp" %>
<%@include file="/WEB-INF/View/admin/blogs/edit.jsp" %>
<%@include file="/WEB-INF/View/admin/blogs/delete.jsp" %>


<div class="table-container" id="blogTable">
    <div class="table-container__header">
        <h2 class="table-container__title">Blogs List</h2>
        <p class="table-container__description">Manage Blogs</p>
    </div>
    <div class="table-container__content" style="overflow-x: auto;">
        <button class="add-button" onclick="openAddBlogModal()">+ Add Blog</button>
        <table class="data-table" id="blogsTable">
            <thead>
                <tr>
                    <th>No</th>
                    <th>Image</th>
                    <th>Title</th>
                    <th>Content</th>
                    <th>Created At</th>
                    <th>Updated At</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <!-- Dữ liệu sẽ được thêm bằng JS -->
            </tbody>
        </table>
    </div>
</div>
