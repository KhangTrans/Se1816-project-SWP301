<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/head.jsp" %>
<%@include file="/WEB-INF/include/Login.jsp" %>
<%@include file="/WEB-INF/include/Register.jsp" %>
<%@include file="/WEB-INF/include/forgotPassword.jsp" %>
<%@include file="/WEB-INF/include/header.jsp" %>
<main>
        <div class="container-profile">
            <!-- Sidebar -->
            <div class="sidebar-profile">
                <div class="profile-image">
                    <!-- Hiển thị ảnh đại diện từ AvatarServlet -->
                    <img id="profile-img" src="${pageContext.request.contextPath}/AvatarServlet?user=${customer.account.username}" alt="Profile Picture">

                    <!-- Nút chỉnh sửa ảnh -->
                    <form id="edit-avatar-form" action="${pageContext.request.contextPath}/profile?action=avatar" method="post" enctype="multipart/form-data">
                        <!-- Ẩn input file -->
                        <input type="file" name="avatar" accept="image/*" id="avatar-input" style="display:none;" onchange="this.form.submit()">

                        <!-- Biểu tượng camera -->
                        <label for="avatar-input" class="camera-icon" style="cursor: pointer;">
                            <i class="fas fa-camera fa-2x"></i> <!-- Font Awesome camera icon -->
                        </label>
                    </form>
                </div>
                <div class="username">
                    <h2>${customer.fullName}</h2> <!-- Hiển thị tên người dùng -->
                </div>
                <ul class="menu">
                    <li><a class="tab-btn package" href="#" data-tab="packages">My Packages</a></li>
                    <li><a class="tab-btn work" href="#" data-tab="schedule">Work Schedule</a></li>
                    <li><a class="tab-btn" href="#" data-tab="changepassword">Change Password</a></li>
                </ul>
            </div>

            <!-- Content area (sẽ thay đổi nội dung ở đây)-->
            <div class="profile-form" id="profile-content">
                <!-- Nội dung mặc định khi trang mở lên sẽ là profile -->
                <div id="profileContent" class="tab-content">
                    <jsp:include page="profileContent.jsp"/>
                </div>
                <div id="packages" class="tab-content" style="display:none;">
                    <%--<jsp:include page="packages.jsp"/>--%>
                </div>
                <div id="schedule" class="tab-content" style="display:none;">
                    <%--<jsp:include page="schedule.jsp"/>--%>
                </div>
                <div id="changepassword" class="tab-content" style="display:none;">
                    <jsp:include page="changepassword.jsp"/>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <% if (session.getAttribute("updateSuccess") != null) {%>
        <script>
                            Swal.fire({
                                icon: 'success',
                                title: '<%= session.getAttribute("updateSuccess")%>',
                                text: 'Your profile has been updated!',
                                confirmButtonText: 'OK',
                                customClass: {
                                    confirmButton: "btn btn-login"
                                }
                            }).then(() => {
                                window.location.href = '${pageContext.request.contextPath}/profile?tab=profileContent';
                            });
        </script>
        <% session.removeAttribute("updateSuccess"); %>
        <% } %>

        <% if (session.getAttribute("updateError") != null) {%>
        <script>
            Swal.fire({
                icon: 'error',
                title: 'Update Failed',
                text: '<%= session.getAttribute("updateError")%>',
                customClass: {
                    confirmButton: "btn btn-login"
                }
            }).then(() => {
                window.location.href = '${pageContext.request.contextPath}/profile?tab=profileContent';
            });
        </script>
        <% session.removeAttribute("updateError"); %>
        <% } %>

        <script>
            // Kiểm tra nếu có thông báo lỗi từ session
            <% if (session.getAttribute("changePasswordError") != null) {%>
            var errorMessage = '<%= session.getAttribute("changePasswordError")%>';
            // Gọi hàm showTab và hiển thị thông báo lỗi
            showTab('changepassword');
            Swal.fire({
                icon: 'error',
                title: 'Password Change Failed',
                text: errorMessage,
                customClass: {
                    confirmButton: "btn btn-login"
                }
            });
            <% session.removeAttribute("changePasswordError"); %> // Xóa thông báo sau khi đã xử lý
            <% } %>

            <% if (session.getAttribute("changePasswordSuccess") != null) {%>
            var successMessage = '<%= session.getAttribute("changePasswordSuccess")%>';
            // Hiển thị thông báo thành công
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
        </script>

        <script src="<%= request.getContextPath()%>/js/profile.js"></script>
</main>
<%@include file="/WEB-INF/include/footer.jsp" %>
