/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.ScheduleDao;
import DAO.TrainerDao;
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
            response.sendRedirect(request.getContextPath() + "/LoginServlet"); // Redirect đến trang đăng nhập nếu không có session
            return;
        }
        System.out.println(trainerId);
        List<TrainerSchedule> schedules = new ArrayList<>();
        List<TrainerBooking> booking = new ArrayList<>();
        // Lấy dữ liệu lịch từ DB theo trainer_id
        try {
            schedules = scheduleDao.getAllTrainerSchedules();
            Trainers trainer = trainerDao.getTrainerDetails(trainerId);
            booking = scheduleDao.getAllBookings();
            // Truyền dữ liệu lịch PT xuống JSP
            request.setAttribute("trainer", trainer);
            request.setAttribute("schedules", new Gson().toJson(schedules));
            request.setAttribute("trainerId", trainerId);
            request.setAttribute("booking", new Gson().toJson(booking));

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

                                    // Đặt lịch cho từng slot
                                    boolean success = scheduleDao.bookTrainerSlot(accountId, trainerId, scheduleId, bookingDate);
                                    if (!success) {
                                        response.sendRedirect("bookingFailed.jsp");
                                        return;
                                    }

                                } catch (NumberFormatException e) {
                                    // Nếu scheduleId không phải là số hợp lệ, bạn có thể log lỗi hoặc thông báo cho người dùng
                                    System.err.println("Lỗi khi chuyển đổi scheduleId: " + scheduleIds[i]);
                                    response.sendRedirect("bookingFailed.jsp");  // Redirect đến trang thất bại
                                    return;
                                }
                            } else {
                                // Nếu scheduleId là chuỗi rỗng, bạn có thể xử lý riêng hoặc bỏ qua
                                response.sendRedirect("bookingFailed.jsp");  // Redirect đến trang thất bại
                                return;
                            }
                        }

                        // Nếu tất cả các lịch đã được đặt thành công, chuyển hướng đến bookingSuccess.jsp
                        response.sendRedirect(request.getContextPath() + "/bookingpt?trainerid=" + trainerId);
                    } else {
                        // Nếu thẻ thành viên đã hết hạn
                        response.sendRedirect(request.getContextPath() +"/AllPackages");
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(BookingPTServlet.class.getName()).log(Level.SEVERE, null, ex);
                    response.sendRedirect("error.jsp");  // Nếu có lỗi, chuyển đến trang lỗi
                }
            } else {
                // Nếu không có lịch nào được chọn
                response.sendRedirect("noSelection.jsp");  // Chuyển hướng đến trang thông báo không có lịch nào được chọn
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
                    response.sendRedirect(request.getContextPath() + "/bookingpt?trainerid=" + trainerId);
                } else {
                    response.sendRedirect("bookingFailed.jsp");  // Thất bại khi hủy
                }
            } catch (SQLException ex) {
                response.sendRedirect("error.jsp");
            }
        }

    }

}
