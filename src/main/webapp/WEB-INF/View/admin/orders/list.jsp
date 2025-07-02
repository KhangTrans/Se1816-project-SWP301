<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@include file="/WEB-INF/View/admin/orders/edit.jsp" %>
<%@include file="/WEB-INF/View/admin/orders/delete.jsp" %>

<style>
    .status-pending { background-color: #ffe6cc; color: #333; padding: 2px 8px; border-radius: 4px; }
    .status-processing { background-color: #cce5ff; color: #333; padding: 2px 8px; border-radius: 4px; }
    .status-shipped { background-color: #d4edda; color: #333; padding: 2px 8px; border-radius: 4px; }
    .status-cancelled { background-color: #f8d7da; color: #333; padding: 2px 8px; border-radius: 4px; }

    .status-dropdown {
        padding: 2px 8px;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-size: 14px;
        width: 100%;
        max-width: 150px;
    }
    .status-dropdown option {
        background-color: #fff;
        color: #333;
    }
</style>

<div class="table-container" id="ordersTable">
    <div class="table-container__header">
        <h2 class="table-container__title">Order List</h2>
        <p class="table-container__description">Manage order information</p>
        <div style="margin-bottom: 20px; display: flex; gap: 20px; align-items: end; justify-content: flex-end;">
            <select id="orderStatusFilter" onchange="loadOrders()" 
                    style="padding: 8px; border: 1px solid #ccc; border-radius: 5px;">
                <option value="">All Status</option>
                <option value="pending">Pending</option>
                <option value="processing">Processing</option>
                <option value="shipped">Shipped</option>
                <option value="cancelled">Cancelled</option>
            </select>

            <div style="position: relative;">
                <input type="text" id="searchOrder" placeholder="Search product, customer name or phone..." 
                       style="padding: 8px 30px 8px 10px; border: 1px solid #ccc; border-radius: 5px;" 
                       onkeyup="clearTimeout(window.orderSearchTimeout); window.orderSearchTimeout = setTimeout(loadOrders, 300);" />
                <i class="fa fa-search" style="position: absolute; right: 10px; top: 10px; color: #999;"></i>
            </div>
        </div>
    </div>

    <div class="table-container__content" style="overflow-x:auto;">
        <table class="data-table" id="orderTable">
            <thead>
                <tr>
                    <th style="width: 120px">Referral Code</th>
                    <th>Products Name</th>
                    <th>Quantity</th>
                    <th>Price</th>
                    <th>Status</th>
                    <th>Address</th>
                    <th>Customer Name</th>
                    <th>Phone</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody id="orderTableBody">
                <!-- Table content will be loaded dynamically via JavaScript -->
            </tbody>
        </table>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize status filter from URL parameters if available
        const urlParams = new URLSearchParams(window.location.search);
        const statusParam = urlParams.get('status');
        const searchParam = urlParams.get('search');
        
        if (statusParam) {
            document.getElementById('orderStatusFilter').value = statusParam;
        }
        
        if (searchParam) {
            document.getElementById('searchOrder').value = searchParam;
        }
        
        // Load orders with current filters
        loadOrders();
    });
</script>