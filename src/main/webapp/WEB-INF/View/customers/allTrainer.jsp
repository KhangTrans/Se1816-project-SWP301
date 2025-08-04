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
        background: #111;
        padding: 10px;
        border: 1px solid #d9ff68;
        border-radius: 10px;
        position: relative;
        cursor: pointer;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        overflow: hidden;
    }

    .gallery__item:hover {
        transform: scale(1.05);
        box-shadow: 0 4px 15px rgba(217, 255, 104, 0.3);
    }

    .gallery__item-img {
        width: 100%;
        height: 100%;
        border-radius: 5px;
        object-fit: cover; /* Ensure images fit nicely */
    }
    
    /* Thêm lớp gradient fade từ dưới lên trên */
    .img-overlay {
        position: absolute;
        bottom: 0;
        left: 0;
        width: 100%;
        height: 50%;
        background: linear-gradient(to top, rgba(0,0,0,0.9) 0%, rgba(0,0,0,0.7) 50%, rgba(0,0,0,0) 100%);
        border-radius: 5px;
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
        z-index: 2; /* Đảm bảo nội dung nằm trên lớp gradient */
    }

    .trainer-info h4 {
        margin: 0;
        font-size: 20px; /* Slightly larger for prominence */
        font-weight: 700; /* Bolder for emphasis */
        color: #fff;
        text-transform: uppercase; /* Uppercase for a modern look */
        letter-spacing: 1px; /* Subtle spacing for readability */
        text-shadow: 0 0 5px rgba(217, 255, 104, 0.5); /* Green glow effect */
        transition: color 0.3s ease;
    }

    .trainer-info h4:hover {
        color: #d9ff68; /* Green on hover for interactivity */
    }

    .view-details-btn {
        display: inline-block;
        background: linear-gradient(135deg, #c4ff00, #9ddb00); /* Gradient for depth */
        color: #111;
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
        transition: all 0.3s ease;
        margin-bottom: 10px;
    }

    .view-details-btn:hover {
        background: linear-gradient(135deg, #9ddb00, #c4ff00); /* Reverse gradient on hover */
        transform: translateY(-2px); /* Slight lift effect */
    }
    
    .content__text--bottom {
        color: #d9ff68;
        font-size: 60px !important;
        font-weight: bold;
        text-align: center;
        margin-top: 50px;
        margin-bottom: 20px;
        text-transform: uppercase;
        letter-spacing: 2px;
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
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
        <div class="img-overlay"></div>
        <div class="trainer-info">
            <h4><%= trainer.getFullName()%></h4>
            <a href="<%= request.getContextPath() + "/TrainerDetail?trainerId=" + trainer.getTrainerId()%>" class="view-details-btn">
                View details
            </a>
        </div>
    </div>
    <%
        }
    } else {
    %>
                    <p>No trainers available</p>
    <%
        }
    %>
</div>


<%@include file="/WEB-INF/include/footer.jsp" %>