package Controller;

import DAO.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Scanner;

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

            // Lấy ảnh đại diện từ Facebook Graph API
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
            e.printStackTrace();
            json.put("status", "error");
            json.put("message", "Facebook login failed: " + e.getMessage());
        }

        response.getWriter().write(json.toString());
    }

    private String getFacebookAvatarUrl(String fbId) throws IOException {
        String url = "https://graph.facebook.com/" + fbId + "/picture?type=large&redirect=false";
        HttpURLConnection connection = (HttpURLConnection) new URL(url).openConnection();
        connection.setRequestMethod("GET");

        StringBuilder responseBuilder = new StringBuilder();
        try ( Scanner scanner = new Scanner(connection.getInputStream())) {
            while (scanner.hasNextLine()) {
                responseBuilder.append(scanner.nextLine());
            }
        }

        JSONObject jsonResponse = new JSONObject(responseBuilder.toString());
        return jsonResponse.getJSONObject("data").getString("url");
    }

    @Override
    public String getServletInfo() {
        return "Handles Facebook Login and auto-registers user if not exists";
    }
}
