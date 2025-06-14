<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>GYM MANAGER</title>
        <link rel="stylesheet" href="./css/styles.css">
    </head>
    <body>
        <div class="fitness-page">

            <%@include file="header.jsp" %>

            <main class="main">
                <div class="hero">
                    <div class="hero__content">
                        <h2 class="hero__title">
                            <span class="hero__title-line">Sculpt <span
                                    class="hero__title-highlight">Your</span>
                                Body,</span>
                            <span class="hero__title-line">Elevate <span
                                    class="hero__title-highlight">Your</span>
                                Spirit</span>
                        </h2>

                        <div class="hero__image-container">
                            <div
                                class="hero__side-text hero__side-text--left">PREV</div>
                            <div class="hero__image-wrapper">
                                <img src="./img/people_gym.png"
                                     alt="Fitness Model" class="hero__image">

                                <div class="stat-card stat-card--hours">
                                    <div class="stat-card__icon">
                                        <img src="clock-icon.png" alt="Clock"
                                             class="stat-card__icon-img">
                                    </div>
                                    <div class="stat-card__label">Hours</div>
                                    <div class="stat-card__value">1.5</div>
                                </div>

                                <div class="stat-card stat-card--poses">
                                    <div class="stat-card__icon">
                                        <img src="pose-icon.png" alt="Poses"
                                             class="stat-card__icon-img">
                                    </div>
                                    <div class="stat-card__label">Poses</div>
                                    <div class="stat-card__value">20</div>
                                </div>

                                <div class="stat-card stat-card--kcal">
                                    <div class="stat-card__icon">
                                        <img src="fire-icon.png" alt="Calories"
                                             class="stat-card__icon-img">
                                    </div>
                                    <div class="stat-card__label">Kcal</div>
                                    <div class="stat-card__value">550</div>
                                </div>

                                <div class="stat-card stat-card--sets">
                                    <div class="stat-card__icon">
                                        <img src="dumbbells-icon.png" alt="Sets"
                                             class="stat-card__icon-img">
                                    </div>
                                    <div class="stat-card__label">Sets</div>
                                    <div class="stat-card__value">5</div>
                                </div>
                            </div>
                            <div
                                class="hero__side-text hero__side-text--right">NEXT</div>
                        </div>

                        <div class="bottom-section">

                            <div class="action">
                                <button class="button button--action">Let's
                                    Start › › ›</button>
                            </div>
                        </div>
                    </div>
                </div>
            </main>

            <section class="brand-logos">
                <div class="brand-logos__container">
                    <div class="brand-logos__list">
                        <div class="brand-logos__item">
                            <img src="./logo/logoadidas.png"
                                 alt="adidas" class="brand-logos__image">
                        </div>
                        <div class="brand-logos__item">
                            <img src="./logo/logonike.png" alt="nike"
                                 class="brand-logos__image">
                        </div>
                        <div class="brand-logos__item">
                            <img src="./logo/logopuma.png" alt="puma"
                                 class="brand-logos__image">
                        </div>
                        <div class="brand-logos__item">
                            <img src="./logo/logothenorthface.png"
                                 alt="thenorthface"
                                 class="brand-logos__image">
                        </div>
                    </div>
                </div>
            </section>

            <div class="content">
                <p class="content__text--bottom ">
                    SẢN PHẨM
                </p>
            </div>

        </div>

        <!-- ===Gallery=== -->
        <div class="gallery">
            <a href="#" class="gallery__item">
                <img src="image1.jpg" alt="Image 1" class="gallery__item-img" />
            </a>
            <a href="#" class="gallery__item">
                <img src="image2.jpg" alt="Image 2" class="gallery__item-img" />
            </a>
            <a href="#" class="gallery__item">
                <img src="image3.jpg" alt="Image 3" class="gallery__item-img" />
            </a>
            <a href="#" class="gallery__item">
                <img src="image4.jpg" alt="Image 4" class="gallery__item-img" />
            </a>
        </div>

        <!-- ===View All=== -->
        <a href="#!" class="gallery__view-all">
            <span class="gallery__view-all-text">XEM TẤT CẢ</span>
            <span class="gallery-slider__arrow">
                <img src="./logo/🦆 icon _nav arrow down_.svg" alt="arrow"
                     width="28"
                     height="16" />
            </span>
        </a>

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
                            <img src="./img/wp12559579-4k-fitness-wallpapers.jpg" alt="Image 1"
                                 class="carousel__image">
                        </div>
                        <div class="carousel__item">
                            <img src="./img/wp12559945-4k-fitness-wallpapers.jpg" alt="Image 2"
                                 class="carousel__image">
                        </div>
                        <div class="carousel__item">
                            <img src="./img/wp4659358-gym-women-wallpapers.jpg" alt="Image 3"
                                 class="carousel__image">
                        </div>
                        <div class="carousel__item">
                            <img src="./img/wp8463825-male-workout-wallpapers.jpg" alt="Image 4"
                                 class="carousel__image">
                        </div>
                        <!-- End of items -->
                    </div>
                </div>
            </div>
        </div>

        <!-- ===Foodter=== -->
        <div class="footer__container">
            <div class="footer__about">
                <h2 class="footer__title">GYM SHOP</h2>
                <p class="footer__desc">Chúng tôi cung cấp dịch dụ về GYM & SPORT
                    HÀNG ĐẦU VIỆT NAM.
                </p>
            </div>

            <div class="footer__links">
                <h3 class="footer__heading">Liên kết nhanh</h3>
                <ul class="footer__list">
                    <li><a href="#">Trang chủ</a></li>
                    <li><a href="#">Dịch vụ</a></li>
                    <li><a href="#">Về chúng tôi</a></li>
                    <li><a href="#">Liên hệ</a></li>
                </ul>
            </div>

            <div class="footer__contact">
                <h3 class="footer__heading">Liên hệ</h3>
                <p>Email: contact@mywebsite.com</p>
                <p>Điện thoại: 0123 456 789</p>
            </div>
        </div>

        <div class="footer__bottom">
            <p>&copy; 2025 MyWebsite. All rights reserved.</p>
        </div>
    </footer>
    <!-- ===End Foodter=== -->

    <script src="./js/carousel.js"></script>
    <script src="./js/script.js"></script>
</body>
</html>