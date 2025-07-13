<%-- 
    Document   : payment
    Created on : Jun 23, 2025, 7:53:14 AM
    Author     : Le Nguyen Hoang Khang - CE191583
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Package" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    Package pkg = (Package) request.getAttribute("pkg");
    // Lấy username từ session
    String username = null;
    Integer accountId = null;
    if (session != null) {
        username = (String) session.getAttribute("username");
        accountId = (Integer) session.getAttribute("accountId");
    }
    String success = (String) request.getAttribute("success");
%>

<%
    // DEBUG: In toàn bộ session attribute ra console và ra trang web (cho dễ nhìn)
    java.util.Enumeration names = session.getAttributeNames();
    System.out.println("--- SESSION ATTRIBUTES ---");
    while (names.hasMoreElements()) {
        String name = (String) names.nextElement();
        Object value = session.getAttribute(name);
        System.out.println("SESSION " + name + ": " + value);
        out.println("<div style='color:darkred;font-size:14px'>SESSION " + name + ": " + value + "</div>");
    }
    Object act = request.getAttribute("activeMembership");
    out.println("<div style='color:blue'>activeMembership: " + act + "</div>");
    System.out.println("-------------------------");
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
                max-width: 850px;
                margin: 40px auto;
                background: #fff;
                border-radius: 18px;
                box-shadow: 0 6px 32px rgba(0,0,0,0.07);
            }
            .left, .right {
                padding: 36px 28px;
            }
            .left {
                flex: 1;
                border-right: 1px solid #eee;
                background: #f2f8fd;
            }
            .right {
                flex: 1;
            }
            .pay-btn {
                padding: 14px 0;
                width: 100%;
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
                margin-right: 12px;
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
                <h2>Xin chào, <%= username%>!</h2>
                <% if (pkg != null) {%>
                <p><strong>Tên gói:</strong> <%= pkg.getName()%></p>
                <p><strong>Mô tả:</strong> <%= pkg.getDescription()%></p>
                <p><strong>Thời hạn:</strong> <%= pkg.getDurationDays()%> ngày</p>
                <p><strong>Giá:</strong> <span style="color:#e63946"><%= pkg.getPrice()%> VNĐ</span></p>
                <% } else { %>
                <p>Không tìm thấy gói tập.</p>
                <% } %>
            </div>
            <!-- Phương thức thanh toán -->
            <div class="right">
                <h2>Phương thức thanh toán</h2>
                <% if (success == null && pkg != null) {%>
                <form action="payment" method="post">
                    <input type="hidden" name="cardId" value="<%= pkg.getId()%>">
                    <div class="method">
                        <input type="radio" name="paymentMethod" id="offline" value="offline" checked>
                        <label for="offline">Đóng tiền tại cơ sở (thanh toán trực tiếp)</label>
                    </div>
                    <div class="method">
                        <input type="radio" name="paymentMethod" id="online" value="online" disabled>
                        <label for="online" class="disabled">Thanh toán online (Chưa hỗ trợ)</label>
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
                        <label><b>Thời điểm áp dụng gói mới:</b></label>
                    </div>
                    <div class="method">
                        <input type="radio" name="applyOption" id="applyNow" value="applyNow" checked>
                        <label for="applyNow">Áp dụng ngay lập tức (gói hiện tại sẽ dừng và thay thế)</label>
                    </div>
                    <div class="method">
                        <input type="radio" name="applyOption" id="applyLater" value="applyLater">
                        <label for="applyLater">Áp dụng khi hết hạn gói cũ (gói mới bắt đầu sau ngày hết hạn)</label>
                    </div>
                    <% } %>

                    <button class="pay-btn" type="submit">Xác nhận thanh toán</button>
                </form>
                <% } %>
            </div>
        </div>
        <% } else { %>
        <div class="warning">
            Bạn chưa đăng nhập! <a href="login.jsp">Đăng nhập ngay</a>
        </div>
        <% }%>
    </body>
</html>
