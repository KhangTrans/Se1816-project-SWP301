<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>AI Chat </title>
        <style>
            .chat-bubble {
                position: fixed;
                bottom: 20px;
                right: 20px;
                color: white;
                width: 60px;
                height: 60px;
                border-radius: 50%;
                font-size: 30px;
                text-align: center;
                line-height: 60px;
                cursor: pointer;
                z-index: 99;
            }

            .chat-popup {
                display: none;
                position: fixed;
                bottom: 90px;
                right: 20px;
                border: 1px solid #ccc;
                border-radius: 10px;
                background-color: white;
                width: 350px;
                z-index: 100;
                box-shadow: 0px 0px 10px rgba(0,0,0,0.3);
                display: flex;
                flex-direction: column;
                height: 450px;
            }

            .chat-popup-header {
                background-color: #007bff;
                color: white;
                padding: 10px;
                border-top-left-radius: 10px;
                border-top-right-radius: 10px;
            }

            .close-btn {
                float: right;
                cursor: pointer;
                font-weight: bold;
            }

            .chat-messages {
                flex: 1;
                overflow-y: auto;
                padding: 10px;
                display: flex;
                flex-direction: column;
                gap: 6px;
            }

            .msg {
                padding: 8px 12px;
                max-width: 80%;
                border-radius: 16px;
                font-size: 14px;
                white-space: pre-line;
                line-height: 1.4;
            }

            .msg.user {
                background-color: #d2f8c6;
                align-self: flex-end;
            }

            .msg.bot {
                background-color: #f1f0f0;
                align-self: flex-start;
            }

            .chat-input {
                display: flex;
                padding: 10px;
                gap: 5px;
                border-top: 1px solid #ddd;
            }

            .chat-input input {
                flex: 1;
                padding: 6px;
            }

            .chat-input button {
                padding: 6px 10px;
            }
        </style>
    </head>
    <body>

        <div class="chat-bubble" onclick="toggleChat()">
            <img src="${pageContext.request.contextPath}/public/img/icon/chatbot.svg"
                 alt="Chatbot"
                 style="width: 80px; height: 80px; margin-top: 5px; margin-bottom: 10px">
        </div>

        <div class="chat-popup" id="chatWindow">
            <div class="chat-popup-header">
                AI Chat
                <span class="close-btn" onclick="toggleChat()">&times;</span>
            </div>
            <div class="chat-messages" id="chatMessages">
                <div class="msg bot">Xin chào! Tôi có thể giúp gì được cho bạn?</div>
            </div>
            <div class="chat-input">
                <input type="text" id="prompt" placeholder="Nhập câu hỏi..." />
                <button onclick="sendMessage()">Gửi</button>
            </div>
        </div>

        <script>
            function toggleChat() {
                const popup = document.getElementById("chatWindow");
                popup.style.display = popup.style.display === "block" ? "none" : "block";
                if (popup.style.display === "block") {
                    scrollToBottom();
                }
            }

            function sendMessage() {
                const input = document.getElementById("prompt");
                const message = input.value.trim();
                const chatBox = document.getElementById("chatMessages");

                if (message === "")
                    return;

                const userMsg = document.createElement("div");
                userMsg.className = "msg user";
                userMsg.innerText = message;
                chatBox.appendChild(userMsg);
                scrollToBottom();
                input.value = "";

                fetch("${pageContext.request.contextPath}/chat", {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: "prompt=" + encodeURIComponent(message)
                })
                        .then(res => res.json())
                        .then(data => {
                            const botMsg = document.createElement("div");
                            botMsg.className = "msg bot";
                            botMsg.innerText = data.reply;
                            chatBox.appendChild(botMsg);
                            scrollToBottom();
                        })
                        .catch(() => {
                            const err = document.createElement("div");
                            err.className = "msg bot";
                            err.innerText = "❌ Lỗi khi gửi yêu cầu.";
                            chatBox.appendChild(err);
                            scrollToBottom();
                        });
            }

            function scrollToBottom() {
                const chatBox = document.getElementById("chatMessages");
                chatBox.scrollTop = chatBox.scrollHeight;
            }
        </script>

    </body>
</html>
