<!-- Modal ??ng Ký Customer -->
<div class="modal fade" id="signupModal" tabindex="-1" aria-labelledby="signupModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="signupForm" enctype="multipart/form-data">
                <div class="modal-header">
                    <h5 class="modal-title">Customer Sign Up</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <div id="signupAlert" class="alert d-none" role="alert"></div>

                    <input type="hidden" name="role" value="customer" />

                    <div class="mb-3">
                        <label>Email</label>
                        <input type="email" class="form-control" name="email" required />
                    </div>

                    <div class="mb-3">
                        <label>Username</label>
                        <input type="text" class="form-control" name="username" required />
                    </div>

                    <div class="mb-3">
                        <label>Phone</label>
                        <input type="text" class="form-control" name="phone" required />
                    </div>

                    <div class="mb-3">
                        <label>Password</label>
                        <input type="password" class="form-control" name="password" required />
                    </div>

                    <div class="mb-3">
                        <label>Confirm Password</label>
                        <input type="password" class="form-control" name="confirm_password" required />
                    </div>

                    <div class="mb-3">
                        <label>Avatar</label>
                        <input type="file" class="form-control" name="avatar" accept=".png, .jpg" />
                    </div>
                </div>

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

        fetch("/SE1816_Oto_Group_4/RegisterServlet", {
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
