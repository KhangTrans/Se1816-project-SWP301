
<div class="container-profile" id="changepassword">
    <div>
        <h1 class="header-content">Change Password</h1>
        <form class="form-profile" action="${pageContext.request.contextPath}/profile?action=changepassword" method="post">
            <label for="old-password">Old Password:</label>
            <input type="password" id="old-password" name="oldPassword" placeholder="Enter your current password" required>

            <label for="new-password">New Password:</label>
            <input type="password" id="new-password" name="newPassword" 
                   pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"
                   title="Password must be at least 8 characters, including uppercase, lowercase, numbers and special characters" 
                   placeholder="Enter your new password" required>

            <label for="confirm-password">Confirm New Password:</label>
            <input type="password" id="confirm-password" name="confirmPassword" placeholder="Confirm your new password" required>

            <button type="submit" class="change-btn">Change Password</button>
            <button type="button" class="back-profile-btn" onclick="window.location.href = '${pageContext.request.contextPath}/profile'">Back to Profile</button>
        </form>  
    </div>
</div>

<div id="notificationModalChange" class="modal" style="display: none;">
    <div class="modal-content">
        <h2 id="modal-title">Notification</h2>
        <p id="modal-messageChange" style="color:#d9ff68"></p>
        <button id="closeBtn" class="submit-btn" onclick="closeModalMesage()">Close</button>
    </div>
</div>


<script>
    // Ki?m tra xem có thông báo t? Servlet không
    <% String notificationMessage = (String) session.getAttribute("changePassword");
        if (notificationMessage != null) {
            session.removeAttribute("changePassword");
        }%>
    if ("<%= notificationMessage != null ? notificationMessage : ""%>" !== "") {
        document.getElementById('modal-messageChange').innerText = "<%= notificationMessage%>";
        document.getElementById('notificationModalChange').style.display = "block";
    }

    // ?óng modal
    function closeModalMesage() {
        document.getElementById('notificationModalChange').style.display = "none";
    }
</script>