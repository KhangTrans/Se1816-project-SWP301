<%-- 
    Document   : delete
    Created on : Jun 27, 2025, 9:53:22 PM
    Author     : Khaang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Delete Order Modal -->
<div class="modal" id="deleteOrderModal">
    <div class="modal-content">
        <div class="modal__header">
            <h2 class="modal__title">Delete Order</h2>
            <span class="modal-close" onclick="closeModal('deleteOrderModal')">&times;</span>
        </div>
        <div class="modal__body">
            <form id="deleteOrderForm" action="<%= request.getContextPath()%>/admin/orders" method="post" 
                  onsubmit="return submitDeleteOrder(this)">
                <input type="hidden" id="deleteOrderId" name="orderId">
                <input type="hidden" name="formAction" value="deleteOrder">
                
                <p>Are you sure you want to delete this order?</p>
                <div id="resultDeleteOrder" class="form-result"></div>
                
                <div class="modal__footer">
                    <button type="submit" class="modal__btn modal__btn--primary">Delete</button>
                    <button type="button" class="modal__btn modal__btn--secondary" onclick="closeModal('deleteOrderModal')">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div>
