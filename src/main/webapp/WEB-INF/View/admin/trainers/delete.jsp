


<div class="modal" id="deleteAccountModal" style="display:none;">
    <div class="modal-content">
        <h2>Confirm account deletion</h2>
        <form method="post" action="${pageContext.request.contextPath}/admin/trainers"
              onsubmit="return submitDeleteAccount(this)">
            <input type="hidden" name="accountId" id="deleteAccountId">
            <p>B?n có ch?c ch?n mu?n xóa Trainer này không</p>
            <button type="submit">Xóa</button>
            <button type="button" onclick="closeModal('deleteTrainerModal')">H?y</button>
        </form><div id="resultDelete" style="margin-top:10px;"></div>      
    </div>
</div>
