<div class="modal" id="deleteAccountModal">
    <div class="modal__content">
        <form method="post" action="${pageContext.request.contextPath}/admin/accounts"
              onsubmit="return submitDeleteAccount(this)">
            <input type="hidden" name="accountId" id="deleteAccountId">

            <div class="modal__header">
                <h2 class="modal__title">Delete Account</h2>
                <button type="button" class="modal__close" onclick="closeModal('deleteAccountModal')">&times;</button>
            </div>

            <div class="modal__body">
                <p>Are you sure you want to delete this account?</p>
                <div id="resultDelete"></div>
            </div>

            <div class="modal__footer">
                <button type="submit" class="modal__btn modal__btn--primary">Delete</button>
                <button type="button" class="modal__btn modal__btn--secondary" onclick="closeModal('deleteAccountModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>
