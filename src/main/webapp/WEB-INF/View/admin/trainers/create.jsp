<div class="modal" id="addTrainer" style="display:none;">
    <div class="modal-content">
        <h2>Create New Trainer </h2>
        <form method="post" action="${pageContext.request.contextPath}/admin/trainers"
              enctype="multipart/form-data"
              onsubmit="return submitFormAjax(this, 'resultAdd')">
            
             <input type="hidden" name="formAction" value="create">
            <div class="modal__header">
                <h2 class="modal__title">Add Trainer</h2>
                <button type="button" class="modal__close" onclick="closeModal('addTrainer')">&times;</button>
            </div>

            <label for="trainerUsername">Select Trainer Username:</label>
            <select name="trainerUsername" id="trainerUsername" required>
                <option value="">Choose a username for the Trainer</option>
                <!-- Các username c?a trainer s? ???c ?i?n vào ?ây b?ng JavaScript -->
            </select>
            <br><br>
            
            <label>Full Name:</label>
            <input type="text" name="fullname" required><br><br>

            <label>Email:</label>
            <input type="email" name="email" required><br><br>

            <label>Phone Number:</label>
            <input type="tel" name="phone_number" required><br><br>

            <label>Bio:</label>
            <textarea name="bio" rows="4" required></textarea><br><br>

            <label>Experience (Years):</label>
            <input type="number" name="experience_years" min="0" required><br><br>

            <button type="submit">Create</button>
            <button type="button" onclick="closeModal('addTrainer')">Cancel</button>
        </form>
        <div id="resultAdd" style="margin-top:10px;"></div>
    </div>
</div>
