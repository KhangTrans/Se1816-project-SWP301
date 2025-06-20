<style>
    .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        justify-content: center;
        align-items: center;
        overflow: auto;
    }

    .modal--active {
        display: flex;
    }

    .modal-content {
        background-color: #fff;
        border-radius: 12px;
        padding: 30px 40px;
        width: 400px;
        max-width: 90%;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
        animation: fadeInScale 0.3s ease;
    }

    @keyframes fadeInScale {
        from {
            opacity: 0;
            transform: scale(0.9);
        }
        to {
            opacity: 1;
            transform: scale(1);
        }
    }

    .modal-content h2 {
        margin-bottom: 20px;
        font-size: 22px;
        color: #333;
        text-align: center;
    }

    .modal-content label {
        font-weight: bold;
        margin-bottom: 6px;
        display: block;
        color: #444;
    }

    .modal-content input[type="text"],
    .modal-content input[type="password"],
    .modal-content input[type="file"],
    .modal-content select {
        width: 100%;
        padding: 10px;
        margin-bottom: 16px;
        border-radius: 6px;
        border: 1px solid #ccc;
        font-size: 14px;
    }

    .modal-content button[type="submit"],
    .modal-content button[type="button"] {
        padding: 10px 20px;
        border: none;
        border-radius: 6px;
        font-size: 14px;
        cursor: pointer;
        margin-right: 10px;
    }

    .modal-content button[type="submit"] {
        background-color: #4CAF50;
        color: white;
    }

    .modal-content button[type="submit"]:hover {
        background-color: #45a049;
    }

    .modal-content button[type="button"] {
        background-color: #ccc;
    }

    .modal-content button[type="button"]:hover {
        background-color: #bbb;
    }

</style>

<div class="modal" id="editAccountModal" style="display:none;">
    <div class="modal-content">
        <h2>Edit Account</h2>
        <form method="post" action="${pageContext.request.contextPath}/admin/accounts"
              enctype="multipart/form-data"
              onsubmit="return submitFormAjax(this, 'resultEdit')">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="accountId" id="editAccountId">
            <label>Username:</label>
            <input type="text" name="username" id="editUsername" required><br><br>

            <label>Password:</label>
            <input type="password" name="password"><br><br>

            <label>Role:</label>
            <select name="role" id="editRole">
                <option value="admin">Admin</option>
                <option value="staff">Staff</option>
                <option value="trainer">Trainer</option>
                <option value="customer">Customer</option>
            </select><br><br>
            <!-- Avatar hi?n t?i -->
            <div id="currentAvatarContainer" style="display:none; text-align: center; margin-bottom: 15px;">
                <p>Current Avatar:</p>
                <img id="currentAvatar" src="" alt="Avatar" style="width:60px; height:60px; border-radius: 50%;">
            </div>
            <label>Upload New Avatar:</label>
            <input type="file" name="avatar" accept="image/*"><br><br>

            <button type="submit">Save</button>
            <button type="button" onclick="closeModal('editAccountModal')">Cancel</button>
             <div id="resultEdit" style="margin-top: 10px;"></div>
        </form>
    </div>
</div>
