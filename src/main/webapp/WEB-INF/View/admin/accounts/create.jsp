<div class="modal" id="addAccountModal" style="display:none;">
    <div class="modal-content">
        <h2>Create New Account</h2>
        <form method="post" action="${pageContext.request.contextPath}/admin/accounts"
              enctype="multipart/form-data"
              onsubmit="return submitFormAjax(this, 'resultAdd')">

            <input type="hidden" name="action" value="create">

            <label>Username:</label>
            <input type="text" name="username" required><br><br>

            <label>Password:</label>
            <input type="password" name="password"
                   pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"
                   title="Password must be at least 8 characters, including uppercase, lowercase, numbers and special characters"
                   required><br><br>

            <label>Role:</label>
            <select name="role">
                <option value="admin">Admin</option>
                <option value="staff">Staff</option>
                <option value="customer">Customer</option>
                <option value="trainer">Trainer</option>
            </select><br><br>
            <input type="hidden" name="auth_provider" value="internal">

            <label>Upload Avatar (optional):</label>
            <input type="file" name="avatar" accept="image/*"><br><br>

            <button type="submit">Create</button>
            <button type="button" onclick="closeModal('addAccountModal')">Cancel</button>
        </form>
        <div id="resultAdd" style="margin-top:10px;"></div>
    </div>
</div>
