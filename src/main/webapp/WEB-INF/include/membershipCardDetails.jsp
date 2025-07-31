
<%@ page import="Model.Package" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    Model.Package pkg = (Model.Package) request.getAttribute("pkg");
    // Tạo đối tượng DecimalFormat để định dạng tiền
    DecimalFormat formatter = new DecimalFormat("#,###");
    String formattedPrice = formatter.format(pkg.getPrice());  // Định dạng giá tiền
    String membershipError = (String) request.getAttribute("membershipError");
    if (membershipError != null) {
%>
<script>
    window.addEventListener('DOMContentLoaded', function () {
        alert('<%= membershipError.replace("'", "\\'")%>');
    });
</script>
<% }%>

<%@ include file="/WEB-INF/include/head.jsp" %>
<%@include file="/WEB-INF/include/Login.jsp" %>
<%@include file="/WEB-INF/include/Register.jsp" %>
<%@include file="/WEB-INF/include/forgotPassword.jsp" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    .package-detail {
        background: linear-gradient(180deg, #4B8137, #153000);
        border-radius: 10px;
        padding: 30px;
        margin: 30px auto;
        max-width: 500px;
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3);
        position: relative;
    }

    .package-detail__title {
        font-size: 24px;
        font-weight: bold;
        color: white;
        margin-bottom: 20px;
    }

    .package-detail__price {
        font-size: 36px;
        font-weight: bold;
        color: #d9ff68;
        margin-bottom: 20px;
        text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.3);
    }

    .package-detail__unit {
        font-size: 18px;
        color: #d9ff68;
    }

    .package-detail__description {
        color: white;
        margin-bottom: 25px;
        line-height: 1.6;
    }

    .package-detail__info-row {
        display: flex;
        flex-wrap: wrap;
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 1px solid rgba(255,255,255,0.2);
    }

    .package-detail__info-row .label {
        color: white;
        font-weight: bold;
        margin-right: 5px;
    }

    .package-detail__info-row .value {
        color: #d9ff68;
        margin-right: 20px;
    }

    .package-detail__book-btn {
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        color: #111;
        border: none;
        padding: 14px 30px;
        border-radius: 8px;
        font-weight: bold;
        font-size: 18px;
        cursor: pointer;
        display: block;
        width: 100%;
        text-transform: uppercase;
        letter-spacing: 1px;
        margin-top: 20px;
        transition: all 0.3s ease;
    }

    .package-detail__book-btn:hover {
        background: linear-gradient(135deg, #d9ff68 0%, #c4ff00 100%);
        transform: translateY(-3px);
        box-shadow: 0 8px 15px rgba(217, 255, 104, 0.3);
    }

    .package-detail__back-link {
        display: inline-block;
        color: #d9ff68;
        text-decoration: none;
        margin-top: 20px;
        font-weight: 600;
        transition: all 0.3s ease;
    }

    .package-detail__back-link:hover {
        color: white;
        transform: translateX(-5px);
    }

    .content__text--bottom {
        color: #d9ff68;
        font-size: 60px !important;
        font-weight: bold;
        text-align: center;
        margin-top: 50px;
        margin-bottom: 20px;
        text-transform: uppercase;
        letter-spacing: 2px;
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

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
</style>

<div class="content" style="margin-top: 20px">
    <p class="content__text--bottom">Membership Packages Detail</p>
</div>

<div class="package-detail">
    <div class="package-detail__title"><%= pkg.getName()%></div>
    <div class="package-detail__price">
        <%= formattedPrice%> <span class="package-detail__unit">VND / Month</span>
    </div>
    <div class="package-detail__description">
        <%= pkg.getDescription().replaceAll("\\. ", ".<br>")%>
    </div>

    <div class="package-detail__info-row">
        <span class="label">Deadline:</span>
        <span class="value"><%= pkg.getDurationDays()%> Date</span>
        <span class="label">Status:</span>
        <span class="value"><%= pkg.isIsActive() ? "Applying" : "Stop applying"%></span>
    </div>

    <% if (session != null && session.getAttribute("username") != null) {%>
    <form action="payment" method="get">
        <input type="hidden" name="cardId" value="<%= pkg.getId()%>">
        <button type="submit" class="package-detail__book-btn">Book now</button>
    </form>
    <% } else { %>
    <div class="login-required-box">
        <div class="login-required-text">
            <i class="fas fa-lock"></i> Login required to book this package
        </div>
        <div class="login-required-buttons">
            <button onclick="openLoginModal()" class="login-required-btn" data-bs-toggle="modal"
                    data-bs-target="#loginModal">Login</button>
            <button onclick="openRegisterModal()" class="login-required-btn register">Register</button>
        </div>
    </div>
    <% }%>

    <a class="package-detail__back-link" href="<%= request.getContextPath()%>/homepage">&lt; Back to homepage</a>
</div>

<script src="js/membership.js"></script>

<%@ include file="/WEB-INF/include/footer.jsp" %>
