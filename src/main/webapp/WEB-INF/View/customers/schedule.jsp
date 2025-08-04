<%@page import="Model.TrainerBooking"%>
<%@page import="java.util.List"%>

<div class="container-profile" id="schedule">
    <div>
        <h1 class="header-content">Work Schedule</h1>
        <div class="form-profile">
            <div class="date-picker">
                <label for="start-date">Select Start Date:</label>
                <input type="date" id="start-date" class="date-input" onchange="updateWeek()">
            </div>

            <div class="week-info" id="week-info"></div>
            <form method="post" action="profile" id="bookingForm">
                <input type="hidden" name="action" id="action" value="cancel">
                <div class="schedule-container">
                    <table class="schedule-table">
                        <thead class="table-header">
                            <tr>
                                <th class="time-header">Hours</th>
                                <th class="day-header">Monday</th>
                                <th class="day-header">Tuesday</th>
                                <th class="day-header">Wednesday</th>
                                <th class="day-header">Thursday</th>
                                <th class="day-header">Friday</th>
                                <th class="day-header">Saturday</th>
                                <th class="day-header">Sunday</th>
                            </tr>
                        </thead>
                        <tbody id="schedule-table" class="schedule-body"></tbody>
                    </table>
                </div>
                <div id="selectedSlotsContainer"></div>
            </form>
        </div>
    </div>
</div>



<!-- Modal x?c nh?n h?y -->
<div id="confirmationModal" style="display: none;">
    <div class="modal-content">
        <div class="modal-header">
            <h2 id="modal-title">Confirm Cancellation</h2>
        </div>
        <div class="modal-body">
            <div class="trainer-info">
                <h3 id="modal-name" style="margin: 0; color: #fff;"></h3>
            </div>
            <p id="modal-details"></p>
        </div>
        <div class="modal-footer">
            <div style="display: flex; justify-content: center; gap: 15px; width: 100%;">
                <button id="confirmBtn" style="flex: 1; max-width: 150px; margin: 0;" onclick="confirmAction()">Confirm</button>
                <button id="cancelBtn" style="flex: 1; max-width: 150px; margin: 0;" onclick="closeModal()">Cancel</button>
            </div>
        </div>
    </div>
</div>


<script>
    // Ki?m tra xem c? th?ng b?o t? Servlet kh?ng
    <% String notificationMessage = (String) session.getAttribute("notificationMessage");
        if (notificationMessage != null) {
            session.removeAttribute("notificationMessage");
        }%>
    if ("<%= notificationMessage != null ? notificationMessage : ""%>" !== "") {
        showToast("<%= notificationMessage%>", "success");
    }
</script>

<style>
    /* Modal styles */
    #confirmationModal {
        position: fixed;
        top: 0;
        left: 0;
        width: 100vw;
        height: 100vh;
        background-color: rgba(0, 0, 0, 0.7);
        display: flex;
        justify-content: center;
        align-items: flex-start;
        padding-top: 200px;
        z-index: 10000;
    }
    
    .modal-content {
        background: linear-gradient(to bottom, #1a2a3a, #0d1b29);
        border-radius: 15px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
        width: 90%;
        max-width: 500px;
        max-height: 70vh;
        display: flex;
        flex-direction: column;
        text-align: center;
        position: relative;
        color: #fff;
        margin: 0 auto;
        left: 0;
        right: 0;
        overflow: hidden;
        border: 1px solid rgba(217, 255, 104, 0.3);
    }
    
    .modal-header {
        padding: 20px 30px;
        border-bottom: 1px solid rgba(217, 255, 104, 0.2);
        position: sticky;
        top: 0;
        background: linear-gradient(to right, #1a2a3a, #162533);
        z-index: 1;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    
    .modal-body {
        flex: 1;
        overflow-y: auto;
        padding: 25px 50px;
        max-height: calc(70vh - 140px);
        text-align: left;
    }
    
    .modal-footer {
        padding: 20px 30px;
        border-top: 1px solid rgba(217, 255, 104, 0.2);
        position: sticky;
        bottom: 0;
        background: linear-gradient(to right, #162533, #1a2a3a);
        z-index: 1;
    }
    
    #modal-title {
        color: #d9ff68;
        margin: 0;
        font-size: 24px;
        font-weight: bold;
        letter-spacing: 0.5px;
    }
    
    #modal-details {
        margin-bottom: 20px;
        line-height: 1.8;
        color: #fff;
    }
    
    .booking-item {
        background: rgba(30, 40, 50, 0.5);
        border-radius: 8px;
        padding: 20px 30px;
        margin-bottom: 20px;
        margin-left: 10px;
        margin-right: 10px;
        border-left: 3px solid #d9ff68;
    }
    
    .booking-item:last-child {
        margin-bottom: 0;
    }
    
    .booking-row {
        display: flex;
        align-items: center;
        margin-bottom: 12px;
        padding-left: 8px;
    }
    
    .booking-row:last-child {
        margin-bottom: 0;
    }
    
    .booking-label {
        width: 85px;
        color: #d9ff68;
        font-weight: 600;
        padding-right: 10px;
    }
    
    .booking-value {
        flex: 1;
        color: #fff;
    }
    
    .trainer-info {
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 10px;
        margin-bottom: 20px;
        border-radius: 10px;
    }
    
    #confirmBtn, #cancelBtn {
        padding: 12px 25px;
        border: none;
        border-radius: 8px;
        font-weight: bold;
        color: #111;
        cursor: pointer;
        transition: all 0.3s;
    }
    
    #confirmBtn {
        background: linear-gradient(135deg, #d9ff68 0%, #a9db00 100%);
    }
    
    #confirmBtn:hover {
        transform: translateY(-3px);
        box-shadow: 0 10px 20px rgba(217, 255, 104, 0.3);
    }
    
    #cancelBtn {
        background: linear-gradient(135deg, #ff6b6b 0%, #ff4757 100%);
        margin-left: 15px;
    }
    
    #cancelBtn:hover {
        background: linear-gradient(135deg, #ff4757 0%, #ff3545 100%);
        box-shadow: 0 10px 20px rgba(255, 71, 87, 0.3);
        transform: translateY(-3px);
    }
    
    /* Responsive adjustments */
    @media (max-width: 768px) {
        .modal-content {
            width: 95%;
            margin: 10px;
        }
        
        .modal-body {
            padding: 20px 25px;
        }
        
        .modal-header, .modal-footer {
            padding: 15px 20px;
        }
        
        #modal-title {
            font-size: 20px;
        }
        
        #confirmBtn, #cancelBtn {
            padding: 10px 20px;
            font-size: 14px;
        }
    }
    
    /* Toast notification styles */
    .toast-container {
        position: fixed;
        bottom: 20px;
        right: 20px;
        z-index: 9999;
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .toast {
        padding: 15px 20px;
        border-radius: 8px;
        min-width: 250px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        transform: translateX(100%);
        opacity: 0;
        transition: all 0.3s ease;
        font-weight: 500;
    }

    .toast--visible {
        transform: translateX(0);
        opacity: 1;
    }

    .toast--success {
        background-color: #2c3e50;
        color: #d9ff68;
        border-left: 4px solid #d9ff68;
        border: 1px solid #d9ff68;
    }

    .toast--error {
        background-color: #f8d7da;
        color: #721c24;
        border-left: 4px solid #dc3545;
    }
</style>

<script>
    var timeSlots = JSON.parse('<%= request.getAttribute("timeSlots")%>');
    var schedules = JSON.parse('<%= request.getAttribute("schedules")%>');
    var booking = JSON.parse('<%= request.getAttribute("booking")%>');
    var mybooking = JSON.parse('<%= request.getAttribute("mybooking")%>');
    console.log(mybooking.length);

    window.onload = function () {
        // Set default date to today
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0');
        var yyyy = today.getFullYear();
        var todayFormatted = yyyy + '-' + mm + '-' + dd;
        document.getElementById('start-date').value = todayFormatted;

        updateWeek(); // Auto display current week when page loads
    };

    function updateWeek() {
        var selectedDate = document.getElementById('start-date').value;
        var startDate = selectedDate ? new Date(selectedDate) : new Date();
        var startDay = startDate.getDay();
        var startOfWeek = new Date(startDate);
        if (startDay === 0) {
            // Sunday, go back to Monday of previous week
            startOfWeek.setDate(startDate.getDate() - 6);
        } else {
            // Other days, calculate Monday of this week
            startOfWeek.setDate(startDate.getDate() - startDay + 1);
        }

        var endOfWeek = new Date(startOfWeek);
        endOfWeek.setDate(startOfWeek.getDate() + 6); // Sunday

        var weekInfo = document.getElementById('week-info');
        weekInfo.innerHTML = "From " + formatDate(startOfWeek) + " to " + formatDate(endOfWeek);
        var tbody = document.getElementById('schedule-table');
        tbody.innerHTML = ''; // Clear previous table content

        for (var i = 0; i < timeSlots.length; i++) {
            var row = '<tr>';
            row += '<td class="time-slot">' + timeSlots[i] + '</td>'; // Display hour in "Hour" column

            for (var j = 0; j < 7; j++) {
                var currentDay = new Date(startOfWeek);
                currentDay.setDate(startOfWeek.getDate() + j); // Calculate day for each day of the week
                var formattedDate = formatDate(currentDay);
                var isBooked = false;
                // Check booking with status = 'confirmed' and corresponding date
                for (var k = 0; k < booking.length; k++) {
                    var bookingDate = booking[k].bookingDate;
                    var dateObject = new Date(bookingDate.year, bookingDate.month - 1, bookingDate.day); // month is 0-indexed in JavaScript
                    if (booking[k].scheduleId === schedules[i].scheduleId && formatDate(dateObject) === formattedDate) {
                        if (booking[k].status === 'confirmed') {
                            isBooked = true;
                        }
                        break;
                    }
                }
                if (!isBooked) {
                    row += '<td>' +
                            '<div class="slot-available"></div>' +
                            '</td>';
                } else {
                    for (var k = 0; k < booking.length; k++) {
                        var bookingDate = booking[k].bookingDate;
                        var dateObject = new Date(bookingDate.year, bookingDate.month - 1, bookingDate.day);
                        var currentScheduleId = schedules[i].scheduleId;
                        if (booking[k].scheduleId === currentScheduleId && formatDate(dateObject) === formattedDate) {
                            if (booking[k].status === 'confirmed' && booking[k].customer.account.accountId === <%= session.getAttribute("accountId")%>) {
                                console.log(booking[k].bookingId);
                                for (var g = 0; g < mybooking.length; g++) {
                                    if (mybooking[g].bookingId === booking[k].bookingId) {
                                        console.log(mybooking[g].trainer.fullName);
                                        var startTime = getStartTimeByScheduleId(currentScheduleId);
                                        var slotDateTime = new Date(dateObject.getFullYear(), dateObject.getMonth(), dateObject.getDate(), startTime.hour, startTime.minute || 0, 0, 0);
                                        var now = new Date();
                                        var className = (slotDateTime.getTime() - now.getTime() < 0) ? 'trainer-name completed' : 'trainer-name upcoming';
                                        row += '<td class="slot-cell">' +
                                                '<button class="' + className + '" disabled>' + mybooking[g].trainer.fullName + '</button>';
                                        if ((slotDateTime.getTime() - now.getTime()) > 3 * 60 * 60 * 1000) {
                                            row += '<button type="button" class="cancel-btn" ' +
                                                    'data-booking="' + mybooking[g].bookingId + '" ' +
                                                    'data-schedule-id="' + schedules[i].scheduleId + '" ' +
                                                    'data-trainer-name="' + mybooking[g].trainer.fullName + '" ' +
                                                    'onclick="confirmCancel(this, \'' + formattedDate + '\')">Cancel</button>';
                                        } else {
                                            row += '<button class="cancel-btn" disabled>Can\'t cancel</button>';
                                        }

                                    }
                                }

                            } else {
                                row += '<td class="slot-cell">';
                            }
                            break;
                        }
                    }

                    row += '</td>';
                }
            }

            row += '</tr>';
            tbody.innerHTML += row; // Add the row to the table
        }
    }

    function confirmAction() {
        if (actionType === 'cancel') {
            document.getElementById("action").value = actionType;
            console.log(actionType);
            document.getElementById('bookingForm').submit();
        }
    }

    function confirmCancel(button, date) {
        actionType = 'cancel'; // Set action to "cancel"

        // Get bookingId and scheduleId from data-booking and data-schedule-id attributes
        var bookingId = button.getAttribute('data-booking');
        var scheduleId = button.getAttribute('data-schedule-id');
        var trainerName = button.getAttribute('data-trainer-name');

        var timeSlot = getTimeSlotByScheduleId(scheduleId);  // Get slot time
        var modalDetails = document.getElementById('modal-details');
        var modalName = document.getElementById('modal-name');

        // Add hidden input for bookingId to form
        var details = '<div class="booking-item">';
        details += '<div class="booking-row"><span class="booking-label">Date:</span><span class="booking-value">' + date + '</span></div>';
        details += '<div class="booking-row"><span class="booking-label">Time:</span><span class="booking-value">' + timeSlot + '</span></div>';
        details += '</div>';
        modalName.innerHTML = trainerName;
        modalDetails.innerHTML = details;
        var container = document.getElementById('selectedSlotsContainer');
        var hiddenBookingId = document.createElement("input");
        hiddenBookingId.type = "hidden";
        hiddenBookingId.name = "bookingId";  // Save bookingId
        hiddenBookingId.value = bookingId;  // Assign bookingId 
        container.appendChild(hiddenBookingId);
        // Change modal title
        document.getElementById('modal-title').innerHTML = 'Confirm Cancellation';

        // Display cancellation modal
        document.getElementById('confirmationModal').style.display = 'flex';
    }

    function closeModal() {
        document.getElementById('confirmationModal').style.display = 'none';
    }

    function getStartTimeByScheduleId(scheduleId) {
        for (var i = 0; i < schedules.length; i++) {
            if (String(schedules[i].scheduleId) === String(scheduleId)) {
                // startTime is object with .hour and .minute
                return schedules[i].startTime;
            }
        }
        // fallback
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
        return yyyy + '-' + mm + '-' + dd; // Format yyyy-MM-dd for date
    }

    function addHiddenInput(checkbox) {
        var container = document.getElementById('selectedSlotsContainer');
        if (checkbox.checked) {
            var hiddenScheduleId = document.createElement("input");
            hiddenScheduleId.type = "hidden";
            hiddenScheduleId.name = "scheduleId[]";
            hiddenScheduleId.value = checkbox.getAttribute("data-schedule-id");
            container.appendChild(hiddenScheduleId);
            var hiddenDate = document.createElement("input");
            hiddenDate.type = "hidden";
            hiddenDate.name = "bookingDate[]";
            hiddenDate.value = checkbox.getAttribute("data-date");
            container.appendChild(hiddenDate);
        } else {
            var hiddenScheduleIds = document.querySelectorAll(`input[name="scheduleId[]"]`);
            var hiddenBookingDates = document.querySelectorAll(`input[name="bookingDate[]"]`);
            for (var i = 0; i < hiddenScheduleIds.length; i++) {
                if (hiddenScheduleIds[i].value === checkbox.getAttribute("data-schedule-id") && hiddenBookingDates[i].value === checkbox.getAttribute("data-date")) {
                    hiddenScheduleIds[i].remove();
                    hiddenBookingDates[i].remove();
                }
            }
        }
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
    
    /**
     * Hiển thị toast notification
     * @param {string} message - Nội dung thông báo
     * @param {string} type - Loại thông báo (success/error)
     */
    function showToast(message, type) {
        // Kiểm tra nếu đã có toast container
        let toastContainer = document.querySelector('.toast-container');

        if (!toastContainer) {
            toastContainer = document.createElement('div');
            toastContainer.className = 'toast-container';
            document.body.appendChild(toastContainer);
        }

        const toast = document.createElement('div');
        toast.className = `toast toast--${type}`;
        toast.textContent = message;

        toastContainer.appendChild(toast);

        // Hiển thị toast
        setTimeout(() => {
            toast.classList.add('toast--visible');
        }, 10);

        // Tự động ẩn toast sau 3 giây
        setTimeout(() => {
            toast.classList.remove('toast--visible');
            setTimeout(() => {
                toast.remove();
            }, 300);
        }, 3000);
    }
</script>