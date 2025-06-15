<div class="modal" id="deleteVoucherModal">
    <div class="modal__content">
        <form method="post" action="<%= request.getContextPath()%>/admin/vouchers"
              onsubmit="return submitDeleteVouchers(this)">
            <input type="hidden" name="formAction" value="delete">
            <input type="hidden" name="voucherId" id="deleteVoucherId">

            <div class="modal__header">
                <h2 class="modal__title">Delete Voucher</h2>
                <button type="button" class="modal__close" onclick="closeModal('deleteVoucherModal')">&times;</button>
            </div>

            <div class="modal__body">
                <p>Are you sure you want to delete this voucher?</p>
                <div id="resultDeleteVoucher"></div>
            </div>

            <div class="modal__footer">
                <button type="submit" class="modal__btn modal__btn--primary">Delete</button>
                <button type="button" class="modal__btn modal__btn--secondary" onclick="closeModal('deleteVoucherModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>
