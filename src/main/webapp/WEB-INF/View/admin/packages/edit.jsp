<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class="modal" id="editPackageModal" style="display:none;">
    <div class="modal-content">
        <form method="post"
              action="${pageContext.request.contextPath}/admin/packages"
              onsubmit="return submitFormAjax(this, 'resultEditPackage', event)">

            <input type="hidden" name="action" value="update">
            <input type="hidden" name="packageId" id="editPackageId">

            <div class="modal__header">
                <h2>Edit Membership Package</h2>
            </div>

            <div class="modal__body">

                <!-- Package Name -->
                <div class="modal__form-group">
                    <label class="modal__label">Package Name</label>
                    <input type="text" name="name" id="editPackageName" class="modal__input" required>
                </div>

                <!-- Price -->
                <div class="modal__form-group">
                    <label class="modal__label">Price (VND)</label>
                    <input type="number" name="price" id="editPackagePrice" class="modal__input" min="0" step="1000" required>
                </div>

                <!-- Duration -->
                <div class="modal__form-group">
                    <label class="modal__label">Duration (Days)</label>
                    <input type="number" name="duration" id="editPackageDuration" class="modal__input" min="1" required>
                </div>

                <!-- Description -->
                <div class="modal__form-group">
                    <label class="modal__label">Description</label>
                    <textarea name="description" id="editPackageDescription" class="modal__textarea" rows="3"></textarea>
                </div>

                <!-- Status -->
                <div class="modal__form-group">
                    <label class="modal__label">Status</label>
                    <select name="isActive" id="editPackageStatus" class="modal__input" required>
                        <option value="1">Active</option>
                        <option value="0">Inactive</option>
                    </select>
                </div>

                <!-- Result -->
                <div id="resultEditPackage" style="margin-top:10px;"></div>
            </div>

            <div class="modal__footer">
                <button type="submit" class="modal__btn modal__btn--primary">Update</button>
                <button type="button" class="modal__btn modal__btn--secondary" onclick="closeModal('editPackageModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>
