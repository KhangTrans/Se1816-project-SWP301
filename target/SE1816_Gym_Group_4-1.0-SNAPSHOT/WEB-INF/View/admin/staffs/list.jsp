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
        <div class="row g-2 mb-3 align-items-end d-flex justify-content-end">
            <div class="col-md-4">
                <input type="text" id="searchStaff" class="form-control" placeholder="Search by full name or username">
            </div>

            <div class="col-md-4">
                <input type="text" id="searchPhone" class="form-control" placeholder="Search by phone number">
            </div>

            <div class="col-md-3">
                <select id="staffFilter" class="form-select">
                    <option value="">Select status</option>
                    <option value="active">Active</option>
                    <option value="inactive">Inactive</option>
                </select>
            </div>
        </div>

    </div>

    <div class="table-container__content" style="overflow-x: auto;">
        <button class="add-button" onclick="openModal('addStaffModal')">+ Add Staff</button>
        <table class="data-table" id="staffsTable">
            <thead>
                <tr>
                    <th style="width: 50px">No</th>
                    <!--                    <th>Account ID</th>-->
                    <th>Avatar</th>
                    <th>Username</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Position</th>
                    <th>Status</th>
                    <th>Staff Code</th>
                    <th style="width: 150px">Action</th>
                </tr>
            </thead>
            <tbody>

            </tbody>
        </table>
    </div>
</div>




