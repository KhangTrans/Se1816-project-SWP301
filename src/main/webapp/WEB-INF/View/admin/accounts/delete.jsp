
<div class="modal" id="deleteAccountModal" style="display:none;">
    <div class="modal-content">
        <h2>X�c nh?n x�a t�i kho?n</h2>
        <form method="post" action="${pageContext.request.contextPath}/admin/accounts"
              onsubmit="return submitDeleteAccount(this)">
            <input type="hidden" name="accountId" id="deleteAccountId">
            <p>B?n c� ch?c ch?n mu?n x�a t�i kho?n n�y kh�ng?</p>
            <button type="submit">X�a</button>
            <button type="button" onclick="closeModal('deleteAccountModal')">H?y</button>
        </form><div id="resultDelete" style="margin-top:10px;"></div>      
    </div>
</div>
