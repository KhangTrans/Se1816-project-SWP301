
<div class="modal" id="deleteTrainerModal" style="display:none;">
    <div class="modal-content">
        <div class="modal__header">
            <h2 class="modal__title">Delete Trainer</h2>
        </div>
        <p>Are you sure you want to delete trainer <strong id="trainerName"></strong>?</p>
        <input type="hidden" id="deleteTrainerId">
        <div class="modal__footer">
            <button id="confirmDeleteBtn" class="modal__btn modal__btn--primary"
                    onclick="submitDeleteTrainer()">Delete</button>
            <button class="modal__btn modal__btn--secondary"
                    onclick="closeModal('deleteTrainerModal')">Cancel</button>
            <div id="deleteTrainerResult" style="margin-top:10px;"></div>
        </div>
    </div>
</div>
