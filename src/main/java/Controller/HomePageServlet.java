/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;
import Model.Package;
import DAO.PackageDao;
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

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PackageDao dao = new PackageDao();
        List<Package> packages = dao.getAllPackages();
        request.setAttribute("membership_packages", packages);
        
        trainerDao = new TrainerDao(); // 💥 thêm dòng này để khởi tạo đối tượng

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
        request.getRequestDispatcher("/WEB-INF/View/customers/HomePage.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
