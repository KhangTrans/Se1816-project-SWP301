package ControllerAdmin;

import DAO.OrderDao;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;

@WebServlet(name = "StatisticsServlet", urlPatterns = {"/admin/statistics"})
public class StatisticsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String range = request.getParameter("range");
        if (range == null || range.trim().isEmpty()) {
            range = "7"; // Mặc định
        }

        OrderDao dao = new OrderDao();
        Map<String, Integer> stats = null;

        try {
            switch (range) {
                case "today":
                    stats = dao.getSalesStatsToday();
                    break;
                case "30":
                    stats = dao.getSalesStatsLast30Days();
                    break;
                case "7":
                default:
                    stats = dao.getSalesStatsLast7Days();
                    break;
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            new Gson().toJson(stats, response.getWriter());

        } catch (Exception e) {
            e.printStackTrace(); // Ghi log chi tiết
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý thống kê");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST not supported.");
    }

    @Override
    public String getServletInfo() {
        return "StatisticsServlet - Trả dữ liệu thống kê bán hàng";
    }
}
