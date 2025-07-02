<%-- 
    Document   : membershipInfoBox
    Created on : Jul 2, 2025, 6:52:31 AM
    Author     : Le Nguyen Hoang Khang - CE191583
--%>

<%@ page import="java.util.List" %>
<%@ page import="Model.CustomerMembership" %>
<%@ page import="Model.MembershipPackage" %>
<%@ page import="Model.Package" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

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
                onclick="showCancelConfirm(<%= activeMembership.getMembershipId()%>)">Hủy gói</button>
        <% if (daysLeft != null && daysLeft <= 7) {%>
        <button class="membership-btn-renew"
                type="button"
                onclick="renewMembership(<%= activeMembership.getMembershipId()%>, <%= pkg.getDurationDays()%>)">Gia hạn</button>
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
        Gói sẽ kết thúc vào <%= activeMembership.getEndDate()%>.<br>
        <button id="show-packages-btn" class="membership-btn-renew" style="margin-top:14px;">Mua gói mới</button>
    </div>
    <% }%>

</div>
<script src="js/membership.js"></script>
