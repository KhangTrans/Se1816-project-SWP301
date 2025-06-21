




<div class="modal" id="deleteTrainerModal" style="display:none;">
    <div class="modal-content">
        <h2>Xác nh?n xóa Hu?n luy?n viên</h2>
        <p>B?n ch?c ch?n mu?n xóa hu?n luy?n viên <strong id="trainerName"></strong>?</p>
        <input type="hidden" id="deleteTrainerId">
        <button id="confirmDeleteBtn" class="btn btn-danger" onclick="submitDeleteTrainer()">Xóa</button>
        <button class="btn btn-secondary" onclick="closeModal('deleteTrainerModal')">H?y</button>
        <div id="deleteTrainerResult" style="margin-top:10px;"></div>
    </div>
</div>
