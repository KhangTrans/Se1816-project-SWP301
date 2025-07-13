<%@page import="Model.TrainerBooking"%>
<%@page import="java.util.List"%>
<div class="container-profile" >
    <div>
        <h1 class="header-profile">Work Schedule</h1>
        <div class="date-picker">
            <label for="start-date">Ch?n Ngày B?t ??u:</label>
            <input type="date" id="start-date" onchange="updateWeek()">
        </div>

        <div class="week-info" id="week-info"></div>
        <form method="post" action="bookingpt" id="bookingForm">
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
            <div id="selectedSlotsContainer"></div>
        </form>
    </div>
</div>

<script>
    var timeSlots = JSON.parse('<%= request.getAttribute("timeSlots")%>');
    var schedules = JSON.parse('<%= request.getAttribute("schedules")%>');
    var booking = JSON.parse('<%= request.getAttribute("booking")%>');
    var mybooking = JSON.parse('<%= request.getAttribute("mybooking")%>');
    console.log(mybooking.length);

    window.onload = function () {
        updateWeek(); // G?i hàm ?? t? ??ng hi?n th? tu?n hi?n t?i khi trang ???c t?i
    };
    function updateWeek() {
        var selectedDate = document.getElementById('start-date').value;
        var startDate = selectedDate ? new Date(selectedDate) : new Date();
        var startDay = startDate.getDay();
        var startOfWeek = new Date(startDate);
        if (startDay === 0) {
            // Ch? nh?t, lùi v? th? 2 tu?n tr??c
            startOfWeek.setDate(startDate.getDate() - 6);
        } else {
            // Các ngày khác, tính ?úng th? 2 tu?n này
            startOfWeek.setDate(startDate.getDate() - startDay + 1);
        }  // Tính ngày b?t ??u tu?n (th? 2)

        var endOfWeek = new Date(startOfWeek);
        endOfWeek.setDate(startOfWeek.getDate() + 6); // Ch? nh?t

        var weekInfo = document.getElementById('week-info');
        weekInfo.innerHTML = "T? ngày " + formatDate(startOfWeek) + " ??n " + formatDate(endOfWeek);
        var tbody = document.getElementById('schedule-table');
        tbody.innerHTML = ''; // Clear previous table content

        for (var i = 0; i < timeSlots.length; i++) {
            var row = '<tr>';
            row += '<td>' + timeSlots[i] + '</td>'; // Hi?n th? gi? vào c?t "Gi?"

            for (var j = 0; j < 7; j++) {
                var currentDay = new Date(startOfWeek);
                currentDay.setDate(startOfWeek.getDate() + j); // Tính ngày cho t?ng ngày trong tu?n
                var formattedDate = formatDate(currentDay);
                var isBooked = false;
                // Ki?m tra booking v?i status = 'confirmed' và ngày t??ng ?ng
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
                                    }
                                }

                                var startTime = getStartTimeByScheduleId(currentScheduleId);
                                var slotDateTime = new Date(dateObject.getFullYear(), dateObject.getMonth(), dateObject.getDate(), startTime.hour, startTime.minute || 0, 0, 0);
                                var now = new Date();
//                                if ((slotDateTime.getTime() - now.getTime()) >= 0) {
//                                    row += '<button type="button" class="cancel-btn" ' +
//                                            'data-booking="' + booking[k].bookingId + '" ' +
//                                            'data-schedule-id="' + schedules[i].scheduleId + '" ' +
//                                            'onclick="confirmCancel(this, \'' + formattedDate + '\')">Huy</button>';
//                                }
                            } 
                            else {

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
        }  // Add the row to the table
    }


    function getStartTimeByScheduleId(scheduleId) {
        for (var i = 0; i < schedules.length; i++) {
            if (String(schedules[i].scheduleId) === String(scheduleId)) {
                // startTime là object có .hour và .minute
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
        return yyyy + '-' + mm + '-' + dd; // ??nh d?ng yyyy-MM-dd cho ngày
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
            document.getElementById('bookingForm').submit(); // ??t l?ch khi ch?n "??t ngay"
        } else if (actionType === 'cancel') {
            document.getElementById("action").value = actionType;
            console.log(actionType);
            document.getElementById('bookingForm').submit();
            cancelBooking(); // H?y l?ch
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