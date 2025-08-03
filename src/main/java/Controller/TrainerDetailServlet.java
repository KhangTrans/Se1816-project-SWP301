package Controller;

import DAO.TrainerDao;
import Model.Trainers;
import com.google.gson.Gson;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "TrainerDetailServlet", urlPatterns = {"/TrainerDetail"})
public class TrainerDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String trainerIdStr = request.getParameter("trainerId");
        System.out.println("Trainer ID: " + trainerIdStr);

        // Kiểm tra nếu có trainerId trong request
        if (trainerIdStr != null && !trainerIdStr.trim().isEmpty()) {
            try {
                // Chuyển trainerId từ String sang int
                int trainerId = Integer.parseInt(trainerIdStr);
                TrainerDao trainerDao = new TrainerDao();
                Trainers trainer = trainerDao.getTrainerDetails(trainerId);

                // Nếu huấn luyện viên tồn tại
                if (trainer != null) {
                    // Truyền thông tin huấn luyện viên vào request để hiển thị trong JSP
                    request.setAttribute("trainer", trainer);
                    // Chuyển hướng đến trang JSP chi tiết
                    request.getRequestDispatcher("/WEB-INF/View/customers/trainerDetail.jsp").forward(request, response);
                } else {
                    // Nếu không tìm thấy huấn luyện viên
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write("{\"error\":\"Trainer not found. Please check the trainerId.\"}");
                }
            } catch (NumberFormatException e) {
                // Nếu trainerId không hợp lệ
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Invalid trainerId format. It must be an integer.\"}");
            }
        } else {
            // Nếu thiếu tham số trainerId trong request
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Missing trainerId parameter. Please provide a valid trainerId.\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Phương thức doPost không xử lý trong trường hợp này, có thể bỏ qua hoặc thêm logic tùy ý.
    }

    @Override
    public String getServletInfo() {
        return "TrainerDetailServlet - fetches and returns trainer details as JSON";
    }
}
