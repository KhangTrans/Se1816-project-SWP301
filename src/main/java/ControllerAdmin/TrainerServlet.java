package ControllerAdmin;

import DAO.TrainerDao;
import Model.Account;
import Model.Trainers;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "TrainerServlet", urlPatterns = {"/TrainerServlet"})
@MultipartConfig
public class TrainerServlet extends HttpServlet {

    private TrainerDao trainerDao;

    @Override
    public void init() throws ServletException {
        trainerDao = new TrainerDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("json".equalsIgnoreCase(action)) {
                String searchTerm = request.getParameter("searchTerm"); // Tìm kiếm theo tên hoặc username
                String experience = request.getParameter("experience");  // Lọc theo kinh nghiệm
                String rating = request.getParameter("rating");         // Lọc theo rating

                List<Trainers> trainersList;

                // Nếu có tham số tìm kiếm hoặc lọc, gọi hàm searchTrainers
                if (searchTerm != null || experience != null || rating != null) {
                    trainersList = trainerDao.searchTrainers(searchTerm, experience, rating);
                } else {
                    // Nếu không có tham số tìm kiếm, trả về tất cả huấn luyện viên
                    trainersList = trainerDao.getAllTrainers();
                }
                // Debug: In ra danh sách huấn luyện viên và giá tiền
                for (Trainers trainer : trainersList) {
                    System.out.println("Trainer ID: " + trainer.getTrainerId() + ", Price: " + trainer.getPrice());
                }

                // Trả kết quả dưới dạng JSON
                Gson gson = new GsonBuilder()
                        .registerTypeAdapter(LocalDateTime.class, new JsonSerializer<LocalDateTime>() {
                            @Override
                            public com.google.gson.JsonElement serialize(LocalDateTime src, java.lang.reflect.Type typeOfSrc, JsonSerializationContext context) {
                                return src == null ? null : new com.google.gson.JsonPrimitive(src.toString());
                            }
                        })
                        .create();

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(gson.toJson(trainersList));

            } else if ("getAccountsWithoutTrainer".equalsIgnoreCase(action)) {
                List<Account> availableAccounts = trainerDao.getAvailableTrainerAccounts();
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                Gson gson = new Gson();
                response.getWriter().write(gson.toJson(availableAccounts));

            } else if ("getById".equalsIgnoreCase(action)) {
                int trainerId = Integer.parseInt(request.getParameter("trainerId"));
                Trainers trainer = trainerDao.getTrainerById(trainerId);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                Gson gson = new Gson();
                response.getWriter().write(gson.toJson(trainer));

            } else {
                // Trả về trang JSP bình thường
                List<Trainers> trainersList = trainerDao.getAllTrainers();
                request.setAttribute("trainersList", trainersList);
                request.getRequestDispatcher("/WEB-INF/View/admin/trainers/list.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tải danh sách trainer.");
        }
    }

    private String generateTrainerCode() throws SQLException {
        String code;
        do {
            int number = (int) (Math.random() * 1_000_000);
            code = String.format("TR%06d", number);
        } while (trainerDao.isTrainerCodeExists(code)); // DAO check trùng
        return code;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: xử lý thêm/sửa trainer nếu cần
        String formAction = request.getParameter("formAction");
        System.out.println("📥 [TrainerServlet] POST called.");
        System.out.println("📥 formAction = " + formAction);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        if (formAction == null) {
            formAction = "";
        }

        if ("create".equalsIgnoreCase(formAction)) {
            try {
                int accountId = Integer.parseInt(request.getParameter("accountId"));
                String fullname = request.getParameter("fullname").trim();
                String email = request.getParameter("email").trim();
                String phone = request.getParameter("phone_number").trim();
                String bio = request.getParameter("bio");
                int experience = Integer.parseInt(request.getParameter("experience_years"));
                double price = Double.parseDouble(request.getParameter("price"));
                System.out.println("📌 Creating Trainer for account ID = " + accountId);

                // Server-side validation
                if (!fullname.matches("^[a-zA-ZÀ-ỹ\\s]+$")) {
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Họ tên không được chứa số hoặc ký tự đặc biệt.\"}");
                    return;
                }

                if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Email không hợp lệ.\"}");
                    return;
                }

                if (!phone.matches("^(0|\\+84)[1-9]\\d{8,9}$")) {
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Số điện thoại phải là định dạng Việt Nam.\"}");
                    return;
                }

                // Kiểm tra tồn tại
                if (trainerDao.isEmailExists(email)) {
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Email đã được sử dụng.\"}");
                    return;
                }

                if (trainerDao.isPhoneExists(phone)) {
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Số điện thoại đã được sử dụng.\"}");
                    return;
                }

                // Lấy account từ DB để đảm bảo tồn tại và đúng role
                Account account = trainerDao.getTrainerAccountById(accountId);
                if (account == null) {
                    System.out.println("❌ Trainer account not found.");

                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Trainer account not found or invalid.\"}");
                    return;
                }

                Trainers trainer = new Trainers();
                trainer.setAccountId(account);  // Gán object Account
                trainer.setFullName(fullname);
                trainer.setEmail(email);
                trainer.setPhone(phone);
                trainer.setBio(bio);
                trainer.setExperienceYears(experience);
                trainer.setRating((float) 5.0); // Nếu bạn muốn khởi tạo rating mặc định
                trainer.setTrainer_code(generateTrainerCode());
                trainer.setPrice(price);
                System.out.println("Generated Trainer Code: " + trainer.getTrainer_code());

                boolean success = trainerDao.insertTrainer(trainer);

                if (success) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    System.out.println("✅ Trainer created successfully.");
                    response.getWriter().write("{\"status\":\"success\", \"message\":\"Trainer created successfully.\"}");
                } else {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    System.out.println("❌ Failed to insert trainer.");
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to create trainer.\"}");
                }

            } catch (Exception e) {
                System.err.println("❌ Exception while creating trainer:");
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Server error while creating trainer.\"}");
            }
        } else if ("edit".equalsIgnoreCase(formAction)) {
            try {
                int trainerId = Integer.parseInt(request.getParameter("trainerId"));
                String fullname = request.getParameter("fullname").trim();
                String email = request.getParameter("email").trim();
                String phone = request.getParameter("phone_number").trim();
                String bio = request.getParameter("bio");
                int experience = Integer.parseInt(request.getParameter("experience_years"));
                double price = Double.parseDouble(request.getParameter("price"));
                float rating = Float.parseFloat(request.getParameter("rating"));

                // Server-side validation tương tự create
                if (!fullname.matches("^[a-zA-ZÀ-ỹ\\s]+$")) {
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Họ tên không được chứa số hoặc ký tự đặc biệt.\"}");
                    return;
                }

                if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Email không hợp lệ.\"}");
                    return;
                }

                if (!phone.matches("^(0|\\+84)[1-9]\\d{8,9}$")) {
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Số điện thoại phải là định dạng Việt Nam.\"}");
                    return;
                }

                // Kiểm tra tồn tại, loại trừ trainer hiện tại
                if (trainerDao.isEmailExistsExceptTrainer(email, trainerId)) {
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Email đã được sử dụng bởi trainer khác.\"}");
                    return;
                }

                if (trainerDao.isPhoneExistsExceptTrainer(phone, trainerId)) {
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Số điện thoại đã được sử dụng bởi trainer khác.\"}");
                    return;
                }

                Trainers trainer = trainerDao.getTrainerById(trainerId);
                if (trainer == null) {
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Trainer not found.\"}");
                    return;
                }

                trainer.setFullName(fullname);
                trainer.setEmail(email);
                trainer.setPhone(phone);
                trainer.setBio(bio);
                trainer.setExperienceYears(experience);
                trainer.setRating(rating);
                trainer.setPrice(price);

                boolean success = trainerDao.updateTrainer(trainer);
                if (success) {
                    response.getWriter().write("{\"status\":\"success\", \"message\":\"Trainer updated successfully.\"}");
                } else {
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to update trainer.\"}");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Server error while updating trainer.\"}");
            }
        } else if ("delete".equalsIgnoreCase(formAction)) {
            try {
                int trainerId = Integer.parseInt(request.getParameter("trainerId"));
                boolean success = trainerDao.deleteTrainer(trainerId);

                if (success) {
                    response.getWriter().write("{\"status\":\"success\", \"message\":\"Trainer deleted successfully.\"}");
                } else {
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to delete trainer.\"}");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Server error while deleting trainer.\"}");
            }
        } else {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Invalid form action.\"}");
        }

    }

    @Override
    public String getServletInfo() {
        return "TrainerServlet - Trả danh sách huấn luyện viên";
    }
}
