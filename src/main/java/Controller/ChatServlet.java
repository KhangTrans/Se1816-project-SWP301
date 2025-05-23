/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author Admin
 */
public class ChatServlet extends HttpServlet {

    private static String OPENAI_API_KEY;
    private static final String MODEL = "gpt-3.5-turbo";
    private List<FAQ> faqList;

    @Override
    public void init() throws ServletException {
        super.init();
        loadFAQFromFile();
        loadApiKey();
    }

    private void loadApiKey() {
        try ( InputStream input = getServletContext().getResourceAsStream("/WEB-INF/config.properties")) {
            Properties prop = new Properties();
            prop.load(input);
            OPENAI_API_KEY = prop.getProperty("openai.api.key");
            System.out.println("✅ API Key loaded from config.properties");
        } catch (Exception e) {
            System.err.println("❌ Không thể đọc API Key từ config.properties");
            e.printStackTrace();
        }
    }

    private void loadFAQFromFile() {
        try ( InputStream is = getServletContext().getResourceAsStream("/WEB-INF/project_faq.json")) {
            if (is == null) {
                return;
            }
            BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            String json = sb.toString();
            JSONArray array = new JSONArray(json);
            faqList = new ArrayList<>();
            for (int i = 0; i < array.length(); i++) {
                JSONObject obj = array.getJSONObject(i);
                faqList.add(new FAQ(obj.getString("question"), obj.getString("answer")));
            }
        } catch (Exception e) {
            e.printStackTrace();
            faqList = new ArrayList<>();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        JSONObject jsonResponse = new JSONObject();
        try {
            String userInput = request.getParameter("prompt");
            FAQ bestMatch = findBestMatch(userInput);

            String result;
            if (bestMatch != null) {
                String reformulatePrompt = "Viết lại câu hỏi sau sao cho tự nhiên hơn: " + bestMatch.question;
                String rewrittenQuestion = callChatGPT(reformulatePrompt);
                result = bestMatch.answer;
            } else {
                result = callChatGPT(userInput);
            }

            jsonResponse.put("reply", result);
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("reply", "❌ Server lỗi: " + e.getMessage());
        }

        response.getWriter().print(jsonResponse.toString());
    }

    private FAQ findBestMatch(String input) {
        input = input.toLowerCase();
        double bestScore = 0.0;
        FAQ best = null;
        for (FAQ faq : faqList) {
            double score = similarity(input, faq.question.toLowerCase());
            if (score > 0.7 && score > bestScore) {
                bestScore = score;
                best = faq;
            }
        }
        return best;
    }

    private double similarity(String s1, String s2) {
        Set<String> words1 = new HashSet<>(Arrays.asList(s1.split("\\s+")));
        Set<String> words2 = new HashSet<>(Arrays.asList(s2.split("\\s+")));
        Set<String> intersect = new HashSet<>(words1);
        intersect.retainAll(words2);
        return (2.0 * intersect.size()) / (words1.size() + words2.size());
    }

    private String callChatGPT(String prompt) throws IOException {
        URL url = new URL("https://api.openai.com/v1/chat/completions");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", "Bearer " + OPENAI_API_KEY);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        String payload = new JSONObject()
                .put("model", MODEL)
                .put("messages", new JSONArray()
                        .put(new JSONObject().put("role", "user").put("content", prompt))
                ).toString();

        try ( OutputStream os = conn.getOutputStream()) {
            os.write(payload.getBytes(StandardCharsets.UTF_8));
        }

        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        String response = sb.toString();

        JSONObject jsonObject = new JSONObject(response);
        JSONArray choices = jsonObject.getJSONArray("choices");
        if (choices.length() > 0) {
            JSONObject message = choices.getJSONObject(0).getJSONObject("message");
            return message.getString("content");
        } else {

            return "(Không thể hiểu phản hồi)";
        }
    }

    static class FAQ {

        String question;
        String answer;

        FAQ(String q, String a) {
            this.question = q;
            this.answer = a;
        }

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
