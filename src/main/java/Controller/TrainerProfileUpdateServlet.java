package Controller;

import DAO.TrainerDao;
import Model.Account;
import Model.Trainers;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import org.json.JSONObject;

@WebServlet(name = "TrainerProfileUpdateServlet", urlPatterns = {"/trainer/update-profile"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 30 // 30 MB
)
public class TrainerProfileUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject json = new JSONObject();
        
        // Check if user is logged in as trainer
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null || !"trainer".equals(account.getRole())) {
            json.put("status", "error");
            json.put("message", "Unauthorized access");
            out.print(json.toString());
            return;
        }
        
        try {
            // Get form parameters
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            int experienceYears = Integer.parseInt(request.getParameter("experienceYears"));
            int trainerId = Integer.parseInt(request.getParameter("trainerId"));
            boolean avatarChanged = Boolean.parseBoolean(request.getParameter("avatarChanged"));
            
            // Get current trainer information
            TrainerDao trainerDao = new TrainerDao();
            Trainers trainer = trainerDao.getTrainerByAccountId(account.getAccountId());
            
            if (trainer == null || trainer.getTrainerId() != trainerId) {
                json.put("status", "error");
                json.put("message", "Invalid trainer data");
                out.print(json.toString());
                return;
            }
            
            // Process avatar upload if changed
            InputStream avatarStream = null;
            if (avatarChanged) {
                Part filePart = request.getPart("avatar");
                if (filePart != null && filePart.getSize() > 0) {
                    avatarStream = filePart.getInputStream();
                }
            }
            
            // Update trainer information
            trainer.setFullName(fullName);
            trainer.setEmail(email);
            trainer.setPhone(phone);
            trainer.setExperienceYears(experienceYears);
            
            // Save changes to database
            boolean updated = trainerDao.updateTrainerWithAvatar(trainer, avatarStream);
            
            if (updated) {
                json.put("status", "success");
                json.put("message", "Profile updated successfully");
            } else {
                json.put("status", "error");
                json.put("message", "Failed to update profile");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            json.put("status", "error");
            json.put("message", "An error occurred: " + e.getMessage());
        }
        
        out.print(json.toString());
    }
} 