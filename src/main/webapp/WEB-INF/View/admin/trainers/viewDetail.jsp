<!-- Modal Detail Trainer -->
<div id="detailTrainerModal" class="modal">
    <div class="modal-content">
        <h2>Trainer Details</h2>
        <div class="trainer-detail">
            <img id="detailTrainerAvatar" src="" alt="Avatar" style="width:100px; height:100px; border-radius:50%; margin-bottom: 20px; display: block; margin: 0 auto 20px;">
            
            <table class="detail-table">
                <tbody>
                    <tr>
                        <td><strong>Full Name:</strong></td>
                        <td><span id="detailTrainerFullName"></span></td>
                    </tr>
                    <tr>
                        <td><strong>Email:</strong></td>
                        <td><span id="detailTrainerEmail"></span></td>
                    </tr>
                    <tr>
                        <td><strong>Phone:</strong></td>
                        <td><span id="detailTrainerPhone"></span></td>
                    </tr>
                    <tr>
                        <td><strong>Trainer Code:</strong></td>
                        <td><span id="detailTrainerCode"></span></td>
                    </tr>
                    <tr>
                        <td><strong>Username:</strong></td>
                        <td><span id="detailTrainerUsername"></span></td>
                    </tr>
                    <tr>
                        <td><strong>Experience:</strong></td>
                        <td><span id="detailTrainerExperience"></span> years</td>
                    </tr>
                    <tr>
                        <td><strong>Rating:</strong></td>
                        <td><span id="detailTrainerRating"></span> <i class="fa fa-star" style="color: orange" aria-hidden="true"></i> </td>
                    </tr>
                    <tr>
                        <td><strong>Price:</strong></td>
                        <td><span id="detailTrainerPrice"></span></td>
                    </tr>
                    <tr>
                        <td><strong>Bio:</strong></td>
                        <td><span id="detailTrainerBio"></span></td>
                    </tr>
                    <tr style="display: none;">
                        <td><strong>ID:</strong></td>
                        <td><span id="detailTrainerId"></span></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <button class="btn" onclick="closeDetailTrainerModal()">Close</button>
    </div>
</div>

<style>
    .detail-table {
        width: 100%;
        border-collapse: collapse;
        margin: 20px 0;
    }
    
    .detail-table td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: left;
    }
    
    .detail-table td:first-child {
        font-weight: bold;
        width: 30%;
        background-color: #f8f9fa;
    }
    
    .btn {
        background-color: #4CAF50;
        color: white;
        padding: 10px 15px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        float: right;
        margin-top: 15px;
    }
    
    .btn:hover {
        background-color: #45a049;
    }
    
    .modal {
    display: none;
    position: fixed;
        z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0,0,0,0.4);
}

.modal-content {
    background-color: #fefefe;
        margin: 5% auto;
    padding: 20px;
    border: 1px solid #888;
        width: 70%;
        max-width: 600px;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
</style>

<script>
function closeDetailTrainerModal() {
    document.getElementById('detailTrainerModal').style.display = 'none';
}
</script>