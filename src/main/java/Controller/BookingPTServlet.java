/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.ScheduleDao;
import DAO.TrainerDao;
import Model.SlotAvailability;
import Model.TrainerBooking;
import Model.TrainerSchedule;
import Model.Trainers;
import com.google.gson.Gson;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author PC
 */
@WebServlet(name = "BookingPTServlet", urlPatterns = {"/bookingpt"})
public class BookingPTServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String trainerIdStr = request.getParameter("trainerid");
        int trainerId = Integer.parseInt(trainerIdStr);
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        System.out.println(accountId);
        TrainerDao trainerDao = new TrainerDao();
        ScheduleDao scheduleDao = new ScheduleDao();
        if (accountId == null) {
            response.sendRedirect(request.getContextPath() + "/homepage"); // Redirect đến trang đăng nhập nếu không có session
            return;
        }
        System.out.println(trainerId);
        List<TrainerSchedule> schedules = new ArrayList<>();
        List<TrainerBooking> booking = new ArrayList<>();
        List<SlotAvailability> slotAvailability = new ArrayList<>();

        // Lấy dữ liệu lịch từ DB theo trainer_id
        try {
            schedules = scheduleDao.getAllTrainerSchedules();
            Trainers trainer = trainerDao.getTrainerDetails(trainerId);
            booking = scheduleDao.getAllBookingByTrainerId(trainerId);
//            booking = scheduleDao.getAllBookings();
            slotAvailability = scheduleDao.getSlotAvailabilityByTrainerId(trainer.getTrainerId());
            // Truyền dữ liệu lịch PT xuống JSP
            request.setAttribute("trainer", trainer);
            request.setAttribute("schedules", new Gson().toJson(schedules));
            request.setAttribute("trainerId", trainerId);
            request.setAttribute("booking", new Gson().toJson(booking));
            request.setAttribute("slotAvailability", new Gson().toJson(slotAvailability));
            // Truyền các slot thời gian
            List<String> timeSlots = new ArrayList<>();
            for (TrainerSchedule schedule : schedules) {
                String timeSlot = schedule.getStartTime().toString() + " - " + schedule.getEndTime().toString();
                if (!timeSlots.contains(timeSlot)) {
                    timeSlots.add(timeSlot);
                }
            }
            request.setAttribute("timeSlots", new Gson().toJson(timeSlots));

            // Lấy thông tin các slot đã bị book (các slot trong tuần)
            Map<String, Boolean> bookedSlots = scheduleDao.getBookedSlotsForWeek(trainerId);
            request.setAttribute("bookedSlots", new Gson().toJson(bookedSlots));

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/View/customers/bookPT.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String trainerIdStr = request.getParameter("trainerId");

        if (trainerIdStr == null || trainerIdStr.trim().isEmpty()) {
            response.sendRedirect("error.jsp");  // Redirect to an error page or handle appropriately
            return;
        }
        ScheduleDao scheduleDao = new ScheduleDao();
        TrainerDao trainerDao = new TrainerDao();

        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        int trainerId = Integer.parseInt(trainerIdStr);
        String action = request.getParameter("action");
        Trainers trainer = trainerDao.getTrainerDetails(trainerId);

        if ("book".equals(action)) {
            String[] scheduleIds = request.getParameterValues("scheduleId[]");
            String[] bookingDates = request.getParameterValues("bookingDate[]");
            // Kiểm tra xem người dùng đã chọn lịch nào chưa
            if (scheduleIds != null && bookingDates != null) {

                try {
                    // Kiểm tra xem thẻ thành viên có còn hiệu lực hay không
                    if (scheduleDao.isMembershipActive(accountId)) {

                        for (int i = 0; i < scheduleIds.length; i++) {
                            // Kiểm tra nếu scheduleId không phải là chuỗi rỗng
                            if (scheduleIds[i] != null && !scheduleIds[i].trim().isEmpty()) {
                                try {
                                    int scheduleId = Integer.parseInt(scheduleIds[i]);
                                    Date bookingDate = Date.valueOf(bookingDates[i]);  // Chuyển đổi chuỗi thành Date
                                    // Kiểm tra xem người dùng đã có booking cho slot này hay chưa
                                    List<TrainerBooking> existingBookings = scheduleDao.getAllBookings();
                                    for (TrainerBooking check : existingBookings) {
                                        // Kiểm tra xem booking có cùng scheduleId và bookingDate và trạng thái là "confirmed" hoặc "pending"
                                        boolean m = check.getBookingDate().toString().equals(bookingDate.toString());
                                        System.out.println(m);
                                        if (check.getCustomer().getAccount().getAccountId() == accountId && check.getScheduleId() == scheduleId
                                                && check.getBookingDate().toString().equals(bookingDate.toString())
                                                && ("confirmed".equalsIgnoreCase(check.getStatus())
                                                || "pending".equalsIgnoreCase(check.getStatus()))) {
                                            // Nếu đã có booking cho slot này, ngừng việc đặt lịch
                                            // Đặt vào session
                                            request.getSession().setAttribute("notificationMessage", "You already have a booking for this slot.");
                                            response.sendRedirect(request.getContextPath() + "/bookingpt?trainerid=" + trainerId);

                                            return;
                                        }

                                    }

                                    // Đặt lịch cho từng slot
                                    boolean success = scheduleDao.bookTrainerSlot(accountId, trainerId, scheduleId, bookingDate);
                                    if (!success) {
                                        request.getSession().setAttribute("notificationMessage", "Booking failed");
                                        response.sendRedirect(request.getContextPath() + "/bookingpt?trainerid=" + trainerId);
                                        return;
                                    }

                                } catch (NumberFormatException e) {
                                    request.getSession().setAttribute("notificationMessage", "Booking failed");
                                    response.sendRedirect(request.getContextPath() + "/bookingpt?trainerid=" + trainerId); // Redirect đến trang thất bại
                                    return;
                                }
                            } else {
                                request.getSession().setAttribute("notificationMessage", "Booking failed");
                                response.sendRedirect(request.getContextPath() + "/bookingpt?trainerid=" + trainerId);
                                return;
                            }
                        }

                        request.getSession().setAttribute("notificationMessage", "Pending confirmation");
                        response.sendRedirect(request.getContextPath() + "/bookingpt?trainerid=" + trainerId);
                    } else {
                        // Nếu thẻ thành viên đã hết hạn
                        response.sendRedirect(request.getContextPath() + "/AllPackages");
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(BookingPTServlet.class.getName()).log(Level.SEVERE, null, ex);
                    response.sendRedirect(request.getContextPath() + "/bookingpt?trainerid=" + trainerId);
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/bookingpt?trainerid=" + trainerId);
            }
        } else if ("cancel".equals(action)) {
            // Handle cancel action
            try {
                String bookingIdStr = request.getParameter("bookingId");  // Lấy bookingId từ request
                System.out.println(bookingIdStr);
                int bookingId = Integer.parseInt(bookingIdStr);

                // Gọi hàm hủy booking
                boolean success = scheduleDao.cancelTrainerSlot(bookingId);

                if (success) {
                    request.getSession().setAttribute("notificationMessage", "Booking successfully canceled");
                } else {
                    request.getSession().setAttribute("notificationMessage", "Booking fail canceled");
                }
                response.sendRedirect(request.getContextPath() + "/bookingpt?trainerid=" + trainerId);
            } catch (SQLException ex) {
                response.sendRedirect("error.jsp");
            }
        }

    }

}
