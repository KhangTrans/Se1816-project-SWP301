package Controller;

import DAO.ScheduleDao;
import DAO.TrainerDao;
import Model.Account;
import Model.Customer;
import Model.SlotAvailability;
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
import java.sql.Date;
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
        List<SlotAvailability> slotAvailability = new ArrayList<>();
        if (trainer != null) {
            try {
                booking = scheduleDao.getAllBookingByTrainerId(trainer.getTrainerId());
                schedules = scheduleDao.getAllTrainerSchedules();
                slotAvailability = scheduleDao.getSlotAvailabilityByTrainerId(trainer.getTrainerId());
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
                request.setAttribute("slotAvailability", new Gson().toJson(slotAvailability));
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ScheduleDao scheduleDao = new ScheduleDao();
        String action = request.getParameter("action");
        System.out.println(action);
        if ("confirm".equals(action)) {
            try {
                String bookingIdStr = request.getParameter("bookingId");
                System.out.println(bookingIdStr);

                // Kiểm tra nếu bookingIdStr không hợp lệ
                if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
                    int bookingId = Integer.parseInt(bookingIdStr);
                    scheduleDao.confirmBooking(bookingId);
                    response.sendRedirect(request.getContextPath() + "/trainer/dashboard");
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid booking ID");
                }
            } catch (SQLException ex) {
                response.sendRedirect("error.jsp");
            } catch (NumberFormatException ex) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid booking ID format");
            }
        }else if("cancel".equals(action)){
            try {
                String bookingIdStr = request.getParameter("bookingId");
                System.out.println(bookingIdStr);

                // Kiểm tra nếu bookingIdStr không hợp lệ
                if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
                    int bookingId = Integer.parseInt(bookingIdStr);
                    scheduleDao.cancelBooking(bookingId);
                    response.sendRedirect(request.getContextPath() + "/trainer/dashboard");
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid booking ID");
                }
            } catch (SQLException ex) {
                response.sendRedirect("error.jsp");
            } catch (NumberFormatException ex) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid booking ID format");
            }
        }else if ("update".equals(action)) {  // Xử lý cập nhật trạng thái ON/OFF của lịch
            try {
                String trainerIdStr = request.getParameter("trainerId");
                String[] scheduleIds = request.getParameterValues("scheduleId[]");
                String[] slotStatuses = request.getParameterValues("slotStatus[]");
                String[] bookingDates = request.getParameterValues("bookingDate[]");

                if (scheduleIds != null && slotStatuses != null && bookingDates != null && trainerIdStr != null) {
                    int trainerId = Integer.parseInt(trainerIdStr);

// Lặp qua từng slot để cập nhật trạng thái
                    for (int i = 0; i < scheduleIds.length; i++) {
                        int scheduleId = Integer.parseInt(scheduleIds[i]);
                        boolean status = Boolean.parseBoolean(slotStatuses[i]);
                        Date bookingDate = Date.valueOf(bookingDates[i]);

                        // Cập nhật trạng thái của slot trong cơ sở dữ liệu
                        boolean updated = scheduleDao.insertUpdateSlotAvailability(scheduleId, trainerId, bookingDate, status);
                        if (!updated) {
                            response.sendRedirect("error.jsp");
                            return;
                        }
                    }
                    response.sendRedirect(request.getContextPath() + "/trainer/dashboard");  // Quay lại dashboard
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
                }
            } catch (NumberFormatException ex) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid schedule ID format");
            }
        }
    }

}
