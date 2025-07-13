<%@page import="Model.Trainers"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trainer's Schedule</title>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/bookingpt.css"/>
    </head>
    <body>

        <% Trainers trainer = (Trainers) request.getAttribute("trainer");%>
        <h1>Chọn Tuần và Đặt Lịch</h1>

        <div class="date-picker">
            <label for="start-date">Chọn Ngày Bắt Đầu:</label>
            <input type="date" id="start-date" onchange="updateWeek()">
        </div>

        <div class="week-info" id="week-info"></div>

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

            <button type="button" class="submit-btn" onclick="showConfirmation('book')">Đặt ngay</button>
        </form>

        <!-- Confirmation Modal -->
        <div id="confirmationModal" style="display: none;">
            <div class="modal-content">
                <h2 id="modal-title">Xác Nhận Đặt Lịch / Hủy Lịch</h2>
                <div style="display: flex; align-items: center; justify-content: center; margin-bottom: 20px;">
                    <div style="background-color: #d3d3d3; width: 80px; height: 80px; margin-right: 20px; border-radius: 50%; overflow: hidden;">
                        <img src="<%= request.getContextPath() + "/AvatarServlet?user=" + trainer.getAccountId().getUsername()%>" alt="Trainer Image" style="width: 100%; height: 100%; object-fit: cover;" />
                    </div>
                    <h3><%= trainer.getFullName()%></h3>
                </div>
                <p id="modal-details"></p>
                <button id="confirmBtn" class="submit-btn" onclick="confirmAction()">Confirm</button>
                <button id="cancelBtn" class="submit-btn" onclick="closeModal()" style="background-color: #f44336;">Cancel</button>
            </div>
        </div>

        <script>
            var timeSlots = JSON.parse('<%= request.getAttribute("timeSlots")%>');
            var bookedSlots = JSON.parse('<%= request.getAttribute("bookedSlots")%>');
            var schedules = JSON.parse('<%= request.getAttribute("schedules")%>');
            var booking = JSON.parse('<%= request.getAttribute("booking")%>');
            var actionType = null;

            window.onload = function () {
                document.getElementById('start-date').setAttribute('min', formatDate(new Date()));
                updateWeek();  // Gọi hàm để tự động hiển thị tuần hiện tại khi trang được tải
            };

            function updateWeek() {
                var selectedDate = document.getElementById('start-date').value;
                var startDate = selectedDate ? new Date(selectedDate) : new Date();

                var startDay = startDate.getDay();
                var startOfWeek = new Date(startDate);
                if (startDay === 0) {
                    // Chủ nhật, lùi về thứ 2 tuần trước
                    startOfWeek.setDate(startDate.getDate() - 6);
                } else {
                    // Các ngày khác, tính đúng thứ 2 tuần này
                    startOfWeek.setDate(startDate.getDate() - startDay + 1);
                }
                var endOfWeek = new Date(startOfWeek);
                endOfWeek.setDate(startOfWeek.getDate() + 6);  // Chủ nhật

                var weekInfo = document.getElementById('week-info');
                weekInfo.innerHTML = "Tuần từ " + formatDate(startOfWeek) + " đến " + formatDate(endOfWeek);

                var tbody = document.getElementById('schedule-table');
                tbody.innerHTML = '';  // Clear previous table content

                for (var i = 0; i < timeSlots.length; i++) {
                    var row = '<tr>';
                    row += '<td>' + timeSlots[i] + '</td>';  // Hiển thị giờ vào cột "Giờ"

                    for (var j = 0; j < 7; j++) {
                        var currentDay = new Date(startOfWeek);
                        currentDay.setDate(startOfWeek.getDate() + j);  // Tính ngày cho từng ngày trong tuần
                        var formattedDate = formatDate(currentDay);
                        var isBooked = false;
                        var isPastTime = false;  // Biến để kiểm tra nếu đã quá thời gian

                        // Kiểm tra booking với status = 'confirmed' và ngày tương ứng
                        for (var k = 0; k < booking.length; k++) {
                            var bookingDate = booking[k].bookingDate;
                            var dateObject = new Date(bookingDate.year, bookingDate.month - 1, bookingDate.day);  // month is 0-indexed in JavaScript
                            if (booking[k].scheduleId === schedules[i].scheduleId && formatDate(dateObject) === formattedDate) {
                                if (booking[k].status === 'confirmed') {
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
                        if (now > slotDateTime) {
                            isPastTime = true;
                        }

                        if (!isBooked && !isPastTime) {
                            row += '<td>' +
                                    '<input type="checkbox" name="selectedSlots" class="slot-checkbox" ' +
                                    'value="' + schedules[i].scheduleId + '_' + formattedDate + '" ' +
                                    'data-schedule-id="' + schedules[i].scheduleId + '" ' +
                                    'data-date="' + formattedDate + '" onclick="addHiddenInput(this)">' +
                                    '</td>';
                        } else {
                            row += '<td>';
                            if (isPastTime) {
                                row += '<button class="slot-booked" disabled>Đã qua giờ</button>';
                            } else {
                                row += '<button class="slot-booked" disabled>Đã Book</button>';
                                // Hiển thị nút "Hủy" nếu còn thời gian hủy
                                for (var k = 0; k < booking.length; k++) {
                                    var bookingDate = booking[k].bookingDate;
                                    var dateObject = new Date(bookingDate.year, bookingDate.month - 1, bookingDate.day);
                                    var currentScheduleId = schedules[i].scheduleId;
                                    var startTime = getStartTimeByScheduleId(currentScheduleId);

                                    if (booking[k].scheduleId === currentScheduleId && formatDate(dateObject) === formattedDate) {
                                        if (booking[k].status === 'confirmed' && booking[k].customer.account.accountId === <%= session.getAttribute("accountId")%>) {
                                            var slotDateTime = new Date(dateObject.getFullYear(), dateObject.getMonth(), dateObject.getDate(), startTime.hour, startTime.minute || 0, 0, 0);
                                            var now = new Date();
                                            if ((slotDateTime.getTime() - now.getTime()) > 3 * 60 * 60 * 1000) {
                                                row += '<button type="button" class="cancel-btn" ' +
                                                        'data-booking="' + booking[k].bookingId + '" ' +
                                                        'data-schedule-id="' + schedules[i].scheduleId + '" ' +
                                                        'onclick="confirmCancel(this, \'' + formattedDate + '\')">Hủy</button>';
                                            } else {
                                                row += '<button class="cancel-btn" disabled>Hết thời gian hủy</button>';
                                            }
                                        } else {
                                            row += '<button class="cancel-btn" style="display:none" disabled>Hủy</button>';
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
                return yyyy + '-' + mm + '-' + dd;  // Định dạng yyyy-MM-dd cho ngày
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
                    document.getElementById('bookingForm').submit(); // Đặt lịch khi chọn "Đặt ngay"
                } else if (actionType === 'cancel') {
                    document.getElementById("action").value = actionType;
                    console.log(actionType);
                    document.getElementById('bookingForm').submit();
                    cancelBooking(); // Hủy lịch
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
                    var price = <%= trainer.getPrice()%>;  // Giá của trainer từ request
                    totalPrice += price;
                    details += 'Ngày: ' + date + '<br>';
                    details += 'Time: ' + timeSlot + '<br>';
                    details += 'Giá: ' + price.toLocaleString() + ' VND' + '<br><br>';
                });
                details += 'Tổng giá: ' + totalPrice.toLocaleString() + ' VND';
                document.getElementById('modal-title').innerHTML = actionType === 'book' ? 'Xác Nhận Đặt Lịch' : 'Xác Nhận Hủy Lịch';
                modalDetails.innerHTML = details;
                document.getElementById('confirmationModal').style.display = 'block';
            }

            function confirmCancel(button, date) {
                actionType = 'cancel'; // Gán hành động là "cancel"

                // Lấy bookingId và scheduleId từ thuộc tính data-booking và data-schedule-id
                var bookingId = button.getAttribute('data-booking');
                var scheduleId = button.getAttribute('data-schedule-id');
                console.log(bookingId);
                // Lấy thời gian của lịch hẹn từ schedules
                var timeSlot = getTimeSlotByScheduleId(scheduleId);  // Lấy giờ của slot
                var modalDetails = document.getElementById('modal-details');

                // Cập nhật thông tin vào modal
                var details = 'Ngày: ' + date + '<br>';
                details += 'Time: ' + timeSlot + '<br>';
                modalDetails.innerHTML = details;
                // Thêm hidden input cho bookingId vào form
                var container = document.getElementById('selectedSlotsContainer');
                var hiddenBookingId = document.createElement("input");
                hiddenBookingId.type = "hidden";
                hiddenBookingId.name = "bookingId";  // Lưu lại bookingId
                hiddenBookingId.value = bookingId;  // Gán bookingId 
                container.appendChild(hiddenBookingId);

                var hiddenScheduleId = document.createElement("input");
                hiddenScheduleId.type = "hidden";
                hiddenScheduleId.name = "scheduleId";  // Lưu lại scheduleId
                hiddenScheduleId.value = scheduleId;   // Gán scheduleId
                container.appendChild(hiddenScheduleId);

                // Thay đổi tiêu đề của modal
                document.getElementById('modal-title').innerHTML = 'Xác Nhận Hủy Lịch';

                // Hiển thị modal hủy lịch
                document.getElementById('confirmationModal').style.display = 'block';
            }

            function cancelBooking() {
                // Thực hiện hủy lịch tại đây (thực hiện gọi đến backend để hủy)
                alert("Lịch đã được hủy!");
                closeModal();
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
    </body>
</html>
