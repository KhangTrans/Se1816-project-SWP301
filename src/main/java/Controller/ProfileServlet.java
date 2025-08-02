/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.ScheduleDao;
import DAO.profileDao;
import Model.Customer;
import Model.TrainerBooking;
import Model.TrainerSchedule;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;

/**
 *
 * @author PC
 */
@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
@MultipartConfig
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        if (accountId == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet"); // Redirect đến trang đăng nhập nếu không có session
            return;
        }

        profileDao dao = new profileDao();
        ScheduleDao scheduleDao = new ScheduleDao();
        List<TrainerSchedule> schedules = new ArrayList<>();
        List<TrainerBooking> myBookings = null;
        List<TrainerBooking> booking = new ArrayList<>();
        try {
            schedules = scheduleDao.getAllTrainerSchedules();
            List<String> timeSlots = new ArrayList<>();
            for (TrainerSchedule schedule : schedules) {
                String timeSlot = schedule.getStartTime().toString() + " - " + schedule.getEndTime().toString();
                if (!timeSlots.contains(timeSlot)) {
                    timeSlots.add(timeSlot);
                }
            }
            System.out.println(timeSlots);

            Customer customer = dao.getCustomerById(accountId);
            myBookings = scheduleDao.getBookingsByAccountId(accountId);
            booking = scheduleDao.getAllBookings();

            request.setAttribute("customer", customer);
            request.setAttribute("schedules", new Gson().toJson(schedules));
            request.setAttribute("mybooking", new Gson().toJson(myBookings));
            request.setAttribute("booking", new Gson().toJson(booking));
            request.setAttribute("timeSlots", new Gson().toJson(timeSlots));
            System.out.println(myBookings);
            request.getRequestDispatcher("/WEB-INF/View/customers/sidebarprofile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");

        if ("update".equals(action)) {
            updateProfile(request, response);
        } else if ("avatar".equals(action)) {
            updateAvatar(request, response, accountId);
        } else if ("changepassword".equals(action)) {
            changePassword(request, response, accountId);  // Thêm xử lý đổi mật khẩu
        } else if ("cancel".equals(action)) {
            // Handle cancel action
            try {
                String bookingIdStr = request.getParameter("bookingId");  // Lấy bookingId từ request
                System.out.println(bookingIdStr);
                int bookingId = Integer.parseInt(bookingIdStr);
                ScheduleDao scheduleDao = new ScheduleDao();

                // Gọi hàm hủy booking
                boolean success = scheduleDao.cancelTrainerSlot(bookingId);

                if (success) {
                    request.getSession().setAttribute("notificationMessage", "Booking successfully canceled");
                } else {
                    request.getSession().setAttribute("notificationMessage", "Booking fail canceled");
                }
                response.sendRedirect(request.getContextPath() + "/profile?tab=schedule");
            } catch (SQLException ex) {
                response.sendRedirect("error.jsp");
            }
        }

    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response, int accountId) throws IOException {
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra mật khẩu mới và xác nhận mật khẩu có khớp không
        if (!newPassword.equals(confirmPassword)) {
            request.getSession().setAttribute("changePasswordError", "Failed to change password.");
            response.sendRedirect(request.getContextPath() + "/profile?tab=changepassword");
            return;
        }

        // Gọi phương thức thay đổi mật khẩu từ UserDao
        profileDao dao = new profileDao();
        try {
            boolean isUpdated = dao.changePassword(accountId, oldPassword, newPassword);
            if (isUpdated) {
                request.getSession().setAttribute("changePasswordSuccess", "Password changed successfully!");
                response.sendRedirect(request.getContextPath() + "/profile?tab=changepassword");
            } else {
                request.getSession().setAttribute("changePasswordError", "Failed to change password.");
                response.sendRedirect(request.getContextPath() + "/profile?tab=changepassword");
            }

            // Redirect to profile
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("Database error: " + e.getMessage());
        }

    }

    // Cập nhật profile
    private void updateProfile(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String cusIdP = request.getParameter("cusId");
            String fullName = request.getParameter("name");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String email = request.getParameter("email");

            int cusId = Integer.parseInt(cusIdP);

            profileDao dao = new profileDao();

            Customer customer = new Customer();
            customer.setCustomerId(cusId);
            customer.setFullName(fullName);
            customer.setPhone(phone);
            customer.setAddress(address);
            customer.setEmail(email);

            boolean isUpdated = dao.updateCustomer(customer);

            if (isUpdated) {
                request.getSession().setAttribute("updateSuccess", "Profile updated successfully!");
            } else {
                request.getSession().setAttribute("updateError", "Failed to update profile.");
            }

            response.sendRedirect(request.getContextPath() + "/profile");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error: " + e.getMessage());
        }
    }

    // Cập nhật avatar
    private void updateAvatar(HttpServletRequest request, HttpServletResponse response, int accountId) throws IOException {
        try {
            Part avatarPart = request.getPart("avatar");
            System.out.println("File name: " + avatarPart.getSubmittedFileName());
            System.out.println("File size: " + avatarPart.getSize());

            if (avatarPart != null && avatarPart.getSize() > 0) {
                InputStream avatarStream = avatarPart.getInputStream();
                profileDao dao = new profileDao();
                dao.updateAvatar(accountId, avatarStream);

                response.sendRedirect(request.getContextPath() + "/profile");
            } else {
                response.getWriter().write("No file uploaded");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Failed to upload avatar.");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for managing user profile, including updating profile and avatar.";
    }
}
