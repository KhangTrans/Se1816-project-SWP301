<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="Model.Trainers" %>

<!-- Thêm CSS trực tiếp vào trang JSP -->
<style>
    /* Cấu hình cho phần gallery */
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
        position: relative; /* Thêm để định vị tuyệt đối cho nội dung */
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
        bottom: 10px; /* Đặt dưới cùng, cách lề 10px */
        left: 50%; /* Căn giữa theo chiều ngang */
        transform: translateX(-50%); /* Điều chỉnh để chính giữa */
        width: 80%; /* Giới hạn chiều rộng */
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

    /* Tiêu đề "ALL TRAINERS" */
    .content__text--bottom {
        text-align: center;
        font-size: 20px;
        font-weight: bold;
        color: #fff;
        margin-bottom: 20px;
    }

    /* Nút "XEM TẤT CẢ" */
    .gallery__view-all {
        display: flex;
        align-items: center;
        justify-content: center;
        text-decoration: none;
        color: #00cc00;
        font-size: 16px;
        font-weight: bold;
        margin-top: 20px;
    }

    .gallery__view-all-text {
        margin-right: 10px;
    }

    .gallery-slider__arrow img {
        width: 28px;
        height: 16px;
    }
</style>
<!-- === Gallery === -->
<div class="content">
    <p class="content__text--bottom">ALL TRAINERS</p> <!-- Đổi từ "TOP 3 TRAINERS" thành "ALL TRAINERS" -->
</div>

<!-- === Gallery: Hiển thị tất cả huấn luyện viên === -->
<div class="gallery" id="top-trainers-gallery">
    <%
        // Lấy danh sách huấn luyện viên từ request
        List<Trainers> trainersList = (List<Trainers>) request.getAttribute("trainersList");

        // Kiểm tra nếu trainersList không rỗng
        if (trainersList != null && !trainersList.isEmpty()) {
            for (Trainers trainer : trainersList) {
    %>
    <div class="gallery__item">
        <!-- Gọi AvatarServlet để lấy hình ảnh -->
        <img src="<%= request.getContextPath() + "/AvatarServlet?user=" + trainer.getAccountId().getUsername() %>" 
             alt="Trainer <%= trainer.getTrainerId() %>" class="gallery__item-img" />
        <div class="trainer-info">
            <h4><%= trainer.getFullName() %></h4>
            <p>Rating: <%= trainer.getRating() %></p>
        </div>
    </div>
    <%
            }
        } else {
    %>
    <p>không có huấn luyện viên nào</p> <!-- Thông báo nếu không có dữ liệu huấn luyện viên -->
    <%
        }
    %>
</div>

<!-- === View All Button === -->
<a href="#!" id="view-all-btn" class="gallery__view-all">
    <span class="gallery__view-all-text">XEM TẤT CẢ</span>
    <span class="gallery-slider__arrow">
        <img src="./logo/🦆 icon _nav arrow down_.svg" alt="arrow" width="28" height="16" />
    </span>
</a>
