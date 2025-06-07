package Controller;

import db.DBcontext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.*;

public class AvatarServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("user");

        if (username == null || username.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/img/avatar/default.png");
            return;
        }

        try (Connection conn = new DBcontext().getConnection()) {
            String sql = "SELECT avatar FROM accounts WHERE username = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Blob avatarBlob = rs.getBlob("avatar");

                // Nếu avatar là NULL trong DB → dùng ảnh mặc định
                if (avatarBlob == null || avatarBlob.length() == 0) {
                    response.sendRedirect(request.getContextPath() + "/img/avatar/default.png");
                    return;
                }

                // Gửi ảnh BLOB về response
                response.setContentType("image/jpeg"); // hoặc "image/png"
                try (InputStream is = avatarBlob.getBinaryStream();
                     OutputStream os = response.getOutputStream()) {

                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = is.read(buffer)) != -1) {
                        os.write(buffer, 0, bytesRead);
                    }
                }

            } else {
                // Không có user → ảnh mặc định
                response.sendRedirect(request.getContextPath() + "/img/avatar/default.png");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/img/avatar/default.png");
        }
    }
}
