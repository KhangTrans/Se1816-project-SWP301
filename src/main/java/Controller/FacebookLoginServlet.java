package Controller;

import DAO.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class FacebookLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JSONObject json = new JSONObject();

        try (BufferedReader reader = request.getReader()) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            JSONObject profile = new JSONObject(sb.toString());
            String fbId = profile.getString("id");
            String name = profile.optString("name", "No Name");
            String email = profile.optString("email", "fbuser_" + fbId + "@noemail.com");

            // Gọi Facebook API để lấy ảnh đại diện URL gốc (redirect=false)
            String avatar = getFacebookAvatarUrl(fbId);

            // Tự động lưu vào database nếu chưa tồn tại
            UserDao dao = new UserDao();
            dao.quickRegisterIfNotExistsF(email, name, email);

            // Lưu session
            HttpSession session = request.getSession();
            session.setAttribute("username", email);
            session.setAttribute("avatar", avatar);
            session.setAttribute("role", "customer");

            json.put("status", "success");
            json.put("message", "Facebook login success!");
        } catch (Exception e) {
            json.put("status", "error");
            json.put("message", "Facebook login failed: " + e.getMessage());
        }

        response.getWriter().write(json.toString());
    }

    // Gọi API để lấy URL ảnh đại diện Facebook (dạng JSON)
    private String getFacebookAvatarUrl(String fbId) {
        String avatarUrl = "https://graph.facebook.com/" + fbId + "/picture?type=large";
        try {
            String apiUrl = "https://graph.facebook.com/" + fbId + "/picture?type=large&redirect=false";
            HttpURLConnection conn = (HttpURLConnection) new URL(apiUrl).openConnection();
            conn.setRequestMethod("GET");

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder responseStr = new StringBuilder();
            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                responseStr.append(inputLine);
            }
            in.close();

            JSONObject data = new JSONObject(responseStr.toString());
            avatarUrl = data.getJSONObject("data").getString("url");

        } catch (Exception e) {
            // fallback: dùng link redirect nếu có lỗi
        }

        return avatarUrl;
    }

    @Override
    public String getServletInfo() {
        return "Facebook login servlet";
    }
}
