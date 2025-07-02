<div class="container-profile" id ="changepassword">
    <div>
        <h1 class="header-profile">Change Password</h1>
        <form class="form-profile" action="${pageContext.request.contextPath}/profile?action=changepassword" method="post">
            <label for="old-password">Old Password:</label>
            <input type="password" id="old-password" name="oldPassword" required>

            <label for="new-password">New Password:</label>
            <input type="password" id="new-password" name="newPassword" pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"
                   title="Password must be at least 8 characters, including uppercase, lowercase, numbers and special characters" required>

            <label for="confirm-password">Confirm New Password:</label>
            <input type="password" id="confirm-password" name="confirmPassword" required>

            <button type="submit" class="change-btn">Change Password</button>
            <button type="button" class="back-profile-btn" onclick="window.location.href = '${pageContext.request.contextPath}/profile'">Back Profile</button>
        </form>  
    </div>

</div>

