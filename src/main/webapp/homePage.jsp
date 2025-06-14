<%-- 
    Document   : homePage.jsp
    Created on : Jun 6, 2025, 3:54:13 PM
    Author     : Khaang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>
    <body>
        <%@include file="header.jsp" %>

        <main class="main">
            <div class="hero">
                <div class="hero__content">
                    <h2 class="hero__title">
                        <span class="hero__title-line">Sculpt <span class="hero__title-highlight">Your</span>
                            Body,</span>
                        <span class="hero__title-line">Elevate <span class="hero__title-highlight">Your</span>
                            Spirit</span>
                    </h2>

                    <div class="hero__image-container">
                        <div class="hero__side-text hero__side-text--left">PREV</div>
                        <div class="hero__image-wrapper">
                            <img src="./img/people_gym.png" alt="Fitness Model" class="hero__image">

                            <div class="stat-card stat-card--hours">
                                <div class="stat-card__icon">
                                    <img src="clock-icon.png" alt="Clock" class="stat-card__icon-img">
                                </div>
                                <div class="stat-card__label">Hours</div>
                                <div class="stat-card__value">1.5</div>
                            </div>

                            <div class="stat-card stat-card--poses">
                                <div class="stat-card__icon">
                                    <img src="pose-icon.png" alt="Poses" class="stat-card__icon-img">
                                </div>
                                <div class="stat-card__label">Poses</div>
                                <div class="stat-card__value">20</div>
                            </div>

                            <div class="stat-card stat-card--kcal">
                                <div class="stat-card__icon">
                                    <img src="fire-icon.png" alt="Calories" class="stat-card__icon-img">
                                </div>
                                <div class="stat-card__label">Kcal</div>
                                <div class="stat-card__value">550</div>
                            </div>

                            <div class="stat-card stat-card--sets">
                                <div class="stat-card__icon">
                                    <img src="dumbbells-icon.png" alt="Sets" class="stat-card__icon-img">
                                </div>
                                <div class="stat-card__label">Sets</div>
                                <div class="stat-card__value">5</div>
                            </div>
                        </div>
                        <div class="hero__side-text hero__side-text--right">NEXT</div>
                    </div>

                    <div class="bottom-section">
                        <div class="action">
                            <button class="button button--action">Let's
                                Start › › ›</button>
                        </div>
                    </div>
                    <section class="brand-logos">
                        <div class="brand-logos__container">
                            <div class="brand-logos__list">
                                <div class="brand-logos__item">
                                    <img src="./logo/logoadidas.png" alt="adidas" class="brand-logos__image">
                                </div>
                                <div class="brand-logos__item">
                                    <img src="./logo/logonike.png" alt="nike" class="brand-logos__image">
                                </div>
                                <div class="brand-logos__item">
                                    <img src="./logo/logopuma.png" alt="puma" class="brand-logos__image">
                                </div>
                                <div class="brand-logos__item">
                                    <img src="./logo/logothenorthface.png" alt="thenorthface" class="brand-logos__image">
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
            </div>
        </main>

        <%@include file="Home/MembershipCard/membershipCard.jsp" %>
        <%@include file="Home/Trainers/Trainers.jsp" %>
        <%@include file="Home/News/News.jsp" %>
        <%@include file="Home/Carousel/Carousel.jsp" %>
        <%@include file="Home/Footer/Footer.jsp" %>
    </body>
</html>
