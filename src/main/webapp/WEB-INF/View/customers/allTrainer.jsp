<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="Model.Trainers" %>


<%@include file="/WEB-INF/include/head.jsp" %>
<%@include file="/WEB-INF/include/Login.jsp" %>
<%@include file="/WEB-INF/include/Register.jsp" %>
<%@include file="/WEB-INF/include/forgotPassword.jsp" %>
<%@include file="/WEB-INF/include/header.jsp" %>

<!-- Thêm CSS trực tiếp vào trang JSP -->
<style>
    .gallery {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
        justify-content: center;
        background-color: #111111;
        padding: 20px;
    }

    .gallery__item {
        width: 300px;
        text-align: center;
        background: #000;
        padding: 10px;
        border: 1px solid #00CC00;
        border-radius: 10px;
        position: relative;
        cursor: pointer;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .gallery__item:hover {
        transform: scale(1.05);
        box-shadow: 0 4px 15px rgba(0, 204, 0, 0.3);
    }

    .gallery__item-img {
        width: 100%;
        height: 100%;
        border-radius: 5px;
        object-fit: cover; /* Ensure images fit nicely */
    }

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

    .trainer-info h4 {
        margin: 0;
        font-size: 20px; /* Slightly larger for prominence */
        font-weight: 700; /* Bolder for emphasis */
        color: #fff;
        text-transform: uppercase; /* Uppercase for a modern look */
        letter-spacing: 1px; /* Subtle spacing for readability */
        text-shadow: 0 0 5px rgba(0, 204, 0, 0.5); /* Green glow effect */
        transition: color 0.3s ease;
    }

    .trainer-info h4:hover {
        color: #00CC00; /* Green on hover for interactivity */
    }

    .view-details-btn {
        display: inline-block;
        background: linear-gradient(135deg, #00CC00, #4CAF50); /* Gradient for depth */
        color: #fff;
        padding: 10px 20px; /* Slightly larger padding */
        border-radius: 25px; /* Rounded for modern look */
        text-decoration: none;
        font-size: 14px;
        font-weight: 600; /* Medium-bold for emphasis */
        margin-top: 12px;
        text-align: center;
        text-transform: uppercase; /* Consistent with trainer name */
        letter-spacing: 0.5px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2); /* Subtle shadow */
        transition: background 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
        margin-bottom: 10px;
    }

    .view-details-btn:hover {
        background: linear-gradient(135deg, #4CAF50, #00CC00); /* Reverse gradient on hover */
        transform: translateY(-2px); /* Slight lift effect */
        box-shadow: 0 4px 10px rgba(0, 204, 0, 0.4); /* Enhanced shadow */
    }

    .gallery__view-all-container {
        display: flex;
        justify-content: center;
        align-items: center;
        width: 100%;
        margin-top: 20px;
    }

    .gallery__view-all {
        display: flex;
        justify-content: center;
        align-items: center;
        text-decoration: none;
        color: #00cc00;
        font-size: 16px;
        font-weight: bold;
        margin-top: 20px;
        width: 100%;
        transition: color 0.3s ease;
    }

    .gallery__view-all:hover {
        color: #4CAF50; /* Matching hover color */
    }

    .gallery__view-all-text {
        text-align: center;
    }

    .gallery_slider__arrow {
        margin-left: 10px;
        vertical-align: middle;
    }
</style>

<!-- === Gallery === -->
<div class="content">
    <p class="content__text--bottom">ALL TRAINERS</p>
</div>

<!-- === Gallery: Hiển thị tất cả huấn luyện viên === -->
<div class="gallery" id="all-trainers-gallery">
    <%
        List<Trainers> trainersList = (List<Trainers>) request.getAttribute("trainersList");

        if (trainersList != null && !trainersList.isEmpty()) {
            for (Trainers trainer : trainersList) {
    %>
    <div class="gallery__item">
        <img src="<%= request.getContextPath() + "/AvatarServlet?user=" + trainer.getAccountId().getUsername()%>" 
             alt="Trainer <%= trainer.getTrainerId()%>" class="gallery__item-img" />
        <div class="trainer-info">
            <h4><%= trainer.getFullName()%></h4>
            <a href="<%= request.getContextPath() + "/TrainerDetail?trainerId=" + trainer.getTrainerId()%>" class="view-details-btn">
                Xem chi tiết
            </a>
        </div>
    </div>
    <%
        }
    } else {
    %>
    <p>Không có huấn luyện viên nào</p>
    <%
        }
    %>
</div>


<%@include file="/WEB-INF/include/footer.jsp" %>