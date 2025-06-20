<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Model.Staff"%>

<%
    List<Staff> list = (List<Staff>) request.getAttribute("staffList");
    if (list == null) {
        list = new java.util.ArrayList<>();
    }
%>


<%@include file="/WEB-INF/View/admin/staffs/create.jsp" %>
<%@include file="/WEB-INF/View/admin/staffs/edit.jsp" %>
<%@include file="/WEB-INF/View/admin/staffs/delete.jsp" %>

<div class="table-container" id="staffsTable">
    <div class="table-container__header">
        <h2 class="table-container__title">Staff List</h2>
        <p class="table-container__description">Manage staff information</p>
    </div>

    <div class="table-container__content" style="overflow-x: auto;">
        <button class="add-button" onclick="openModal('addStaffModal')">+ Add Staff</button>
        <table class="data-table" id="staffsTable">
            <thead>
                <tr>
                    <th>No</th>
<!--                    <th>Account ID</th>-->
                    <th>Avatar</th>
                    <th>Username</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Position</th>
                    <th>Status</th>
                    <th>Staff Code</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
               
            </tbody>
        </table>
    </div>
</div>




