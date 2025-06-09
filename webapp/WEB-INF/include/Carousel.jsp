<%-- 
    Document   : Carousel
    Created on : Jun 6, 2025, 10:56:14 PM
    Author     : Khaang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- ===Carousel=== -->
<div class="carousel-wrapper">
    <div class="carousel" id="carousel">
        <!-- Fade effects -->
        <div class="carousel__fade carousel__fade--left"></div>
        <div class="carousel__fade carousel__fade--right"></div>

        <!-- Main carousel container -->
        <div class="carousel__container" id="carouselContainer">
            <div class="carousel__track" id="carouselTrack">
                <!-- Example of image items - Replace with your JSP image tags -->
                <div class="carousel__item">
                    <img src="./img/wp12559579-4k-fitness-wallpapers.jpg" alt="Image 1" class="carousel__image">
                </div>
                <div class="carousel__item">
                    <img src="./img/wp12559945-4k-fitness-wallpapers.jpg" alt="Image 2" class="carousel__image">
                </div>
                <div class="carousel__item">
                    <img src="./img/wp4659358-gym-women-wallpapers.jpg" alt="Image 3" class="carousel__image">
                </div>
                <div class="carousel__item">
                    <img src="./img/wp8463825-male-workout-wallpapers.jpg" alt="Image 4" class="carousel__image">
                </div>
            </div>
        </div>
    </div>
</div>
<!-- ===EndCarousel=== -->

<script src="<%= request.getContextPath()%>/js/carousel.js"></script>
