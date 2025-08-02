<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Trainer Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Montserrat', sans-serif;
            background-color: #111;
            color: #fff;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background-image: url('${pageContext.request.contextPath}/img/wp8463825-male-workout-wallpapers.jpg');
            background-size: cover;
            background-position: center;
            position: relative;
        }
        
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7);
        }

        .form {
            position: relative;
            z-index: 1;
            background: rgba(30, 30, 30, 0.9);
            border-radius: 15px;
            width: 400px;
            padding: 40px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.5);
            border: 1px solid rgba(255, 255, 255, 0.1);
            overflow: hidden;
        }

        .form::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, #c4ff00, #9ddb00);
            z-index: 1;
        }

        .card_header {
            text-align: center;
            margin-bottom: 30px;
        }

        .card_header svg {
            color: #c4ff00;
            width: 60px;
            height: 60px;
            margin-bottom: 15px;
        }

        .form_heading {
            font-size: 28px;
            font-weight: bold;
            color: #fff;
            margin-bottom: 5px;
        }

        .form_subheading {
            color: #888;
            font-size: 14px;
        }

        .field {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #ddd;
        }

        .input {
            width: 100%;
            padding: 12px 15px;
            border-radius: 8px;
            border: 1px solid #444;
            background-color: rgba(255, 255, 255, 0.08);
            color: #fff;
            font-size: 14px;
            transition: all 0.3s;
        }

        .input:focus {
            outline: none;
            border-color: #c4ff00;
            box-shadow: 0 0 0 2px rgba(196, 255, 0, 0.3);
        }

        button {
            width: 100%;
            padding: 14px;
            border-radius: 8px;
            border: none;
            background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
            color: #111;
            font-weight: bold;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
        }

        button:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            background: linear-gradient(135deg, #d9ff68 0%, #c4ff00 100%);
        }

        #loginMessage {
            margin-top: 15px;
            text-align: center;
            font-size: 14px;
            padding: 10px;
            border-radius: 8px;
            transition: all 0.3s;
        }

        #loginMessage.error {
            color: #ff5252;
            background-color: rgba(255, 82, 82, 0.1);
        }

        #loginMessage.success {
            color: #4caf50;
            background-color: rgba(76, 175, 80, 0.1);
        }
        
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #888;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .back-link:hover {
            color: #c4ff00;
        }
        
        .back-link i {
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <form id="trainerLoginForm" class="form" method="post" action="${pageContext.request.contextPath}/loginTrainer">
        <div class="card_header">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                <path fill="currentColor" d="M12 14c2.206 0 4-1.794 4-4s-1.794-4-4-4-4 1.794-4 4 1.794 4 4 4zm0-6c1.103 0 2 .897 2 2s-.897 2-2 2-2-.897-2-2 .897-2 2-2z"/>
                <path fill="currentColor" d="M12 2C6.486 2 2 6.486 2 12s4.486 10 10 10 10-4.486 10-10S17.514 2 12 2zm0 18c-1.42 0-2.78-.32-4.01-.87 1.07-.72 1.95-1.79 2.01-3.13h4c.06 1.34.94 2.4 2.01 3.13C14.78 19.68 13.42 20 12 20zm7-5c0 1.1-.9 2-2 2s-2-.9-2-2h-6c0 1.1-.9 2-2 2s-2-.9-2-2c0-3.86 3.14-7 7-7s7 3.14 7 7z"/>
            </svg>
            <h1 class="form_heading">Trainer Login</h1>
            <p class="form_subheading">Enter your credentials to access your trainer dashboard</p>
        </div>
        <div class="field">
            <label for="username"><i class="fas fa-user"></i> Username</label>
            <input class="input" name="username" type="text" placeholder="Enter your username" id="username" required>
        </div>
        <div class="field">
            <label for="password"><i class="fas fa-lock"></i> Password</label>
            <input class="input" name="password" type="password" placeholder="Enter your password" id="password" required>
        </div>
        <div class="field">
            <button type="submit">Login <i class="fas fa-sign-in-alt"></i></button>
        </div>
        <div id="loginMessage"></div>
        <a href="${pageContext.request.contextPath}/homepage" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Homepage
        </a>
    </form>

    <script>
        document.getElementById("trainerLoginForm").addEventListener("submit", function(e) {
            e.preventDefault();
            const form = e.target;
            const data = new URLSearchParams(new FormData(form));
            const messageDiv = document.getElementById("loginMessage");
            
            // Show loading message
            messageDiv.textContent = "Logging in...";
            messageDiv.className = "";
            
            fetch(form.action, {
                method: "POST",
                body: data
            })
            .then(response => response.json())
            .then(data => {
                messageDiv.textContent = data.message;
                if (data.status === "success") {
                    messageDiv.className = "success";
                    setTimeout(() => {
                        window.location.href = "${pageContext.request.contextPath}/trainer/dashboard";
                    }, 1000);
                } else {
                    messageDiv.className = "error";
                }
            })
            .catch(error => {
                messageDiv.textContent = "An error occurred. Please try again.";
                messageDiv.className = "error";
            });
        });
    </script>
</body>
</html>