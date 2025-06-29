<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@include file="/WEB-INF/View/admin/accounts/create.jsp" %>
<%@include file="/WEB-INF/View/admin/accounts/edit.jsp" %>
<%@include file="/WEB-INF/View/admin/accounts/delete.jsp" %>

<div class="table-container" id="accountTable">
    <div class="table-container__header">
        <h2 class="table-container__title">Account List</h2>
        <p class="table-container__description">Manage user accounts</p>
        <div style="margin-bottom: 20px; display: flex; gap: 20px; align-items: end; justify-content: flex-end;">
            <select id="roleFilter" onchange="loadAccounts()" 
                    style="padding: 8px; border: 1px solid #ccc; border-radius: 5px;">
                <option value="">All Roles</option>
                <option value="admin">Admin</option>
                <option value="staff">Staff</option>
                <option value="trainer">Trainer</option>
                <option value="customer">Customer</option>
            </select>

            <input type="date" id="fromDate" onchange="loadAccounts()" 
                   style="padding: 8px; border: 1px solid #ccc; border-radius: 5px;" />
            <input type="date" id="toDate" onchange="loadAccounts()" 
                   style="padding: 8px; border: 1px solid #ccc; border-radius: 5px;" />
            <div style="position: relative;">
                <input type="text" id="searchInput" placeholder="Search username..." 
                       onkeyup="loadAccounts()" 
                       style="padding: 8px 30px 8px 10px; border: 1px solid #ccc; border-radius: 5px;" />
                <i class="fa fa-search" style="position: absolute; right: 10px; top: 10px; color: #999;"></i>
            </div>
        </div>
    </div>

    <div class="table-container__content" style="overflow-x: auto;">
        <button class="add-button" onclick="openModal('addAccountModal')">+ Add Account</button>
        <table class="data-table">
            <thead>
                <tr>
                    <th style="width: 50px">No</th>
                    <th>Avatar</th>
                    <th>Username</th>
                    <th>Role</th>
                    <th>Created At</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody id="accountTableBody">
                <%-- DỮ LIỆU SẼ ĐƯỢC FETCH BẰNG AJAX QUA HÀM loadAccounts() --%>
            </tbody>
        </table>
    </div>
</div>
