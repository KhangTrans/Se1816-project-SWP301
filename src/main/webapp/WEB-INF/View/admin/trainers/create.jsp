<div class="modal" id="addTrainer" style="display: none; margin-top: 30px">
    <div class="modal-content">
        <h2>Add Trainer</h2>
        <form id="addTrainerForm"
              method="post"
              action="/SE1816_Gym_Group_4/TrainerServlet"
              onsubmit="return submitFormAjaxTrainers(this, 'resultAddTainer')">
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
                <input type="text" name="fullname" id="fullname" required pattern="^[A-Za-z\s]+$" title="Full name should only contain letters and spaces."><br><br>

                <label for="email">Email:</label>
                <input type="email" name="email" id="email" 
                       pattern="^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$"
                       title="Please enter a valid email address." 
                       required>
                <span id="emailError" style="color: red; font-size: 12px;"></span><br><br>

                <label for="phone_number">Phone Number:</label>
                <input type="tel" name="phone_number" id="phone_number" 
                       pattern="^(0[35789])[0-9]{8}$" 
                       title="Please enter a valid Vietnamese phone number (e.g., 0912345678)."
                       required>
                <span id="phoneError" style="color: red; font-size: 12px;"></span><br><br>

                <label for="bio">Bio:</label>
                <textarea name="bio" id="bio" rows="4" required></textarea><br><br>

                <label for="experience_years">Experience (Years):</label>
                <input type="number" name="experience_years" id="experience_years" min="0" required><br><br>

                <label for="session_price">Session Price (VND):</label>
                <input type="number" name="price" id="session_price" min="0" step="10000" required><br><br>
            </div>

            <div class="modal__footer">
                <button type="submit">Create</button>
                <button type="button" onclick="closeModal('addTrainer')">Cancel</button>
            </div>
        </form>

        <!-- Hi?n th? k?t qu? th�ng b�o l?i/th�nh c�ng -->
        <div id="resultAddTainer" style="margin-top: 10px;"></div>
    </div>
</div>


<style>
    /* Modal Container */
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

/* Modal Content */
.modal-content {
    background-color: #fff;
    border-radius: 12px;
    padding: 30px 40px;
    width: 400px;
    max-width: 90%;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
    animation: fadeInScale 0.3s ease;
}

/* Animation */
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

/* Title */
.modal__title {
    text-align: center;
    font-size: 22px;
    margin-bottom: 20px;
    color: #333;
}

/* Input Fields and Buttons */
.modal__body input,
.modal__body select,
.modal__body textarea {
    width: 100%;
    padding: 10px;
    margin-bottom: 16px;
    border-radius: 6px;
    border: 1px solid #ccc;
    font-size: 14px;
}

/* Buttons */
button[type="submit"],
button[type="button"] {
    padding: 10px 20px;
    border: none;
    border-radius: 6px;
    font-size: 14px;
    cursor: pointer;
    margin-right: 10px;
}

button[type="submit"] {
    background-color: #4CAF50;
    color: white;
}

button[type="submit"]:hover {
    background-color: #45a049;
}

button[type="button"] {
    background-color: #ccc;
}

button[type="button"]:hover {
    background-color: #bbb;
}

/* Error Message Styling */
#errorMessage {
    color: red;
    font-size: 14px;
}

/* Success Message Styling */
.successMessage {
    color: green;
    font-size: 14px;
}

    </style>