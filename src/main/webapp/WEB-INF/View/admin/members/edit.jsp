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

<div class="modal" id="editCustomerModal" ...>
    <div class="modal-content">
        <h2>Edit Member</h2>
        <form method="post"
              action="${pageContext.request.contextPath}/admin/customer"
              enctype="multipart/form-data"
              onsubmit="return submitFormAjax(this, 'resultEditCustomer')">

            <input type="hidden" name="action" value="update">
            <input type="hidden" id="editCustomerId" name="customerId">
            <input type="hidden" id="editCustomerAccountId" name="accountId">

            <label>Current Avatar:</label><br>
            <img id="editCustomerAvatarPreview"
                 src=""
                 alt="Avatar Preview"
                 style="width:60px;height:60px;border-radius:50%;margin-bottom:10px;"><br>

            <label for="editCustomerFullName">Full Name:</label>
            <input type="text" id="editCustomerFullName" name="fullName" required><br><br>

            <label for="editCustomerEmail">Email:</label>
            <input type="email" id="editCustomerEmail" name="email" required><br><br>

            <label for="editCustomerPhone">Phone:</label>
            <input type="text" id="editCustomerPhone" name="phone" required><br><br>

            <label for="editCustomerCode">Customer Code:</label>
            <input type="text" id="editCustomerCode" name="customerCode" required><br><br>

            <label for="editCustomerAddress">Address:</label>
            <input type="text" id="editCustomerAddress" name="address" ><br><br>

            <div style="text-align: right;">
                <button type="submit">Update</button>
                <button type="button" onclick="closeModal('editCustomerModal')">Cancel</button>
            </div>
        </form>
        <div id="resultEditCustomer" style="margin-top:10px;"></div>
    </div>
</div>
