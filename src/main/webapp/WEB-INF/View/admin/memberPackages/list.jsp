<div class="table-container" id="memberPackagesTable">
    <div class="table-container__header">
        <h2 class="table-container__title">Member Packages List</h2>
        <p class="table-container__description">Manage member packages</p>
        <div style="margin-bottom: 20px; display: flex; gap: 20px; align-items: end; justify-content: flex-end;">
            <label for="username"></label>
            <input type="text" id="username"
                   name="username" placeholder="Enter username..."
                   oninput="loadMemberPackage()"
                   style="padding: 8px; border: 1px solid #ccc; border-radius: 5px;">

            <label for="packageName"></label>
            <select  style="padding: 8px; border: 1px solid #ccc; border-radius: 5px;" id="packageName" name="packageName" onchange="loadMemberPackage()">
                <option value="">Select Package</option>
                <!-- Package options will be added here via JavaScript -->
            </select>

            <label for="paymentStatus"></label>
            <select  style="padding: 8px; border: 1px solid #ccc; border-radius: 5px;" id="paymentStatus" name="paymentStatus" onchange="loadMemberPackage()">
                <option value="">All</option>
                <option value="paid">Paid</option>
                <option value="unpaid">Unpaid</option>
                <option value="cancelled">Cancelled</option>
            </select>
        </div>
    </div>

    <div class="table-container__content" style="overflow-x: auto;">
        <div id="successMessage" style="display: none; color: green; font-weight: bold;">
            Status updated successfully!
        </div>
        <div id="errorMessage" style="display: none; color: red; font-weight: bold; margin-bottom: 10px;">
            L?i: Không th? c?p nh?t tr?ng thái!
        </div>
        <table class="data-table" id="trainerPackageTable">
            <thead>
                <tr>
                    <th style="width: 20px">No.</th>
                    <th style="width: 50px">Username</th>
                    <th style="width: 50px">Package Name</th>
                    <th style="width: 50px">Start Date</th>
                    <th style="width: 50px">End Date</th>
                    <th style="width: 50px">Status</th>
                </tr>
            </thead>

            <tbody id="trainerPackageTableBody">
                <!-- Data will be injected here by JavaScript -->
            </tbody>
        </table>
    </div>
</div>

