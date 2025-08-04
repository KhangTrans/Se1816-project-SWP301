
<style>
    .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        justify-content: center;
        align-items: center;
        overflow: auto;
    }

    .modal--active {
        display: flex;
    }

    .modal-content {
        background-color: #fff;
        border-radius: 12px;
        padding: 30px 40px;
        width: 400px;
        max-width: 90%;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
        animation: fadeInScale 0.3s ease;
    }

    @keyframes fadeInScale {
        from {
            opacity: 0;
            transform: scale(0.9);
        }
        to {
            opacity: 1;
            transform: scale(1);
        }
    }

    .modal-content h2 {
        margin-bottom: 20px;
        font-size: 22px;
        color: #333;
        text-align: center;
    }

    .modal-content label {
        font-weight: bold;
        margin-bottom: 6px;
        display: block;
        color: #444;
    }

    .modal-content input[type="text"],
    .modal-content input[type="password"],
    .modal-content input[type="file"],
    .modal-content select {
        width: 100%;
        padding: 10px;
        margin-bottom: 16px;
        border-radius: 6px;
        border: 1px solid #ccc;
        font-size: 14px;
    }

    .modal-content button[type="submit"],
    .modal-content button[type="button"] {
        padding: 10px 20px;
        border: none;
        border-radius: 6px;
        font-size: 14px;
        cursor: pointer;
        margin-right: 10px;
    }

    .modal-content button[type="submit"] {
        background-color: #4CAF50;
        color: white;
    }

    .modal-content button[type="submit"]:hover {
        background-color: #45a049;
    }

    .modal-content button[type="button"] {
        background-color: #ccc;
    }

    .modal-content button[type="button"]:hover {
        background-color: #bbb;
    }

</style>
<div class="modal" id="editTrainerModal">
    <div class="modal-content">
        <h2>Edit Trainer</h2>
        <form method="post"
              action="/SE1816_Gym_Group_4/TrainerServlet"
              enctype="multipart/form-data"
              onsubmit="return submitEditTrainerForm(this, 'editTrainerResult');">
            <input type="hidden" name="formAction" value="edit">
            <input type="hidden" name="trainerId" id="editTrainerId">
            <div class="modal__body">
                <label for="editTrainerFullName">Full Name:</label>
                <input type="text" name="fullname" id="editTrainerFullName" required
                       pattern="^[A-Za-z\s]+$"
                       title="Full name should only contain letters and spaces."
                       aria-describedby="editFullnameError">
                <span id="editFullnameError" style="color: red; font-size: 12px;"></span><br><br>

                <label for="editTrainerEmail">Email:</label>
                <input type="email" name="email" id="editTrainerEmail" required
                       pattern="^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$"
                       title="Please enter a valid email address."
                       aria-describedby="editEmailError">
                <span id="editEmailError" style="color: red; font-size: 12px;"></span><br><br>

                <label for="editTrainerPhone">Phone:</label>
                <input type="tel" name="phone_number" id="editTrainerPhone"
                       pattern="^(0[35789])[0-9]{8}$"
                       title="Please enter a valid Vietnamese phone number (e.g., 0912345678)."
                       aria-describedby="editPhoneError" required>
                <span id="phoneError" style="color: red; font-size: 12px;"></span><br><br>

                <label for="editTrainerBio">Bio:</label>
                <textarea name="bio" id="editTrainerBio" rows="4" maxlength="500"
                          aria-describedby="editBioError"></textarea>
                <span id="editBioError" style="color: red; font-size: 12px;"></span><br><br>

                <label for="editTrainerExperience">Experience (years):</label>
                <input type="number" name="experience_years" id="editTrainerExperience" min="0"
                       aria-describedby="editExperienceError">
                <span id="editExperienceError" style="color: red; font-size: 12px;"></span><br><br>

                <label for="editTrainerPrice">Session Price (VND):</label>
                <input type="number" name="price" id="editTrainerPrice" min="0" step="10000" required
                       aria-describedby="editPriceError">
                <span id="editPriceError" style="color: red; font-size: 12px;"></span><br><br>

                <label for="editTrainerRating">Rating:</label>
                <input type="number" name="rating" id="editTrainerRating" min="0" max="5" step="0.1"
                       aria-describedby="editRatingError">
                <span id="editRatingError" style="color: red; font-size: 12px;"></span><br><br>
            </div>
            <div class="modal__footer">
                <button type="submit">Save</button>
                <button type="button" onclick="closeModal('editTrainerModal')">Cancel</button>
            </div>
        </form>
        <div id="editTrainerResult" style="margin-top: 10px;"></div>
    </div>
</div>