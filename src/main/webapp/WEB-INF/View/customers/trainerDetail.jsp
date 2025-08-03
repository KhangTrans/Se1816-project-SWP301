<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="Model.Trainers" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ include file="/WEB-INF/include/head.jsp" %>
<%@ include file="/WEB-INF/include/Login.jsp" %>
<%@ include file="/WEB-INF/include/Register.jsp" %>
<%@ include file="/WEB-INF/include/forgotPassword.jsp" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<!-- Thêm CSS trực tiếp vào trang JSP -->
<style>
    .trainer-detail-container {
        max-width: 1000px;
        margin: 0 auto 50px;
        padding: 0 20px;
    }

    .content__text--bottom {
        color: #d9ff68;
        font-size: 40px !important;
        font-weight: bold;
        text-align: center;
        margin-top: 50px;
        margin-bottom: 30px;
        text-transform: uppercase;
        letter-spacing: 2px;
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

    .trainer-profile-card {
        background: linear-gradient(to bottom, #1a2a3a, #0d1b29);
        border-radius: 15px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
        overflow: hidden;
        display: flex;
        flex-wrap: wrap;
        margin-top: 30px;
    }

    .trainer-image-container {
        flex: 0 0 300px;
        position: relative;
        overflow: hidden;
    }

    .trainer-image {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.5s;
    }

    .trainer-info-container {
        flex: 1;
        padding: 30px;
        position: relative;
    }

    .trainer-name {
        font-size: 32px;
        font-weight: 700;
        margin-bottom: 20px;
        color: #d9ff68;
        text-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
    }

    .trainer-details {
        list-style: none;
        padding: 0;
        margin-bottom: 30px;
    }

    .trainer-details li {
        display: flex;
        align-items: baseline;
        margin-bottom: 15px;
        font-size: 16px;
        color: #fff;
    }

    .trainer-details li i {
        color: #d9ff68;
        width: 25px;
        margin-right: 10px;
        text-align: center;
    }

    .trainer-details .label {
        font-weight: 600;
        color: #d9ff68;
        width: 120px;
        margin-right: 10px;
    }

    .trainer-details .value {
        color: #fff;
        flex: 1;
    }

    .price-tag {
        display: inline-block;
        background: rgba(217, 255, 104, 0.2);
        padding: 8px 15px;
        border-radius: 50px;
        color: #d9ff68;
        font-weight: bold;
        margin-top: 10px;
        border: 1px solid rgba(217, 255, 104, 0.3);
    }

    .trainer-rating {
        margin-top: 5px;
        display: flex;
        align-items: center;
    }

    .rating-stars {
        color: #ffc107;
        margin-right: 10px;
    }

    .book-now-btn {
        display: inline-block;
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        color: #111;
        padding: 12px 30px;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 700;
        font-size: 18px;
        text-transform: uppercase;
        letter-spacing: 1px;
        transition: all 0.3s ease;
        border: none;
        margin-top: 20px;
        cursor: pointer;
    }

    .book-now-btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 10px 20px rgba(217, 255, 104, 0.4);
        background: linear-gradient(135deg, #d9ff68 0%, #c4ff00 100%);
    }

    /* Login required styles */
    .login-required-box {
        background: rgba(0, 0, 0, 0.3);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 8px;
        padding: 20px;
        margin-top: 20px;
        text-align: center;
        position: relative;
    }

    .login-required-text {
        color: #ff8a80;
        font-size: 16px;
        margin-bottom: 15px;
        font-weight: bold;
    }

    .login-required-text i {
        margin-right: 8px;
    }

    .login-required-buttons {
        display: flex;
        gap: 15px;
        justify-content: center;
    }

    .login-required-btn {
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        color: #111;
        border: none;
        padding: 12px 25px;
        border-radius: 8px;
        font-weight: bold;
        font-size: 16px;
        cursor: pointer;
        flex: 1;
        max-width: 120px;
        transition: all 0.3s ease;
    }

    .login-required-btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 15px rgba(217, 255, 104, 0.3);
    }

    .login-required-btn.register {
        background: transparent;
        border: 1px solid #c4ff00;
        color: #c4ff00;
    }

    .login-required-btn.register:hover {
        background: rgba(196, 255, 0, 0.1);
    }

    @media (max-width: 768px) {
        .trainer-image-container {
            flex: 0 0 100%;
            height: 350px;
        }
    }
</style>

<!-- Link to Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<!-- Lấy đối tượng huấn luyện viên từ request -->
<%
    Trainers trainer = (Trainers) request.getAttribute("trainer");
    DecimalFormat formatter = new DecimalFormat("#,###");
    String formattedPrice = formatter.format(trainer.getPrice());
%>

<div class="content">
    <p class="content__text--bottom">Trainer Detail</p>
</div>

<div class="trainer-detail-container">
    <div class="trainer-profile-card">
        <div class="trainer-image-container">
            <img class="trainer-image" src="<%= request.getContextPath() + "/AvatarServlet?user=" + trainer.getAccountId().getUsername()%>" 
                 alt="<%= trainer.getFullName()%>" />
        </div>

        <div class="trainer-info-container">
            <h1 class="trainer-name"><%= trainer.getFullName()%></h1>

            <ul class="trainer-details">
                <li>
                    <i class="fas fa-info-circle"></i>
                    <span class="label">Bio:</span>
                    <span class="value"><%= trainer.getBio()%></span>
                </li>
                <li>
                    <i class="fas fa-phone-alt"></i>
                    <span class="label">Phone:</span>
                    <span class="value"><%= trainer.getPhone()%></span>
                </li>
                <li>
                    <i class="fas fa-history"></i>
                    <span class="label">Experience:</span>
                    <span class="value"><%= trainer.getExperienceYears()%> years</span>
                </li>
                <li>
                    <i class="fas fa-star"></i>
                    <span class="label">Rating:</span>
                    <span class="value">
                        <div class="trainer-rating">
                            <div class="rating-stars">
                                <% for (int i = 0; i < Math.floor(trainer.getRating()); i++) { %>
                                <i class="fas fa-star"></i>
                                <% } %>
                                <% if (trainer.getRating() % 1 != 0) { %>
                                <i class="fas fa-star-half-alt"></i>
                                <% }%>
                            </div>
                            <%= trainer.getRating()%>/5
                        </div>
                    </span>
                </li>
                <li>
                    <i class="fas fa-tag"></i>
                    <span class="label">Price:</span>
                    <span class="value">
                        <div class="price-tag">
                            <%= formattedPrice%> VND / slot
                        </div>
                    </span>
                </li>
            </ul>

            <% if (session != null && session.getAttribute("username") != null) {%>
            <a class="book-now-btn" href="<%= request.getContextPath()%>/bookingpt?trainerid=<%= trainer.getTrainerId()%>">
                <i class="fas fa-calendar-check"></i> Book Now
            </a>
            <% } else { %>
            <div class="login-required-box">
                <div class="login-required-text">
                    <i class="fas fa-lock"></i> Login required to book this trainer
                </div>
                <div class="login-required-buttons">
                    <button onclick="openLoginModal()" class="login-required-btn" data-bs-toggle="modal"
                            data-bs-target="#loginModal">Login</button>
                    <button onclick="openRegisterModal()" class="login-required-btn register">Register</button>
                </div>
            </div>
            <% }%>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/include/footer.jsp" %>
