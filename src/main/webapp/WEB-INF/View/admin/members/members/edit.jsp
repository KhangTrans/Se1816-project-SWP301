<div class="modal" id="editCustomerModal" style="display: none;">
    <div class="modal-content">
        <h2>Edit Member</h2>
        <form method="post"
              action="${pageContext.request.contextPath}/admin/customer"
              enctype="multipart/form-data"
              onsubmit="return submitFormAjax(this, 'resultEditCustomer')">

            <input type="hidden" name="action" value="update">
            <input type="hidden" id="editCustomerId" name="customerId">
            <input type="hidden" id="editAccountId" name="accountId">

            <label>Username:</label>
            <input type="text" id="editUsername" name="username" required><br><br>

            <label>Avatar:</label><br>
            <img id="editAvatarPreview"
                 src=""
                 alt="Avatar Preview"
                 style="width:60px;height:60px;border-radius:50%;margin-bottom:10px;"><br>

            <input type="file" name="avatar" accept="image/*"><br><br>

            <label>Full Name:</label>
            <input type="text" id="editFullName" name="fullName" required><br><br>

            <label>Email:</label>
            <input type="email" id="editEmail" name="email" required><br><br>

            <label>Phone:</label>
            <input type="text" id="editPhone" name="phone" required><br><br>

            <label>Customer Code:</label>
            <input type="text" id="editCustomerCode" name="customerCode" required><br><br>

            <label>Address:</label>
            <input type="text" id="editAddress" name="address" required><br><br>

            <button type="submit">Update</button>
            <button type="button" onclick="closeModal('editCustomerModal')">Cancel</button>
        </form>
        <div id="resultEditCustomer" style="margin-top:10px;"></div>
    </div>
</div>
