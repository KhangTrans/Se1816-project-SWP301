<%@page contentType="text/html" pageEncoding="UTF-8"%>
<style>
    .fb-btn-fullwidth {
        display: flex !important;
        justify-content: center;
        width: 100% !important;
    }

    .fb-btn-fullwidth > span,
    .fb-btn-fullwidth iframe {
        width: 100% !important;
        max-width: 100% !important;
    }

</style>
<!-- Login Modal -->
<body>
    <div class="modal fade" id="loginModal" tabindex="-1" aria-labelledby="loginModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form id="loginForm" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title" style="margin-left: 40%">Login</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">
                        <div id="loginAlert" class="alert d-none" role="alert"></div>

                        <div class="mb-3">
                            <label>Username</label>
                            <input type="text"
                                   class="form-control"
                                   name="username" required />
                        </div>

                        <div class="mb-3">
                            <label>Password</label>
                            <input type="password"
                                   class="form-control"
                                   name="password" required />
                        </div>

                        <button type="submit" class="btn btn-primary w-100 mb-3">Login</button>
                        <div class="text-end">
                            <a href="#" onclick="openForgotPasswordModal()">Forgot password</a>
                        </div>


                        <div class="text-center">or</div>


                        <div class="social-login row text-center mt-3 mb-3">
                            <!-- Google Login -->
                            <div class="col-6 d-flex justify-content-center align-items-center">
                                <div>
                                    <div id="g_id_onload"
                                         data-client_id="749125474877-p8jcn9i7b48rpgq3eh4gkintoph2noo5.apps.googleusercontent.com"
                                         data-callback="onGoogleSignIn"
                                         data-auto_prompt="false"></div>
                                    <div class="g_id_signin" data-type="standard"></div>
                                </div>
                            </div>

                            <!-- Facebook Login -->
                            <div class="col-6 d-flex justify-content-center align-items-center"
                                 style="background-color: #1c78ff; border-radius: 5px;">
                                <div class="fb-login-button fb-btn-fullwidth"
                                     style=" margin-right: 20%"
                                     data-width=""
                                     data-size="large"
                                     data-button-type="login_with"
                                     data-layout="default"
                                     data-auto-logout-link="false"
                                     data-use-continue-as="false"
                                     data-scope="public_profile,email"
                                     onlogin="checkFacebookLogin();">
                                </div>
                            </div>
                        </div>
                    </div>
            </div>
            </form> 
        </div>
    </div>
    <!-- Forgot Password Modal -->
    <div class="modal fade" id="forgotPasswordModal" tabindex="-1" aria-labelledby="forgotPasswordLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form id="forgotPasswordForm">
                    <div class="modal-header">
                        <h5 class="modal-title">Forgot Password</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div id="forgotAlert" class="alert d-none" role="alert"></div>
                        <div class="mb-3">
                            <label>Enter Your Email</label>
                            <input type="email" class="form-control" name="email" required />
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">Confirm Email</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <!-- OTP Verification Modal -->
    <div class="modal fade" id="otpModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <form id="otpForm">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Verify OTP</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="email" id="otpEmail">
                        <div class="mb-3">
                            <label>Code OTP</label>
                            <input type="text" name="otp" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label>New Password</label>
                            <input type="password" name="newPassword" class="form-control" required>
                        </div>
                        <div id="otpAlert" class="alert d-none" role="alert"></div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">Change Password</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

</div>
<!-- Google SDK -->
<script src="https://accounts.google.com/gsi/client" async defer></script>

<!-- Facebook SDK -->
<div id="fb-root"></div>
<script async defer crossorigin="anonymous"
        src="https://connect.facebook.net/en_US/sdk.js#xfbml=1&version=v18.0&appId=1194387945498607&autoLogAppEvents=1"
        nonce="X123">
</script>

</body>

<script>
    document.getElementById("loginForm").addEventListener("submit", function (e) {
        e.preventDefault();

        const data = new URLSearchParams(new FormData(this));

        fetch("${pageContext.request.contextPath}/LoginServlet", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: data
        })
                .then(res => res.json())
                .then(data => {
                    const alertBox = document.getElementById("loginAlert");
                    alertBox.classList.remove("d-none");
                    alertBox.className = "alert " + (data.status === "success" ? "alert-success" : "alert-danger");
                    alertBox.textContent = data.message;

                    if (data.status === "success") {
                        setTimeout(() => window.location.reload(), 1000);
                    }
                });
    });


// GOOGLE LOGIN
    function onGoogleSignIn(response) {
        fetch("${pageContext.request.contextPath}/GoogleLoginServlet", {
            method: "POST",
            headers: {"Content-Type": "application/json"},
            body: JSON.stringify({credential: response.credential})
        })
                .then(res => res.json())
                .then(data => {
                    if (data.status === "success") {
                        window.location.reload();
                    } else {
                        alert("Google login failed");
                    }
                });
    }

// FACEBOOK
    function checkFacebookLogin() {
        FB.getLoginStatus(function (response) {
            if (response.status === 'connected') {
                const accessToken = response.authResponse.accessToken;
                FB.api('/me', {fields: 'id,name,email'}, function (profile) {
                    profile.accessToken = FB.getAuthResponse().accessToken; // thêm token để lấy avatar

                    // Gửi profile về server
                    fetch("${pageContext.request.contextPath}/FacebookLoginServlet", {
                        method: "POST",
                        headers: {"Content-Type": "application/json"},
                        body: JSON.stringify(profile)
                    })
                            .then(res => res.json())
                            .then(data => {
                                if (data.status === "success") {
                                    window.location.reload();
                                } else {
                                    alert("Facebook login failed");
                                }
                            });
                });
            }
        });
    }

    // M? modal forgot password
    function openForgotPasswordModal() {
        // Đóng mọi modal đang mở
        const modals = document.querySelectorAll('.modal.show');
                modals.forEach(m => bootstrap.Modal.getInstance(m)?.hide());

        // Mở modal forgot password
        const modal = new bootstrap.Modal(document.getElementById("forgotPasswordModal"));
        modal.show();
    }

// Khi g?i form forgot password
    document.getElementById("forgotPasswordForm").addEventListener("submit", function (e) {
    e.preventDefault();
            const data = new URLSearchParams(new FormData(this));
            const email = this.email.value;
            fetch("${pageContext.request.contextPath}/ForgotPasswordServlet", {
            method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: data
            })
            .then(res => res.json())
            .then(data => {
            const alertBox = document.getElementById("forgotAlert");
                    alertBox.classList.remove("d-none");
                    alertBox.className = "alert " + (data.status === "success" ? "alert-success" : "alert-danger");
                    alertBox.textContent = data.message;
                    if (data.status === "success") {
            document.getElementById("otpEmail").value = email;
                    // Đóng mọi modal đang mở
                    const modals = document.querySelectorAll('.modal.show');
                    modals.forEach(m => bootstrap.Modal.getInstance(m)?.hide());
                    // Mở OTP modal
                    const modal = new bootstrap.Modal(document.getElementById("otpModal"));
                    modal.show();
            }
            }
            );
    });
// Khi xác nh?n OTP + m?t kh?u m?i
            document.getElementById("otpForm").addEventListener("submit", function (e) {
    e.preventDefault();
            const data = new URLSearchParams(new FormData(this));
            fetch("${pageContext.request.contextPath}/ResetPasswordServlet", {
            method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: data
            })
            .then(res => res.json())
            .then(data => {
            const alertBox = document.getElementById("otpAlert");
                    alertBox.classList.remove("d-none");
                    alertBox.className = "alert " + (data.status === "success" ? "alert-success" : "alert-danger");
                    alertBox.textContent = data.message;
            });
    });

</script>
