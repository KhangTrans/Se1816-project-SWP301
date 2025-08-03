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

<!-- Modal thông báo -->
<div id="notificationModal" class="modal" style="display: none;">
    <div class="modal-content">
        <h2 id="modal-title">Notification</h2>
        <p id="modal-message" style="color:#d9ff68"></p>
        <button id="closeBtn" class="submit-btn" onclick="closeModalMesage()">Close</button>
    </div>
</div>

<!-- Modal xác nh?n h?y -->
<div id="confirmationModal" class="modal" style="display: none;">
    <div class="modal-content">
        <h2 id="modal-title">Confirm Cancellation</h2>
        <h3 id="modal-name"></h3>
        <p id="modal-details"></p>
        <button id="confirmBtn" class="submit-btn" onclick="confirmAction()">Confirm</button>
        <button id="cancelBtn" class="submit-btn" onclick="closeModal()">Cancel</button>
    </div>
</div>


<script>
    // Ki?m tra xem có thông báo t? Servlet không
    <% String notificationMessage = (String) session.getAttribute("notificationMessage");
        if (notificationMessage != null) {
            session.removeAttribute("notificationMessage");
        }%>
    if ("<%= notificationMessage != null ? notificationMessage : ""%>" !== "") {
        document.getElementById('modal-message').innerText = "<%= notificationMessage%>";
        document.getElementById('notificationModal').style.display = "block";
    }

    // ?óng modal
    function closeModalMesage() {
        document.getElementById('notificationModal').style.display = "none";
    }
</script>

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
        var details = 'Date: ' + date + '<br>';
        details += 'Time: ' + timeSlot + '<br>';
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
        document.getElementById('confirmationModal').style.display = 'block';
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
</script>