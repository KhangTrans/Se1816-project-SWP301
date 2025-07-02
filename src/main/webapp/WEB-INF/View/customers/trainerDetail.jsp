<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="Model.Trainers" %>
<%@ include file="/WEB-INF/include/head.jsp" %>
<%@ include file="/WEB-INF/include/Login.jsp" %>
<%@ include file="/WEB-INF/include/Register.jsp" %>
<%@ include file="/WEB-INF/include/forgotPassword.jsp" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<!-- Thêm CSS trực tiếp vào trang JSP bằng thẻ style với type="text/css" -->
<style type="text/css">
    /* Cấu hình chung cho phần gallery */
    .gallery {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
        justify-content: center;
        background-color: #111111;
        padding: 20px;
    }

    /* Mỗi item trong gallery */
    .gallery__item {
        width: 300px;
        text-align: center;
        background: #000;
        padding: 10px;
        border: 1px solid #00CC00;
        border-radius: 10px;
        position: relative;
        cursor: pointer;
    }

    /* Hình ảnh huấn luyện viên */
    .gallery__item-img {
        width: 100%;
        height: 100%;
        border-radius: 5px;
    }

    /* Phần thông tin tên và rating */
    .trainer-info {
        position: absolute;
        bottom: 10px;
        left: 50%;
        transform: translateX(-50%);
        width: 80%;
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    /* Tên huấn luyện viên */
    .trainer-info h4 {
        margin: 0;
        font-size: 18px;
        font-weight: bold;
        color: #fff;
    }

    /* Rating */
    .trainer-info p {
        font-size: 14px;
        color: #fff;
        background-color: #00cc00;
        padding: 5px 10px;
        border-radius: 5px;
        margin-top: 5px;
        display: inline-block;
    }

    /* Nút Xem chi tiết */
    .view-details-btn {
        display: inline-block;
        background-color: #00cc00;
        color: white;
        padding: 8px 16px;
        border-radius: 5px;
        text-decoration: none;
        font-weight: bold;
        margin-top: 10px;
        text-align: center;
    }

    .view-details-btn:hover {
        background-color: #4CAF50;
    }

    .book-now {
        background-color: #4CAF50;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }
</style>

<!-- Lấy đối tượng huấn luyện viên từ request -->
<%
    Trainers trainer = (Trainers) request.getAttribute("trainer");
%>

<div style="background-color: #1a2b3c; color: white; padding: 20px; text-align: center;margin-top: 100px;">
    <!-- Hiển thị ảnh huấn luyện viên -->
    <div style="display: inline-block; background-color: #d3d3d3; width: 200px; height: 300px; margin-right: 20px; border-radius: 5px;">
        <img src="<%= request.getContextPath() + "/AvatarServlet?user=" + trainer.getAccountId().getUsername()%>" 
             alt="Trainer <%= trainer.getTrainerId()%>" class="gallery__item-img" />
    </div>

    <!-- Hiển thị thông tin chi tiết của huấn luyện viên -->
    <div style="display: inline-block; vertical-align: top; text-align: left;">
        <h1><%= trainer.getFullName()%></h1>
        <ul>
            <li><strong>Bio:</strong> <%= trainer.getBio()%></li>
            <li><strong>Phone:</strong> <%= trainer.getPhone()%></li>
            <li><strong>Experience:</strong> <%= trainer.getExperienceYears()%> years</li>
            <li><strong>Rating:</strong> <%= trainer.getRating()%></li>
            <li><strong>Price:</strong> <%= String.format("%,.0f", trainer.getPrice())%> ₫/slot</li> <!-- Thêm giá tiền ở đây -->
        </ul>
    </div>

    <!-- Nút Book Now -->
    <button class="book-now">
        BOOK NOW
    </button>
</div>

<%@ include file="/WEB-INF/include/footer.jsp" %>
