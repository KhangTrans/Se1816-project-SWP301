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
                <%
                    int indexv = 1;
                    for (Voucher voucher : vouchers) {
                %>
                <tr>
                    <td><%= indexv++%></td>
                    <td><%= voucher.getCode()%></td>
                    <td><%= voucher.getDescription()%></td>
                    <td><%= voucher.getDiscountPercent()%></td>
                    <td><%= voucher.getMaxDiscount()%></td>
                    <td><%= voucher.getUsageLimit()%></td>
                    <td><%= voucher.getUsedCount()%></td>
                    <td><%= voucher.getMinOrderAmount()%></td>
                    <td><%= voucher.getStartDate()%></td>
                    <td><%= voucher.getEndDate()%></td>
                    <td><%= voucher.isActive() ? "Active" : "Inactive"%></td>
                    <td>
                        <button class="action-buttons__btn action-buttons__btn--edit" 
                                onclick="openEditVoucherModal(
                                                '<%= voucher.getVoucherId()%>',
                                                '<%= voucher.getCode().replace("'", "\\'")%>',
                                                '<%= voucher.getDescription().replace("'", "\\'")%>',
                                                '<%= voucher.getDiscountPercent()%>',
                                                '<%= voucher.getMaxDiscount()%>',
                                                '<%= voucher.getUsageLimit()%>',
                                                '<%= voucher.getUsedCount()%>',
                                                '<%= voucher.getMinOrderAmount()%>',
                                                '<%= voucher.getStartDate()%>',
                                                '<%= voucher.getEndDate()%>',
                                                '<%= voucher.isActive() ? "true" : "false"%>'
                                                )">
                            Edit
                        </button>


                        <button class="action-buttons__btn action-buttons__btn--delete"
                                onclick="openDeleteVoucherModal(<%= voucher.getVoucherId()%>)">Delete
                        </button>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</div>
