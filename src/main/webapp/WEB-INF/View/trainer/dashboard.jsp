<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trainer Dashboard</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f5f5f5;
            }


            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }
            .header {
                background-color: #333;
                color: white;
                padding: 15px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .welcome-message {
                font-size: 18px;
            }
            .header-menu {
                display: flex;
                gap: 20px;
            }
            .header-menu-item {
                color: white;
                text-decoration: none;
                font-size: 16px;
                font-weight: bold;
                padding: 5px 15px;
                cursor: pointer;
                border-radius: 4px;
            }
            .header-menu-item:hover {
                background-color: #555;
            }
            .header-menu-item.active {
                background-color: #007bff;
            }
            .logout-btn {
                background-color: #dc3545;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 4px;
                cursor: pointer;
                text-decoration: none;
            }
            .dashboard-section {
                background-color: white;
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                padding: 20px;
                margin-top: 20px;
            }
            h1, h2 {
                color: #333;
            }
            .tab-content {
                display: none;
            }
            .tab-content.active {
                display: block;
            }
            .sub-tabs {
                display: flex;
                border-bottom: 1px solid #ddd;
                margin-bottom: 20px;
            }
            .sub-tab {
                padding: 10px 20px;
                cursor: pointer;
                border-bottom: 2px solid transparent;
            }
            .sub-tab.active {
                border-bottom: 2px solid #007bff;
                font-weight: bold;
            }
            .sub-content {
                display: none;
            }
            .sub-content.active {
                display: block;
            }
            .profile-container {
                display: flex;
                flex-wrap: wrap;
                gap: 30px;
            }
            .profile-left {
                flex: 1;
                min-width: 250px;
                display: flex;
                flex-direction: column;
                align-items: center;
            }
            .profile-right {
                flex: 2;
                min-width: 300px;
            }
            .avatar-container {
                width: 200px;
                height: 200px;
                border-radius: 50%;
                overflow: hidden;
                margin-bottom: 15px;
                border: 3px solid #ddd;
                position: relative;
            }
            .avatar-container img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }
            .avatar-upload {
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                background-color: rgba(0, 0, 0, 0.6);
                padding: 8px 0;
                text-align: center;
                opacity: 0;
                transition: opacity 0.3s;
            }
            .avatar-container:hover .avatar-upload {
                opacity: 1;
            }
            .avatar-upload-btn {
                color: white;
                font-size: 14px;
                cursor: pointer;
            }
            .avatar-upload-btn:hover {
                text-decoration: underline;
            }
            .info-item {
                margin-bottom: 20px;
            }
            .info-item label {
                display: block;
                font-weight: bold;
                margin-bottom: 5px;
                color: #555;
            }
            .info-item .value {
                font-size: 16px;
            }
            .rating {
                display: flex;
                align-items: center;
                margin-top: -15px;
                gap: 5px;
                color: #6c757d;
            }
            .btn-edit {
                background-color: #007bff;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 4px;
                cursor: pointer;
                margin-top: 10px;
                text-align: center;
            }
            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }
            .form-group input, .form-group textarea {
                width: 98%;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
            }
            .schedule-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            .schedule-table th, .schedule-table td {
                border: 1px solid #ddd;
                padding: 12px;
                text-align: center;
            }
            .schedule-table th {
                background-color: #f2f2f2;
            }
            .schedule-time {
                font-weight: bold;
            }
            .schedule-session {
                background-color: #e3f2fd;
                border-radius: 4px;
                padding: 5px;
                margin: 5px 0;
            }
            .calendar-container {
                overflow-x: auto;
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            .calendar {
                width: 100%;
                border-collapse: collapse;
                table-layout: fixed;
                position: relative;
            }
            .calendar th, .calendar td {
                border: 1px solid #ddd;
                padding: 5px;
                text-align: center;
                height: 100px;
                position: relative;
                vertical-align: top;
            }
            .calendar th {
                background-color: #f2f2f2;
                font-weight: bold;
                height: auto;
            }
            .time-slot {
                font-weight: bold;
                background-color: #f2f2f2;
                padding: 5px;
                border-right: 1px solid #ddd;
                width: 80px;
                vertical-align: middle;
            }
            .calendar-cell {
                position: relative;
                height: 100%;
            }
            .event {
                background-color: #e3f2fd; /* Light blue for general events */
                border-radius: 4px;
                padding: 10px;
                font-size: 1em;
                position: absolute;
                width: calc(100% - 10px);
                z-index: 10;
                box-sizing: border-box;
                left: 5px;
            }
            .blue-event {
                background-color: #e3f2fd; /* Light blue for general events */
            }
            .red-event {
                background-color: #dc3545; /* Light blue for general events */
            }

            .purple-event {
                background-color: #f0e6f7; /* Light purple for kickboxing */
            }
            .event-title {
                font-weight: bold;
                margin-bottom: 5px;
                font-size: 1.1em;
            }
            .event-details {
                color: #555;
                font-size: 0.9em;
                margin-bottom: 8px;
            }
            .event-trainer {
                font-size: 0.9em;
                color: #007bff;
                margin-top: 5px;
            }
            .password-requirements {
                margin: 10px 0;
                padding: 10px;
                background-color: #f8f9fa;
                border-radius: 4px;
                border-left: 3px solid #007bff;
                font-size: 0.9em;
            }
            .password-requirements p {
                margin: 0 0 5px 0;
                font-weight: bold;
            }
            .password-requirements ul {
                margin: 0;
                padding-left: 20px;
            }
            .password-requirements li {
                margin: 3px 0;
            }
            .password-error {
                color: #dc3545;
                font-size: 0.85em;
                margin-top: 5px;
                min-height: 20px;
            }

            .btn-disabled {
                opacity: 0.6;
                cursor: not-allowed;
            }

            .message-container {
                margin-top: 15px;
                padding: 10px;
                border-radius: 4px;
                font-weight: bold;
                min-height: 20px;
            }

            .success-message {
                color: #155724;
            }

            .error-message {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            .btn-confirm{
                margin-top: 60px;
            }

        </style>
    </head>
    <body>
        <div class="header">
            <div class="welcome-message">Welcome, ${account.username}</div>

            <div class="header-menu">
                <a class="header-menu-item active" onclick="showTab('profile')">Profile</a>
                <a class="header-menu-item" onclick="showTab('schedule')">Calendar</a>
            </div>

            <a href="${pageContext.request.contextPath}/LogoutTrainer" class="logout-btn">Logout</a>
        </div>

        <div class="container">
            <!-- Profile Tab -->
            <div id="profile-tab" class="tab-content active">
                <h1>Trainer Profile</h1>

                <div class="dashboard-section">
                    <div class="sub-tabs">
                        <div class="sub-tab active" onclick="showSubTab('personal-info')">Personal Information</div>
                        <div class="sub-tab" onclick="showSubTab('change-password')">Change Password</div>
                    </div>

                    <!-- Personal Info Sub Tab -->
                    <div id="personal-info-tab" class="sub-content active">
                        <div class="profile-container">
                            <div class="profile-left">
                                <div class="avatar-container">
                                    <img id="avatar-preview" src="${pageContext.request.contextPath}/AvatarServlet?accountId=${account.accountId}" alt="Trainer Avatar" onerror="this.src='${pageContext.request.contextPath}/avatar/default.png';">
                                    <div class="avatar-upload">
                                        <label for="avatar-upload-input" class="avatar-upload-btn">
                                            <i class="fas fa-camera"></i> Change Photo
                                        </label>
                                        <input type="file" id="avatar-upload-input" accept="image/*" style="display: none;">
                                    </div>
                                </div>
                                <h2>${trainer.fullName}</h2>
                                <div class="rating">
                                    <div>Rating: ${trainer.rating}★</div>
                                </div>
                            </div>
                            <div class="profile-right">
                                <form id="profileForm" enctype="multipart/form-data">
                                    <div class="form-group">
                                        <label for="fullName">Full Name:</label>
                                        <input type="text" id="fullName" class="form-control" value="${trainer.fullName}">
                                    </div>
                                    <div class="form-group">
                                        <label for="email">Email:</label>
                                        <input type="email" id="email" class="form-control" value="${trainer.email}">
                                    </div>
                                    <div class="form-group">
                                        <label for="phone">Phone:</label>
                                        <input type="text" id="phone" class="form-control" value="${trainer.phone}">
                                    </div>
                                    <div class="form-group">
                                        <label for="experience">Experience:</label>
                                        <input type="number" id="experience" class="form-control" value="${trainer.experienceYears}">
                                    </div>
                                    <input type="hidden" id="avatarChanged" value="false">
                                    <button type="submit" class="btn-edit">Save</button>
                                    <div id="profileMessage" class="message-container"></div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Change Password Sub Tab -->
                    <div id="change-password-tab" class="sub-content">
                        <h2>Change Password</h2>
                        <form id="passwordForm">
                            <div class="form-group">
                                <label for="currentPassword">Current Password:</label>
                                <input type="password" id="currentPassword" required>
                                <div class="password-error" id="currentPassword-error"></div>
                            </div>
                            <div class="form-group">
                                <label for="newPassword">New Password:</label>
                                <input type="password" id="newPassword" required>
                                <div class="password-requirements">
                                    <p>Password must contain:</p>
                                    <ul>
                                        <li id="length">At least 8 characters</li>
                                        <li id="uppercase">At least one uppercase letter</li>
                                        <li id="lowercase">At least one lowercase letter</li>
                                        <li id="number">At least one number</li>
                                    </ul>
                                </div>
                                <div class="password-error" id="newPassword-error"></div>
                            </div>
                            <div class="form-group">
                                <label for="confirmPassword">Confirm New Password:</label>
                                <input type="password" id="confirmPassword" required>
                                <div class="password-error" id="confirmPassword-error"></div>
                            </div>
                            <button type="submit" class="btn-edit">Change Password</button>
                            <div id="passwordMessage" class="message-container"></div>
                        </form>
                    </div>
                </div>
            </div>

            <div id="schedule-tab" class="tab-content">
                <h1>Training Schedule</h1>
                <div class="date-picker">
                    <label for="start-date">Choose Day</label>
                    <input type="date" id="start-date" onchange="updateWeek()">
                </div>
                <div class="week-info" id="week-info"></div>
                <form method="post" action="dashboard" id="bookingForm">
                    <input type="hidden" name="trainerId" value="${trainer.trainerId}">
                    <!--<input type="hidden" name="action" id="action" value="confirm">-->
                    <div class="dashboard-section">
                        <!--<h2>Weekly Schedule</h2>-->
                        <div class="calendar-container">
                            <table class="calendar">
                                <thead>
                                    <tr>
                                        <th></th>
                                        <th>Monday</th>
                                        <th>Tuesday</th>
                                        <th>Wednesday</th>
                                        <th>Thursday</th>
                                        <th>Friday</th>
                                        <th>Saturday</th>
                                        <th>Sunday</th>
                                    </tr>
                                </thead>
                                <tbody id="schedule-table" class="schedule-body"></tbody>
                            </table>
                        </div>
                    </div>
                    <div id="selectedSlotsContainer"></div>
                </form>
            </div>
        </div>

        <script>
            // ==========================================
            // COMMON FUNCTIONS
            // ==========================================

            // Tab switching functionality
            function showTab(tabName) {
                // Hide all tabs
                document.querySelectorAll('.tab-content').forEach(tab => {
                    tab.classList.remove('active');
                });

                // Show the selected tab
                document.getElementById(tabName + '-tab').classList.add('active');

                // Update active state in menu
                document.querySelectorAll('.header-menu-item').forEach(item => {
                    item.classList.remove('active');
                    if (item.textContent.toLowerCase() === tabName.toLowerCase()) {
                        item.classList.add('active');
                    }
                });
            }

            // Sub-tab switching functionality
            function showSubTab(tabName) {
                // Hide all sub-tabs and update menu
                document.querySelectorAll('.sub-content').forEach(tab => {
                    tab.classList.remove('active');
                });
                document.querySelectorAll('.sub-tab').forEach(item => {
                    item.classList.remove('active');
                    if (item.getAttribute('onclick').includes(tabName)) {
                        item.classList.add('active');
                    }
                });

                // Show the selected sub-tab
                document.getElementById(tabName + '-tab').classList.add('active');
            }

            // ==========================================
            // PROFILE FUNCTIONS
            // ==========================================

            // Handle avatar file selection and preview
            document.getElementById('avatar-upload-input').addEventListener('change', function (e) {
                const file = e.target.files[0];
                if (file) {
                    document.getElementById('avatarChanged').value = 'true';
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        document.getElementById('avatar-preview').src = e.target.result;
                    };
                    reader.readAsDataURL(file);
                }
            });

            // Password form submission
            document.getElementById('passwordForm').addEventListener('submit', function (e) {
                e.preventDefault();

                const currentPassword = document.getElementById('currentPassword').value;
                const newPassword = document.getElementById('newPassword').value;
                const confirmPassword = document.getElementById('confirmPassword').value;

                // Reset errors
                document.getElementById('currentPassword-error').textContent = '';
                document.getElementById('newPassword-error').textContent = '';
                document.getElementById('confirmPassword-error').textContent = '';

                // Validation
                let isValid = true;

                if (!currentPassword) {
                    document.getElementById('currentPassword-error').textContent = 'Please enter your current password';
                    isValid = false;
                }

                if (!validatePassword(newPassword)) {
                    document.getElementById('newPassword-error').textContent = 'Password does not meet all requirements';
                    isValid = false;
                }

                if (newPassword !== confirmPassword) {
                    document.getElementById('confirmPassword-error').textContent = 'Passwords do not match';
                    isValid = false;
                }

                if (isValid) {
                    // Disable form
                    disableForm('#passwordForm');

                    // Submit password change
                    fetch('${pageContext.request.contextPath}/TrainerChangePasswordServlet', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: new URLSearchParams({
                            'currentPassword': currentPassword,
                            'newPassword': newPassword
                        })
                    })
                            .then(response => response.json())
                            .then(data => {
                                if (data.success) {
                                    showSuccess('#passwordForm', 'Password updated successfully!');
                                    document.getElementById('passwordForm').reset();
                                    reloadAfterDelay();
                                } else {
                                    enableForm('#passwordForm');
                                    showError('#passwordForm', data.message || 'Failed to update password');
                                    document.getElementById('currentPassword-error').textContent = data.message || 'Failed to update password';
                                }
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                enableForm('#passwordForm');
                                alert('An error occurred while updating password');
                            });
                }
            });

            // Profile form submission
            document.getElementById('profileForm').addEventListener('submit', function (e) {
                e.preventDefault();

                // Get form values
                const fullName = document.getElementById('fullName').value;
                const email = document.getElementById('email').value;
                const phone = document.getElementById('phone').value;
                const experience = document.getElementById('experience').value;
                const avatarChanged = document.getElementById('avatarChanged').value;

                // Basic validation
                if (!fullName || !email || !phone || !experience) {
                    alert('Please fill in all required fields');
                    return;
                }

                if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                    alert('Please enter a valid email address');
                    return;
                }

                // Create FormData
                const formData = new FormData();
                formData.append('fullName', fullName);
                formData.append('email', email);
                formData.append('phone', phone);
                formData.append('experienceYears', experience);
                formData.append('trainerId', '${trainer.trainerId}');
                formData.append('avatarChanged', avatarChanged);

                // Add avatar file if changed
                if (avatarChanged === 'true' && document.getElementById('avatar-upload-input').files.length > 0) {
                    formData.append('avatar', document.getElementById('avatar-upload-input').files[0]);
                }

                // Submit profile update
                fetch('${pageContext.request.contextPath}/trainer/update-profile', {
                    method: 'POST',
                    body: formData
                })
                        .then(response => response.json())
                        .then(data => {
                            if (data.status === 'success') {
                                document.getElementById('avatarChanged').value = 'false';
                                showSuccess('#profileForm', 'Profile updated successfully!');
                                disableForm('#profileForm');
                                reloadAfterDelay();
                            } else {
                                showError('#profileForm', 'Error: ' + data.message);
                                alert('Error: ' + data.message);
                            }
                        })
                        .catch(error => {
                            console.error('Error updating profile:', error);
                            alert('An error occurred while updating your profile. Please try again.');
                        });
            });

            // ==========================================
            // HELPER FUNCTIONS
            // ==========================================

            // Password validation
            function validatePassword(password) {
                return password.length >= 8 &&
                        /[A-Z]/.test(password) &&
                        /[a-z]/.test(password) &&
                        /\d/.test(password);
            }

            // Disable form elements
            function disableForm(formSelector) {
                document.querySelectorAll(`${formSelector} input, ${formSelector} button`).forEach(el => {
                    el.disabled = true;
                    if (el.tagName === 'BUTTON') {
                        el.classList.add('btn-disabled');
                    }
                });
            }

            // Enable form elements
            function enableForm(formSelector) {
                document.querySelectorAll(`${formSelector} input, ${formSelector} button`).forEach(el => {
                    el.disabled = false;
                    if (el.tagName === 'BUTTON') {
                        el.classList.remove('btn-disabled');
                    }
                });
            }

            // Show success message
            function showSuccess(formSelector, message) {
                const messageContainer = document.querySelector(`${formSelector} .message-container`);
                messageContainer.innerHTML = message;
                messageContainer.className = 'message-container success-message';
            }

            // Show error message
            function showError(formSelector, message) {
                const messageContainer = document.querySelector(`${formSelector} .message-container`);
                messageContainer.innerHTML = message;
                messageContainer.className = 'message-container error-message';
            }

            // Reload page after delay
            function reloadAfterDelay() {
                setTimeout(() => {
                    window.location.reload();
                }, 1000);
            }

            // ==========================================
            // CALENDAR FUNCTIONS
            // ==========================================

            // Initialize calendar when DOM is loaded
            document.addEventListener('DOMContentLoaded', function () {
                // Initialize calendar when Calendar tab is shown
                document.querySelectorAll('.header-menu-item').forEach(item => {
                    if (item.textContent === 'Calendar') {
                        item.addEventListener('click', () => setTimeout(initCalendar, 100));
                    }
                });

                // Initialize calendar if it's active on page load
                if (document.getElementById('schedule-tab').classList.contains('active')) {
                    setTimeout(initCalendar, 100);
                }
            });

            // Calendar initialization
            function initCalendar() {
                // Calculate average row height
                const rows = document.querySelectorAll('.calendar tr');
                let totalHeight = 0;
                rows.forEach((row, index) => {
                    if (index > 0)
                        totalHeight += row.offsetHeight;
                });
                const avgRowHeight = totalHeight / (rows.length - 1);

                // Process each event
                document.querySelectorAll('.event').forEach(event => {
                    const timeText = event.querySelector('.event-details small')?.textContent;
                    if (!timeText)
                        return;

                    const times = timeText.match(/(\d+):(\d+)([ap]m)\s*-\s*(\d+):(\d+)([ap]m)/i);
                    if (times) {
                        // Parse times and calculate duration
                        let startHour = parseInt(times[1]);
                        const startMinute = parseInt(times[2]);
                        const startPeriod = times[3].toLowerCase();

                        let endHour = parseInt(times[4]);
                        const endMinute = parseInt(times[5]);
                        const endPeriod = times[6].toLowerCase();

                        if (startPeriod === 'pm' && startHour < 12)
                            startHour += 12;
                        if (endPeriod === 'pm' && endHour < 12)
                            endHour += 12;

                        const duration = (endHour + endMinute / 60) - (startHour + startMinute / 60);

                        // Set event height
                        const heightInPixels = Math.max(100, duration * avgRowHeight * 1.3);
                        event.style.height = heightInPixels + 'px';
                        event.style.top = '2px';
                    }
                });
            }
        </script>

        <script>
            var timeSlots = JSON.parse('<%= request.getAttribute("timeSlots")%>');
            var booking = JSON.parse('<%= request.getAttribute("booking")%>');
            var trainer = JSON.parse('<%= request.getAttribute("trainerJ")%>');
            var schedules = JSON.parse('<%= request.getAttribute("schedules")%>');
            var slotAvailability = JSON.parse('<%= request.getAttribute("slotAvailability")%>');

            window.onload = function () {
                updateWeek();
            };
            function updateWeek() {
                var selectedDate = document.getElementById('start-date').value;
                var startDate = selectedDate ? new Date(selectedDate) : new Date();
                var startDay = startDate.getDay();
                var startOfWeek = new Date(startDate);
                if (startDay === 0) {
                    startOfWeek.setDate(startDate.getDate() - 6);
                } else {
                    startOfWeek.setDate(startDate.getDate() - startDay + 1);
                }

                var endOfWeek = new Date(startOfWeek);
                endOfWeek.setDate(startOfWeek.getDate() + 6);

                var weekInfo = document.getElementById('week-info');
                weekInfo.innerHTML = "To " + formatDate(startOfWeek) + " from " + formatDate(endOfWeek);
                var tbody = document.getElementById('schedule-table');
                tbody.innerHTML = ''; // Clear previous table content

                for (var i = 0; i < timeSlots.length; i++) {
                    var row = '<tr>';
                    row += '<td class="time-slot">' + timeSlots[i] + '</td>';

                    for (var j = 0; j < 7; j++) {
                        var currentDay = new Date(startOfWeek);
                        currentDay.setDate(startOfWeek.getDate() + j);
                        var formattedDate = formatDate(currentDay);
                        var isBooked = false;
                        var isPastTime = false;
                        for (var k = 0; k < booking.length; k++) {
                            var bookingDate = booking[k].bookingDate;
                            var dateObject = new Date(bookingDate.year, bookingDate.month - 1, bookingDate.day); // month is 0-indexed in JavaScript
                            if (booking[k].scheduleId === schedules[i].scheduleId && formatDate(dateObject) === formattedDate) {
                                if (booking[k].status === 'confirmed' || booking[k].status === 'pending') {
                                    isBooked = true;
                                }
                                break;
                            }
                        }

                        // Kiểm tra nếu đã quá thời gian
                        var startTime = getStartTimeByScheduleId(schedules[i].scheduleId);
                        var slotDateTime = new Date(currentDay);
                        slotDateTime.setHours(startTime.hour, startTime.minute, 0, 0);  // Kết hợp ngày và giờ

                        var now = new Date();
                        console.log(slotDateTime);
                        console.log(now);
                        if (now > slotDateTime) {
                            isPastTime = true;
                        }
                        console.log(isBooked);
                        console.log(isPastTime);

                        if (!isBooked && !isPastTime) {
//                            console.log(slotAvailability[0].slotDate);
                            var availability = slotAvailability.find(function (item) {
                                var slotDate = new Date(item.slotDate.year, item.slotDate.month - 1, item.slotDate.day);
                                console.log(slotDate);
                                // Chuẩn hóa cả item.slotDate và formattedDate về dạng yyyy-MM-dd
                                var itemDate = slotDate.toLocaleDateString('en-CA');
                                console.log(itemDate + '---' + formattedDate);
                                console.log(item.scheduleId + '--' + schedules[i].scheduleId);
                                return item.scheduleId === schedules[i].scheduleId && itemDate === formattedDate;
                            });
//                            console.log(availability);
                            var isSlotAvailable = availability ? availability.isAvailable : true;

                            row += '<td class="calendar-cell">' +
                                    '<select name="slotStatus" data-schedule-id="' + schedules[i].scheduleId + '" data-date="' + formattedDate + '" onchange="updateSlotStatus(this)">' +
                                    '<option value="true" ' + (isSlotAvailable ? 'selected' : '') + '>ON</option>' +
                                    '<option value="false" ' + (!isSlotAvailable ? 'selected' : '') + '>OFF</option>' +
                                    '</select>' +
                                    '</td>';

                        } else {
                            if (isPastTime && !isBooked) {
                                row += '<td class="calendar-cell"></td>';
                            } else {
                                for (var k = 0; k < booking.length; k++) {
                                    var bookingDate = booking[k].bookingDate;
                                    var dateObject = new Date(bookingDate.year, bookingDate.month - 1, bookingDate.day);
                                    var currentScheduleId = schedules[i].scheduleId;
                                    if (booking[k].scheduleId === currentScheduleId && formatDate(dateObject) === formattedDate) {
                                        if (booking[k].status === 'confirmed' && booking[k].trainer.trainerId === trainer.trainerId) {
                                            console.log(booking[k].bookingId);

                                            var startTime = getStartTimeByScheduleId(currentScheduleId);
                                            var slotDateTime = new Date(dateObject.getFullYear(), dateObject.getMonth(), dateObject.getDate(), startTime.hour, startTime.minute || 0, 0, 0);
                                            var now = new Date();
                                            var className = (slotDateTime.getTime() - now.getTime() < 0) ? 'event red-event' : 'event blue-event';
                                            row += '<td class="calendar-cell">' +
                                                    '<div class="' + className + '" disabled>' + booking[k].customer.fullName + '</div>';

                                        } else if (booking[k].status === 'pending' && booking[k].trainer.trainerId === trainer.trainerId) {
                                            var startTime = getStartTimeByScheduleId(currentScheduleId);
                                            var slotDateTime = new Date(dateObject.getFullYear(), dateObject.getMonth(), dateObject.getDate(), startTime.hour, startTime.minute || 0, 0, 0);
                                            var now = new Date();
                                            if ((slotDateTime.getTime() - now.getTime()) > 0) {
                                                var className = (slotDateTime.getTime() - now.getTime() < 0) ? 'event red-event' : 'event blue-event';
                                                row += '<td class="calendar-cell">' +
                                                        '<div class="' + className + '" disabled>' + booking[k].customer.fullName + '</div>';
                                                row += '<button class="btn-confirm" type="submit" data-bookingConfirm="' + booking[k].bookingId + '" onclick="confirmBooking(this)">Xác Nhận</button>';
                                                row += '<button class="btn-confirm" type="submit" data-bookingConfirm="' + booking[k].bookingId + '" onclick="cancelBooking(this)">Hủy</button>';

                                                console.log(booking[k].bookingId);
                                            }
                                        } else {

                                            row += '<td class="calendar-cell">';
                                        }
                                        console.log(booking[k].status);

                                        break;
                                    }
                                }
                            }

                            row += '</td>';
                        }

                    }

                    row += '</tr>';
                    tbody.innerHTML += row; // Add the row to the table
                }  // Add the row to the table
            }
            function updateSlotStatus(selectElement) {
                // Lấy các thuộc tính từ select
                const scheduleId = selectElement.getAttribute("data-schedule-id");
                const selectedValue = selectElement.value;  // Giá trị "ON" hoặc "OFF"
                const selectedDate = selectElement.getAttribute("data-date");

                // Tạo các input ẩn để gửi dữ liệu qua form
                const hiddenScheduleId = document.createElement("input");
                hiddenScheduleId.type = "hidden";
                hiddenScheduleId.name = "scheduleId[]";
                hiddenScheduleId.value = scheduleId;
                document.getElementById('selectedSlotsContainer').appendChild(hiddenScheduleId);

                const hiddenDate = document.createElement("input");
                hiddenDate.type = "hidden";
                hiddenDate.name = "bookingDate[]";
                hiddenDate.value = selectedDate;
                document.getElementById('selectedSlotsContainer').appendChild(hiddenDate);

                const hiddenStatus = document.createElement("input");
                hiddenStatus.type = "hidden";
                hiddenStatus.name = "slotStatus[]";
                hiddenStatus.value = selectedValue;
                document.getElementById('selectedSlotsContainer').appendChild(hiddenStatus);

                // Cập nhật action cho form
                const actionInput = document.createElement("input");
                actionInput.type = "hidden";
                actionInput.name = "action";
                actionInput.value = "update";  // Đây là giá trị action mà bạn muốn gửi
                document.getElementById('selectedSlotsContainer').appendChild(actionInput);

                // Gửi form ngay lập tức khi thay đổi giá trị
                document.getElementById('bookingForm').submit();
            }
            
            function cancelBooking(button){
                var bookingId = button.getAttribute('data-bookingConfirm'); // lấy giá trị từ button
                console.log(bookingId);

                // Thêm hidden input cho bookingId vào form
                var form = document.getElementById('bookingForm'); // form cần phải có trong HTML
                var hiddenBookingId = document.createElement("input");
                hiddenBookingId.type = "hidden";
                hiddenBookingId.name = "bookingId";  // Lưu lại bookingId
                hiddenBookingId.value = bookingId;  // Gán bookingId 
                form.appendChild(hiddenBookingId); // Thêm vào form

// Cập nhật action cho form
                const actionInput = document.createElement("input");
                actionInput.type = "hidden";
                actionInput.name = "action";
                actionInput.value = "cancel";  // Đây làs giá trị action mà bạn muốn gửi
                document.getElementById('selectedSlotsContainer').appendChild(actionInput);

                // Submit form
                form.submit();
            }

            function confirmBooking(button) {
                var bookingId = button.getAttribute('data-bookingConfirm'); // lấy giá trị từ button
                console.log(bookingId);

                // Thêm hidden input cho bookingId vào form
                var form = document.getElementById('bookingForm'); // form cần phải có trong HTML
                var hiddenBookingId = document.createElement("input");
                hiddenBookingId.type = "hidden";
                hiddenBookingId.name = "bookingId";  // Lưu lại bookingId
                hiddenBookingId.value = bookingId;  // Gán bookingId 
                form.appendChild(hiddenBookingId); // Thêm vào form

// Cập nhật action cho form
                const actionInput = document.createElement("input");
                actionInput.type = "hidden";
                actionInput.name = "action";
                actionInput.value = "confirm";  // Đây là giá trị action mà bạn muốn gửi
                document.getElementById('selectedSlotsContainer').appendChild(actionInput);

                // Submit form
                form.submit();
            }


            function getStartTimeByScheduleId(scheduleId) {
                for (var i = 0; i < schedules.length; i++) {
                    if (String(schedules[i].scheduleId) === String(scheduleId)) {
                        return schedules[i].startTime;
                    }
                }
                return {hour: 0, minute: 0};
            }

            function formatDate(date) {
                var dd = date.getDate();
                var mm = date.getMonth() + 1;
                var yyyy = date.getFullYear();
                if (dd < 10)
                    dd = '0' + dd;
                if (mm < 10)
                    mm = '0' + mm;
                return yyyy + '-' + mm + '-' + dd; // ??nh d?ng yyyy-MM-dd cho ng�y
            }

            function getTimeSlotByScheduleId(scheduleId) {
                for (var i = 0; i < schedules.length; i++) {
                    if (String(schedules[i].scheduleId) === String(scheduleId)) {
                        var startTime = schedules[i].startTime;
                        var endTime = schedules[i].endTime;
                        var startHour = startTime.hour;
                        var startMinute = startTime.minutes ? startTime.minutes : '00';
                        var endHour = endTime.hour;
                        var endMinute = endTime.minutes ? endTime.minutes : '00';
                        return startHour + ':' + startMinute + ' - ' + endHour + ':' + endMinute;
                    }
                }
                return 'Unknown';
            }
        </script>
    </body>
</html> 