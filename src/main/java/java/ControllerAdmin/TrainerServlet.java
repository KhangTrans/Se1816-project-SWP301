package ControllerAdmin;

import DAO.TrainerDao;
import Model.Trainers;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSerializer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "TrainerServlet", urlPatterns = {"/TrainerServlet"})
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: xử lý thêm/sửa trainer nếu cần
    }

    @Override
    public String getServletInfo() {
        return "TrainerServlet - Trả danh sách huấn luyện viên";
    }
}
