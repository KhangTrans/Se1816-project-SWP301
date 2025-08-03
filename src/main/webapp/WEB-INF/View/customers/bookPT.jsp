
<%@include file="/WEB-INF/include/head.jsp" %>
<%@include file="/WEB-INF/include/Login.jsp" %>
<%@include file="/WEB-INF/include/Register.jsp" %>
<%@include file="/WEB-INF/include/forgotPassword.jsp" %>
<%@include file="/WEB-INF/include/header.jsp" %>
<%@page import="Model.Trainers"%>

<% Trainers trainer = (Trainers) request.getAttribute("trainer");%>

<style>
    .booking-container {
        max-width: 1000px;
        margin: 20px auto 50px;
        padding: 0 20px;
    }

    .booking-header {
        text-align: center;
        margin-bottom: 30px;
    }

    .booking-title {
        color: #d9ff68;
        font-size: 50px;
        font-weight: bold;
        margin-top: 100px;
        margin-bottom: 20px;
        text-transform: uppercase;
        letter-spacing: 2px;
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

    .trainer-info-bar {
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 30px;
        background: linear-gradient(to right, rgba(26, 42, 58, 0.8), rgba(13, 27, 41, 0.8));
        border-radius: 10px;
        padding: 15px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    }

    .trainer-avatar {
        width: 60px;
        height: 60px;
        border-radius: 50%;
        overflow: hidden;
        margin-right: 15px;
        border: 2px solid #d9ff68;
    }

    .trainer-avatar img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .trainer-name {
        font-size: 20px;
        font-weight: bold;
        color: #fff;
    }

    .date-picker-container {
        background: rgba(26, 42, 58, 0.8);
        border-radius: 10px;
        padding: 20px;
        margin-bottom: 30px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
    }

    .date-picker {
        display: flex;
        align-items: center;
        justify-content: center;
        flex-wrap: wrap;
        gap: 15px;
        margin-bottom: 15px;
    }

    .date-picker label {
        color: #d9ff68;
        font-weight: bold;
        font-size: 16px;
    }

    .date-picker input[type="date"] {
        padding: 10px 15px;
        border-radius: 8px;
        border: 1px solid #d9ff68;
        background-color: rgba(255, 255, 255, 0.9);
        font-size: 16px;
        color: #333;
        outline: none;
    }

    .date-picker input[type="date"]:focus {
        box-shadow: 0 0 0 2px rgba(217, 255, 104, 0.5);
    }

    .week-info {
        text-align: center;
        color: #fff;
        font-size: 18px;
        font-weight: 600;
        padding: 10px;
        border-radius: 8px;
        background: rgba(217, 255, 104, 0.2);
        margin-top: 10px;
    }

    .schedule-table-container {
        overflow-x: auto;
        margin-bottom: 30px;
        background: rgba(17, 17, 17, 0.7);
        border-radius: 10px;
        padding: 20px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin: 0 auto;
    }

    table th, table td {
        text-align: center;
        padding: 12px;
        border: 1px solid rgba(217, 255, 104, 0.3);
    }

    table th {
        background: rgba(26, 42, 58, 0.9);
        color: #d9ff68;
        font-weight: bold;
        text-transform: uppercase;
        font-size: 14px;
    }

    table td {
        color: #fff;
        font-size: 14px;
        vertical-align: middle;
    }

    table tr:first-child th {
        border-top: none;
    }

    table tr td:first-child {
        background: rgba(26, 42, 58, 0.7);
        font-weight: bold;
        color: #d9ff68;
    }

    .slot-checkbox {
        appearance: none;
        -webkit-appearance: none;
        width: 25px;
        height: 25px;
        border-radius: 5px;
        border: 2px solid #d9ff68;
        outline: none;
        cursor: pointer;
        background-color: transparent;
        position: relative;
    }

    .slot-checkbox:checked {
        background-color: #d9ff68;
    }

    .slot-checkbox:checked::before {
        content: "";
        font-size: 16px;
        color: #111;
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        font-weight: bold;
    }

    .slot-booked {
        padding: 8px 12px;
        background-color: rgba(255, 107, 107, 0.3);
        color: #ff6b6b;
        border: 1px solid rgba(255, 107, 107, 0.5);
        border-radius: 5px;
        font-size: 13px;
        width: 100px;
        cursor: not-allowed;
    }

    .cancel-btn {
        padding: 5px 10px;
        background-color: rgba(255, 107, 107, 0.8);
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        margin-top: 5px;
        font-size: 12px;
        transition: all 0.3s ease;
    }

    .cancel-btn:hover {
        background-color: rgba(255, 71, 87, 0.9);
    }

    .cancel-btn:disabled {
        background-color: #777;
        cursor: not-allowed;
    }

    .submit-btn {
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        color: #111;
        font-size: 18px;
        font-weight: bold;
        padding: 15px 30px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        margin: 20px auto;
        display: block;
        text-transform: uppercase;
        letter-spacing: 1px;
        transition: all 0.3s ease;
    }

    .submit-btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 10px 20px rgba(217, 255, 104, 0.3);
        background: linear-gradient(135deg, #d9ff68 0%, #c4ff00 100%);
    }

    /* Modal styles */
    #confirmationModal {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.7);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 1000;
    }

    .modal-content {
        background: linear-gradient(to bottom, #1a2a3a, #0d1b29);
        border-radius: 15px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
        padding: 30px;
        width: 90%;
        max-width: 500px;
        text-align: center;
        position: relative;
        color: #fff;
    }

    #modal-title {
        color: #d9ff68;
        margin-bottom: 20px;
        font-size: 24px;
    }

    #modal-details {
        margin-bottom: 30px;
        line-height: 1.8;
        text-align: left;
    }

    #cancelBtn {
        background: linear-gradient(135deg, #ff6b6b 0%, #ff4757 100%);
        margin-left: 15px;
    }

    #cancelBtn:hover {
        background: linear-gradient(135deg, #ff4757 0%, #ff3545 100%);
        box-shadow: 0 10px 20px rgba(255, 71, 87, 0.3);
    }

    /* Responsive adjustments */
    @media (max-width: 768px) {
        .booking-title {
            font-size: 28px;
        }

        table th, table td {
            padding: 8px 5px;
            font-size: 12px;
        }

        .submit-btn {
            padding: 12px 25px;
            font-size: 16px;
        }
    }
</style>

<!-- Link to Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<div class="booking-container">
    <div class="booking-header">
        <h1 class="booking-title">Book Training Session</h1>
        <div class="trainer-info-bar">
            <div class="trainer-avatar">
                <img src="<%= request.getContextPath() + "/AvatarServlet?user=" + trainer.getAccountId().getUsername()%>" alt="<%= trainer.getFullName()%>">
            </div>
            <div class="trainer-name"><%= trainer.getFullName()%></div>
        </div>
    </div>

    <div class="date-picker-container">
        <div class="date-picker">
            <label for="start-date"><i class="far fa-calendar-alt"></i> Select Start Date:</label>
            <input type="date" id="start-date" onchange="updateWeek()">
        </div>
        <div class="week-info" id="week-info"></div>
    </div>

    <div class="schedule-table-container">
        <form method="post" action="bookingpt" id="bookingForm">
            <input type="hidden" name="trainerId" value="<%= request.getAttribute("trainerId")%>">
            <input type="hidden" name="action" id="action" value="book">
            <table>
                <thead>
                    <tr>
                        <th>Hours</th>
                        <th>Monday</th>
                        <th>Tuesday</th>
                        <th>Wednesday</th>
                        <th>Thursday</th>
                        <th>Friday</th>
                        <th>Saturday</th>
                        <th>Sunday</th>
                    </tr>
                </thead>
                <tbody id="schedule-table"></tbody>
            </table>

            <!-- Add hidden inputs here for each selected slot -->
            <div id="selectedSlotsContainer"></div>

            <button type="button" class="submit-btn" onclick="showConfirmation('book')"><i class="fas fa-calendar-check"></i> Book Now</button>
        </form>
    </div>
</div>

<!-- Confirmation Modal -->
<div id="confirmationModal" style="display: none;">
    <div class="modal-content">
        <h2 id="modal-title">Confirm Booking / Cancellation</h2>
        <div style="display: flex; align-items: center; justify-content: center; margin-bottom: 20px;">
            <div class="trainer-avatar">
                <img src="<%= request.getContextPath() + "/AvatarServlet?user=" + trainer.getAccountId().getUsername()%>" alt="<%= trainer.getFullName()%>" />
            </div>
            <h3><%= trainer.getFullName()%></h3>
        </div>
        <p id="modal-details"></p>
        <button id="confirmBtn" class="submit-btn" onclick="confirmAction()">Confirm</button>
        <button id="cancelBtn" class="submit-btn" onclick="closeModal()">Cancel</button>
    </div>
</div>

<!-- Modal thông báo -->
<div id="notificationModal" class="modal" style="display: none;">
    <div class="modal-content">
        <h2 id="modal-title">Notification</h2>
        <p id="modal-message" style="color:#d9ff68"></p>
        <button id="closeBtn" class="submit-btn" onclick="closeModalMesage()">Close</button>
    </div>
</div>

<script>
    // Ki?m tra xem có thông báo t? Servlet không
    <% String notificationMessage = (String) session.getAttribute("notificationMessage");
    if (notificationMessage != null) {
        session.removeAttribute("notificationMessage");
    } %>
    if ("<%= notificationMessage != null ? notificationMessage : "" %>" !== "") {
        document.getElementById('modal-message').innerText = "<%= notificationMessage %>";
        document.getElementById('notificationModal').style.display = "block";
    }

    // ?óng modal
    function closeModalMesage() {
        document.getElementById('notificationModal').style.display = "none";
    }
</script>

<script>
    var timeSlots = JSON.parse('<%= request.getAttribute("timeSlots")%>');
    var bookedSlots = JSON.parse('<%= request.getAttribute("bookedSlots")%>');
    var schedules = JSON.parse('<%= request.getAttribute("schedules")%>');
    var booking = JSON.parse('<%= request.getAttribute("booking")%>');
    var slotAvailability = JSON.parse('<%= request.getAttribute("slotAvailability")%>');

    var actionType = null;

    window.onload = function () {
        document.getElementById('start-date').setAttribute('min', formatDate(new Date()));
        updateWeek();  // Call function to automatically display the current week when page loads
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
            // Other days, calculate correct Monday of this week
            startOfWeek.setDate(startDate.getDate() - startDay + 1);
        }
        var endOfWeek = new Date(startOfWeek);
        endOfWeek.setDate(startOfWeek.getDate() + 6);  // Sunday

        var weekInfo = document.getElementById('week-info');
        weekInfo.innerHTML = "Week from " + formatDate(startOfWeek) + " to " + formatDate(endOfWeek);

        var tbody = document.getElementById('schedule-table');
        tbody.innerHTML = '';  // Clear previous table content

        for (var i = 0; i < timeSlots.length; i++) {
            var row = '<tr>';
            row += '<td>' + timeSlots[i] + '</td>';  // Display hours in the "Hours" column

            for (var j = 0; j < 7; j++) {
                var currentDay = new Date(startOfWeek);
                currentDay.setDate(startOfWeek.getDate() + j);  // Calculate date for each day of the week
                var formattedDate = formatDate(currentDay);
                var isBooked = false;
                var isPastTime = false;  // Variable to check if time has passed

                // Check booking with status = 'confirmed' and corresponding date
                for (var k = 0; k < booking.length; k++) {
                    var bookingDate = booking[k].bookingDate;
                    var dateObject = new Date(bookingDate.year, bookingDate.month - 1, bookingDate.day);  // month is 0-indexed in JavaScript
                    if (booking[k].scheduleId === schedules[i].scheduleId && formatDate(dateObject) === formattedDate) {
                        if (booking[k].status === 'confirmed' || booking[k].status === 'pending') {
                            isBooked = true;
                        }
                        break;
                    }
                }

                // Check if time has passed
                var startTime = getStartTimeByScheduleId(schedules[i].scheduleId);
                var slotDateTime = new Date(currentDay);
                slotDateTime.setHours(startTime.hour, startTime.minute, 0, 0);  // Combine date and time

                var now = new Date();
                if (now > slotDateTime) {
                    isPastTime = true;
                }

                var availability = slotAvailability.find(function (item) {
                    var slotDate = new Date(item.slotDate.year, item.slotDate.month - 1, item.slotDate.day);
                    var itemDate = slotDate.toLocaleDateString('en-CA'); // Normalize date for comparison
                    return item.scheduleId === schedules[i].scheduleId && itemDate === formattedDate;
                });

                var isSlotAvailable = availability ? availability.isAvailable : true;

                if (!isBooked && !isPastTime) {
                    if (isSlotAvailable) {
                        row += '<td>' +
                                '<input type="checkbox" name="selectedSlots" class="slot-checkbox" ' +
                                'value="' + schedules[i].scheduleId + '_' + formattedDate + '" ' +
                                'data-schedule-id="' + schedules[i].scheduleId + '" ' +
                                'data-date="' + formattedDate + '" onclick="addHiddenInput(this)">' +
                                '</td>';
                    } else {
                        row += '<td></td>';
                    }

                } else {
                    row += '<td>';
                    if (isPastTime) {
                        row += '<button class="slot-booked" disabled>Time passed</button>';
                    } else {
                        // Display "Cancel" button if cancellation time is still valid
                        for (var k = 0; k < booking.length; k++) {
                            var bookingDate = booking[k].bookingDate;
                            var dateObject = new Date(bookingDate.year, bookingDate.month - 1, bookingDate.day);
                            var currentScheduleId = schedules[i].scheduleId;
                            var startTime = getStartTimeByScheduleId(currentScheduleId);

                            if (booking[k].scheduleId === currentScheduleId && formatDate(dateObject) === formattedDate) {
                                if (booking[k].status === 'confirmed' && booking[k].customer.account.accountId === <%= session.getAttribute("accountId")%>) {
                                    row += '<button class="slot-booked" disabled>Booked</button>';
                                    var slotDateTime = new Date(dateObject.getFullYear(), dateObject.getMonth(), dateObject.getDate(), startTime.hour, startTime.minute || 0, 0, 0);
                                    var now = new Date();
                                    if ((slotDateTime.getTime() - now.getTime()) > 3 * 60 * 60 * 1000) {
                                        row += '<button type="button" class="cancel-btn" ' +
                                                'data-booking="' + booking[k].bookingId + '" ' +
                                                'data-schedule-id="' + schedules[i].scheduleId + '" ' +
                                                'onclick="confirmCancel(this, \'' + formattedDate + '\')">Cancel</button>';
                                    } else {
                                        row += '<button class="cancel-btn" disabled>Can\'t cancel</button>';
                                    }
                                } else if (booking[k].status === 'pending' && booking[k].customer.account.accountId === <%= session.getAttribute("accountId")%>) {
                                    row += '<button class="slot-booked" disabled>Pending approval</button>';
                                } else {
                                    row += '<button class="cancel-btn" style="display:none" disabled>Cancel</button>';
                                }
                                break;
                            }
                        }
                    }

                    row += '</td>';
                }
            }

            row += '</tr>';
            tbody.innerHTML += row;  // Add the row to the table
        }
    }

    function getStartTimeByScheduleId(scheduleId) {
        for (var i = 0; i < schedules.length; i++) {
            if (String(schedules[i].scheduleId) === String(scheduleId)) {
                // startTime is an object with .hour and .minute
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
        return yyyy + '-' + mm + '-' + dd;  // Format yyyy-MM-dd for date
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

    function confirmAction() {
        if (actionType === 'book') {
            document.getElementById("action").value = actionType;
            document.getElementById('bookingForm').submit(); // Book when "Book Now" is selected
        } else if (actionType === 'cancel') {
            document.getElementById("action").value = actionType;
            console.log(actionType);
            document.getElementById('bookingForm').submit();
            cancelBooking(); // Cancel booking
        }
    }

    function showConfirmation(type) {
        actionType = type; // "book" or "cancel"
        var selectedSlots = document.querySelectorAll('input[name="selectedSlots"]:checked');
        var modalDetails = document.getElementById('modal-details');
        var totalPrice = 0;
        var details = '';

        selectedSlots.forEach(function (slot) {
            var scheduleId = slot.getAttribute("data-schedule-id");
            var date = slot.getAttribute("data-date");
            var timeSlot = getTimeSlotByScheduleId(scheduleId);
            var price = <%= trainer.getPrice()%>;  // Trainer price from request
            totalPrice += price;
            details += 'Date: ' + date + '<br>';
            details += 'Time: ' + timeSlot + '<br>';
            details += 'Price: ' + price.toLocaleString() + ' VND' + '<br><br>';
        });
        details += 'Total price: ' + totalPrice.toLocaleString() + ' VND';
        document.getElementById('modal-title').innerHTML = actionType === 'book' ? 'Confirm Booking' : 'Confirm Cancellation';
        modalDetails.innerHTML = details;
        document.getElementById('confirmationModal').style.display = 'block';
    }

    function confirmCancel(button, date) {
        actionType = 'cancel'; // Set action to "cancel"

        // Get bookingId and scheduleId from data-booking and data-schedule-id attributes
        var bookingId = button.getAttribute('data-booking');
        var scheduleId = button.getAttribute('data-schedule-id');
        console.log(bookingId);
        // Get time of appointment from schedules
        var timeSlot = getTimeSlotByScheduleId(scheduleId);  // Get slot time
        var modalDetails = document.getElementById('modal-details');

        // Update information in modal
        var details = 'Date: ' + date + '<br>';
        details += 'Time: ' + timeSlot + '<br>';
        modalDetails.innerHTML = details;
        // Add hidden input for bookingId to form
        var container = document.getElementById('selectedSlotsContainer');
        var hiddenBookingId = document.createElement("input");
        hiddenBookingId.type = "hidden";
        hiddenBookingId.name = "bookingId";  // Save bookingId
        hiddenBookingId.value = bookingId;  // Assign bookingId 
        container.appendChild(hiddenBookingId);

        var hiddenScheduleId = document.createElement("input");
        hiddenScheduleId.type = "hidden";
        hiddenScheduleId.name = "scheduleId";  // Save scheduleId
        hiddenScheduleId.value = scheduleId;   // Assign scheduleId
        container.appendChild(hiddenScheduleId);

        // Change modal title
        document.getElementById('modal-title').innerHTML = 'Confirm Cancellation';

        // Display cancellation modal
        document.getElementById('confirmationModal').style.display = 'block';
    }

    function closeModal() {
        document.getElementById('confirmationModal').style.display = 'none';
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
<%@include file="/WEB-INF/include/footer.jsp" %>

