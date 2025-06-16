<div class="modal" id="deleteCustomerModal" style="display: none;">
    <div class="modal-content">
        <h2>Confirm Delete</h2>
        <p>Are you sure you want to delete this member?</p>

        <form method="get" action="${pageContext.request.contextPath}/admin/customers"
              onsubmit="return submitFormAjax(this, 'resultDeleteCustomer')">

            <input type="hidden" name="action" value="delete">
            <input type="hidden" id="deleteCustomerId" name="customerId">

            <button type="submit" class="delete-confirm">Delete</button>
            <button type="button" onclick="closeModal('deleteCustomerModal')">Cancel</button>
            
        </form>

        <div id="resultDeleteCustomer" style="margin-top: 10px;"></div>
    </div>
</div>
