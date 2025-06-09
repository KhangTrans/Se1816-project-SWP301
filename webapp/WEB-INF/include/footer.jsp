<%-- 
    Document   : footer
    Created on : Feb 9, 2025, 12:16:04 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<style>
    footer {
        background-color: #111;
        color: white;
        font-family: 'Segoe UI', sans-serif;
        margin-top: 50px;
        width: 100%;
    }

    footer h5 {
        color: #ff7f00;
        font-weight: 600;
    }

    footer p, footer a {
        color: #dcdcdc;
        font-size: 15px;
    }

    footer a:hover, footer i:hover {
        color: #ff7f00;
        text-decoration: none;
        transition: all 0.3s ease;
    }

    .map-responsive {
        overflow: hidden;
        padding-bottom: 56.25%;
        position: relative;
        border-radius: 10px;
    }

    .map-responsive iframe {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        border: 0;
    }

    .footer-icon {
        margin-right: 10px;
    }

    .footer-bottom {
        border-top: 1px solid #444;
        margin-top: 20px;
        padding-top: 15px;
        text-align: center;
        font-size: 14px;
    }

    .wrapper {
        display: flex;
        flex-direction: column;
        min-height: 100vh;
    }

    .content {
        flex: 1;
    }
</style>

<footer class="container text-white pt-5 pb-4 mt-5">
    <div class="container text-md-left">
        <div class="row text-md-left">
            <!-- About section -->
            <div class="col-md-4 col-lg-4 col-xl-4 mx-auto mt-3">
                <h5 class="text-uppercase mb-4 font-weight-bold text-warning">FPT University - Cần Thơ</h5>
                <p>Đào tạo sinh viên toàn diện với chương trình học hiện đại, kỹ năng thực tiễn và môi trường quốc tế.</p>
            </div>

            <!-- Contact section -->
            <div class="col-md-4 col-lg-4 col-xl-4 mx-auto mt-3">
                <h5 class="text-uppercase mb-4 font-weight-bold text-warning">Liên hệ</h5>
                <p><i class="fas fa-home me-2"></i> 600 Nguyễn Văn Cừ, An Bình, Ninh Kiều, Cần Thơ</p>
                <p><i class="fas fa-envelope me-2"></i> fpt.ct@fe.edu.vn</p>
                <p><i class="fas fa-phone me-2"></i> (+84) 292 730 1866</p>
            </div>

            <!-- Google Map -->
            <div class="col-md-4 col-lg-4 col-xl-4 mx-auto mt-3">
                <h5 class="text-uppercase mb-4 font-weight-bold text-warning">Địa chỉ trên bản đồ</h5>
                <div class="map-responsive">
                    <iframe 
                        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3929.058643908444!2d105.735396075019!3d10.012271790092959!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31a088a2556e4f4f%3A0x7c56e6603c42d087!2zVHLGsOG7nW5nIMSQ4bqhaSBo4buNYyBGUFQgQ-G7rWEgQ8awbiBUaMOybw!5e0!3m2!1svi!2s!4v1715330992296!5m2!1svi!2s" 
                        width="100%" 
                        height="200" 
                        style="border:0;" 
                        allowfullscreen="" 
                        loading="lazy" 
                        referrerpolicy="no-referrer-when-downgrade">
                    </iframe>
                </div>
            </div>
        </div>

        <hr class="mb-4">

        <!-- Copyright -->
        <div class="row align-items-center">
            <div class="col-md-8 col-lg-8">
                <p class="text-left">© 2025 Bản quyền thuộc về <strong>FPT University - Cần Thơ</strong>. All rights reserved.</p>
            </div>
        </div>
    </div>
</footer>


<!-- Font Awesome (for icons) -->
<script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
<!-- Bootstrap CSS (n?u ch?a có) -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Bootstrap JS & Popper.js -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
