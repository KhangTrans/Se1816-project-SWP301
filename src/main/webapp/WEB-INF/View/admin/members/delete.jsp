<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="deleteCustomerModal" class="modal" style="display:none;">
    <div class="modal-content">
        <h2>Confirm Delete</h2>
        <p>Are you sure you want to delete this customer?</p>

        <form id="deleteCustomerForm"
              onsubmit="return submitFormAjax(this, 'resultDeleteProduct')"
              method="post" action="<%= request.getContextPath()%>/admin/customer">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" id="deleteCustomerId" name="customerId">

            <div style="margin-top: 20px; text-align: right;">
                <button type="button" onclick="closeModal('deleteCustomerModal')">Cancel</button>
                <button type="submit">Delete</button>
            </div>

            <div id="resultDeleteCustomer" style="margin-top: 10px; color: red;"></div>
        </form>

    </div>
</div>
