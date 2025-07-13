package Controller;

import DAO.ScheduleDao;
import DAO.TrainerDao;
import Model.Account;
import Model.Customer;
import Model.TrainerBooking;
import Model.TrainerSchedule;
import Model.Trainers;
import com.google.gson.Gson;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "TrainerDashboardServlet", urlPatterns = {"/trainer/dashboard"})
public class TrainerDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the session and check if the user is logged in as a trainer
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null || !"trainer".equals(account.getRole())) {
            // If not logged in as trainer, redirect to login page
            response.sendRedirect(request.getContextPath() + "/loginTrainer");
            return;
        }

        // Fetch trainer information using TrainerDao
        TrainerDao trainerDao = new TrainerDao();
        ScheduleDao scheduleDao = new ScheduleDao();

        Trainers trainer = trainerDao.getTrainerByAccountId(account.getAccountId());
        List<TrainerBooking> booking = new ArrayList<>();
        List<String> timeSlots = new ArrayList<>();
        List<TrainerSchedule> schedules = new ArrayList<>();
        if (trainer != null) {
            try {
                booking = scheduleDao.getAllBookingByTrainerId(trainer.getTrainerId());
                schedules = scheduleDao.getAllTrainerSchedules();
                for (TrainerSchedule schedule : schedules) {
                    String timeSlot = schedule.getStartTime().toString() + " - " + schedule.getEndTime().toString();
                    if (!timeSlots.contains(timeSlot)) {
                        timeSlots.add(timeSlot);
                    }
                }
                // Set trainer information as request attribute
                request.setAttribute("booking", new Gson().toJson(booking));
                request.setAttribute("trainer", trainer);
                request.setAttribute("schedules", new Gson().toJson(schedules));
                request.setAttribute("trainerJ", new Gson().toJson(trainer));
                request.setAttribute("timeSlots", new Gson().toJson(timeSlots));
                System.out.println("Trainer found: " + trainer.getFullName());
            } catch (SQLException ex) {
                Logger.getLogger(TrainerDashboardServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else {
            System.out.println("No trainer data found for account ID: " + account.getAccountId());
        }

        // Forward to the dashboard JSP page
        request.getRequestDispatcher("/WEB-INF/View/trainer/dashboard.jsp").forward(request, response);
    }
}
