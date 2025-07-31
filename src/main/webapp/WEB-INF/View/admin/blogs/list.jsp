<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/View/admin/blogs/create.jsp" %>
<%@include file="/WEB-INF/View/admin/blogs/edit.jsp" %>
<%@include file="/WEB-INF/View/admin/blogs/delete.jsp" %>


<div class="table-container" id="blogTable">
    <div class="table-container__header">
        <h2 class="table-container__title">Blogs List</h2>
        <p class="table-container__description">Manage Blogs</p>
        <div style="margin-bottom: 20px; display: flex; gap: 20px; align-items: end; justify-content: flex-end;">
            <!--            <select id="statusFilter" onchange="loadVouchers()" 
                                style="padding: 8px; border: 1px solid #ccc; border-radius: 5px;">
                            <option value="">All Status</option>
                            <option value="active">Active</option>
                            <option value="inactive">Inactive</option>
                        </select>-->

            <input type="date" id="blogStartDate" onchange="reloadBlogList()" 
                   style="padding: 8px; border: 1px solid #ccc; border-radius: 5px;" placeholder="Start Date" />
            <input type="date" id="blogEndDate" onchange="reloadBlogList()" 
                   style="padding: 8px; border: 1px solid #ccc; border-radius: 5px;" placeholder="End Date" />
            <div style="position: relative;">
                <input type="text" id="searchBlog" placeholder="Search code or description..." 
                       onkeyup="reloadBlogList()" 
                       style="padding: 8px 30px 8px 10px; border: 1px solid #ccc; border-radius: 5px;" />
                <i class="fa fa-search" style="position: absolute; right: 10px; top: 10px; color: #999;"></i>
            </div>
        </div>
    </div>

    <div class="table-container__content" style="overflow-x: auto;">
        <button class="add-button" onclick="openAddBlogModal()">+ Add Blog</button>
        <table class="data-table" id="blogsTable">
            <thead>
                <tr>
                    <th style="width: 50px">No</th>
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
