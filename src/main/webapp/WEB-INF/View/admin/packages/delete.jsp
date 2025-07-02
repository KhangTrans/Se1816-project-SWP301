<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class="modal" id="deletePackageModal" style="display:none;">
    <div class="modal-content">
        <form method="post"
              action="${pageContext.request.contextPath}/admin/packages"
              onsubmit="return submitFormAjax(this, 'resultDeletePackage', event)">

            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="packageId" id="deletePackageId">

            <div class="modal__header">
                <h2>Confirm Delete</h2>
            </div>

            <div class="modal__body">
                <p>Are you sure you want to delete this package?</p>
                <div id="resultDeletePackage" style="margin-top: 10px;"></div>
            </div>

            <div class="modal__footer">
                <button type="submit" class="modal__btn modal__btn--danger">Delete</button>
                <button type="button" class="modal__btn modal__btn--secondary" onclick="closeModal('deletePackageModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>
