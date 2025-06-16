package Controller;

import DAO.UserDao;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import org.json.JSONObject;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.GeneralSecurityException;
import java.sql.SQLException;
import java.util.Collections;
import java.util.logging.Level;
import java.util.logging.Logger;

public class GoogleLoginServlet extends HttpServlet {

    private static final String CLIENT_ID = "749125474877-p8jcn9i7b48rpgq3eh4gkintoph2noo5.apps.googleusercontent.com";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JSONObject json = new JSONObject();

        try {
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            String token = new JSONObject(sb.toString()).getString("credential");

            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                    GoogleNetHttpTransport.newTrustedTransport(), JacksonFactory.getDefaultInstance())
                    .setAudience(Collections.singletonList(CLIENT_ID))
                    .build();

            GoogleIdToken idToken = verifier.verify(token);
            if (idToken != null) {
                String email = idToken.getPayload().getEmail();
                String name = (String) idToken.getPayload().get("name");
                String pictureUrl = (String) idToken.getPayload().get("picture");

                String username = email.split("@")[0];

                // Tải ảnh từ Google avatar
                InputStream avatarStream = null;
                try {
                    URL url = new URL(pictureUrl);
                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    conn.setRequestMethod("GET");
                    conn.connect();
                    if (conn.getResponseCode() == 200) {
                        avatarStream = conn.getInputStream();
                    }
                } catch (Exception ex) {
                    ex.printStackTrace(); // fallback nếu lỗi: avatarStream = null
                }

                // Lưu vào database nếu chưa tồn tại
                UserDao dao = new UserDao();
                if (!dao.isUsernameExists(username) && !dao.isEmailExists(email)) {
                    dao.registerCustomer(username, "googleuser", avatarStream, name, email, "");
                }

                // Set session
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", "customer");

                json.put("status", "success");
                json.put("message", "Google login success!");
            } else {
                json.put("status", "error");
                json.put("message", "Invalid ID token.");
            }

        } catch (IOException | GeneralSecurityException | SQLException ex) {
            Logger.getLogger(GoogleLoginServlet.class.getName()).log(Level.SEVERE, null, ex);
            json.put("status", "error");
            json.put("message", "Google login failed: " + ex.getMessage());
        }

        response.getWriter().write(json.toString());
    }

    @Override
    public String getServletInfo() {
        return "Handles Google Login and stores user info with avatar into DB";
    }
}
