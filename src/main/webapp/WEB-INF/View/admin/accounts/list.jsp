<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@include file="/WEB-INF/View/admin/accounts/create.jsp" %>
<%@include file="/WEB-INF/View/admin/accounts/edit.jsp" %>
<%@include file="/WEB-INF/View/admin/accounts/delete.jsp" %>

<div class="table-container" id="accountTable">
    <div class="table-container__header">
        <h2 class="table-container__title">Account List</h2>
        <p class="table-container__description">Manage user accounts</p>
    </div>

    <div class="table-container__content" style="overflow-x: auto;">
        <button class="add-button" onclick="openModal('addAccountModal')">+ Add Account</button>
        <table class="data-table">
            <thead>
                <tr>
                    <th>No</th>
                    <th>Avatar</th>
                    <th>Username</th>
                    <th>Role</th>
                    <th>Created At</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%-- DỮ LIỆU SẼ ĐƯỢC FETCH BẰNG AJAX QUA HÀM loadAccounts() --%>
            </tbody>
        </table>
    </div>
</div>
