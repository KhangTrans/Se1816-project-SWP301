/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.TrainerDao;
import Model.Trainers;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Admin
 */
@WebServlet(name = "HomePageServlet", urlPatterns = {"/homepage"})
public class HomePageServlet extends HttpServlet {

    private TrainerDao trainerDao;

    @Override
    public void init() throws ServletException {
        // Khởi tạo đối tượng TrainerDao để truy vấn cơ sở dữ liệu
        trainerDao = new TrainerDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy danh sách 3 huấn luyện viên có rating cao nhất
        List<Trainers> trainersList = null;
        try {
            trainersList = trainerDao.getTopTrainers();  // Lấy danh sách huấn luyện viên
        } catch (SQLException ex) {
            Logger.getLogger(HomePageServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        // Kiểm tra và truyền dữ liệu vào request
        if (trainersList != null && !trainersList.isEmpty()) {
            request.setAttribute("trainersList", trainersList);
        }

        // Chuyển tiếp đến JSP
        request.getRequestDispatcher("/WEB-INF/View/customers/HomePage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý POST nếu cần
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
