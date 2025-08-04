/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Account;
import Model.Customer;
import Model.SlotAvailability;
import Model.TrainerBooking;
import Model.TrainerSchedule;
import Model.Trainers;
import db.DBcontext;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author PC
 */
public class ScheduleDao extends DBcontext {

    public boolean isMembershipActive(int accountId) throws SQLException {
        String sql = "SELECT 1 FROM customer_memberships cm "
                + "JOIN membership_packages mp ON cm.package_id = mp.package_id "
                + "WHERE cm.account_id = ? "
                + "AND mp.is_active = 1 "
                + "AND GETDATE() BETWEEN cm.start_date AND cm.end_date";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);  // Set accountId vào câu lệnh SQL
            try ( ResultSet rs = ps.executeQuery()) {
                return rs.next();  // Nếu có kết quả, nghĩa là thẻ thành viên còn hiệu lực
            }
        } catch (SQLException e) {
            // Log lỗi (hoặc thông báo tùy theo yêu cầu của bạn)
            throw new SQLException("Error checking membership status: " + e.getMessage(), e);
        }
    }

    public boolean isSlotAvailable(int scheduleId, Date bookingDate) throws SQLException {
        String sql = "SELECT 1 FROM trainer_bookings WHERE schedule_id = ? AND booking_date = ? AND status = 'confirmed'";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            ps.setDate(2, bookingDate);  // Sử dụng kiểu java.sql.Date trực tiếp
            try ( ResultSet rs = ps.executeQuery()) {
                return !rs.next();  // Nếu không có kết quả, tức là slot trống, có thể book
            }
        } catch (SQLException e) {
            // Log lỗi hoặc xử lý lỗi nếu cần
            throw new SQLException("Error checking slot availability: " + e.getMessage(), e);
        }
    }

    // Book slot PT nếu slot trống
    public boolean bookTrainerSlot(int accountId, int trainerId, int scheduleId, Date bookingDate) throws SQLException {
        // Kiểm tra slot đã tồn tại và có trạng thái cancelled không
        String checkSql = "SELECT booking_id, status FROM trainer_bookings WHERE schedule_id = ? AND booking_date = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setInt(1, scheduleId);
            ps.setDate(2, new java.sql.Date(bookingDate.getTime()));
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String status = rs.getString("status");
                int bookingId = rs.getInt("booking_id");
                if ("cancelled".equalsIgnoreCase(status)) {
                    // Nếu slot đã bị hủy thì update lại thành confirmed
                    String updateSql = "UPDATE trainer_bookings SET status = 'pending', account_id = ?, trainer_id = ? WHERE booking_id = ?";
                    try ( PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                        updatePs.setInt(1, accountId);
                        updatePs.setInt(2, trainerId);
                        updatePs.setInt(3, bookingId);
                        int rows = updatePs.executeUpdate();
                        return rows > 0;
                    }
                } else {
                    // Nếu đã confirmed thì báo lỗi
                    throw new SQLException("Slot is already booked for the selected date.");
                }
            } else {
                // Nếu chưa tồn tại thì insert mới
                String insertSql = "INSERT INTO trainer_bookings (account_id, trainer_id, schedule_id, booking_date, status) VALUES (?, ?, ?, ?, 'pending')";
                try ( PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                    insertPs.setInt(1, accountId);
                    insertPs.setInt(2, trainerId);
                    insertPs.setInt(3, scheduleId);
                    insertPs.setDate(4, new java.sql.Date(bookingDate.getTime()));
                    int rows = insertPs.executeUpdate();
                    return rows > 0;
                }
            }
        }
    }

    public List<TrainerSchedule> getAllTrainerSchedules() throws SQLException {
        List<TrainerSchedule> schedules = new ArrayList<>();

        // Truy vấn dữ liệu các lịch của PT theo trainer_id
        String sql = "SELECT schedule_id, weekday, start_time, end_time, is_available "
                + "FROM trainer_schedules";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TrainerSchedule schedule = new TrainerSchedule();
                    schedule.setScheduleId(rs.getInt("schedule_id"));
                    schedule.setWeekday(rs.getString("weekday"));
                    schedule.setStartTime(rs.getTime("start_time").toLocalTime());
                    schedule.setEndTime(rs.getTime("end_time").toLocalTime());
                    schedule.setAvailable(rs.getBoolean("is_available"));
                    schedules.add(schedule);  // Thêm vào danh sách
                }
            }
        }
        return schedules;
    }

    public Trainers getTrainerById(int trainerId) {
        Trainers trainer = null;
        String sql = "SELECT t.*, a.* FROM trainers t JOIN accounts a ON t.account_id = a.account_id WHERE t.trainer_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, trainerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                trainer = new Trainers();
                trainer.setTrainerId(rs.getInt("trainer_id"));
                trainer.setFullName(rs.getString("full_name"));
                trainer.setEmail(rs.getString("email"));
                trainer.setPhone(rs.getString("phone"));
                trainer.setBio(rs.getString("bio"));
                trainer.setExperienceYears(rs.getInt("experience_years"));
                trainer.setRating(rs.getFloat("rating"));
                trainer.setTrainer_code(rs.getString("trainer_code"));

                // Lấy object Account
                Account acc = new Account();
                acc.setAccountId(rs.getInt("account_id"));
                acc.setUsername(rs.getString("username"));
                // ... nếu cần set thêm field
                trainer.setAccountId(acc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return trainer;
    }

    public Map<String, Boolean> getBookedSlotsForWeek(int trainerId) throws SQLException {
        Map<String, Boolean> bookedSlots = new HashMap<>();

        // SQL query lấy schedule_id, booking_date và trạng thái availability của các slot
        String sql = "SELECT ts.schedule_id, ts.is_available, tb.booking_date "
                + "FROM trainer_schedules ts "
                + "LEFT JOIN trainer_bookings tb ON ts.schedule_id = tb.schedule_id "
                + "WHERE tb.trainer_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, trainerId);  // Gắn trainerId vào câu lệnh SQL

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int scheduleId = rs.getInt("schedule_id");
                    String bookingDate = rs.getDate("booking_date") != null ? rs.getDate("booking_date").toString() : null;
                    boolean isAvailable = rs.getBoolean("is_available");  // Lấy trạng thái slot có sẵn

                    // Lưu vào Map chỉ dựa trên trạng thái is_available
                    bookedSlots.put(scheduleId + "_" + bookingDate, isAvailable);
                }
            }
        }
        return bookedSlots;
    }

    public int getIdTrainerbyAccountId(int accountId) {
        String sql = "select trainer_id from [dbo].[trainers] where account_id = ?";
        int trainerId = -1;
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                trainerId = rs.getInt("trainer_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return trainerId;
    }

    public boolean cancelTrainerSlot(int bookingId) throws SQLException {
        String sql = "UPDATE trainer_bookings SET status = 'cancelled' WHERE booking_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;  // Trả về true nếu hủy thành công
        }
    }

    public List<TrainerBooking> getAllBookings() throws SQLException {
        List<TrainerBooking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM trainer_bookings";  // Câu lệnh SQL để lấy tất cả bản ghi từ bảng trainer_booking

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TrainerBooking booking = new TrainerBooking();
                    booking.setBookingId(rs.getInt("booking_id"));
                    Trainers trainer = getTrainerById(rs.getInt("trainer_id"));
                    Customer customer = getCustomerById(rs.getInt("account_id"));
                    booking.setCustomer(customer);
                    booking.setTrainer(trainer);
                    booking.setScheduleId(rs.getInt("schedule_id"));
                    booking.setBookingDate(rs.getDate("booking_date").toLocalDate());
                    booking.setStatus(rs.getString("status"));
                    bookings.add(booking);  // Thêm vào danh sách bookings
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();  // Xử lý lỗi
        }
        return bookings;  // Trả về danh sách các booking
    }

    public Customer getCustomerById(int accountId) {
        Customer customer = null;
        String query = "SELECT * FROM customers WHERE account_id = ?"; // sửa
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, accountId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    customer = new Customer();
                    customer.setCustomerId(rs.getInt("customer_id"));
                    Account acc = getAccountById(rs.getInt("account_id"));
                    customer.setAccount(acc);
                    customer.setFullName(rs.getString("full_name"));
                    customer.setEmail(rs.getString("email"));
                    customer.setPhone(rs.getString("phone"));
                    customer.setCustomerCode(rs.getString("customer_code"));
                    customer.setAddress(rs.getString("address"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customer;
    }

    public Account getAccountById(int accountId) {
        Account account = null;
        String sql = "SELECT account_id, username FROM accounts WHERE account_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accountId);  // Gán giá trị accountId vào câu lệnh SQL

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    account = new Account();  // Tạo đối tượng Account mới
                    account.setAccountId(rs.getInt("account_id"));
                    account.setUsername(rs.getString("username"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();  // Log lỗi nếu có
        }

        return account;  // Trả về đối tượng Account (hoặc null nếu không tìm thấy)
    }

    public List<TrainerBooking> getBookingsByAccountId(int accountId) throws SQLException {
        List<TrainerBooking> bookings = new ArrayList<>();
        String sql = "SELECT tb.booking_id, tb.trainer_id, tb.booking_date, tb.status, "
                + "ts.start_time, ts.end_time, t.full_name AS trainer_name "
                + "FROM trainer_bookings tb "
                + "JOIN trainer_schedules ts ON tb.schedule_id = ts.schedule_id "
                + "JOIN trainers t ON tb.trainer_id = t.trainer_id "
                + "WHERE tb.account_id = ? AND tb.status IN ('confirmed', 'pending')"
                + "ORDER BY tb.booking_date "; // Sắp xếp theo ngày booking

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TrainerBooking booking = new TrainerBooking();
                    Trainers trainer = getTrainerById(rs.getInt("trainer_id"));
                    TrainerSchedule schedule = new TrainerSchedule();

                    booking.setBookingId(rs.getInt("booking_id"));
                    booking.setTrainer(trainer);
                    booking.setBookingDate(rs.getDate("booking_date").toLocalDate());
                    booking.setStatus(rs.getString("status"));

                    // Set thông tin huấn luyện viên
                    trainer.setFullName(rs.getString("trainer_name"));

                    // Set thông tin lịch tập
                    schedule.setStartTime(rs.getTime("start_time").toLocalTime());
                    bookings.add(booking);
                }
            }
        }
        return bookings;
    }

    public List<TrainerBooking> getAllBookingByTrainerId(int trainerId) throws SQLException {
        List<TrainerBooking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM trainer_bookings WHERE trainer_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, trainerId);  // Gán giá trị trainerId vào câu lệnh SQL

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TrainerBooking booking = new TrainerBooking();
                    booking.setBookingId(rs.getInt("booking_id"));

                    // Lấy Trainer và Customer liên quan
                    Trainers trainer = getTrainerById(rs.getInt("trainer_id"));
                    Customer customer = getCustomerById(rs.getInt("account_id"));

                    // Gán thông tin
                    booking.setTrainer(trainer);
                    booking.setCustomer(customer);
                    booking.setScheduleId(rs.getInt("schedule_id"));
                    booking.setBookingDate(rs.getDate("booking_date").toLocalDate());
                    booking.setStatus(rs.getString("status"));

                    bookings.add(booking);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;  // Nên ném lại exception để lớp gọi xử lý nếu cần
        }

        return bookings;
    }

    public boolean confirmBooking(int bookingId) throws SQLException {
        String sql = "UPDATE trainer_bookings SET status = 'confirmed' WHERE booking_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error confirming booking: " + e.getMessage());
            return false;
        }
    }

    public boolean insertUpdateSlotAvailability(int scheduleId, int trainerId, Date slotDate, boolean isAvailable) {
        // SQL để kiểm tra xem bản ghi đã tồn tại chưa
        String checkSql = "SELECT COUNT(*) FROM trainer_slot_availability WHERE schedule_id = ? AND trainer_id = ? AND slot_date = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(checkSql)) {
            // Set các tham số cho câu lệnh SQL
            ps.setInt(1, scheduleId);
            ps.setInt(2, trainerId);
            ps.setDate(3, slotDate);

            // Thực hiện truy vấn và kiểm tra số lượng bản ghi
            ResultSet rs = ps.executeQuery();
            rs.next();
            int count = rs.getInt(1);

            // Nếu bản ghi đã tồn tại, thực hiện cập nhật
            if (count > 0) {
                String updateSql = "UPDATE trainer_slot_availability SET is_available = ? WHERE schedule_id = ? AND trainer_id = ? AND slot_date = ?";
                try ( PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                    updatePs.setBoolean(1, isAvailable);
                    updatePs.setInt(2, scheduleId);
                    updatePs.setInt(3, trainerId);
                    updatePs.setDate(4, slotDate);

                    int rowsAffected = updatePs.executeUpdate();
                    return rowsAffected > 0;  // Trả về true nếu cập nhật thành công
                }
            } else {
                // Nếu bản ghi chưa tồn tại, thực hiện chèn mới
                String insertSql = "INSERT INTO trainer_slot_availability (schedule_id, trainer_id, slot_date, is_available) VALUES (?, ?, ?, ?)";
                try ( PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                    insertPs.setInt(1, scheduleId);
                    insertPs.setInt(2, trainerId);
                    insertPs.setDate(3, slotDate);
                    insertPs.setBoolean(4, isAvailable);

                    int rowsAffected = insertPs.executeUpdate();
                    return rowsAffected > 0;  // Trả về true nếu chèn thành công
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();  // In ra lỗi nếu có
            return false;  // Trả về false nếu có lỗi
        }
    }

    public List<SlotAvailability> getSlotAvailabilityByTrainerId(int trainerId) {
        List<SlotAvailability> slotAvailabilityList = new ArrayList<>();
        String sql = "SELECT * FROM trainer_slot_availability WHERE trainer_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, trainerId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SlotAvailability slot = new SlotAvailability();
                slot.setAvailabilityId(rs.getInt("availability_id"));
                slot.setScheduleId(rs.getInt("schedule_id"));

                Trainers trainer = getTrainerById(rs.getInt("trainer_id"));
                slot.setTrainer(trainer);
                slot.setSlotDate(rs.getDate("slot_date").toLocalDate());
                slot.setIsAvailable(rs.getBoolean("is_available"));
                slotAvailabilityList.add(slot);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return slotAvailabilityList;
    }

    public boolean cancelBooking(int bookingId) throws SQLException {
        String sql = "UPDATE trainer_bookings SET status = 'cancelled' WHERE booking_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error confirming booking: " + e.getMessage());
            return false;
        }
    }

    public static void main(String[] args) throws SQLException {
        ScheduleDao dao = new ScheduleDao();
        List<TrainerSchedule> list = dao.getAllTrainerSchedules();
        for (TrainerSchedule trainerSchedule : list) {
            System.out.println(trainerSchedule.isAvailable());
        }
    }
}
