<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class="modal" id="addPackageModal" style="display:none;">
    <div class="modal-content">
        <form method="post"
              action="${pageContext.request.contextPath}/admin/packages"
              onsubmit="return submitFormAjax(this, 'resultAddPackage', event)">

            <input type="hidden" name="action" value="create">

            <div class="modal__header">
                <h2>Create New Membership Package</h2>
            </div>

            <div class="modal__body">

                <!-- Package Name -->
                <div class="modal__form-group">
                    <label class="modal__label">Package Name</label>
                    <input type="text" name="name" class="modal__input" required>
                </div>

                <!-- Price -->
                <div class="modal__form-group">
                    <label class="modal__label">Price (VND)</label>
                    <input type="number" name="price" class="modal__input" min="0" step="1000" required>
                </div>

                <!-- Duration -->
                <div class="modal__form-group">
                    <label class="modal__label">Duration (Days)</label>
                    <input type="number" name="duration" class="modal__input" min="1" required>
                </div>

                <!-- Description -->
                <div class="modal__form-group">
                    <label class="modal__label">Description</label>
                    <textarea name="description" class="modal__textarea" rows="3"></textarea>
                </div>
                <!-- Status -->
                <div class="modal__form-group">
                    <label class="modal__label">Status</label>
                    <select name="isActive" class="modal__input" required>
                        <option value="1">Active</option>
                        <option value="0">Inactive</option>
                    </select>
                </div>
                <!-- Result -->
                <div id="resultAddPackage" style="margin-top:10px;"></div>
            </div>

            <div class="modal__footer">
                <button type="submit" class="modal__btn modal__btn--primary">Create</button>
                <button type="button" class="modal__btn modal__btn--secondary" onclick="closeModal('addPackageModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>
