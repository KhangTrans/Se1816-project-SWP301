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
    <h2>YOUR MEMBERSHIP PACKAGE</h2>
    <p><b>Package name:</b> <%= pkg.getName()%></p>
    <p><b>Start date:</b> <%= activeMembership.getStartDate()%></p>
    <p><b>End date:</b> <%= activeMembership.getEndDate()%></p>
    <p><b>Status:</b>
        <% if ("cancelled".equalsIgnoreCase(activeMembership.getPaymentStatus())) { %>
        Cancelled (active until <%= activeMembership.getEndDate()%>)
        <% } else if ("pending".equalsIgnoreCase(activeMembership.getPaymentStatus())) { %>
        <span style="color:#e65100;font-weight:bold;">Pending (Waiting for confirmation)</span>
        <% } else { %>
        Active
        <% } %>
    </p>
    <p style="color: #388e3c; font-weight: bold;">
        <i class="fa fa-clock"></i>
        you have <%= daysLeft%> day(s) left
    </p>
    <% if ("paid".equalsIgnoreCase(activeMembership.getPaymentStatus())) { %>
    <div style="margin-top:20px;">
        <button class="membership-btn-cancel"
                type="button"
                onclick="showCancelConfirm(<%= activeMembership.getMembershipId()%>)">CANCEL</button>
        <% if (daysLeft != null && daysLeft <= 7) { %>
        <form action="payment" method="get" style="display:inline;">
            <input type="hidden" name="cardId" value="<%= pkg.getPackageId()%>">
            <input type="hidden" name="renew" value="1">
            <button class="membership-btn-renew" type="submit">RENEW</button>
        </form>
        <% } %>
    </div>
    <!-- Xác nhận hủy gói (ẩn mặc định) -->
    <div id="cancel-confirm-box" style="display:none; margin-top:12px;">
        <span>are you sure you want to cancel this membership ?</span>
        <button class="membership-btn-cancel" onclick="doCancelMembership(<%= activeMembership.getMembershipId()%>)">YES</button>
        <button class="membership-btn-renew" onclick="hideCancelConfirm()">NO</button>
    </div>
    <% if (daysLeft != null && daysLeft <= 7) { %>
    <div class="membership-warning">
        ⚠ Your membership package is about to expire!
    </div>
    <% } %>
    <% } else if ("pending".equalsIgnoreCase(activeMembership.getPaymentStatus())) { %>
    <!-- Block cho PENDING -->
    <div style="margin-top:20px;">
        <button class="membership-btn-cancel"
                type="button"
                onclick="showCancelConfirm(<%= activeMembership.getMembershipId()%>)">
            CANCEL REQUEST
        </button>
    </div>
    <div id="cancel-confirm-box" style="display:none; margin-top:12px;">
        <span>Are you sure you want to cancel this membership request?</span> <br>
        <button class="membership-btn-cancel" onclick="doCancelMembership(<%= activeMembership.getMembershipId()%>)">YES</button>
        <button class="membership-btn-renew" onclick="hideCancelConfirm()">NO</button>
    </div>
    <div class="membership-warning" style="color:#e65100;">
        ⚠ This membership is pending confirmation. You can cancel it at any time before approval.
    </div>
    <% } else if ("cancelled".equalsIgnoreCase(activeMembership.getPaymentStatus())) {
        CustomerMembership pendingMembership = (CustomerMembership) request.getAttribute("upcomingMembership");
        if (pendingMembership != null && pendingMembership.getStartDate().isAfter(java.time.LocalDate.now())) { %>
            <div class="membership-warning" style="color:#0d47a1;">
                You have new package coming on <%= pendingMembership.getStartDate() %>
            </div>
        <% } else { %>
            <div class="membership-warning" style="color:gray;">
                Membership package will end on <%= activeMembership.getEndDate()%>.<br><br>
                <a href="AllPackages" class="membership-btn-renew" style="margin-top:14px;">BUY NEW</a>
            </div>
        <% }
    } %>
</div>
<% } else { %>
<div class="membership-info-box" style="background: #fff7ec; color: #e65100; border: 1.5px solid #ff9800;">
    <b>You don't have any active membership.</b>
    <br>
    <a href="AllPackages" style="color: #388e3c; text-decoration: underline;">BUY ONE NOW</a>
</div>
<% } %>