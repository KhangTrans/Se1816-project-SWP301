
<%@ page import="Model.Package" %>
<%
    Model.Package pkg = (Model.Package) request.getAttribute("pkg");
%>

<%@ include file="/WEB-INF/include/head.jsp" %>
<%@include file="/WEB-INF/include/Login.jsp" %>
<%@include file="/WEB-INF/include/Register.jsp" %>
<%@include file="/WEB-INF/include/forgotPassword.jsp" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<div class="content" style="margin-top: 20px">
    <p class="content__text--bottom">Packages Detail</p>
</div>
<div class="membership-cards-container container d-flex justify-content-center">
    <div class="membership-card">   
        <div class="membership-card__title"><%= pkg.getName()%></div>
        <div class="membership-card__price">
            <%= pkg.getPrice()%><span class="membership-card__unit"> / Month</span>
        </div>
        <div class="membership-card__description">
            <%= pkg.getDescription().replaceAll("\\. ", ".<br>")%>
        </div>

        <div class="membership-card__info-row">
            <span class="label">Deadline:</span>
            <span class="value"><%= pkg.getDurationDays()%> Date</span>
            <span class="label" style="margin-left: 32px;">Status:</span>
            <span class="value"><%= pkg.isIsActive() ? "Applying" : "Stop applying"%></span>
        </div>

        <form action="payment" method="get">
            <input type="hidden" name="cardId" value="<%= pkg.getId()%>">
            <button type="submit">Book ngay</button>
        </form>
        <% if (request.getAttribute("membershipError") != null) {%>
        <div style="color:red"><%= request.getAttribute("membershipError")%></div>
        <% }%>
        <div id="membership-error-msg" style="color:red; margin-top:10px"></div>
        <script src="js/membership.js"></script>

        <a class="back-link" href="<%= request.getContextPath()%>/homepage">&lt; Back to homepage</a>
    </div>
</div>

<%@ include file="/WEB-INF/include/footer.jsp" %>
