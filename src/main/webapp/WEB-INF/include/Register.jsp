
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- Modal ??ng Ký Customer -->
<div class="modal fade" id="signupModal" tabindex="-1" aria-labelledby="signupModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="signupForm" enctype="multipart/form-data">
                <div class="modal-header">
                    <h5 class="modal-title" style="margin-left: 40%">Register</h5>
                    <button type="button"
                            class="btn-close"
                            data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <div id="signupAlert"
                         class="alert d-none"
                         role="alert"></div>

                    <input type="hidden"
                           name="role"
                           value="customer" />

                    <div class="mb-3">
                        <label style="color: black">Email</label>
                        <input type="email"
                               class="form-control"
                               name="email"
                               pattern="^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$"
                               required />
                    </div>

                    <div class="mb-3">
                        <label style="color: black">Username</label>
                        <input type="text"
                               class="form-control"
                               name="username"
                               required/>
                    </div>

                    <div class="mb-3">
                        <label style="color: black">Phone</label>
                        <input type="text"
                               class="form-control"
                               name="phone"
                               pattern="^(0[35789])[0-9]{8}$" 
                               title="Please enter a valid phone number (eg: 0912345678)."
                               required/>
                    </div>

                    <div class="mb-3">
                        <label style="color: black">Password</label>
                        <input type="password"
                               class="form-control"
                               name="password"
                               pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"
                               title="Password must be at least 8 characters, including uppercase, lowercase, numbers and special characters"
                               required/>
                        <h6>Note: </h6>
                        <ul style="color: #555; font-size: 12px; margin-top: 5px; padding-left: 20px;">
                            <li>Password must be at least 8 characters.</li>
                            <li>Contain at least 1 uppercase letter.</li>
                            <li>Contain at least 1 lowercase letter.</li>
                            <li>Contain at least 1 number.</li>
                            <li>Contain at least 1 special character (e.g. @$!%*?&).</li>
                        </ul>
                    </div>

                    <div class="mb-3">
                        <label style="color: black">Confirm Password</label>
                        <input type="password"
                               class="form-control"
                               name="confirm_password"/>
                    </div>

                    <div class="mb-3">
                        <label style="color: black">Avatar</label>
                        <input type="file"
                               class="form-control"
                               name="avatar"
                               accept=".png, .jpg"/>
                    </div>
                </div>
                <a href="#" class="d-flex justify-content-center"
                   data-bs-toggle="modal"
                   data-bs-target="#loginModal">
                    Already have an account? Login here</a>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary w-100">Register</button>
                </div>
            </form>

        </div>
    </div>

</div>
<script>
    document.getElementById("signupForm").addEventListener("submit", function (e) {
        e.preventDefault();
        const formData = new FormData(this);

        fetch("${pageContext.request.contextPath}/RegisterServlet", {
            method: "POST",
            body: formData
        })
                .then(res => res.json())
                .then(data => {
                    const alertBox = document.getElementById("signupAlert");
                    alertBox.classList.remove("d-none");
                    alertBox.className = "alert " + (data.status === "success" ? "alert-success" : "alert-danger");
                    alertBox.textContent = data.message;

                    if (data.status === "success") {
                        setTimeout(() => {
                            const modal = bootstrap.Modal.getInstance(document.getElementById("signupModal"));
                            modal.hide();
                            document.getElementById("signupForm").reset();
                            alertBox.classList.add("d-none");
                        }, 2000);
                    }
                })
                .catch(error => {
                    console.error("Error:", error);
                    const alertBox = document.getElementById("signupAlert");
                    alertBox.classList.remove("d-none");
                    alertBox.className = "alert alert-danger";
                    alertBox.textContent = "Client error: " + error.message;
                });
    });
</script>
