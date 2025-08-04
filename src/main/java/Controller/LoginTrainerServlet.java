package Controller;

import DAO.UserDao;
import DAO.TrainerDao;
import Model.Account;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;

/**
 *
 * @author Admin
 */
@WebServlet(name = "LoginTrainerServlet", urlPatterns = {"/loginTrainer"})
public class LoginTrainerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/View/trainer/loginTrainer.jsp").forward(request, response);
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

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDao userDao = new UserDao();
        try {
            // Check if login credentials are valid and user is a trainer
            Account account = userDao.loginTrainer(username, password);
            
            System.out.println(">> Login attempt: " + username);
            if (account != null) {
                System.out.println(">> Success login for trainer: " + account.getUsername());

                HttpSession session = request.getSession();
                session.setAttribute("account", account);

                // Get trainer information from TrainerDao if needed
                TrainerDao trainerDao = new TrainerDao();
                // You could get more trainer details here if needed

                out.print("{\"status\":\"success\", \"message\":\"Login successful\"}");
            } else {
                System.out.println(">> Login failed for: " + username);
                out.print("{\"status\":\"error\", \"message\":\"Invalid username or password or no access permission\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"status\":\"error\", \"message\":\"System error. Please try again later.\"}");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }
} 