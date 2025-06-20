


<%@include file="/WEB-INF/View/admin/trainers/create.jsp" %>
<%@include file="/WEB-INF/View/admin/trainers/edit.jsp" %>
<%@include file="/WEB-INF/View/admin/trainers/delete.jsp" %>
<div class="table-container" id="trainersTable">
    <div class="table-container__header">
        <h2 class="table-container__title">Trainer List</h2>
        <p class="table-container__description">Manage Trainer information</p>
    </div>
    <div class="table-container__content" style="overflow-x: auto;">
        <button class="add-button" onclick="openModal('addTrainer')">+ Add Trainer</button>
        <table class="data-table" id="trainerTable">
            <thead>

                <tr>
                    <th>No</th>
                    <th>Avatar</th>
                    <th>Username</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Position</th>
                    <th>Experience</th>
                    <th>Rating</th>
                    <th>Action</th>
                </tr>

            </thead>
            <tbody>

            </tbody>
        </table>
    </div>
</div>