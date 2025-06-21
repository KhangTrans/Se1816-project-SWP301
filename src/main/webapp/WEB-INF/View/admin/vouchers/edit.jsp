
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
<div name="code" class="modal" id="editVoucherModal" style="display: none;">
    <div class="modal-content">
        <form method="post"
              action="${pageContext.request.contextPath}/admin/vouchers"
              enctype="multipart/form-data"
              onsubmit="return submitEditVoucher(this, 'resultEditVoucher', event)">

            <input type="hidden" name="formAction" value="update">
            <input type="hidden" name="voucherId" id="editVoucherId">

            <div class="modal__header">
                <h2 class="modal__title">Edit Voucher</h2>
            </div>

            <div class="modal__body">
                <!-- ? Code -->
                <div class="modal__form-group">
                    <label class="modal__label">Code</label>
                    <input type="text" name="code" id="editVoucherCode" class="modal__input" required>
                </div>

                <!-- Description -->
                <div class="modal__form-group">
                    <label class="modal__label">Description</label>
                    <textarea name="description" id="editVoucherDescription" class="modal__textarea" required></textarea>
                </div>

                <!-- Discount (%) -->
                <div class="modal__form-group">
                    <label class="modal__label">Discount (%)</label>
                    <input type="number" name="discountPercent" id="editVoucherDiscount" class="modal__input" required>
                </div>

                <!-- Max Discount -->
                <div class="modal__form-group">
                    <label class="modal__label">Max Discount</label>
                    <input type="number" name="maxDiscount" id="editVoucherMaxDiscount" class="modal__input" required>
                </div>

                <!-- Usage Limit -->
                <div class="modal__form-group">
                    <label class="modal__label">Usage Limit</label>
                    <input type="number" name="usageLimit" id="editVoucherUsageLimit" class="modal__input" required>
                </div>

                <!-- Used Count -->
                <div class="modal__form-group">
                    <label class="modal__label">Used Count</label>
                    <input type="number" name="usedCount" id="editVoucherUsedCount" class="modal__input" required>
                </div>

                <!-- Min Order Amount -->
                <div class="modal__form-group">
                    <label class="modal__label">Min Order Amount</label>
                    <input type="number" name="minOrderAmount" id="editVoucherMinOrderAmount" class="modal__input" required>
                </div>

                <!-- Start Date -->
                <div class="modal__form-group">
                    <label class="modal__label">Start Date</label>
                    <input type="date" name="startDate" id="editVoucherStartDate" class="modal__input" required>
                </div>

                <!-- End Date -->
                <div class="modal__form-group">
                    <label class="modal__label">End Date</label>
                    <input type="date" name="endDate" id="editVoucherEndDate" class="modal__input" required>
                </div>

                <!-- Active -->
                <div class="modal__form-group">
                    <label class="modal__label">Active</label>
                    <select name="isActive" id="editVoucherActive" class="modal__input" required>
                        <option value="1">Active</option>
                        <option value="0">Inactive</option>
                    </select>
                </div>

                <!-- Result -->
                <div id="resultEditVoucher"></div>
            </div>

            <div class="modal__footer">
                <button type="submit" class="modal__btn modal__btn--primary">Update</button>
                <button type="button" class="modal__btn modal__btn--secondary" onclick="closeModal('editVoucherModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>
