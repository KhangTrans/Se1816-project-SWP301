<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trainer Login</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            background: #f0f2f5;
            font-family: Arial, sans-serif;
        }

        .card {
            width: 190px;
            height: 254px;
            background: #F4F6FB;
            border: 1px solid white;
            box-shadow: 10px 10px 64px 0px rgba(180, 180, 207, 0.75);
            -webkit-box-shadow: 10px 10px 64px 0px rgba(186, 186, 202, 0.75);
            -moz-box-shadow: 10px 10px 64px 0px rgba(208, 208, 231, 0.75);
        }

        .form {
            padding: 25px;
        }

        .card_header {
            display: flex;
            align-items: center;
        }

        .card svg {
            color: #7878bd;
            margin-bottom: 20px;
            margin-right: 5px;
        }

        .form_heading {
            padding-bottom: 20px;
            font-size: 21px;
            color: #7878bd;
            margin: 0;
        }

        .field {
            padding-bottom: 10px;
        }

        .input {
            border-radius: 5px;
            background-color: #e9e9f7;
            padding: 5px;
            width: 100%;
            color: #7a7ab3;
            border: 1px solid #dadaf7;
            box-sizing: border-box;
        }

        .input:focus-visible {
            outline: 1px solid #aeaed6;
        }

        .input::placeholder {
            color: #bcbcdf;
        }

        label {
            color: #B2BAC8;
            font-size: 14px;
            display: block;
            padding-bottom: 4px;
        }

        button {
            background-color: #7878bd;
            margin-top: 10px;
            font-size: 14px;
            padding: 7px 12px;
            height: auto;
            font-weight: 500;
            color: white;
            border: none;
            cursor: pointer;
            width: 100%;
            border-radius: 5px;
        }

        button:hover {
            background-color: #5f5f9c;
        }

        #loginMessage {
            color: red;
            text-align: center;
            margin-top: 10px;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <form id="trainerLoginForm" class="form card" method="post" action="${pageContext.request.contextPath}/loginTrainer">
        <div class="card_header">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24">
                <path fill="none" d="M0 0h24v24H0z"></path>
                <path fill="currentColor" d="M4 15h2v5h12V4H6v5H4V3a1 1 0 0 1 1-1h14a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1v-6zm6-4V8l5 4-5 4v-3H2v-2h8z"></path>
            </svg>
            <h1 class="form_heading">Trainer Login</h1>
        </div>
        <div class="field">
            <label for="username">Username</label>
            <input class="input" name="username" type="text" placeholder="Username" id="username" required>
        </div>
        <div class="field">
            <label for="password">Password</label>
            <input class="input" name="password" type="password" placeholder="Password" id="password" required>
        </div>
        <div class="field">
            <button type="submit">Login</button>
        </div>
        <div id="loginMessage"></div>
    </form>

    <script>
        document.getElementById("trainerLoginForm").addEventListener("submit", function(e) {
            e.preventDefault();
            const form = e.target;
            const data = new URLSearchParams(new FormData(form));

            fetch(form.action, {
                method: "POST",
                body: data
            })
            .then(response => response.json())
            .then(data => {
                const messageDiv = document.getElementById("loginMessage");
                messageDiv.textContent = data.message;
                messageDiv.style.color = data.status === "success" ? "green" : "red";
                messageDiv.style.display = "block";

                if (data.status === "success") {
                    setTimeout(() => {
                        window.location.href = "${pageContext.request.contextPath}/trainer/dashboard";
                    }, 1000);
                }
            })
            .catch(error => {
                const messageDiv = document.getElementById("loginMessage");
                messageDiv.textContent = "An error occurred. Please try again.";
                messageDiv.style.color = "red";
                messageDiv.style.display = "block";
            });
        });
    </script>
</body>
</html>