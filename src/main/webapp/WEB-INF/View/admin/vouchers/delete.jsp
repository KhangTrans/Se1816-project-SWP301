<div class="modal" id="deleteVoucherModal" style="display: none;">
    <div class="modal-content">
        <h2>X�c nh?n x�a Voucher</h2>

        <form  method="post" action="<%= request.getContextPath()%>/admin/vouchers"
              onsubmit="return submitDeleteVouchers(this)">
            <input type="hidden" name="formAction" value="delete">
            <input type="hidden" name="voucherId" id="deleteVoucherId">
            <p>B?n c� ch?c ch?n mu?n x�a voucher n�y kh�ng?</p>
            <div style="display: flex; gap: 10px;">
                <button type="submit" style="background-color: green; color: white; padding: 6px 12px; border: none; border-radius: 4px;">X�a</button>
                <button type="button" onclick="closeModal('deleteVoucherModal')" style="padding: 6px 12px;">H?y</button>
            </div>
        </form>

        <!-- Hi?n th? k?t qu? x�a -->
        <div id="resultDeleteVoucher" style="margin-top: 10px;"></div>
    </div>
</div>
