package Controller;

import DAO.TrainerDao;
import DAO.UserDao;
import Model.Account;
import Model.Trainers;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "TrainerChangePasswordServlet", urlPatterns = {"/TrainerChangePasswordServlet"})
public class TrainerChangePasswordServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            HttpSession session = request.getSession();
            Account account = (Account) session.getAttribute("account");
            
            if (account == null || !"trainer".equals(account.getRole())) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Not logged in as trainer");
                out.print(jsonResponse.toString());
                return;
            }
            
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            
            System.out.println("Trainer password change attempt for account ID: " + account.getAccountId());
            
            // Get trainer from database to check current password
            TrainerDao trainerDao = new TrainerDao();
            Account dbAccount = trainerDao.getTrainerAccountById(account.getAccountId());
            
            if (dbAccount == null) {
                System.out.println("Failed to retrieve account from database");
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Account not found in database");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Hash the current password with MD5 to check against stored password
            String hashedCurrentPassword = UserDao.hashMD5(currentPassword);
            
            System.out.println("Stored password: " + dbAccount.getPassword());
            System.out.println("Hashed current password: " + hashedCurrentPassword);
            
            // Check if current password is correct
            if (!hashedCurrentPassword.equals(dbAccount.getPassword())) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Current password is incorrect");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Hash the new password with MD5
            String hashedNewPassword = UserDao.hashMD5(newPassword);
            System.out.println("New hashed password: " + hashedNewPassword);
            
            // Update password in database
            boolean updated = trainerDao.updateAccountPassword(account.getAccountId(), hashedNewPassword);
            
            if (updated) {
                // Update the session account's password to reflect the change
                account.setPassword(hashedNewPassword);
                session.setAttribute("account", account);
                System.out.println("Password updated successfully in database and session");
                
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Password updated successfully");
            } else {
                System.out.println("Failed to update password in database");
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Failed to update password");
            }
            
        } catch (Exception e) {
            System.out.println("Error in TrainerChangePasswordServlet: " + e.getMessage());
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Error: " + e.getMessage());
        }
        
        out.print(jsonResponse.toString());
        out.flush();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("loginTrainer");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Trainer Change Password Servlet";
    }
} 