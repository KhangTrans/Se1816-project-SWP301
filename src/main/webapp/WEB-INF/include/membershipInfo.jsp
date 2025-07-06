<%@ page import="Model.CustomerMembership" %>
<%@ page import="Model.MembershipPackage" %>
<%@ page import="Model.Package" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<style>
    .membership-info-box {
        margin: 40px auto 32px auto;
        max-width: 480px;
        padding: 24px 32px;
        border: 2px solid #388e3c;
        border-radius: 10px;
        background: #73de7c;
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
    .success-box {
        color: #1b5e20;
        background: #e6ffe6;
        padding: 10px;
        border-radius: 6px;
        margin-bottom: 12px;
        font-weight: 500;
    }
    .error-box {
        color: #b71c1c;
        background: #fff0f0;
        padding: 10px;
        border-radius: 6px;
        margin-bottom: 12px;
        font-weight: 500;
    }
</style>

<%
    CustomerMembership activeMembership = (CustomerMembership) request.getAttribute("activeMembership");
    Long daysLeft = (Long) request.getAttribute("daysLeft");
%>

<% if (activeMembership != null) {
        MembershipPackage pkg = activeMembership.getMembershipPackage();
%>

<div id="membershipInfoBox" class="membership-info-box" data-packageid="<%= pkg.getPackageId()%>">
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
                onclick="showCancelConfirm(<%= activeMembership.getMembershipId()%>)">Hủy gói</button>
        <% if (daysLeft != null && daysLeft <= 7) {%>
        <button class="membership-btn-renew"
                type="button"
                onclick="renewMembership(<%= activeMembership.getMembershipId()%>, <%= pkg.getDurationDays()%>)">
            Gia hạn
        </button>
        <% }%>
    </div>
    <!-- Xác nhận hủy gói (ẩn mặc định) -->
    <div id="cancel-confirm-box" style="display:none; margin-top:12px;">
        <span>Bạn có chắc muốn hủy gói thành viên này?</span>
        <button class="membership-btn-cancel" onclick="doCancelMembership(<%= activeMembership.getMembershipId()%>)">Xác nhận</button>
        <button class="membership-btn-renew" onclick="hideCancelConfirm()">Không</button>
    </div>
    <% if (daysLeft != null && daysLeft <= 7) { %>
    <div class="membership-warning">
        ⚠ Gói của bạn sắp hết hạn!
    </div>
    <% } %>
    <% } else if ("cancelled".equalsIgnoreCase(activeMembership.getPaymentStatus())) {%>
    <div class="membership-warning" style="color:gray;">
        Gói sẽ kết thúc vào <%= activeMembership.getEndDate()%>.   <br> 
        <button id="show-packages-btn" class="membership-btn-renew" style="margin-top:14px;">Mua gói mới</button>

    </div>

    <% } %>

</div>

<% }%>
