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
 * Servlet xử lý các yêu cầu từ người dùng, tìm câu trả lời từ FAQ hoặc gọi
 * OpenAI API để trả lời các câu hỏi liên quan đến gym và fitness.
 */
public class ChatServlet extends HttpServlet {

    private static String OPENAI_API_KEY;
    private static final String MODEL = "gpt-3.5-turbo";  // Chỉ định mô hình GPT-3.5 sử dụng cho OpenAI
    private List<FAQ> faqList;  // Danh sách các câu hỏi và câu trả lời từ FAQ

    /**
     * Phương thức init() được gọi khi Servlet khởi tạo. Hàm này sẽ tải danh
     * sách FAQ từ file và API Key từ cấu hình.
     */
    @Override
    public void init() throws ServletException {
        super.init();
        loadFAQFromFile();  // Tải các câu hỏi và câu trả lời từ file
        loadApiKey();  // Tải API Key từ file cấu hình
    }

    /**
     * Tải API Key từ file config.properties. Nếu không đọc được API key, sẽ
     * hiển thị lỗi.
     */
    private void loadApiKey() {
        try ( InputStream input = getServletContext().getResourceAsStream("/WEB-INF/config.properties")) {
            Properties prop = new Properties();
            prop.load(input);
            OPENAI_API_KEY = prop.getProperty("openai.api.key");  // Lấy API key từ file
            System.out.println("API Key loaded from config.properties");
            System.out.println("API Key: " + OPENAI_API_KEY);
        } catch (Exception e) {
            System.err.println("Không thể đọc API Key từ config.properties");
            e.printStackTrace();
        }
    }

    /**
     * Tải danh sách các câu hỏi và câu trả lời FAQ từ file project_faq.json.
     * Nếu không thể tải được, danh sách FAQ sẽ được khởi tạo rỗng.
     */
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
            JSONArray array = new JSONArray(json);  // Chuyển chuỗi JSON thành JSONArray
            faqList = new ArrayList<>();
            for (int i = 0; i < array.length(); i++) {
                JSONObject obj = array.getJSONObject(i);
                faqList.add(new FAQ(obj.getString("question"), obj.getString("answer")));  // Thêm vào danh sách FAQ
            }
        } catch (Exception e) {
            e.printStackTrace();
            faqList = new ArrayList<>();  // Nếu lỗi, khởi tạo danh sách FAQ rỗng
        }
    }

    /**
     * Xử lý yêu cầu POST từ người dùng. Phản hồi trả về dưới dạng JSON, có thể
     * trả lời từ FAQ hoặc từ OpenAI.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");  // Thiết lập kiểu nội dung trả về là JSON
        JSONObject jsonResponse = new JSONObject();
        try {
            String userInput = request.getParameter("prompt");  // Lấy câu hỏi từ người dùng

            // Tìm kiếm câu trả lời trong FAQ trước
            FAQ bestMatch = findBestMatch(userInput);  // Tìm câu trả lời phù hợp trong FAQ

            String result;
            if (bestMatch != null) {
                result = bestMatch.answer;  // Nếu tìm thấy trong FAQ, trả lời từ FAQ
            } else {
                // Nếu không tìm thấy trong FAQ, kiểm tra câu hỏi liên quan đến gym/fitness
                if (isFitnessQuestion(userInput)) {
                    result = callChatGPT(userInput);  // Gọi OpenAI để trả lời câu hỏi liên quan đến gym/fitness
                } else {
                    result = "❌ Question not related to gym or fitness.";  // If question is not related
                }
            }

            jsonResponse.put("reply", result);  // Đưa câu trả lời vào JSON phản hồi
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("reply", "❌ Server error: " + e.getMessage());  // Error handling
        }

        // Trả lại phản hồi cho client dưới dạng JSON
        response.getWriter().print(jsonResponse.toString());
    }

    /**
     * Kiểm tra xem câu hỏi có liên quan đến gym hoặc fitness hay không. Dựa vào
     * các từ khóa liên quan đến gym và fitness trong câu hỏi.
     */
    private boolean isFitnessQuestion(String input) {
        // Danh sách từ khóa liên quan đến gym và fitness
        String[] fitnessKeywords = {
            "gym", "fitness", "exercise", "workout", "strength", "training", "muscle", "cardio",
            "weight loss", "health", "bodybuilding", "fitness routine", "diet", "nutrition", "stretching",
            "huấn luyện viên", "trainer", "lịch tập", "đặt lịch", "gói tập", "phòng gym",
            "tập thể dục", "thể hình", "tập luyện", "tập cardio", "tập sức bền", "tập cơ bắp", "tăng cơ",
            "giảm cân", "hỗ trợ dinh dưỡng", "tư vấn dinh dưỡng", "khóa học thể hình", "chế độ ăn", "tập bụng",
            "tập chân", "tập tay", "tập lưng", "tập ngực", "tập vai", "tập mông", "tập toàn thân", "sức khỏe"
        };

        // Kiểm tra nếu câu hỏi chứa bất kỳ từ khóa nào
        for (String keyword : fitnessKeywords) {
            if (input.toLowerCase().contains(keyword)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Tìm câu hỏi phù hợp nhất trong danh sách FAQ dựa trên độ tương tự. Sử
     * dụng Cosine similarity để so sánh câu hỏi.
     */
    private FAQ findBestMatch(String input) {
        input = input.toLowerCase();  // Chuyển câu hỏi người dùng thành chữ thường
        double bestScore = 0.0;
        FAQ best = null;
        for (FAQ faq : faqList) {
            double score = similarity(input, faq.question.toLowerCase());  // Tính độ tương tự với câu hỏi trong FAQ
            if (score > 0.3 && score > bestScore) {
                bestScore = score;
                best = faq;  // Cập nhật câu hỏi FAQ phù hợp nhất
            }
        }
        return best;  // Trả về câu hỏi FAQ tốt nhất
    }

    /**
     * Tính toán độ tương tự giữa hai câu hỏi bằng phương pháp Cosine
     * similarity.
     */
    private double cosineSimilarity(String s1, String s2) {
        // Tính toán tần suất từ (term frequency) cho mỗi chuỗi s1 và s2
        Map<String, Integer> termFrequency1 = getTermFrequency(s1); // Đếm tần suất của các từ trong chuỗi s1
        Map<String, Integer> termFrequency2 = getTermFrequency(s2); // Đếm tần suất của các từ trong chuỗi s2

        // Tạo một tập hợp tất cả các từ có trong cả hai chuỗi
        Set<String> allTerms = new HashSet<>(termFrequency1.keySet()); // Lấy tất cả các từ trong s1
        allTerms.addAll(termFrequency2.keySet()); // Thêm tất cả các từ trong s2 vào tập hợp

        // Khởi tạo các biến để tính toán các giá trị cần thiết
        int dotProduct = 0; // Biến lưu trữ giá trị nhân vô hướng (dot product)
        int norm1 = 0; // Biến lưu trữ độ dài vector của chuỗi s1
        int norm2 = 0; // Biến lưu trữ độ dài vector của chuỗi s2

        // Duyệt qua tất cả các từ có trong cả hai chuỗi
        for (String term : allTerms) {
            // Lấy tần suất xuất hiện của từ trong chuỗi s1 và s2
            int tf1 = termFrequency1.getOrDefault(term, 0); // Nếu từ không có trong s1 thì mặc định là 0
            int tf2 = termFrequency2.getOrDefault(term, 0); // Nếu từ không có trong s2 thì mặc định là 0

            // Cộng dồn các giá trị cần thiết cho cosine similarity
            dotProduct += tf1 * tf2; // Cộng dồn giá trị nhân vô hướng (dot product)
            norm1 += tf1 * tf1; // Cộng dồn bình phương của tần suất trong s1 (để tính độ dài vector của s1)
            norm2 += tf2 * tf2; // Cộng dồn bình phương của tần suất trong s2 (để tính độ dài vector của s2)
        }

        // Tính toán cosine similarity bằng công thức
        return dotProduct / (Math.sqrt(norm1) * Math.sqrt(norm2));  // Trả về độ tương tự cosine giữa hai chuỗi
    }

    /**
     * Lấy tần suất xuất hiện của các từ trong câu.
     */
    private Map<String, Integer> getTermFrequency(String s) {
        Map<String, Integer> termFrequency = new HashMap<>();
        String[] words = s.toLowerCase().split("\\s+");

        for (String word : words) {
            termFrequency.put(word, termFrequency.getOrDefault(word, 0) + 1);  // Đếm tần suất từ
        }

        return termFrequency;  // Trả về tần suất từ
    }

    /**
     * Tính toán độ tương tự giữa hai chuỗi.
     */
    private double similarity(String s1, String s2) {
        return cosineSimilarity(s1, s2);  // Sử dụng cosine similarity để đo độ tương tự
    }

    /**
     * Gọi API OpenAI để trả lời câu hỏi từ người dùng.
     */
    private String callChatGPT(String prompt) throws IOException {
        URL url = new URL("https://api.openai.com/v1/chat/completions");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", "Bearer " + OPENAI_API_KEY);  // Gửi API key
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        // Tạo payload gửi đến OpenAI API
        String payload = new JSONObject()
                .put("model", MODEL)
                .put("messages", new JSONArray()
                        .put(new JSONObject().put("role", "user").put("content", prompt))
                ).toString();

        try ( OutputStream os = conn.getOutputStream()) {
            os.write(payload.getBytes(StandardCharsets.UTF_8));  // Gửi payload đến OpenAI
        }

        // Đọc phản hồi từ OpenAI API
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
            return message.getString("content");  // Trả về câu trả lời từ OpenAI
        } else {
            return "(Không thể hiểu phản hồi)";  // Nếu không có câu trả lời
        }
    }

    /**
     * Lớp FAQ để lưu trữ câu hỏi và câu trả lời.
     */
    static class FAQ {

        String question;
        String answer;

        FAQ(String q, String a) {
            this.question = q;
            this.answer = a;
        }
    }

    /**
     * Trả về mô tả ngắn gọn về servlet.
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
