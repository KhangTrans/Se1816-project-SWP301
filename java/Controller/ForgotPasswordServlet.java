package Controller;

import DAO.UserDao;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import org.json.JSONObject;

import java.io.IOException;
import java.util.Properties;
import java.util.Random;

public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JSONObject json = new JSONObject();

        String email = request.getParameter("email");

        try {
            UserDao dao = new UserDao();
            if (!dao.isEmailExists(email)) {
                json.put("status", "error");
                json.put("message", "Email does not exist.");
                response.getWriter().write(json.toString());
                return;
            }

            // Tạo mã OTP
            String otp = String.format("%06d", new Random().nextInt(999999));

            // Lưu vào session (key duy nhất cho mỗi email)
            HttpSession session = request.getSession();
            session.setAttribute("otp_" + email, otp);
            session.setMaxInactiveInterval(300); // Hết hạn sau 5 phút

            // Gửi email
            sendEmail(email, otp);

            json.put("status", "success");
            json.put("message", "OTP sent to email.");
        } catch (Exception e) {
            json.put("status", "error");
            json.put("message", "Error: " + e.getMessage());
        }

        response.getWriter().write(json.toString());
    }

    private void sendEmail(String to, String otp) throws MessagingException {
        final String from = "trank7866@gmail.com"; // Thay bằng email thật
        final String password = "tgda ujin vpla gwub"; // App password của Gmail

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session mailSession = Session.getInstance(props, new jakarta.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        Message message = new MimeMessage(mailSession);
        message.setFrom(new InternetAddress(from));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject("Your OTP Code");
        message.setText("Your OTP code is: " + otp);

        Transport.send(message);
    }

    @Override
    public String getServletInfo() {
        return "Handles OTP email sending for password reset";
    }
}
