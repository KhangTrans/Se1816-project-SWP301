<%-- 
    Document   : edit
    Created on : Jun 5, 2025, 5:00:36 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class="modal" id="editStaffModal" style="display:none;">
    <div class="modal-content" style="margin-top: 300px">
        <h2>Edit Staff</h2>
        <form method="post" action="<%= request.getContextPath()%>/admin/staffs"
              enctype="multipart/form-data"
              onsubmit="return validateStaffForm(this, 'editStaffError') && submitFormAjax(this, 'resultEditStaff')">

            <div id="editStaffError" style="color: red; margin-bottom: 10px;"></div>


            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="staffId" id="editStaffId" readonly>


            <label>Full Name:</label>
            <input type="text" name="fullName" id="editFullName" required><br><br>

            <label>Email:</label>
            <input type="text" name="email" id="editEmail" required><br><br>

            <label>Phone:</label>
            <input type="text" name="phone" id="editPhone" required><br><br>

            <label>Position:</label>
            <input type="text" name="position" id="editPosition" required><br><br>

            <label>Status:</label>
            <select name="status" id="editStatus" required>
                <option value="active">Active</option>
                <option value="inactive">Inactive</option>
            </select><br><br>

            <!-- Avatar hiện tại -->
            <div id="currentAvatarContainer" style="display:none; text-align: center; margin-bottom: 15px;">
                <p>Current Avatar:</p>
                <img id="currentAvatar" src="" alt="Avatar" style="width:60px; height:60px; border-radius: 50%;">
            </div>

            <input type="hidden" name="accountId" id="editStaffAccountId" readonly>

            <button type="submit">Save</button>
            <button type="button" onclick="closeModal('editStaffModal')">Cancel</button>

            <div id="resultEditStaff" style="margin-top: 10px;"></div>
        </form>
    </div>
</div>

