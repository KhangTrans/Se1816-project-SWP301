<%-- 
    Document   : footer
    Created on : Feb 9, 2025, 12:16:04 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<style>
    footer {
        background-color: #111;
        color: #f8f9fa;
        font-family: 'Segoe UI', sans-serif;
        margin-top: 50px;
        border-top: 1px solid #333;
        padding: 30px 0 15px 0;
    }

    .footer-sections {
        display: flex;
        justify-content: space-between;
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 15px;
        flex-wrap: wrap;
    }

    .footer-section {
        flex: 1;
        min-width: 300px;
        margin-bottom: 25px;
    }

    .footer-title {
        color: #d9ff00 !important;
        font-size: 18px;
        font-weight: 700;
        margin-bottom: 20px;
        text-transform: uppercase;
    }

    .footer-content p {
        color: #fff;
        margin: 0 0 8px 0;
        font-size: 15px;
        line-height: 1.5;
    }

    .footer-content a {
        color: #fff;
        text-decoration: none;
        display: flex;
        align-items: center;
        margin-bottom: 10px;
    }

    .footer-content i {
        margin-right: 10px;
        width: 18px;
    }

    .footer-map {
        width: 100%;
        height: 200px;
        border-radius: 5px;
    }

    .footer-map iframe {
        width: 100%;
        height: 100%;
        border: 0;
        border-radius: 5px;
    }

    .footer-bottom {
        max-width: 1200px;
        margin: 20px auto 0;
        padding: 15px;
        text-align: center;
        border-top: 1px solid #333;
        color: #ccc;
        font-size: 14px;
    }
</style>

<footer>
    <div class="footer-sections">
        <!-- About section -->
        <div class="footer-section">
                            <h3 class="footer-title" style="color: #d9ff00;">FPT UNIVERSITY - CAN THO</h3>
                <div class="footer-content">
                    <p>Comprehensive student training with modern curriculum, practical skills and international environment.</p>
            </div>
        </div>

        <!-- Contact section -->
        <div class="footer-section">
                            <h3 class="footer-title" style="color: #d9ff00;">CONTACT</h3>
                <div class="footer-content">
                    <a href="#"><i class="fas fa-map-marker-alt"></i> 600 Nguyen Van Cu, An Binh, Ninh Kieu, Can Tho</a>
                <a href="mailto:fpt.ct@fe.edu.vn"><i class="fas fa-envelope"></i> fpt.ct@fe.edu.vn</a>
                <a href="tel:+84292730186"><i class="fas fa-phone"></i> (+84) 292 730 1866</a>
            </div>
        </div>

        <!-- Google Map -->
        <div class="footer-section">
                            <h3 class="footer-title" style="color: #d9ff00;">MAP LOCATION</h3>
            <div class="footer-map">
                <iframe 
                    src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3929.058643908444!2d105.735396075019!3d10.012271790092959!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31a088a2556e4f4f%3A0x7c56e6603c42d087!2zVHLGsOG7nW5nIMSQ4bqhaSBo4buNYyBGUFQgQ-G7rWEgQ8awbiBUaMOybw!5e0!3m2!1svi!2s!4v1715330992296!5m2!1svi!2s" 
                    allowfullscreen="" 
                    loading="lazy" 
                    referrerpolicy="no-referrer-when-downgrade">
                </iframe>
            </div>
        </div>
    </div>

    <!-- Copyright -->
    <div class="footer-bottom">
                    <p>© 2025 Copyright belongs to Group 4 SE1816 FPTU Can Tho. All rights reserved.</p>
    </div>
</footer>
<!-- Font Awesome (for icons) -->
<script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
<!-- Bootstrap CSS (n?u ch?a có) -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Bootstrap JS & Popper.js -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%= request.getContextPath()%>/js/carousel.js"></script>
<script src="./js/pagination.js"></script>
</body>
</html>
