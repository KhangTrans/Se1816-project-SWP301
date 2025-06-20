package Controller;

import DAO.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
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

        try ( BufferedReader reader = request.getReader()) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            JSONObject profile = new JSONObject(sb.toString());
            String fbId = profile.getString("id");
            String name = profile.optString("name", "No Name");
            String email = profile.optString("email", "fbuser_" + fbId + "@noemail.com");
            String accessToken = profile.optString("accessToken", "");

            // Tải ảnh avatar Facebook dùng access token
            InputStream avatarStream = downloadFacebookAvatarAsStream(fbId, accessToken);

            // Lưu vào database nếu chưa có
            UserDao dao = new UserDao();
            if (!dao.isUsernameExists(email) && !dao.isEmailExists(email)) {
                dao.registerCustomerBinary(email, "fbuser", avatarStream, name, email, "");
            }

            // Lưu session
            HttpSession session = request.getSession();
            session.setAttribute("username", email);
            session.setAttribute("avatar", "fb_blob");
            session.setAttribute("role", "customer");

            json.put("status", "success");
            json.put("message", "Facebook login success!");
        } catch (Exception e) {
            e.printStackTrace();
            json.put("status", "error");
            json.put("message", "Facebook login failed: " + e.getMessage());
        }

        response.getWriter().write(json.toString());
    }

    private InputStream downloadFacebookAvatarAsStream(String fbId, String accessToken) {
        try {
            String apiUrl = "https://graph.facebook.com/" + fbId + "/picture?type=large&redirect=false&access_token=" + accessToken;
            HttpURLConnection conn = (HttpURLConnection) new URL(apiUrl).openConnection();
            conn.setRequestMethod("GET");

            BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            JSONObject obj = new JSONObject(sb.toString());
            String imageUrl = obj.getJSONObject("data").getString("url");

            // Tải ảnh từ URL đó
            HttpURLConnection imageConn = (HttpURLConnection) new URL(imageUrl).openConnection();
            imageConn.setRequestMethod("GET");
            return imageConn.getInputStream();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }

    }

    @Override
    public String getServletInfo() {
        return "Handles Facebook Login and stores user info with avatar into DB";
    }
}
