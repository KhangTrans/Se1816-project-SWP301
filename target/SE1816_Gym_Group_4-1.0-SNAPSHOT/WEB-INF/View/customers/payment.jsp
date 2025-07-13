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
        <title>Thanh toán</title>
        <% if (success != null) { %>
        <meta http-equiv="refresh" content="3;url=homepage">
        <% } %>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f7f7f7;
            }
            .container {
                display: flex;
                max-width: 900px; /* Hoặc lớn hơn nếu muốn */
                margin: 40px auto;
                background: #fff;
                border-radius: 18px;
                box-shadow: 0 6px 32px rgba(0,0,0,0.07);
            }
            .left, .right {
                flex: 1 1 0;
                box-sizing: border-box;
                padding: 36px 28px;
                min-width: 0;         /* Fix flexbox bug khi nội dung lớn */
            }
            .left {
                flex: 1;
                border-right: 1px solid #eee;
                background: #f2f8fd;
            }
            .right {
                display: flex;
                flex-direction: column;
                justify-content: flex-start;
                align-items: flex-start; /* căn trái toàn bộ */
            }

            .right form {
                width: 100%;       /* full chiều ngang cột phải */
                max-width: 100%;   /* không giới hạn max */
                text-align: left;
            }
            .pay-btn {
                padding: 14px 0;
                width: 45%;
                gap: 10px;
                background: #3a7bfd;
                color: #fff;
                font-size: 18px;
                font-weight: bold;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                margin-top: 10px;
            }
            .pay-btn:hover {
                background: #2563eb;
            }
            .method {
                display: flex;
                align-items: center;
                margin-bottom: 18px;
            }
            .method input[type="radio"] {
                width: 16px !important;   /* radio mặc định thường là 16px */
                height: 16px !important;
                min-width: 0 !important;
                max-width: 24px !important;
                margin: 4px 12px 4px 0;
                vertical-align: middle;
            }
            .method label {
                font-size: 16px;
                color: #333;
            }
            .disabled {
                color: #aaa;
            }
            h2 {
                margin-top: 0;
                color: #3a7bfd;
            }
            .success-box {
                color: green;
                padding: 18px;
                margin-bottom: 18px;
                border-radius: 10px;
                background: #e6ffe6;
                font-size: 1.1rem;
                text-align: center;
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
        <div class="warning">
            You are not logged in! <a href="login.jsp">Login now</a>
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