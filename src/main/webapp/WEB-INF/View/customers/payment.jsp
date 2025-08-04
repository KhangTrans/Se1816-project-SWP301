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
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/payment.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <% if (success != null) { %>
        <meta http-equiv="refresh" content="3;url=homepage">
        <% } %>
    </head>
    <body>
        <div class="payment-page-wrapper">
            <% if (pkg == null) { %>
            <div class="login-required" style="margin:100px auto;max-width:500px">
                <div class="login-required__icon" style="text-align:center;">
                    <i class="fas fa-exclamation-triangle" style="color:#e67c1b;font-size:56px;"></i>
                </div>
                <div class="login-required__title" style="color:#e67c1b;font-size:2rem;font-weight:bold;text-align:center;margin-top:10px;">
                    Package Not Found
                </div>
                <div class="login-required__message" style="color:#fff">
                    The package you are looking for does not exist, has been removed, or the link is invalid. 
                    Please choose another package or return to the homepage.
                </div>
                <div class="login-required__buttons" style="text-align:center;">
                    <a href="homepage" class="cancel-btn" style="padding:10px 24px;font-size:1.05rem;">Go to Homepage</a>
                </div>
            </div>
            <% } else if (accountId != null && username != null) { %>
            <% if (success != null) {%>
            <div class="success-box"><%= success%></div>
            <% } else {%>
            <div class="payment-header">
                <h1 class="payment-title">Membership Payment</h1>
            </div>
            <div class="container">
                <!-- Package Information -->
                <div class="left">
                    <h2>Hello, <%= username%>!</h2>
                    <% if (pkg != null) {%>
                    <div class="package-info">
                        <p><strong>Package name:</strong> <span><%= pkg.getName()%></span></p>
                        <p><strong>Description:</strong> <span><%= pkg.getDescription()%></span></p>
                        <p><strong>Duration:</strong> <span><%= pkg.getDurationDays()%> days</span></p>
                        <p><strong>Price:</strong> <span class="price"><%= String.format("%,.0f", pkg.getPrice())%> VND</span></p>
                    </div>
                    <% } else { %>
                    <p>Package information not available.</p>
                    <% } %>
                </div>
                <!-- Payment Methods -->
                <div class="right">
                    <h2>Payment method</h2>
                    <% if (success == null && pkg != null) {%>
                    <form action="payment" method="post">
                        <input type="hidden" name="cardId" value="<%= pkg.getId()%>">
                        <% if (Boolean.TRUE.equals(renewMode)) { %>
                        <input type="hidden" name="renew" value="1">
                        <% } %>

                        <div class="payment-methods">
                            <div class="payment-option">
                                <input type="radio" id="offline" name="paymentMethod" value="offline" checked>
                                <label for="offline" class="payment-option-label">
                                    <i class="fas fa-money-bill-wave payment-icon"></i>
                                    <span class="payment-option-text">Pay in person (Direct payment)</span>
                                </label>
                            </div>
                            <div class="payment-option disabled">
                                <input type="radio" id="online" name="paymentMethod" value="online" disabled>
                                <label for="online" class="payment-option-label disabled">
                                    <i class="fas fa-credit-card payment-icon"></i>
                                    <span class="payment-option-text">Online payment (unsupported)</span>
                                </label>
                            </div>
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
                        <h2>When to apply new membership package</h2>
                        <div class="payment-methods">
                            <div class="payment-option">
                                <input type="radio" id="applyNow" name="applyOption" value="applyNow" checked>
                                <label for="applyNow" class="payment-option-label">
                                    <i class="fas fa-bolt payment-icon"></i>
                                    <span class="payment-option-text">Apply immediately (current package will be replaced)</span>
                                </label>
                            </div>
                            <div class="payment-option">
                                <input type="radio" id="applyLater" name="applyOption" value="applyLater">
                                <label for="applyLater" class="payment-option-label">
                                    <i class="fas fa-calendar-alt payment-icon"></i>
                                    <span class="payment-option-text">Apply after current package expires</span>
                                </label>
                            </div>
                        </div>
                        <% } %>

                        <div style="display: flex">
                            <button type="submit" class="pay-btn">Confirm</button>
                            <a href="homepage" class="cancel-btn">Cancel</a>
                        </div>
                        <% if (request.getAttribute("error") != null) {%>
                        <div class="warning"><%= request.getAttribute("error")%></div>
                        <% } %>
                    </form>
                    <% } %>
                </div>
            </div>
            <% } %>
            <% } else { %>
            <div class="login-required">
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
            <% } %>
        </div>

        <% if (request.getAttribute("success") != null) {%>
        <div class="success-box"><%= request.getAttribute("success")%></div>
        <meta http-equiv="refresh" content="2;url=homepage">
        <% } else if (request.getAttribute("error") != null) {%>
        <% }%>

        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>