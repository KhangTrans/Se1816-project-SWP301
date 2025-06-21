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

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
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

    ////////////////TEST////////////////
    public boolean insertTrainer(Trainers trainer) {
        String sql = "INSERT INTO trainers (account_id, full_name, email, phone, bio, experience_years, rating, trainer_code)\n"
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, trainer.getAccountId().getAccountId());
            stmt.setString(2, trainer.getFullName());
            stmt.setString(3, trainer.getEmail());
            stmt.setString(4, trainer.getPhone());
            stmt.setString(5, trainer.getBio());
            stmt.setInt(6, trainer.getExperienceYears());
            stmt.setFloat(7, trainer.getRating());
            stmt.setString(8, trainer.getTrainer_code());
            System.out.println(" Trainer code trước khi insert: " + trainer.getTrainer_code());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isTrainerCodeExists(String code) throws SQLException {
        String sql = "SELECT COUNT(*) FROM trainers WHERE trainer_code = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, code);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public Account getAccountByUsername(String username) {
        String sql = "SELECT * FROM Accounts WHERE username = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Account acc = new Account();
                acc.setAccountId(rs.getInt("account_id"));
                acc.setUsername(rs.getString("username"));
                // other setters if needed
                return acc;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Account> getAvailableTrainerAccounts() {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT * \n"
                + "FROM accounts\n"
                + "WHERE role = 'trainer'\n"
                + "AND account_id NOT IN (SELECT account_id FROM trainers);";

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql);  ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Account acc = new Account();
                acc.setAccountId(rs.getInt("account_id"));
                acc.setUsername(rs.getString("username"));
                acc.setRole(rs.getString("role"));
                acc.setCreatedAt(rs.getTimestamp("created_at"));
                accounts.add(acc);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return accounts;
    }

    public Account getTrainerAccountById(int id) throws SQLException {
        String sql = "SELECT * FROM accounts WHERE account_id = ? AND role = 'trainer'";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Account acc = new Account();
                acc.setAccountId(rs.getInt("account_id"));
                acc.setUsername(rs.getString("username"));
                acc.setPassword(rs.getString("password"));
                acc.setAvatar(rs.getBytes("avatar"));
                acc.setRole(rs.getString("role"));
                return acc;
            }
        }
        return null;
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

    public boolean updateTrainer(Trainers trainer) {
        String sql = "UPDATE trainers SET full_name = ?, email = ?, phone = ?, bio = ?, experience_years = ?, rating = ? WHERE trainer_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, trainer.getFullName());
            ps.setString(2, trainer.getEmail());
            ps.setString(3, trainer.getPhone());
            ps.setString(4, trainer.getBio());
            ps.setInt(5, trainer.getExperienceYears());
            ps.setFloat(6, trainer.getRating());
            ps.setInt(7, trainer.getTrainerId());
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteTrainer(int trainerId) {
        String sql = "DELETE FROM trainers WHERE trainer_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, trainerId);
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}
