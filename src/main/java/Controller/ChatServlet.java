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
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
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
            System.out.println("API Key loaded from config.properties");
            System.out.println("API Key: " + OPENAI_API_KEY);
        } catch (Exception e) {
            System.err.println("Không thể đọc API Key từ config.properties");
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

            // Tìm kiếm câu trả lời trong FAQ trước
            FAQ bestMatch = findBestMatch(userInput);

            String result;
            if (bestMatch != null) {
                // Nếu tìm thấy câu hỏi trong FAQ, trả lời từ FAQ
                result = bestMatch.answer;
            } else {
                // Nếu không tìm thấy, kiểm tra câu hỏi liên quan đến gym/fitness
                if (isFitnessQuestion(userInput)) {
                    result = callChatGPT(userInput);  // Gọi OpenAI để trả lời câu hỏi liên quan đến gym/fitness
                } else {
                    result = "❌ Câu hỏi không liên quan đến gym hoặc fitness."; // Nếu không liên quan đến gym/fitness
                }
            }

            jsonResponse.put("reply", result);
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("reply", "❌ Server lỗi: " + e.getMessage());
        }

        response.getWriter().print(jsonResponse.toString());
    }

    private boolean isFitnessQuestion(String input) {
        // Danh sách từ khóa liên quan đến gym, fitness, và huấn luyện viên
        String[] fitnessKeywords = {
            "gym", "fitness", "exercise", "workout", "strength", "training", "muscle", "cardio",
            "weight loss", "health", "bodybuilding", "fitness routine", "diet", "nutrition", "stretching",
            "huấn luyện viên", "trainer", "lịch tập", "đặt lịch", "gói tập", "phòng gym",
            "tập thể dục", "thể hình", "tập luyện", "tập cardio", "tập sức bền", "tập cơ bắp", "tăng cơ",
            "giảm cân", "hỗ trợ dinh dưỡng", "tư vấn dinh dưỡng", "khóa học thể hình", "chế độ ăn", "tập bụng",
            "tập chân", "tập tay", "tập lưng", "tập ngực", "tập vai", "tập mông", "tập toàn thân", "sức khỏe",
            "tập thể thao", "đường cong cơ thể", "tăng cường sức khỏe", "hướng dẫn tập luyện", "gói tập PT", "tập gym",
            "phòng tập", "thẻ thành viên", "lịch tập", "gói tập 1:1", "huấn luyện viên cá nhân", "chế độ ăn kiêng",
            "phục hồi thể thao", "tập thể dục giảm cân", "các bài tập thể hình", "bài tập gym tại nhà", "hệ thống gym",
            "tập thể dục tại nhà", "gói tập thể dục", "tập luyện giảm cân", "hệ thống phòng gym", "gym có tư vấn",
            "giảm mỡ bụng", "kế hoạch tập luyện", "phương pháp tập luyện", "cung cấp dinh dưỡng"
        };

        // Kiểm tra nếu câu hỏi chứa bất kỳ từ khóa nào
        for (String keyword : fitnessKeywords) {
            if (input.toLowerCase().contains(keyword)) {
                return true;
            }
        }
        return false;
    }

    private FAQ findBestMatch(String input) {
        input = input.toLowerCase();
        double bestScore = 0.0;
        FAQ best = null;
        for (FAQ faq : faqList) {
            double score = similarity(input, faq.question.toLowerCase());
            if (score > 0.3 && score > bestScore) {
                bestScore = score;
                best = faq;
            }
        }
        return best;
    }

    private double cosineSimilarity(String s1, String s2) {
        Map<String, Integer> termFrequency1 = getTermFrequency(s1);
        Map<String, Integer> termFrequency2 = getTermFrequency(s2);

        Set<String> allTerms = new HashSet<>(termFrequency1.keySet());
        allTerms.addAll(termFrequency2.keySet());

        int dotProduct = 0;
        int norm1 = 0;
        int norm2 = 0;

        for (String term : allTerms) {
            int tf1 = termFrequency1.getOrDefault(term, 0);
            int tf2 = termFrequency2.getOrDefault(term, 0);
            dotProduct += tf1 * tf2;
            norm1 += tf1 * tf1;
            norm2 += tf2 * tf2;
        }

        return dotProduct / (Math.sqrt(norm1) * Math.sqrt(norm2));
    }

    private Map<String, Integer> getTermFrequency(String s) {
        Map<String, Integer> termFrequency = new HashMap<>();
        String[] words = s.toLowerCase().split("\\s+");

        for (String word : words) {
            termFrequency.put(word, termFrequency.getOrDefault(word, 0) + 1);
        }

        return termFrequency;
    }

    private double similarity(String s1, String s2) {
        // Sử dụng Cosine similarity để đo độ tương tự
        return cosineSimilarity(s1, s2);
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
