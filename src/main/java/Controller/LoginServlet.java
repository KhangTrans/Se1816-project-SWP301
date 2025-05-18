package Controller;

import DAO.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.json.JSONObject;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Enumeration;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Chuẩn bị JSON response
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JSONObject json = new JSONObject();
        System.out.println("=== Received Request ===");
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String param = paramNames.nextElement();
            System.out.println("🔍 Param: " + param + " = " + request.getParameter(param));
        }
        // Nhận dữ liệu từ form
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        System.out.println("DEBUG >> username: " + username);
        System.out.println("DEBUG >> password: " + password);

        // Kiểm tra dữ liệu đầu vào
        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            json.put("status", "error");
            json.put("message", "Please enter username and password.");
            response.getWriter().write(json.toString());
            return;
        }

        try {
            UserDao dao = new UserDao();

            if (dao.login(username, password)) {
                // Lưu session
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", "customer"); // hoặc lấy từ DB nếu có

                json.put("status", "success");
                json.put("message", "Login successful!");
            } else {
                json.put("status", "error");
                json.put("message", "Invalid credentials!");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            json.put("status", "error");
            json.put("message", "Database error: " + e.getMessage());
        }

        // Trả về phản hồi JSON
        response.getWriter().write(json.toString());
    }
}
