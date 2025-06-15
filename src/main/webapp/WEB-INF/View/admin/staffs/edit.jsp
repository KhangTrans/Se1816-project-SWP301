<%-- 
    Document   : edit
    Created on : Jun 5, 2025, 5:00:36 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class="modal" id="editStaffModal" style="display:none;">
    <div class="modal-content">
        <h2>Edit Staff</h2>
        <form method="post" action="<%= request.getContextPath()%>/admin/staffs"
              enctype="multipart/form-data"
              onsubmit="return submitFormForStaff(this, 'resultEditStaff', event)">

            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="staffId" id="editStaffId" readonly>
            

            <label>Full Name:</label>
            <input type="text" name="fullName" id="editFullName" required><br><br>

            <input type="email" name="email" id="editEmail" hidden>

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

            <label>Upload New Avatar:</label>
            <input type="file" name="avatar" id="editStaffAvatar" accept="image/*"><br><br>
            <input type="hidden" name="accountId" id="editStaffAccountId" readonly>

            <button type="submit">Save</button>
            <button type="button" onclick="closeModal('editStaffModal')">Cancel</button>

            <div id="resultEditStaff" style="margin-top: 10px;"></div>
        </form>
    </div>
</div>

