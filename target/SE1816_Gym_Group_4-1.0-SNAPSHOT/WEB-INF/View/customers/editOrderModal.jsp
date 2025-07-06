<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Edit Order Modal -->
<div class="modal" id="editOrderModal">
    <div class="modal-content">
        <div class="modal-header">
            <h2>Edit order</h2>
            <span class="modal-close" onclick="closeModal('editOrderModal')">&times;</span>
        </div>
        <div class="modal-body">
            <form id="editOrderForm" action="${pageContext.request.contextPath}/historyorder/update" method="post" 
                  onsubmit="return submitEditOrder(this)">
                <input type="hidden" id="editOrderId" name="orderId">
                
                <div class="form-group">
                    <label for="editReferralCode">Referral Code:</label>
                    <input type="text" id="editReferralCode" name="referralCode" readonly>
                </div>
                
                <div class="form-group">
                    <label for="productNameDisplay">Product Name:</label>
                    <input type="text" id="productNameDisplay" readonly>
                </div>
                
                <div class="form-group">
                    <label for="editOrderQuantity">Quantity:</label>
                    <input type="number" id="editOrderQuantity" name="quantity" readonly>
                </div>
                
                <div class="form-group" style="display: block !important; visibility: visible !important;">
                    <label for="editOrderPrice">Price:</label>
                    <input type="text" id="editOrderPrice" name="price" value="$350.00" readonly style="display: block !important; visibility: visible !important; width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px;">
                </div>
                
                <div class="form-group">
                    <label for="editStatus">Status:</label>
                    <input type="text" id="editStatus" name="status" readonly>
                </div>
                
                <div class="form-group">
                    <label for="editShippingAddress">Address:</label>
                    <input type="text" id="editShippingAddress" name="shippingAddress" required>
                </div>
                
                <div class="form-group">
                    <label for="editCustomerName">Customer Name:</label>
                    <input type="text" id="editCustomerName" name="customerName" required>
                </div>
                
                <div class="form-group">
                    <label for="editCustomerPhone">Phone:</label>
                    <input type="text" id="editCustomerPhone" name="customerPhone" required>
                </div>
                
                <div id="resultEditOrder" class="form-result"></div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Save</button>
                    <button type="button" class="btn btn-secondary" onclick="closeModal('editOrderModal')">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div> 