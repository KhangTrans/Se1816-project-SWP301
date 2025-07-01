<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Package" %>
<%
    Model.Package pkg = (Model.Package) request.getAttribute("pkg");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết gói tập</title>
        <style>
            body {
                background: #191919;
                min-height: 100vh;
                margin: 0;
                font-family: "Segoe UI", Arial, sans-serif;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .membership-card {
                background: linear-gradient(180deg, #4B8137, #153000);
                color: #ffffff;
                padding: 32px 30px 28px 30px;
                border-radius: 16px;
                width: 350px;
                min-height: 420px;
                box-shadow: 0 2px 18px rgba(0,0,0,0.23);
                display: flex;
                flex-direction: column;
                gap: 18px;
                align-items: flex-start;
            }
            .membership-card__title {
                font-size: 1.25rem;
                font-weight: 700;
                letter-spacing: 1px;
                margin: 0 0 12px 0;
            }
            .membership-card__price {
                font-size: 2.8rem;
                font-weight: bold;
                line-height: 1;
                margin-bottom: 8px;
                margin-top: 0;
                letter-spacing: 2px;
            }
            .membership-card__unit {
                font-size: 1.2rem;
                font-weight: 400;
                margin-left: 4px;
                opacity: 0.88;
            }
            .membership-card__description {
                font-size: 1.05rem;
                opacity: 0.95;
                margin-bottom: 8px;
                border-bottom: 1px solid rgba(255,255,255,0.18);
                padding-bottom: 10px;
                width: 100%;
            }
            .membership-card__details-title {
                margin-top: 8px;
                margin-bottom: 4px;
                font-size: 1.08rem;
                font-weight: 500;
            }
            .membership-card__details {
                font-size: 1rem;
                white-space: pre-line;
                opacity: 0.97;
                margin: 0;
            }
            .back-link {
                margin-top: 18px;
                color: #9ef6a7;
                text-decoration: none;
                font-weight: 500;
                font-size: 1rem;
                transition: color 0.2s;
            }
            .back-link:hover {
                color: #ffffff;
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <div class="membership-card">
    <div class="membership-card__title"><%= pkg.getName()%></div>
    <div class="membership-card__price">
        <%= pkg.getPrice()%><span class="membership-card__unit">₫ / Month</span>
    </div>
    <div class="membership-card__description">
    <%= pkg.getDescription().replaceAll("\\. ", ".<br>") %>
</div>

    <div class="membership-card__info-row">
    <span class="label">Thời hạn:</span>
    <span class="value"><%= pkg.getDurationDays() %> ngày</span>
    <span class="label" style="margin-left: 32px;">Trạng thái:</span>
    <span class="value"><%= pkg.isIsActive() ? "Đang áp dụng" : "Ngừng áp dụng" %></span>
</div>

    <a class="back-link" href="<%= request.getContextPath()%>/homepage">&lt; Back to homepage</a>
</div>

    </body>
</html>
