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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.JSONObject;

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

                // Kiểm tra nếu là request AJAX
                String requestedWith = request.getHeader("X-Requested-With");
                if ("XMLHttpRequest".equals(requestedWith)) {
                    // Trả về JSON cho AJAX
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    Map<String, Object> jsonResponse = new HashMap<>();
                    jsonResponse.put("booking", booking); // Trả về danh sách booking
                    jsonResponse.put("timeSlots", timeSlots);
                    jsonResponse.put("schedules", schedules);
                    jsonResponse.put("slotAvailability", slotAvailability);
                    jsonResponse.put("trainer", trainer);
                    new Gson().toJson(jsonResponse, response.getWriter());
                    return; // Kết thúc request, không forward
                } else {
                    // Set trainer information as request attribute cho JSP
                    request.setAttribute("booking", new Gson().toJson(booking));
                    request.setAttribute("trainer", trainer);
                    request.setAttribute("schedules", new Gson().toJson(schedules));
                    request.setAttribute("trainerJ", new Gson().toJson(trainer));
                    request.setAttribute("timeSlots", new Gson().toJson(timeSlots));
                    request.setAttribute("slotAvailability", new Gson().toJson(slotAvailability));
                    System.out.println("Trainer found: " + trainer.getFullName());
                }
            } catch (SQLException ex) {
                Logger.getLogger(TrainerDashboardServlet.class.getName()).log(Level.SEVERE, null, ex);

            }
        } else {
            System.out.println("No trainer data found for account ID: " + account.getAccountId());
        }

        // Forward to the dashboard JSP page cho request thông thường
        request.getRequestDispatcher("/WEB-INF/View/trainer/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ScheduleDao scheduleDao = new ScheduleDao();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Debug: In tất cả các tham số nhận được
        System.out.println("All parameters: " + request.getParameterMap());
        String action = request.getParameter("action");
        String bookingIdStr = request.getParameter("bookingId");
        System.out.println("Action: " + action);
        System.out.println("BookingId: " + bookingIdStr);
        JSONObject jsonResponse = new JSONObject();

        if ("confirm".equals(action)) {
//            String bookingIdStr = request.getParameter("bookingId");
            if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
                try {
                    int bookingId = Integer.parseInt(bookingIdStr);
                    System.out.println("Confirming booking ID: " + bookingId);
                    boolean check = scheduleDao.confirmBooking(bookingId);
                    System.out.println(check);
                    if (check) {
                        jsonResponse.put("status", "success");
                        jsonResponse.put("message", "Booking confirmed successfully.");
                    } else {
                        System.out.println("fail");
                    }
                } catch (SQLException ex) {
                    jsonResponse.put("status", "error");
                    jsonResponse.put("message", "Error confirming booking.");
                }
            } else {
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "Invalid booking ID.");
            }
            System.out.println("Response: " + jsonResponse.toString());
            // Send JSON response instead of redirect
            response.getWriter().write(jsonResponse.toString());
        } else if ("cancel".equals(action)) {
            try {
                // Kiểm tra nếu bookingIdStr không hợp lệ
                if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
                    int bookingId = Integer.parseInt(bookingIdStr);
                    scheduleDao.cancelBooking(bookingId);
                    jsonResponse.put("status", "success");
                    jsonResponse.put("message", "Booking cancel successfully.");
                } else {
                    jsonResponse.put("status", "error");
                    jsonResponse.put("message", "Error cancel booking.");
                }
            } catch (SQLException ex) {
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "Error cancel booking.");
            }
            response.getWriter().write(jsonResponse.toString());
        } else if ("update".equals(action)) {  // Xử lý cập nhật trạng thái ON/OFF của lịch
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
                            jsonResponse.put("status", "error");
                            jsonResponse.put("message", "Error cancel booking.");
                            return;
                        }
                    }
                    jsonResponse.put("status", "success");
                    jsonResponse.put("message", "Slot updated successfully");

                } else {
                    jsonResponse.put("status", "error");
                    jsonResponse.put("message", "Error cancel booking.");
                }
            } catch (NumberFormatException ex) {
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "Error cancel booking.");
            }
            response.getWriter().write(jsonResponse.toString());
        }
    }

}
