<div class="modal" id="addVoucherModal" style="display:none;">
    <div class="modal-content">
        <h2>Create New Voucher</h2>
        <form method="post" action="${pageContext.request.contextPath}/admin/vouchers" 
              onsubmit="submitFormAjax(event, this, 'resultAddVoucher')">

            <input type="hidden" name="formAction" value="create">

            <label>Code:</label>
            <input type="text" name="code" required><br><br>

            <label>Description:</label>
            <input type="text" name="description" required><br><br>

            <label>Discount (%):</label>
            <input type="number" name="discountPercent" required><br><br>

            <label>Max Discount:</label>
            <input type="number" name="maxDiscount" required><br><br>

            <label>Usage Limit:</label>
            <input type="number" name="usageLimit" required><br><br>

            <label>Used Count:</label>
            <input type="number" name="usedCount" required><br><br>

            <label>Min Order Amount:</label>
            <input type="number" name="minOrderAmount" required><br><br>

            <label>Start Date:</label>
            <input type="date" name="startDate" required><br><br>

            <label>End Date:</label>
            <input type="date" name="endDate" required><br><br>

            <label>Status:</label>
            <select name="isActive">
                <option value="1">Active</option>
                <option value="0">Inactive</option>
            </select><br><br>

            <button type="submit">Create</button>
            <button type="button" onclick="closeModal('addVoucherModal')">Cancel</button>
        </form>
        <div id="resultAddVoucher" style="margin-top:10px;"></div>
    </div>
</div>
