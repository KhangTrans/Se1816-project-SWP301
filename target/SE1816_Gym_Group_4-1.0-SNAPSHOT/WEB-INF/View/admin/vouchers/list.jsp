<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Voucher"%>
<%@page import="DAO.VoucherDao"%>

<%
    VoucherDao vochers = new VoucherDao();
    List<Voucher> vouchers = vochers.getAllVouchers();
%>

<%@include file="/WEB-INF/View/admin/vouchers/create.jsp" %>
<%@include file="/WEB-INF/View/admin/vouchers/edit.jsp" %>
<%@include file="/WEB-INF/View/admin/vouchers/delete.jsp" %>



<div class="table-container" id="vouchersTable">
    <div class="table-container__header">
        <h2 class="table-container__title">Voucher List</h2>
        <p class="table-container__description">Manage vouchers</p>
        <div style="margin-bottom: 20px; display: flex; gap: 20px; align-items: end; justify-content: flex-end;">
            <select id="statusFilter" onchange="loadVouchers()" 
                    style="padding: 8px; border: 1px solid #ccc; border-radius: 5px;">
                <option value="">All Status</option>
                <option value="active">Active</option>
                <option value="inactive">Inactive</option>
            </select>

            <input type="date" id="startDate" onchange="loadVouchers()" 
                   style="padding: 8px; border: 1px solid #ccc; border-radius: 5px;" placeholder="Start Date" />
            <input type="date" id="endDate" onchange="loadVouchers()" 
                   style="padding: 8px; border: 1px solid #ccc; border-radius: 5px;" placeholder="End Date" />
            <div style="position: relative;">
                <input type="text" id="searchVoucher" placeholder="Search code or description..." 
                       onkeyup="loadVouchers()" 
                       style="padding: 8px 30px 8px 10px; border: 1px solid #ccc; border-radius: 5px;" />
                <i class="fa fa-search" style="position: absolute; right: 10px; top: 10px; color: #999;"></i>
            </div>
        </div>
    </div>
    <div class="table-container__content" style="overflow-x: auto;">
        <button class="add-button" onclick="openModal('addVoucherModal')">+ Add Voucher</button>
        <table class="data-table" id="voucherTable">
            <thead>
                <tr>
                    <th style="width: 50px">No</th>
                    <th>Code</th>
                    <th style="width: 100px">Description</th>
                    <th  style="width: 100px">Discount(%)</th>
                    <th>Max Discount</th>
                    <th>Usage Limit</th>
                    <th>Used Count</th>
                    <th>Min Order Amount</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Active</th>
                    <th style="width: 150px">Action</th>
                </tr>
            </thead>
            <tbody id="voucherTableBody">

            </tbody>
        </table>
    </div>
</div>