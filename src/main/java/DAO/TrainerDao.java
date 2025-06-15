package DAO;

import Model.Trainers;
import Model.Account;
import db.DBcontext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TrainerDao extends DBcontext {

    // Lấy tất cả huấn luyện viên
    public List<Trainers> getAllTrainers() throws SQLException {
        List<Trainers> trainersList = new ArrayList<>();

        String sql
                = "SELECT "
                + "t.trainer_id, t.full_name, t.phone, t.email, t.bio, t.experience_years, t.rating, t.trainer_code, "
                + "a.account_id, a.username, a.avatar, a.role, a.auth_provider, a.created_at "
                + "FROM trainers t "
                + "JOIN accounts a ON t.account_id = a.account_id";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                // Tạo trainer
                Trainers trainer = new Trainers();
                trainer.setTrainerId(rs.getInt("trainer_id"));
                trainer.setFullName(rs.getString("full_name"));
                trainer.setPhone(rs.getString("phone"));
                trainer.setEmail(rs.getString("email"));
                trainer.setBio(rs.getString("bio"));
                trainer.setExperienceYears(rs.getInt("experience_years"));
                trainer.setRating(rs.getFloat("rating"));
                trainer.setTrainer_code(rs.getString("trainer_code"));

                // Tạo đối tượng Account và gán
                Account account = new Account();
                account.setAccountId(rs.getInt("account_id"));
                account.setUsername(rs.getString("username"));
                account.setAvatar(rs.getBytes("avatar")); // nếu bạn dùng VARBINARY
                trainer.setAccountId(account); // gán account vào trainer

                // Thêm vào danh sách
                trainersList.add(trainer);
            }
        }

        return trainersList;
    }


    public List<Trainers> getTopTrainers() throws SQLException {
        List<Trainers> trainersList = new ArrayList<>();
        String sql = "SELECT TOP 3 t.trainer_id, t.full_name, t.email, t.bio, t.experience_years, t.rating, a.account_id, a.avatar, a.username "
                + "FROM trainers t "
                + "JOIN accounts a ON t.account_id = a.account_id "
                + "ORDER BY t.rating DESC"; // Sử dụng TOP để lấy 3 huấn luyện viên có rating cao nhất

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();

            // Kiểm tra xem có dữ liệu trả về không
            if (!rs.next()) {
                System.out.println("No trainers found!"); // Nếu không có dữ liệu
            }

            // Duyệt qua các dòng dữ liệu
            do {
                Trainers trainer = new Trainers();
                trainer.setTrainerId(rs.getInt("trainer_id"));
                trainer.setFullName(rs.getString("full_name"));
                trainer.setEmail(rs.getString("email"));
                trainer.setBio(rs.getString("bio"));
                trainer.setExperienceYears(rs.getInt("experience_years"));
                trainer.setRating(rs.getFloat("rating"));

                Account account = new Account();
                account.setAccountId(rs.getInt("account_id"));
                account.setUsername(rs.getString("username"));
                account.setAvatar(rs.getBytes("avatar")); // Lấy avatar từ CSDL
                trainer.setAccountId(account);

                trainersList.add(trainer);
            } while (rs.next()); // Tiếp tục nếu còn dữ liệu

        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Error fetching top trainers", e); // Ném lỗi nếu gặp vấn đề
        }

        return trainersList;
    }
    
    

    public List<String> getTrainerUsernames() throws SQLException {
        List<String> usernames = new ArrayList<>();
        String sql = "SELECT username FROM accounts WHERE role = 'trainer' AND account_id NOT IN (SELECT account_id FROM trainers)";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                usernames.add(rs.getString("username"));
            }
        }

        return usernames;
    }
    
    
    

//     // Phương thức tạo huấn luyện viên mới
//    public int createTrainer(Trainers trainer) throws SQLException {
//        String sql = "INSERT INTO trainers (account_id, full_name, email, phone, specialization, bio, experience_years, rating) " +
//                     "VALUES ((SELECT account_id FROM accounts WHERE username = ? AND role = 'trainer'), ?, ?, ?, ?, ?, ?, ?)";
//        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setString(1, trainer.getUsername());  // Tên tài khoản của huấn luyện viên
//            ps.setString(2, trainer.getFullName());
//            ps.setString(3, trainer.getEmail());     // Đặt email trước phone
//            ps.setString(4, trainer.getPhone());     // Số điện thoại
//            ps.setString(6, trainer.getBio());
//            ps.setInt(7, trainer.getExperienceYears());
//            ps.setFloat(8, trainer.getRating());
//            return ps.executeUpdate();
//        }
//    }
    // Phương thức xóa huấn luyện viên
    
    
    public int deleteTrainer(int trainerId) throws SQLException {
        String sql = "DELETE FROM trainers WHERE trainer_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, trainerId);
            return ps.executeUpdate();
        }
    }

    // Phương thức cập nhật huấn luyện viên
    public int updateTrainer(Trainers trainer) throws SQLException {
        String sql = "UPDATE trainers SET full_name = ?, email = ?, phone = ?, bio = ?, experience_years = ?, rating = ? "
                + "WHERE trainer_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, trainer.getFullName());
            ps.setString(2, trainer.getEmail());     // Đặt email trước phone
            ps.setString(3, trainer.getPhone());     // Số điện thoại
            ps.setString(4, trainer.getBio());
            ps.setInt(5, trainer.getExperienceYears());
            ps.setFloat(6, trainer.getRating());
            ps.setInt(7, trainer.getTrainerId());
            return ps.executeUpdate();
        }
    }

    
    ////////////////TEST////////////////
    public static void main(String[] args) {
        TrainerDao trainerDao = new TrainerDao();
        
        try {
            // Lấy danh sách 3 huấn luyện viên hàng đầu theo rating
            List<Trainers> topTrainers = trainerDao.getTopTrainers();
            
            // Kiểm tra nếu có huấn luyện viên
            if (topTrainers.isEmpty()) {
                System.out.println("No top trainers found.");
            } else {
                // In thông tin về các huấn luyện viên
                for (Trainers trainer : topTrainers) {
                    System.out.println("Trainer ID: " + trainer.getTrainerId());
                    System.out.println("Full Name: " + trainer.getFullName());
                    System.out.println("Email: " + trainer.getEmail());
                    System.out.println("Bio: " + trainer.getBio());
                    System.out.println("Experience Years: " + trainer.getExperienceYears());
                    System.out.println("Rating: " + trainer.getRating());
                    System.out.println("Account ID: " + trainer.getAccountId().getAccountId());
                    System.out.println("Username: " + trainer.getAccountId().getUsername());
                    System.out.println("Avatar: " + (trainer.getAccountId().getAvatar() != null ? "Has Avatar" : "No Avatar"));
                    System.out.println("------------------------------------");
                }
            }
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
