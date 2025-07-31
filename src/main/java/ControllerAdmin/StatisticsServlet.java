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

        String type = request.getParameter("type");
        String range = request.getParameter("range");
        if (range == null || range.trim().isEmpty()) {
            range = "7"; // Đặt mặc định cho mọi trường hợp
        }
        OrderDao dao = new OrderDao();

        try {
            if ("status".equals(type)) {
                // Trả về thống kê trạng thái đơn hàng cho donut chart
                Map<String, Integer> stats = dao.getOrderStatusStats(range);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                new Gson().toJson(stats, response.getWriter());
                return;
            }
            if ("summary".equals(type)) {
                Map<String, Object> summary = dao.getOrderSummary(range);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                new Gson().toJson(summary, response.getWriter());
                return;
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

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
