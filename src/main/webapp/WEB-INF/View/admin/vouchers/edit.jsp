<div name="code" class="modal" id="editVoucherModal" style="display: none;">
    <div class="modal__content">
        <form method="post"
              action="${pageContext.request.contextPath}/admin/vouchers"
              enctype="multipart/form-data"
              onsubmit="return submitEditVoucher(this, 'resultEditVoucher', event)">

            <input type="hidden" name="formAction" value="update">
            <input type="hidden" name="voucherId" id="editVoucherId">

            <div class="modal__header">
                <h2 class="modal__title">Edit Voucher</h2>
                <button type="button" class="modal__close" onclick="closeModal('editVoucherModal')">&times;</button>
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
