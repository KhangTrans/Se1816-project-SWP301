
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/View/admin/packages/create.jsp" %>
<%@include file="/WEB-INF/View/admin/packages/edit.jsp" %>
<%@include file="/WEB-INF/View/admin/packages/delete.jsp" %>


<div class="table-container" id="packagesTable">
    <div class="table-container__header">
        <h2 class="table-container__title">Packages List</h2>
        <p class="table-container__description">Manage Gym Packages</p>
        <input type="text" id="packageSearchInput"
               placeholder="Search by Package Name..."
               style="padding: 8px 30px 8px 10px; border: 1px solid #ccc; border-radius: 5px; margin-left: 75%">
    </div>
    <div class="table-container__content" style="overflow-x: auto;">
        <button class="add-button" onclick="openModal('addPackageModal')">+ Add Package</button>
        <table class="data-table" id="packagesTableData">
            <thead>
                <tr>
                    <th style="width: 50px">No</th>
                    <th>Package Name</th>
                    <th>Price</th>
                    <th>Duration (days)</th>
                    <th>Description</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <!-- Dữ liệu sẽ được render bằng JavaScript hoặc server-side -->
            </tbody>
        </table>
    </div>
</div>
