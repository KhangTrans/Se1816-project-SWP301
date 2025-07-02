<%-- 
    Document   : edit
    Created on : Jun 27, 2025, 9:53:37 PM
    Author     : Khaang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Edit Order Modal -->
<div class="modal" id="editOrderModal">
    <div class="modal-content">
        <div class="modal-header">
            <h2>Edit Order</h2>
            <span class="modal-close" onclick="closeModal('editOrderModal')">&times;</span>
        </div>
        <div class="modal-body">
            <form id="editOrderForm" action="<%= request.getContextPath()%>/admin/orders" method="post" 
                  onsubmit="return submitEditOrder(this)">
                <input type="hidden" id="editOrderId" name="orderId">
                <input type="hidden" name="formAction" value="editOrder">
                
                <div class="form-group">
                    <label for="editReferralCode">Referral Code:</label>
                    <input type="text" id="editReferralCode" name="referralCode" readonly>
                </div>
                
                <div class="form-group">
                    <label for="productNameDisplay">Product Name:</label>
                    <input type="text" id="productNameDisplay" readonly>
                    <input type="hidden" id="hiddenOrderItemId" name="orderItemId">
                </div>
                
                <div class="form-group">
                    <label for="editOrderQuantity">Quantity:</label>
                    <input type="number" id="editOrderQuantity" name="quantity" min="1" required onchange="updateTotalPrice()">
                </div>
                
                <div class="form-group">
                    <label for="editStatus">Status:</label>
                    <select id="editStatus" name="status" required>
                        <option value="pending">Pending</option>
                        <option value="processing">Processing</option>
                        <option value="shipped">Shipped</option>
                        <option value="cancelled">Cancelled</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="editShippingAddress">Shipping Address:</label>
                    <input type="text" id="editShippingAddress" name="shippingAddress" required>
                </div>
                
                <div class="form-group">
                    <label for="editCustomerName">Customer Name:</label>
                    <input type="text" id="editCustomerName" name="customerName" required>
                </div>
                
                <div class="form-group">
                    <label for="editCustomerPhone">Phone:</label>
                    <input type="text" id="editCustomerPhone" name="customerPhoneNumber">
                </div>
                
                <div class="form-group">
                    <label for="editOrderNote">Note:</label>
                    <textarea id="editOrderNote" name="note"></textarea>
                </div>
                
                <div id="resultEditOrder" class="form-result"></div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                    <button type="button" class="btn btn-secondary" onclick="closeModal('editOrderModal')">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div>
