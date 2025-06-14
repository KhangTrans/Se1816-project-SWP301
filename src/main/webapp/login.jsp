<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập</title>
        <link rel="stylesheet" href="./css/login_register.css">
    </head>
    <body>
        <div class="form">
            <h2 class="form__title">LOGIN</h2>
            <div class="form__group">
                <label class="form__label">Tên Đăng Nhập</label>
                <input type="text" class="form__input"
                       placeholder="Tên đăng nhập">
            </div>
            <div class="form__group">
                <label class="form__label">Mật Khẩu</label>
                <input type="password" class="form__input"
                       placeholder="Mật khẩu">
            </div>
            <button class="form__btn form__btn--primary">Đăng nhập</button>

            <div class="form__social">
                <button class="form__btn form__btn--google">Google</button>
                <button class="form__btn form__btn--facebook">Facebook</button>
            </div>

            <a href="register.jsp" class="form__link">Chưa có tài khoản? Đăng
                ký ngay!</a>
        </div>
    </body>
</html>

