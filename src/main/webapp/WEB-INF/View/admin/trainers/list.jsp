<%@include file="/WEB-INF/View/admin/trainers/create.jsp" %>
<%@include file="/WEB-INF/View/admin/trainers/edit.jsp" %>
<%@include file="/WEB-INF/View/admin/trainers/delete.jsp" %>

<div class="table-container" id="trainersTable">
    <div class="table-container__header">
        <h2 class="table-container__title">Trainer List</h2>
        <p class="table-container__description">Manage Trainer information</p>

        <!-- Tìm ki?m và l?c -->
        <div>
            <input type="text" id="searchTerm" placeholder="Tìm ki?m theo tên ho?c username" onkeyup="loadTrainers()">
            <select id="experienceFilter" onchange="loadTrainers()">
                <option value="">Ch?n kinh nghi?m</option>
                <option value="1">1+ N?m</option>
                <option value="2">2+ N?m</option>
                <option value="3">3+ N?m</option>
            </select>
            <select id="ratingFilter" onchange="loadTrainers()">
                <option value="">Ch?n Rating</option>
                <option value="1">1+ sao</option>
                <option value="2">2+ sao</option>
                <option value="3">3+ sao</option>
                <option value="4">4+ sao</option>
                <option value="5">5 sao</option>
            </select>
        </div>
    </div>

    <div class="table-container__content" style="overflow-x: auto;">
        <button class="add-button" onclick="openModal('addTrainer')">+ Add Trainer</button>
        <table class="data-table" id="trainerTable">
            <thead>
                <tr>
                    <th style="width: 50px">No</th>
                    <th>Avatar</th>
                    <th>Username</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Position</th>
                    <th>Experience</th>
                    <th>Rating</th>
                    <th>Session Price (VND)</th>
                    <th style="width: 150px">Action</th>
                </tr>
            </thead>
            <tbody id="trainerTableBody">
                <!-- Trainers will be inserted here by JavaScript -->
            </tbody>
        </table>
    </div>
</div>