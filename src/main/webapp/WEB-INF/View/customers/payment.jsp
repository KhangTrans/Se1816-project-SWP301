<%-- 
    Document   : payment
    Created on : Jun 23, 2025, 7:53:14 AM
    Author     : Le Nguyen Hoang Khang - CE191583
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="Model.Package" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@include file="/WEB-INF/include/head.jsp" %>
<%@include file="/WEB-INF/include/Login.jsp" %>
<%@include file="/WEB-INF/include/Register.jsp" %>
<%@include file="/WEB-INF/include/forgotPassword.jsp" %>
<%@include file="/WEB-INF/include/header.jsp" %>
<%
    Boolean renewMode = (Boolean) request.getAttribute("renewMode");
%>
<%
    Package pkg = (Package) request.getAttribute("pkg");
    // Lấy username từ session
    Integer accountId = null;
    if (session != null) {
        username = (String) session.getAttribute("username");
        accountId = (Integer) session.getAttribute("accountId");
    }
    String success = (String) request.getAttribute("success");
%>

<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <% if (success != null) { %>
        <meta http-equiv="refresh" content="3;url=homepage">
        <% } %>
        <style>
            body {
                font-family: 'Montserrat', sans-serif;
                background-color: #111;
                color: #fff;
                margin: 0;
                padding: 0;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                justify-content: center;
            }
            .container {
                display: flex;
                max-width: 1000px;
                margin: 40px auto;
                background: rgba(30, 30, 30, 0.9);
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3);
            }
            .left, .right {
                padding: 40px;
                flex: 1;
            }
            .left {
                background: rgba(36, 36, 36, 0.6);
                border-right: 1px solid #444;
            }
            .right h2, .left h2 {
                margin-top: 0;
                color: #c4ff00;
            }
            .method {
                margin-bottom: 20px;
                display: flex;
                align-items: center;
            }
            input[type="radio"] {
                margin-right: 10px;
            }
            label {
                cursor: pointer;
            }
            label.disabled {
                color: #888;
                cursor: not-allowed;
            }
            .pay-btn {
                background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
                color: #111;
                border: none;
                padding: 12px 25px;
                border-radius: 6px;
                font-weight: bold;
                cursor: pointer;
                transition: all 0.3s;
                width: 45%;
            }
            .pay-btn:hover {
                transform: translateY(-3px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            }
            .success-box {
                color: #66bb6a;
                background: #eaffec;
                padding: 22px 30px;
                border-radius: 12px;
                font-size: 1.15rem;
                margin: 60px auto;
                max-width: 480px;
                text-align: center;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
                animation: fadeIn 0.5s ease-out;
            }
            .warning {
                color: #c71c22;
                background: #fff4f4;
                padding: 22px 30px;
                border-radius: 12px;
                font-size: 1.15rem;
                margin: 60px auto;
                max-width: 480px;
                text-align: center;
            }

            /* New login required styles */
            .login-required {
                max-width: 500px;
                margin: 80px auto;
                background: rgba(30, 30, 30, 0.9);
                border-radius: 15px;
                padding: 40px;
                text-align: center;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
                position: relative;
                border: 1px solid #333;
                overflow: hidden;
            }
            
            .login-required__icon {
                font-size: 60px;
                color: #ff5252;
                margin-bottom: 20px;
            }
            
            .login-required__title {
                font-size: 24px;
                font-weight: bold;
                margin-bottom: 15px;
                color: #ff5252;
            }
            
            .login-required__message {
                margin-bottom: 30px;
                font-size: 16px;
                line-height: 1.6;
            }
            
            .login-required__buttons {
                display: flex;
                justify-content: center;
                gap: 20px;
            }
            
            .login-btn {
                background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
                color: #111;
                border: none;
                padding: 12px 30px;
                border-radius: 30px;
                font-weight: bold;
                cursor: pointer;
                text-decoration: none;
                transition: all 0.3s;
                font-size: 16px;
            }
            
            .login-btn:hover {
                transform: translateY(-3px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            }
            
            .cancel-btn {
                background: transparent;
                color: #fff;
                border: 1px solid #aaa;
                padding: 12px 30px;
                border-radius: 30px;
                font-weight: bold;
                cursor: pointer;
                text-decoration: none;
                transition: all 0.3s;
                font-size: 16px;
            }
            
            .cancel-btn:hover {
                background: rgba(255, 255, 255, 0.1);
                border-color: #fff;
            }
            
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(20px); }
                to { opacity: 1; transform: translateY(0); }
            }
            
            .glow {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 5px;
                background: linear-gradient(to right, #ff5252, #ff8a80);
                box-shadow: 0 0 20px rgba(255, 82, 82, 0.8);
            }
        </style>
    </head>
    <body>

        <% if (accountId != null && username != null) { %>
        <% if (success != null) {%>
        <div class="success-box"><%= success%></div>
        <% }%>
        <div class="container">
            <!-- Thông tin gói -->
            <div class="left">
                <h2>Hello, <%= username%>!</h2>
                <% if (pkg != null) {%>
                <p><strong>Membership Package name:</strong> <%= pkg.getName()%></p>
                <p><strong>Description:</strong> <%= pkg.getDescription()%></p>
                <p><strong>Duration:</strong> <%= pkg.getDurationDays()%> ngày</p>
                <p><strong>Price:</strong> <span style="color:#e63946"><%= pkg.getPrice()%> VNĐ</span></p>
                <% } else { %>
                <p>Can't find package.</p>
                <% } %>
            </div>
            <!-- Phương thức thanh toán -->
            <div class="right">
                <h2>Payment method</h2>
                <% if (success == null && pkg != null) {%>
                <form action="payment" method="post">
                    <input type="hidden" name="cardId" value="<%= pkg.getId()%>">
                    <% if (Boolean.TRUE.equals(renewMode)) { %>
                    <input type="hidden" name="renew" value="1">
                    <% } %>

                    <div class="method">
                        <input type="radio" name="paymentMethod" id="offline" value="offline" checked>
                        <label for="offline">Pay in person (Direct payment)</label>
                    </div>
                    <div class="method">
                        <input type="radio" name="paymentMethod" id="online" value="online" disabled>
                        <label for="online" class="disabled">Online payment (unsupported)</label>
                    </div>
                    <%
                        // Lấy membership đang bị "cancelled" mà chưa hết hạn
                        Model.CustomerMembership activeMembership = (Model.CustomerMembership) request.getAttribute("activeMembership");
                        boolean canChooseApplyTime = false;
                        if (activeMembership != null
                                && "cancelled".equalsIgnoreCase(activeMembership.getPaymentStatus())
                                && !java.time.LocalDate.now().isAfter(activeMembership.getEndDate())) {
                            canChooseApplyTime = true;
                        }
                    %>
                    <% if (canChooseApplyTime) { %>
                    <div class="method">
                        <label><h2>When to apply new membership package</h2></label>
                    </div>
                    <div class="method">
                        <input type="radio" name="applyOption" id="applyNow" value="applyNow" checked>
                        <label for="applyNow">Apply immediately (the current package will be stopped and replaced)</label>
                    </div>
                    <div class="method">
                        <input type="radio" name="applyOption" id="applyLater" value="applyLater">
                        <label for="applyLater">Apply after the current package expires (the new package will start after the old one ends)</label>
                    </div>
                    <% } %>

                    <div style="display: flex">
                    <button type="submit" class="pay-btn">Confirm</button>
                    <a href="homepage" class="pay-btn" style="margin-left: 10%; background: #ccc; color: #111; text-align:center; text-decoration:none; display:flex; align-items:end; justify-content:center; width: 45%">
                        Cancel
                    </a>
                    </div>
                    <% if (request.getAttribute("error") != null) {%>
                    <div style="color:red"><%= request.getAttribute("error")%></div>
                    <% } %>
                </form>
                <% } %>
            </div>
        </div>
        <% } else { %>
        <div class="login-required">
            <div class="glow"></div>
            <div class="login-required__icon">
                <i class="fas fa-lock"></i>
            </div>
            <div class="login-required__title">Login Required</div>
            <div class="login-required__message">
                You need to be logged in to book a membership package. Please login to your account or create a new one to continue.
            </div>
            <div class="login-required__buttons">
                <a href="Login.jsp" class="login-btn">Login Now</a>
                <a href="homepage" class="cancel-btn">Go to Homepage</a>
            </div>
        </div>
        <% }%>
    </body>
    <% if (request.getAttribute("success") != null) {%>
    <div class="success-box"><%= request.getAttribute("success")%></div>
    <meta http-equiv="refresh" content="2;url=homepage">
    <% } else if (request.getAttribute("error") != null) {%>
    <div class="warning"><%= request.getAttribute("error")%></div>
    <% }%>
</html>
<%@include file="/WEB-INF/include/footer.jsp" %>