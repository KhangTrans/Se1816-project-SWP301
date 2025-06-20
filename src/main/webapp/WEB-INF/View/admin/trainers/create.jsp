<div class="modal" id="addTrainer" style="display: none;">
    <div class="modal-content">
        <form id="addTrainerForm"
              method="post"
              action="/SE1816_Gym_Group_4/TrainerServlet"
              onsubmit="return submitFormAjaxTrainers(this, 'resultAdd')">
            <input type="hidden" name="formAction" value="create">

            <div class="modal__header">
                <h2 class="modal__title">Add Trainer</h2>
            </div>

            <div class="modal__body">
                <label for="trainerUsername">Trainer Username:</label>
                <select name="accountId" id="trainerUsername" required>
                    <option value="">-- Choose Username --</option>
                </select>
                <br><br>

                <label for="fullname">Full Name:</label>
                <input type="text" name="fullname" id="fullname" required><br><br>

                <label for="email">Email:</label>
                <input type="email" name="email" id="email" required><br><br>

                <label for="phone_number">Phone Number:</label>
                <input type="tel" name="phone_number" id="phone_number" required><br><br>

                <label for="bio">Bio:</label>
                <textarea name="bio" id="bio" rows="4" required></textarea><br><br>

                <label for="experience_years">Experience (Years):</label>
                <input type="number" name="experience_years" id="experience_years" min="0" required><br><br>
            </div>

            <div class="modal__footer">
                <button type="submit">Create</button>
                <button type="button" onclick="closeModal('addTrainer')">Cancel</button>
            </div>
        </form>

        <div id="resultAdd" style="margin-top: 10px;"></div>
    </div>
</div>
