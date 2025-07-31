package Controller;

import db.DBcontext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet(name = "AvatarServlet", urlPatterns = {"/AvatarServlet"})
public class AvatarServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("user");
        String accountIdParam = request.getParameter("accountId");
        int accountId = -1;
        
        if (accountIdParam != null && !accountIdParam.trim().isEmpty()) {
            try {
                accountId = Integer.parseInt(accountIdParam);
            } catch (NumberFormatException e) {
                // Invalid account ID format
                response.sendRedirect(request.getContextPath() + "/avatar/default.png");
                return;
            }
        }

        if ((username == null || username.trim().isEmpty()) && accountId <= 0) {
            response.sendRedirect(request.getContextPath() + "/avatar/default.png");
            return;
        }

        try (Connection conn = new DBcontext().getConnection()) {
            String sql;
            PreparedStatement stmt;
            
            if (accountId > 0) {
                // Fetch by account ID
                sql = "SELECT avatar FROM accounts WHERE account_id = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, accountId);
            } else {
                // Fetch by username
                sql = "SELECT avatar FROM accounts WHERE username = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, username);
            }
            
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                byte[] avatarBytes = rs.getBytes("avatar");

                // Nếu avatar là NULL trong DB → dùng ảnh mặc định
                if (avatarBytes == null || avatarBytes.length == 0) {
                    response.sendRedirect(request.getContextPath() + "/avatar/default.png");
                    return;
                }

                // Gửi ảnh về response
                String mimeType = getServletContext().getMimeType("avatar.jpg");
                response.setContentType(mimeType != null ? mimeType : "image/jpeg");

                try (OutputStream os = response.getOutputStream()) {
                    os.write(avatarBytes);
                }

            } else {
                // Không có user → ảnh mặc định
                response.sendRedirect(request.getContextPath() + "/avatar/default.png");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/avatar/default.png");
        }
    }
}
