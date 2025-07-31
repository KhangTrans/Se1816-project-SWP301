<%@include file="/WEB-INF/View/admin/trainers/create.jsp" %>
<%@include file="/WEB-INF/View/admin/trainers/edit.jsp" %>
<%@include file="/WEB-INF/View/admin/trainers/delete.jsp" %>
<%@include file="/WEB-INF/View/admin/trainers/viewDetail.jsp" %>

<div class="table-container" id="trainersTable">
    <div class="table-container__header">
        <h2 class="table-container__title">Trainer List</h2>
        <p class="table-container__description">Manage Trainer information</p>

        <!-- Tìm ki?m và l?c -->
        <div class="row g-2 mb-3 align-items-end d-flex justify-content-end">
            <div class="col-md-5">
                <input type="text" id="searchTerm" class="form-control" placeholder="Search by name or username" onkeyup="loadTrainers()">
            </div>

            <div class="col-md-3">
                <select id="experienceFilter" class="form-select" onchange="loadTrainers()">
                    <option value="">Select experience</option>
                    <option value="1">1+ year</option>
                    <option value="2">2+ years</option>
                    <option value="3">3+ years</option>
                </select>
            </div>

            <div class="col-md-3">
                <select id="ratingFilter" class="form-select" onchange="loadTrainers()">
                    <option value="">Select rating</option>
                    <option value="1">1+ stars</option>
                    <option value="2">2+ stars</option>
                    <option value="3">3+ stars</option>
                    <option value="4">4+ stars</option>
                    <option value="5">5 stars</option>
                </select>
            </div>
        </div>

    </div>

    <div class="table-container__content" style="overflow-x: auto;">
        <button class="add-button" onclick="openModal('addTrainer')">+ Add Trainer</button>
        <table class="data-table" id="trainerTable">
            <thead>
                <tr>
                    <th style="width: 60px">Avatar</th>
                    <th style="width: 80px">USN</th>
                    <th style="width: 150px">Full Name</th>
                    <th style="width: 50px">Experience</th>
                    <th style="width: 50px">Rating</th>
                    <th style="width: 90px">Session Price (VND)</th>
                    <th style="width: 130px">Action</th>
                </tr>
            </thead>
            <tbody id="trainerTableBody">
                <!-- Trainers will be inserted here by JavaScript -->
            </tbody>
        </table>
    </div>
</div>