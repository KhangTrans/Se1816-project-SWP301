<%-- 
    Document   : loginAdmin
    Created on : May 23, 2025, 2:50:52 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login Admin</title>
        <style>

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: "Montserrat", sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                position: relative;
                overflow: hidden;
            }

            /* Liquid Background Effect */
            body::before {
                content: '';
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background:
                    radial-gradient(circle at var(--mouse-x, 50%) var(--mouse-y, 50%),
                    rgba(255, 255, 255, 0.2) 0%,
                    rgba(255, 255, 255, 0.1) 25%,
                    transparent 50%),
                    radial-gradient(circle at calc(var(--mouse-x, 50%) + 20%) calc(var(--mouse-y, 50%) - 15%),
                    rgba(102, 126, 234, 0.3) 0%,
                    rgba(102, 126, 234, 0.1) 35%,
                    transparent 60%),
                    radial-gradient(circle at calc(var(--mouse-x, 50%) - 15%) calc(var(--mouse-y, 50%) + 20%),
                    rgba(118, 75, 162, 0.25) 0%,
                    rgba(118, 75, 162, 0.08) 40%,
                    transparent 65%);
                transition: all 0.3s ease;
                pointer-events: none;
                z-index: 1;
            }

            /* Animated Liquid Blobs */
            body::after {
                content: '';
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background:
                    radial-gradient(ellipse at calc(var(--mouse-x, 50%) * 0.8) calc(var(--mouse-y, 50%) * 1.2),
                    rgba(255, 182, 193, 0.15) 0%,
                    transparent 50%),
                    radial-gradient(ellipse at calc(var(--mouse-x, 50%) * 1.3) calc(var(--mouse-y, 50%) * 0.7),
                    rgba(173, 216, 230, 0.12) 0%,
                    transparent 45%),
                    radial-gradient(ellipse at calc(var(--mouse-x, 50%) * 0.6) calc(var(--mouse-y, 50%) * 1.1),
                    rgba(221, 160, 221, 0.1) 0%,
                    transparent 55%);
                filter: blur(1px);
                animation: liquidFlow 8s ease-in-out infinite;
                pointer-events: none;
                z-index: 1;
            }

            @keyframes liquidFlow {
                0%, 100% {
                    transform: scale(1) rotate(0deg);
                    filter: blur(1px) hue-rotate(0deg);
                }
                25% {
                    transform: scale(1.1) rotate(90deg);
                    filter: blur(2px) hue-rotate(90deg);
                }
                50% {
                    transform: scale(0.9) rotate(180deg);
                    filter: blur(1.5px) hue-rotate(180deg);
                }
                75% {
                    transform: scale(1.05) rotate(270deg);
                    filter: blur(1px) hue-rotate(270deg);
                }
            }

            /* Background Shapes */
            .bg-shapes {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                pointer-events: none;
                z-index: 2;
                overflow: hidden;
            }

            /* Liquid Moving Shapes */
            .bg-shapes::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background:
                    radial-gradient(circle at calc(var(--mouse-x, 50%) + 10%) calc(var(--mouse-y, 50%) + 5%),
                    rgba(255, 255, 255, 0.08) 0%,
                    transparent 40%),
                    radial-gradient(circle at calc(var(--mouse-x, 50%) - 5%) calc(var(--mouse-y, 50%) - 10%),
                    rgba(255, 255, 255, 0.06) 0%,
                    transparent 35%);
                transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
                animation: liquidPulse 6s ease-in-out infinite alternate;
            }

            @keyframes liquidPulse {
                0% {
                    opacity: 0.3;
                    transform: scale(1);
                }
                100% {
                    opacity: 0.7;
                    transform: scale(1.2);
                }
            }

            /* Enhanced Liquid Circles */
            .bg-shapes::after {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background:
                    radial-gradient(ellipse 300px 200px at var(--mouse-x, 50%) var(--mouse-y, 50%),
                    rgba(102, 126, 234, 0.1) 0%,
                    rgba(102, 126, 234, 0.05) 30%,
                    transparent 60%),
                    radial-gradient(ellipse 200px 300px at calc(var(--mouse-x, 50%) + 15%) calc(var(--mouse-y, 50%) - 10%),
                    rgba(118, 75, 162, 0.08) 0%,
                    rgba(118, 75, 162, 0.03) 25%,
                    transparent 50%);
                transition: all 0.5s ease;
                animation: liquidWave 10s ease-in-out infinite;
            }

            @keyframes liquidWave {
                0%, 100% {
                    filter: blur(0px);
                    transform: rotate(0deg) scale(1);
                }
                25% {
                    filter: blur(1px);
                    transform: rotate(90deg) scale(1.1);
                }
                50% {
                    filter: blur(2px);
                    transform: rotate(180deg) scale(0.9);
                }
                75% {
                    filter: blur(1px);
                    transform: rotate(270deg) scale(1.05);
                }
            }

            .bg-shapes__circle {
                position: absolute;
                border: 3px dashed rgba(255, 255, 255, 0.15);
                border-radius: 50%;
                animation: rotate 20s linear infinite;
                filter: blur(0.5px);
            }

            .bg-shapes__circle--top-left {
                width: 200px;
                height: 200px;
                top: -100px;
                left: -100px;
                animation-direction: normal;
                background: radial-gradient(circle, rgba(255, 255, 255, 0.03) 0%, transparent 70%);
            }

            .bg-shapes__circle--top-right {
                width: 150px;
                height: 150px;
                top: 50px;
                right: -75px;
                animation-direction: reverse;
                animation-duration: 15s;
                background: radial-gradient(circle, rgba(102, 126, 234, 0.05) 0%, transparent 70%);
            }

            .bg-shapes__circle--bottom-left {
                width: 180px;
                height: 180px;
                bottom: 30px;
                left: -90px;
                animation-direction: normal;
                animation-duration: 25s;
                background: radial-gradient(circle, rgba(118, 75, 162, 0.04) 0%, transparent 70%);
            }

            .bg-shapes__circle--bottom-right {
                width: 120px;
                height: 120px;
                bottom: -60px;
                right: -60px;
                animation-direction: reverse;
                animation-duration: 18s;
                background: radial-gradient(circle, rgba(255, 182, 193, 0.06) 0%, transparent 70%);
            }

            @keyframes inputWave {
                0% {
                    box-shadow: 0 0 0 0 rgba(102, 126, 234, 0.4);
                }
                50% {
                    box-shadow: 0 0 0 10px rgba(102, 126, 234, 0.1);
                }
                100% {
                    box-shadow: 0 0 0 20px rgba(102, 126, 234, 0);
                }
            }

            @keyframes rotate {
                from {
                    transform: rotate(0deg);
                }
                to {
                    transform: rotate(360deg);
                }
            }

            /* Header */
            .header {
                position: relative;
                z-index: 20;
                padding: 20px;
                text-align: left;
            }

            .header__title {
                color: rgba(255, 255, 255, 0.9);
                font-size: 16px;
                font-weight: 400;
                margin-left: 20px;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            /* Main Content */
            .main {
                flex: 1;
                display: flex;
                justify-content: center;
                align-items: center;
                position: relative;
                z-index: 20;
                padding: 20px;
            }

            /* Login Block */
            .login {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 20px;
                padding: 60px 50px;
                width: 100%;
                max-width: 450px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                text-align: center;
                position: relative;
                overflow: hidden;
            }

            /* Liquid Hover Effect for Login Box */
            .login::before {
                content: '';
                position: absolute;
                top: -2px;
                left: -2px;
                right: -2px;
                bottom: -2px;
                background: linear-gradient(45deg, #667eea, #764ba2, #667eea);
                border-radius: 22px;
                z-index: -2;
                opacity: 0.3;
            }

            .login::after {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: radial-gradient(circle at var(--mouse-x-local, 50%) var(--mouse-y-local, 50%),
                    rgba(102, 126, 234, 0.15) 0%,
                    rgba(118, 75, 162, 0.1) 30%,
                    transparent 70%);
                border-radius: 20px;
                opacity: 0;
                transition: opacity 0.4s ease;
                z-index: -1;
                pointer-events: none;
            }

            .login:hover::after {
                opacity: 1;
            }

            /* Advanced Liquid Effects */
            .login__title {
                font-size: 48px;
                font-weight: 700;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                margin-bottom: 40px;
                letter-spacing: 2px;
                position: relative;
                overflow: hidden;
            }

            .login__title::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg,
                    transparent 0%,
                    rgba(255, 255, 255, 0.3) 50%,
                    transparent 100%);
                animation: titleShine 3s ease-in-out infinite;
            }

            @keyframes titleShine {
                0% {
                    left: -100%;
                }
                50% {
                    left: -100%;
                }
                100% {
                    left: 100%;
                }
            }

            /* Floating particles effect */
            .login::before {
                content: '';
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background:
                    radial-gradient(circle at 20% 20%, rgba(102, 126, 234, 0.1) 0%, transparent 50%),
                    radial-gradient(circle at 80% 80%, rgba(118, 75, 162, 0.1) 0%, transparent 50%),
                    radial-gradient(circle at 60% 30%, rgba(102, 126, 234, 0.05) 0%, transparent 50%);
                animation: float 20s ease-in-out infinite;
                z-index: -3;
                border-radius: 20px;
            }

            @keyframes float {
                0%, 100% {
                    transform: rotate(0deg) scale(1);
                }
                33% {
                    transform: rotate(120deg) scale(1.1);
                }
                66% {
                    transform: rotate(240deg) scale(0.9);
                }
            }

            .login__form {
                display: flex;
                flex-direction: column;
                gap: 25px;
            }

            /* Form Group */
            .form-group {
                text-align: left;
            }

            .form-group__label {
                display: block;
                font-size: 16px;
                font-weight: 600;
                color: #333;
                margin-bottom: 8px;
            }

            .form-group__input {
                width: 100%;
                padding: 15px 20px;
                border: 2px solid #e1e5e9;
                border-radius: 12px;
                font-size: 16px;
                background: #f8f9fa;
                transition: all 0.3s ease;
                outline: none;
                position: relative;
                overflow: hidden;
            }

            .form-group__input::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg,
                    transparent 0%,
                    rgba(102, 126, 234, 0.1) 50%,
                    transparent 100%);
                transition: left 0.6s ease;
                pointer-events: none;
            }

            .form-group__input:hover::before {
                left: 100%;
            }

            .form-group__input:focus {
                border-color: #667eea;
                background: #fff;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                transform: translateY(-2px);
            }

            .form-group__input:hover {
                border-color: #764ba2;
                transform: translateY(-1px);
                box-shadow: 0 5px 15px rgba(102, 126, 234, 0.2);
            }

            .form-group__input::placeholder {
                color: #adb5bd;
            }

            /* Submit Button */
            .login__submit {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                padding: 16px 32px;
                border-radius: 12px;
                font-size: 18px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.4s ease;
                margin-top: 15px;
                position: relative;
                overflow: hidden;
            }

            .login__submit::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                transition: left 0.5s;
            }

            .login__submit::after {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                width: 0;
                height: 0;
                background: radial-gradient(circle, rgba(255, 255, 255, 0.3) 0%, transparent 70%);
                transform: translate(-50%, -50%);
                transition: all 0.6s ease;
                border-radius: 50%;
            }

            .login__submit:hover::before {
                left: 100%;
            }

            .login__submit:hover::after {
                width: 300px;
                height: 300px;
            }

            .login__submit:hover {
                transform: translateY(-3px);
                box-shadow: 0 15px 35px rgba(102, 126, 234, 0.4);
                background: linear-gradient(135deg, #7c8ef7 0%, #8b5fbf 100%);
            }

            .login__submit:active {
                transform: translateY(-1px);
                box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
            }

            /* Error Message */
            .error-message {
                background: linear-gradient(135deg, #ff6b6b, #ee5a24);
                color: white;
                padding: 12px 20px;
                border-radius: 8px;
                margin-bottom: 20px;
                text-align: center;
                font-size: 14px;
                font-weight: 500;
                box-shadow: 0 4px 12px rgba(255, 107, 107, 0.3);
                animation: shake 0.5s ease-in-out;
            }

            @keyframes shake {
                0%, 100% {
                    transform: translateX(0);
                }
                25% {
                    transform: translateX(-5px);
                }
                75% {
                    transform: translateX(5px);
                }
            }

            /* Form Group Focus State */
            .form-group--focused .form-group__label {
                color: #667eea;
                transform: translateY(-2px);
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .header__title {
                    margin-left: 10px;
                    font-size: 14px;
                }

                .login {
                    padding: 40px 30px;
                    margin: 20px;
                }

                .login__title {
                    font-size: 36px;
                    margin-bottom: 30px;
                }

                .bg-shapes__circle--top-left {
                    width: 150px;
                    height: 150px;
                }

                .bg-shapes__circle--top-right {
                    width: 100px;
                    height: 100px;
                }

                .bg-shapes__circle--bottom-left {
                    width: 120px;
                    height: 120px;
                }

                .bg-shapes__circle--bottom-right {
                    width: 80px;
                    height: 80px;
                }
            }

            @media (max-width: 480px) {
                .login {
                    padding: 30px 20px;
                }

                .login__title {
                    font-size: 28px;
                }

                .form-group__input {
                    padding: 12px 16px;
                    font-size: 14px;
                }

                .login__submit {
                    padding: 14px 28px;
                    font-size: 16px;
                }
            }
        </style>
    </head>
    <body>
        <!-- Background Shapes -->
        <div class="bg-shapes">
            <div class="bg-shapes__circle bg-shapes__circle--top-left"></div>
            <div class="bg-shapes__circle bg-shapes__circle--top-right"></div>
            <div class="bg-shapes__circle bg-shapes__circle--bottom-left"></div>
            <div
                class="bg-shapes__circle bg-shapes__circle--bottom-right"></div>
        </div>

        <!-- Main Content -->
        <main class="main">
            <div class="login">
                <h2 class="login__title">LOGIN</h2>

                <form class="login__form" id="adminLoginForm" action="${pageContext.request.contextPath}/loginAdmin">
                    <div class="form-group">
                        <label class="form-group__label" for="username">Tên Đăng Nhập</label>
                        <input class="form-group__input"
                               type="text"
                               id="username"
                               name="username"
                               required placeholder="Nhập tên đăng nhập">
                    </div>

                    <div class="form-group">
                        <label class="form-group__label" for="password">Mật Khẩu</label>
                        <input class="form-group__input"
                               type="password"
                               id="password"
                               name="password"
                               required placeholder="Nhập mật khẩu">
                    </div>

                    <div id="loginMessage" class="error-message" style="display:none;"></div>

                    <button class="login__submit" type="submit">Đăng Nhập</button>
                </form>

            </div>
        </main>
    </body>
    <script>
        document.getElementById("adminLoginForm").addEventListener("submit", function (e) {
            e.preventDefault();
            const form = e.target;
            const data = new URLSearchParams(new FormData(form));

            fetch(form.action, {
                method: "POST",
                body: data
            })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error("Lỗi server: " + response.status);
                        }
                        return response.text();
                    })
                    .then(text => {
                        if (!text)
                            throw new Error("Không có phản hồi từ máy chủ.");
                        let json;
                        try {
                            json = JSON.parse(text);
                        } catch (e) {
                            throw new Error("Phản hồi không hợp lệ: " + text);
                        }

                        const messageDiv = document.getElementById("loginMessage");
                        messageDiv.textContent = json.message;
                        messageDiv.style.display = "block";
                        messageDiv.style.color = json.status === "success" ? "green" : "red";

                        if (json.status === "success") {
                            setTimeout(() => {
                                window.location.href = form.action.replace("/loginAdmin", "/admin/dashboard.jsp");
                            }, 1000);
                        }
                    })
                    .catch(error => {
                        const messageDiv = document.getElementById("loginMessage");
                        messageDiv.textContent = error.message;
                        messageDiv.style.display = "block";
                        messageDiv.style.color = "orange";
                    });
        });
    </script>

</html>