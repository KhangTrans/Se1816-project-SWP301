<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng ký</title>
        <link rel="stylesheet" href="./css/login_register.css">
    </head>
    <body>
        <div class="form">
            <h2 class="form__title">REGISTER</h2>
            <div class="form__group">
                <label class="form__label">Email</label>
                <input type="email" class="form__input" placeholder="Email">
            </div>
            <div class="form__group">
                <label class="form__label">Username</label>
                <input type="text" class="form__input" placeholder="Username">
            </div>
            <div class="form__group">
                <label class="form__label">Phone</label>
                <input type="tel" class="form__input" placeholder="Phone">
            </div>
            <div class="form__group">
                <label class="form__label">Password</label>
                <input type="password" class="form__input"
                       placeholder="Password">
            </div>
            <div class="form__group">
                <label class="form__label">Confirm Password</label>
                <input type="password" class="form__input"
                       placeholder="Confirm Password">
            </div>
            <button class="form__btn form__btn--primary">Đăng ký</button>

            <a href="login.jsp" class="form__link">Đã có tài khoản? Đăng
                nhập!</a>
        </div>

    </body>
</html>
