package Controller;

import DAO.TrainerDao;
import Model.Trainers;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "TrainerHomepageServlet", urlPatterns = {"/TrainerHomepageServlet"})
public class TrainerHomepageServlet extends HttpServlet {

   private TrainerDao trainerDao;

    @Override
    public void init() throws ServletException {
        // Khởi tạo đối tượng TrainerDao để truy vấn cơ sở dữ liệu
        trainerDao = new TrainerDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
    }
    

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý POST nếu cần
    }

    @Override
    public String getServletInfo() {
        return "TrainerHomepageServlet - Trả danh sách huấn luyện viên";
    }
}
