<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="addStaffModal" class="modal" style="display: none;">
    <div class="modal-content">
        <h2>Create New Staff</h2>
        <form id="createStaffForm"
              action="<%= request.getContextPath()%>/admin/staffs?action=create"
              method="post"
              onsubmit="return submitFormAjaxStaff(this, 'resultAddStaff')">
            <input type="hidden" name="action" value="create">

            <div id="createStaffError" style="color: red; margin-bottom: 10px;"></div>

            <label for="accountId">Choose Account (with role 'staff'):</label>
            <select name="accountId" required>
                <option value="">-- Select Staff Account --</option>
                <%-- Populate staff account options here --%>
            </select>

            <label for="fullName">Full Name:</label>
            <input type="text" name="fullName" required oninput="validateInput(this)" />

            <label for="email">Email:</label>
            <input type="text" name="email" required oninput="validateInput(this)" />

            <label for="phone">Phone:</label>
            <input type="text" name="phone" required oninput="validateInput(this)" />

            <label for="position">Position:</label>
            <input type="text" name="position" required oninput="validateInput(this)" />

            <button type="submit">Create</button>
            <button type="button" onclick="closeModal('addStaffModal')">Cancel</button>
            <div id="resultAddStaff" style="margin-top: 10px;"></div>
        </form>
    </div>
</div>
