<%@ page import="java.util.List" %>
<%@ page import="Model.CustomerMembership" %>
<%@ page import="Model.MembershipPackage" %>
<%@ page import="Model.Package" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<head>
    <style>
        .membership-info-box {
            margin: 40px auto 32px auto;
            max-width: 480px;
            padding: 24px 32px;
            border: 2px solid #388e3c;
            border-radius: 10px;
            background: #e8f5e9;
            box-shadow: 0 2px 8px rgba(56,142,60,0.09);
            text-align: center;
        }
        .membership-warning {
            color: #b71c1c;
            margin-top: 12px;
            font-weight: bold;
        }
        .membership-btn-cancel, .membership-btn-renew {
            padding: 8px 22px;
            margin: 0 8px;
            border-radius: 5px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            outline: none;
            border: none;
        }
        .membership-btn-cancel {
            background: #ffcdd2;
            color: #b71c1c;
            border: 1.5px solid #e57373;
            transition: background 0.2s;
        }
        .membership-btn-renew {
            background: #bbdefb;
            color: #1976d2;
            border: 1.5px solid #64b5f6;
            transition: background 0.2s;
        }
        .membership-btn-cancel[disabled],
        .membership-btn-renew[disabled] {
            opacity: 0.6;
            cursor: not-allowed;
        }
        .back-btn-mini {
            padding: 2%;
            width: 40px;
            height: 40px;
            background: #e8f5e9;
            color: #388e3c;
            border: 1.5px solid #388e3c;
            border-radius: 10px;
            font-size: 1.2rem;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 22px;
            margin-left: 0;
            box-shadow: 0 2px 8px rgba(56,142,60,0.09);
            cursor: pointer;
            transition: background 0.2s, box-shadow 0.2s;
        }
        .back-btn-mini:hover {
            background: #b2fab4;
            color: #1a4d14;
            box-shadow: 0 2px 12px rgba(56,142,60,0.11);
        }

    </style>
</head>
<body>
    <div class="content">
        <p class="content__text--bottom">MEMBERSHIP</p>
    </div>

    <%
        CustomerMembership activeMembership = (CustomerMembership) request.getAttribute("activeMembership");
        Long daysLeft = (Long) request.getAttribute("daysLeft");
        List<Package> packages = (List<Package>) request.getAttribute("membership_packages");
    %>

    <% if (activeMembership != null) {
            MembershipPackage pkg = activeMembership.getMembershipPackage();
    %>
    <div id="membershipInfoBox" class="membership-info-box">
        <h2>GÓI THÀNH VIÊN HIỆN TẠI CỦA BẠN</h2>
        <p><b>Tên gói:</b> <%= pkg.getName()%></p>
        <p><b>Ngày bắt đầu:</b> <%= activeMembership.getStartDate()%></p>
        <p><b>Ngày hết hạn:</b> <%= activeMembership.getEndDate()%></p>
        <p><b>Trạng thái:</b>
            <% if ("cancelled".equalsIgnoreCase(activeMembership.getPaymentStatus())) {%>
            Cancelled (active until <%= activeMembership.getEndDate()%>)
            <% } else { %>
            Active
            <% }%>
        </p>
        <p style="color: #388e3c; font-weight: bold;">
            <i class="fa fa-clock"></i>
            Còn <%= daysLeft%> ngày
        </p>
        <% if ("paid".equalsIgnoreCase(activeMembership.getPaymentStatus())) {%>
        <div style="margin-top:20px;">
            <button class="membership-btn-cancel"
                    type="button"
                    onclick="deleteMembership(<%= activeMembership.getMembershipId()%>)">Hủy gói</button>
            <% if (daysLeft != null && daysLeft <= 7) {%>
            <button class="membership-btn-renew"
                    type="button"
                    onclick="renewMembership(<%= activeMembership.getMembershipId()%>, <%= pkg.getDurationDays()%>)">Gia hạn</button>
            <% } %>
        </div>
        <% if (daysLeft != null && daysLeft <= 7) { %>
        <div class="membership-warning">
            ⚠ Gói của bạn sắp hết hạn!
        </div>
        <% } %>
        <% } else if ("cancelled".equalsIgnoreCase(activeMembership.getPaymentStatus())) {%>
        <div class="membership-warning" style="color:gray;">
            Gói sẽ kết thúc vào <%= activeMembership.getEndDate()%>.<br>
            <button id="show-packages-btn" class="membership-btn-renew" style="margin-top:14px;">Mua gói mới</button>
        </div>
        <% } %>

    </div>
    <!-- Danh sách gói mới (ẩn mặc định) -->

    <div id="packageListContainer" class="membership-cards-container container" style="display:none; flex-wrap:wrap; align-items: center;">
        <button class="back-btn-mini" onclick="showInfoBox()" title="Back">Back</button>
        <% for (Package pkg2 : packages) {%>
        <div class="membership-card">
            <div class="membership-card__duration"><%= pkg2.getName()%></div>
            <div class="membership-card__price"><%= pkg2.getPrice()%><sup>₫</sup>
                <span class="membership-card__price-unit">/ Month</span>
            </div>
            <div class="membership-card__description">
                <%= pkg2.getDescription().replaceAll("\\. ", ".<br>")%>
            </div>
            <a href="payment?cardId=<%= pkg2.getId()%>">Chọn gói này</a>
        </div>
        <% } %>
    </div>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var showBtn = document.getElementById('show-packages-btn');
            if (showBtn) {
                showBtn.onclick = function () {
                    document.getElementById('membershipInfoBox').style.display = 'none';
                    document.getElementById('packageListContainer').style.display = 'flex';
                }
            }
        });
        function showInfoBox() {
            document.getElementById('packageListContainer').style.display = 'none';
            document.getElementById('membershipInfoBox').style.display = 'block';
        }
    </script>
    <% } else { %>
    <!-- Không có membership nào, hiện thẳng danh sách gói -->
    <div class="membership-cards-container container">
        <% for (Package pkg : packages) {%>
        <div class="membership-card">
            <div class="membership-card__duration"><%= pkg.getName()%></div>
            <div class="membership-card__price"><%= pkg.getPrice()%><sup>₫</sup> <span class="membership-card__price-unit">/ Month</span></div>
            <div class="membership-card__description">
                <%= pkg.getDescription().replaceAll("\\. ", ".<br>")%>
            </div>
            <a href="package-details?id=<%= pkg.getId()%>">Xem chi tiết &gt;</a>
        </div>
        <% } %>
    </div>
    <% }%>
    <script src="js/membership.js"></script>
</body>