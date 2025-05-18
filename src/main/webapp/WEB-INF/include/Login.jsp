<!-- Login Modal -->
<body>
    <div class="modal fade" id="loginModal" tabindex="-1" aria-labelledby="loginModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form id="loginForm" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title">Login</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">
                        <div id="loginAlert" class="alert d-none" role="alert"></div>

                        <div class="mb-3">
                            <label>Username</label>
                            <input type="text" class="form-control" name="username" required />
                        </div>

                        <div class="mb-3">
                            <label>Password</label>
                            <input type="password" class="form-control" name="password" required />
                        </div>

                        <button type="submit" class="btn btn-primary w-100 mb-3">Login</button>

                        <div class="text-center">OR</div>

                        <!-- Google Login -->
                        <div class="d-grid gap-2 mt-3 mb-2">
                            <div id="g_id_onload"
                                 data-client_id="749125474877-p8jcn9i7b48rpgq3eh4gkintoph2noo5.apps.googleusercontent.com"
                                 data-callback="onGoogleSignIn"
                                 data-auto_prompt="false"></div>
                            <div class="g_id_signin" data-type="standard"></div>
                        </div>

                        <!-- Facebook Login -->
                        <div class="d-grid gap-2">
                            <div class="fb-login-button"
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
                </form> <!-- ? ?óng form ?úng ch? ? ?ây -->
            </div>
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

        fetch("/SE1816_Oto_Group_4/LoginServlet", {
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
        fetch("/SE1816_Oto_Group_4/GoogleLoginServlet", {
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
                FB.api('/me?fields=id,name,email', function (profile) {
                    fetch("/SE1816_Oto_Group_4/FacebookLoginServlet", {
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
</script>
