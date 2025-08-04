<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/head.jsp" %>
<%@include file="/WEB-INF/include/Login.jsp" %>
<%@include file="/WEB-INF/include/Register.jsp" %>
<%@include file="/WEB-INF/include/forgotPassword.jsp" %>
<%@include file="/WEB-INF/include/header.jsp" %>
<!-- Add Font Awesome CSS -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
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
                        <i class="fas fa-camera"></i>
                    </label>
                </form>
            </div>
            <div class="username">
                <h2>${customer.fullName}</h2>
            </div>
            <ul class="menu">
                <li><a class="tab-btn" href="#" data-tab="profileContent"><i class="fas fa-user-circle"></i> Profile</a></li>
                <li><a class="tab-btn package" href="#" data-tab="packages"><i class="fas fa-box"></i> My Packages</a></li>
                <li><a class="tab-btn work" href="#" data-tab="schedule"><i class="fas fa-calendar-alt"></i> Work Schedule</a></li>
                <li><a class="tab-btn" href="#" data-tab="changepassword"><i class="fas fa-lock"></i> Change Password</a></li>
            </ul>
        </div>

        <!-- Content area -->
        <div class="profile-form" id="profile-content" >
            <!-- Default content is profile -->
            <div id="profileContent" class="tab-content" style="display:none;">
                <jsp:include page="profileContent.jsp"/>
            </div>
            <div id="packages" class="tab-content" style="display:none;">
                <div id="membership-block"></div>
            </div>
            <div id="schedule" class="tab-content" style="display:none;">
                <jsp:include page="schedule.jsp"/>
            </div>
            <div id="changepassword" class="tab-content" style="display:none;">
                <jsp:include page="changepassword.jsp"/>
            </div>
        </div>
    </div>
    <script src="js/membership.js"></script>
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

    <% if (session.getAttribute("changePasswordError") != null) {%>
    <script>
        Swal.fire({
            icon: 'success',
            title: '<%= session.getAttribute("changePasswordError")%>',
            text: 'Your password has been changed!',
            customClass: {
                confirmButton: "btn btn-login"
            }
        });
    </script>
    <% session.removeAttribute("updateSuccess"); %>
    <% }%>

    <script src="<%= request.getContextPath()%>/js/profile.js"></script>
</main>
<%@include file="/WEB-INF/include/footer.jsp" %>
