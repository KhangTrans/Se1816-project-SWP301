<%-- 
    Document   : shopDetails
    Created on : May 27, 2025, 10:33:34 PM
    Author     : Khaang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
         <title>Gym Shop</title>
    <link rel="stylesheet" href="./css/shopDetail.css">
    </head>
    <body>
        <div class="product-card">
            <!-- Header -->
            <div class="product-card__header">
                <h1 class="product-card__title">MacBook Air M4 15 inch 2025 10CPU 10GPU 16GB 256GB | Chính hãng Apple Việt Nam</h1>
                <div class="product-card__rating">
                    <div class="rating">
                        <span class="rating__stars">★★★★★</span>
                        <span class="rating__text">1 đánh giá</span>
                    </div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="product-card__content">
                <!-- Left Side - Product Image -->
                <div class="product-card__image-section">
                    <button class="product-card__wishlist">❤</button>
                    <div class="product-image">
                        <img class="product-image__main" src="macbook-air-m4.jpg" alt="MacBook Air M4" />
                        <div class="product-image__apps">
                            <div class="app-icon app-icon--adobe">A</div>
                            <div class="app-icon app-icon--powerpoint">P</div>
                            <div class="app-icon app-icon--pages">📄</div>
                            <div class="app-icon app-icon--final-cut">🎬</div>
                        </div>
                    </div>
                    <div class="product-specs">
                        <div class="product-specs__chip">Apple M4</div>
                        <div class="product-specs__gpu">10 nhân GPU</div>
                        <div class="product-specs__storage">16GB 256GB</div>
                        <div class="product-specs__display">15.3" 3K</div>
                    </div>
                </div>

                <!-- Right Side - Combined Info & Actions -->
                <div class="product-card__right-section">
                    <!-- Action Buttons -->
                    <div class="product-card__actions">
                        <button class="btn btn--primary">
                            <span class="btn__text">MUA NGAY</span>
                            <span class="btn__subtext">(Giao nhanh từ 2 giờ hoặc nhận tại cửa hàng)</span>
                        </button>
                        <button class="btn btn--cart">
                            <span class="btn__icon">🛒</span>
                            <span class="btn__count">0</span>
                            <span class="btn__label">Thêm vào giỏ</span>
                        </button>
                    </div>

                    <!-- Product Info with Scroll -->
                    <div class="product-info">
                        <h2 class="product-info__title">TÍNH NĂNG NỔI BẬT</h2>

                        <div class="product-info__container">
                            <div class="product-info__features" id="features-list">
                                <div class="feature">
                                    <div class="feature__text">MacBook Air 15 inch M4 mang thiết kế thanh lịch, độ mỏng ấn tượng 1.15 cm và trọng lượng chỉ 1.51 kg, phù hợp cho việc di chuyển.</div>
                                </div>

                                <div class="feature">
                                    <div class="feature__text">Trang bị chip Apple M4 mạnh mẽ với 10 CPU và 10 GPU, cho khả năng xử lý đa tác vụ và đồ họa vượt trội so với thế hệ trước.</div>
                                </div>

                                <div class="feature">
                                    <div class="feature__text">Bộ nhớ RAM 16GB cùng ổ cứng SSD 256GB đem lại trải nghiệm đa nhiệm mượt mà, tốc độ khởi động và truy xuất dữ liệu nhanh chóng.</div>
                                </div>

                                <div class="feature">
                                    <div class="feature__text">Màn hình Liquid Retina 15.3 inch với độ phân giải 2880x1864 pixels, độ sáng 500 nits và dải màu P3 rộng, mang lại hình ảnh sắc nét và màu sắc chân thực.</div>
                                </div>

                                <div class="feature">
                                    <div class="feature__text">Pin lên đến 18 giờ sử dụng liên tục, hỗ trợ sạc nhanh MagSafe 3 và các cổng Thunderbolt 4 hiện đại.</div>
                                </div>

                                <div class="feature">
                                    <div class="feature__text">Tương thích hoàn hảo với hệ sinh thái Apple, đồng bộ seamless với iPhone, iPad và các thiết bị Apple khác.</div>
                                </div>

                                <div class="feature">
                                    <div class="feature__text">Bàn phím Magic Keyboard với Touch ID, trackpad Force Touch rộng rãi và hệ thống âm thanh stereo chất lượng cao.</div>
                                </div>

                                <div class="feature">
                                    <div class="feature__text">Hỗ trợ tối đa 2 màn hình ngoài 6K và camera FaceTime HD 1080p với tính năng Center Stage thông minh.</div>
                                </div>
                            </div>

                            <div class="product-info__toggle">
                                <button class="btn-toggle" id="toggle-features">
                                    <span class="btn-toggle__text">Xem thêm</span>
                                    <span class="btn-toggle__icon">▼</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="./js/shopDetail.js"></script>
    </body>
</html>
