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
    </div>
    <div class="table-container__content" style="overflow-x: auto;">
        <button class="add-button" onclick="openModal('addVoucherModal')">+ Add Voucher</button>
        <table class="data-table" id="voucherTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Code</th>
                    <th>Description</th>
                    <th>Discount(%)</th>
                    <th>Max Discount</th>
                    <th>Usage Limit</th>
                    <th>Used Count</th>
                    <th>Min Order Amount</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Active</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
             
            </tbody>
        </table>
    </div>
</div>
