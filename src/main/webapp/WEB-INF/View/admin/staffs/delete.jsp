<%-- 
    Document   : delete
    Created on : Jun 5, 2025, 5:00:47 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div id="deleteStaffModal" class="modal" style="display:none;">
    <div class="modal-content">
        <h2>Confirm to demote this staff ?</h2>
        <p>do you want to demote this staff to customer ?</p>

        <form id="deleteStaffForm" 
              onsubmit="return submitFormAjax(this, 'resultDeleteStaff')"
              method="post" action="<%= request.getContextPath()%>/admin/staffs">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" id="deleteStaffId" name="staffId">

            <div style="margin-top: 20px; text-align: right;">
                <button type="submit" class="action-buttons__btn action-buttons__btn--delete">Delete</button>
                <button type="button" class="action-buttons__btn" onclick="closeModal('deleteStaffModal')">Cancel</button>                
            </div>

            <div id="resultDeleteStaff" style="margin-top: 10px;"></div>
        </form>
    </div>
</div>