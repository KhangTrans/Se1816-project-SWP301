package ControllerAdmin;

import DAO.TrainerDao;
import Model.Account;
import Model.Trainers;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
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
            List<Trainers> trainersList = trainerDao.getAllTrainers();

            if ("json".equalsIgnoreCase(action)) {
                // Trả JSON cho client (AJAX)
                Gson gson = new GsonBuilder()
                        .registerTypeAdapter(LocalDateTime.class, new JsonSerializer<LocalDateTime>() {
                            @Override
                            public com.google.gson.JsonElement serialize(LocalDateTime src, java.lang.reflect.Type typeOfSrc, com.google.gson.JsonSerializationContext context) {
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
                return;
            } else {
                // Trả ra JSP thông thường
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
                String fullname = request.getParameter("fullname");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone_number");
                String bio = request.getParameter("bio");
                int experience = Integer.parseInt(request.getParameter("experience_years"));
                double price = Double.parseDouble(request.getParameter("price"));
                System.out.println("📌 Creating Trainer for account ID = " + accountId);

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
                String fullname = request.getParameter("fullname");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone_number");
                String bio = request.getParameter("bio");
                int experience = Integer.parseInt(request.getParameter("experience_years"));
                double price = Double.parseDouble(request.getParameter("price"));
                float rating = Float.parseFloat(request.getParameter("rating"));

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
