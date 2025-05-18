/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.Collections;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Admin
 */
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

                HttpSession session = request.getSession();
                session.setAttribute("username", email);
                session.setAttribute("role", "customer");
                json.put("status", "success");
                json.put("message", "Google login success!");
            } else {
                json.put("status", "error");
                json.put("message", "Invalid ID token.");
            }

        } catch (IOException e) {
            json.put("status", "error");
            json.put("message", "Google login failed: " + e.getMessage());
        } catch (GeneralSecurityException ex) {
            Logger.getLogger(GoogleLoginServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        response.getWriter().write(json.toString());

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
