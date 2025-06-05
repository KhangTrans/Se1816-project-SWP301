package Controller;

import DAO.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JSONObject json = new JSONObject();

        try {
            String email = request.getParameter("email");
            String username = request.getParameter("username");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");
            String confirm = request.getParameter("confirm_password");

            // Kiểm tra dữ liệu đầu vào
            if (email == null || username == null || phone == null || password == null || confirm == null
                    || email.isEmpty() || username.isEmpty() || phone.isEmpty() || password.isEmpty() || confirm.isEmpty()) {
                json.put("status", "error");
                json.put("message", "Missing required fields!");
                response.getWriter().write(json.toString());
                return;
            }

            if (!password.equals(confirm)) {
                json.put("status", "error");
                json.put("message", "Passwords do not match!");
                response.getWriter().write(json.toString());
                return;
            }

            // Lấy ảnh đại diện (nếu có)
            Part avatarPart = request.getPart("avatar");
            InputStream avatarStream = (avatarPart != null && avatarPart.getSize() > 0)
                    ? avatarPart.getInputStream()
                    : null;

            // Gọi DAO
            UserDao dao = new UserDao();
            if (dao.isUsernameExists(username)) {
                json.put("status", "error");
                json.put("message", "Username already exists!");
            } else if (dao.isEmailExists(email)) {
                json.put("status", "error");
                json.put("message", "Email already exists!");
            } else if (dao.isPhoneExists(phone)) {
                json.put("status", "error");
                json.put("message", "Phone number already exists!");
            } else {
                boolean success = dao.registerCustomerBinary(username, password, avatarStream, username, email, phone);
                if (success) {
                    json.put("status", "success");
                    json.put("message", "Đăng ký thành công!");
                } else {
                    json.put("status", "error");
                    json.put("message", "Registration failed, try again.");
                }
            }

        } catch (SQLException e) {
            Logger.getLogger(RegisterServlet.class.getName()).log(Level.SEVERE, null, e);
            json.put("status", "error");
            json.put("message", "Database error: " + e.getMessage());
        } catch (Exception e) {
            Logger.getLogger(RegisterServlet.class.getName()).log(Level.SEVERE, null, e);
            json.put("status", "error");
            json.put("message", "Server error: " + e.getMessage());
        }

        response.getWriter().write(json.toString());
    }
}
