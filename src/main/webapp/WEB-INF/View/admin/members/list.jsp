<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/View/admin/members/create.jsp" %>
<%@include file="/WEB-INF/View/admin/members/edit.jsp" %>
<%@include file="/WEB-INF/View/admin/members/delete.jsp" %>
<div class="table-container" id="customersTable">
    <div class="table-container__header">
        <h2 class="table-container__title">Member List</h2>
        <p class="table-container__description">Manage member information</p>
    </div>

    <div class="table-container__content" style="overflow-x:auto;">
<button class="add-button" onclick="openModal('addCustomerModal')">+ Add Member</button>
        <table class="data-table" id="customerTable">
            <thead>
                <tr>
                    <th>No</th>
                    <th>Avatar</th>
                    <th>Username</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Customer Code</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <!-- D? li?u s? ???c JS fill ? ?ây -->
            </tbody>
        </table>
    </div>
</div>
