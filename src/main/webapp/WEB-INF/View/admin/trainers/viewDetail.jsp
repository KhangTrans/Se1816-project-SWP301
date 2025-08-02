<!-- Modal Detail Trainer -->
<div id="detailTrainerModal" class="modal" style="display: none;">
    <div class="modal-content">
        <span class="close" onclick="closeDetailTrainerModal()"></span>
        <h2>TrainerDetail</h2>
        <div class="trainer-detail">
            <img id="detailTrainerAvatar" src="" alt="Avatar" style="width:100px; height:100px; c; margin-left: 110px; border-radius:50%; margin-bottom: 20px;">
            <p><strong>ID:</strong> <span id="detailTrainerId"></span></p>
            <p><strong>Username:</strong> <span id="detailTrainerUsername"></span></p>
            <p><strong>Fullname:</strong> <span id="detailTrainerFullName"></span></p>
            <p><strong>Email:</strong> <span id="detailTrainerEmail"></span></p>
            <p><strong>Phone:</strong> <span id="detailTrainerPhone"></span></p>
            <p><strong>Bio:</strong> <span id="detailTrainerBio"></span></p>
            <p><strong>Experience:</strong> <span id="detailTrainerExperience"></span></p>
            <p><strong>Rating:</strong> <span id="detailTrainerRating"></span></p>
            <p><strong>Price:</strong> <span id="detailTrainerPrice"></span></p>
            <p><strong>Trainer Code:</strong> <span id="detailTrainerCode"></span></p>
        </div>
        <button style="border-radius: 20px; background-color: #0056b3; " onclick="closeDetailTrainerModal()">Close</button>
    </div>
</div>

<style>
    .modal {
    display: none;
    position: fixed;
    z-index: 1;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgb(0,0,0);
    background-color: rgba(0,0,0,0.4);
}

.modal-content {
    background-color: #fefefe;
    margin: 15% auto;
    padding: 20px;
    border: 1px solid #888;
    width: 80%;
}

.close {
    color: #aaa;
    font-size: 28px;
    font-weight: bold;
    position: absolute;
    top: 10px;
    right: 25px;
    text-decoration: none;

}
.trainer-detail p {
    margin: 8px 0;
    font-size: 15px;
    color: #333;
    display: flex;
    align-items: baseline;
    gap: 8px; /* Kho?ng c?ch gi?a label v? value */
}

.trainer-detail img:hover {
    transform: scale(1.05);
}
.trainer-detail p strong {
    color: #007bff; /* M?u xanh n?i b?t cho label */
    font-weight: 600;
    min-width: 120px; /* ??m b?o label th?ng h?ng */
}

.close:hover,
.close:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
}

/* Th?m CSS ?? fix text overflow */
.trainer-detail p span {
    flex: 1; /* Cho ph?p span chi?m h?t kh?ng gian c?n l?i */
    word-break: break-word; /* Wrap text d?i, tr?nh overflow */
    white-space: normal; /* Cho ph?p wrap t? nhi?n */
    overflow-wrap: break-word; /* H? tr? wrap t? d?i */
    hyphens: auto; /* T? ??ng ng?t d?ng n?u c?n */
}

/* Th?m overflow cho modal n?u text qu? d?i */
.modal-content {
    overflow: hidden; /* Ng?n text tr?n ra ngo?i modal */
}



</style>