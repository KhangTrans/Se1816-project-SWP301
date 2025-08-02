
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

 <script>
        
        // Check for password change errors
        <% if (session.getAttribute("changePasswordError") != null) {%>
        var errorMessage = '<%= session.getAttribute("changePasswordError")%>';
        console.log(errorMessage);

        
        <% session.removeAttribute("changePasswordError"); %>
        <% } %>

        <% if (session.getAttribute("changePasswordSuccess") != null) {%>
        var successMessage = '<%= session.getAttribute("changePasswordSuccess")%>';
        showTab('changepassword');
        Swal.fire({
            icon: 'success',
            title: successMessage,
            text: 'Your password has been changed!',
            customClass: {
                confirmButton: "btn btn-login"
            }
        });
        <% session.removeAttribute("changePasswordSuccess"); %>
        <% }%>

        // Add active class to the current tab
        );
    </script>
