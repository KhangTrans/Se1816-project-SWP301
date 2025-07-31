package DAO;

import Model.Trainers;
import Model.Account;
import db.DBcontext;
import java.io.InputStream;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TrainerDao extends DBcontext {

    // Lấy tất cả huấn luyện viên
    public List<Trainers> getAllTrainers() throws SQLException {
        List<Trainers> trainersList = new ArrayList<>();

        String sql
                = "SELECT "
                + "t.trainer_id, t.full_name, t.phone, t.email, t.bio, t.experience_years, t.rating,t.price, t.trainer_code, "
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
                trainer.setPrice(rs.getDouble("price"));
                trainer.setTrainer_code(rs.getString("trainer_code"));
                System.out.println("Gia: " + trainer.getPrice());
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
        String sql = "INSERT INTO trainers (account_id, full_name, email, phone, bio, experience_years, rating, trainer_code, price)\n"
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, trainer.getAccountId().getAccountId());
            stmt.setString(2, trainer.getFullName());
            stmt.setString(3, trainer.getEmail());
            stmt.setString(4, trainer.getPhone());
            stmt.setString(5, trainer.getBio());
            stmt.setInt(6, trainer.getExperienceYears());
            stmt.setFloat(7, trainer.getRating());
            stmt.setString(8, trainer.getTrainer_code());
            stmt.setDouble(9, trainer.getPrice());
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
        String sql = "UPDATE trainers SET full_name = ?, email = ?, phone = ?, bio = ?, experience_years = ?, rating = ?, price = ? WHERE trainer_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, trainer.getFullName());
            ps.setString(2, trainer.getEmail());
            ps.setString(3, trainer.getPhone());
            ps.setString(4, trainer.getBio());
            ps.setInt(5, trainer.getExperienceYears());
            ps.setFloat(6, trainer.getRating());
            ps.setDouble(7, trainer.getPrice());      // moved price to position 7
            ps.setInt(8, trainer.getTrainerId());     // moved trainerId to last position
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

    public int countTrainers() {
        String sql = "SELECT COUNT(*) FROM trainers";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Trainers getTrainerDetails(int trainerId) {
        Trainers trainer = null;
        String sql = "SELECT t.*, a.* FROM trainers t JOIN accounts a ON t.account_id = a.account_id WHERE t.trainer_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, trainerId); // Đảm bảo rằng trainerId được truyền vào
            System.out.println("Executing query with trainerId: " + trainerId); // Kiểm tra giá trị trainerId
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
                trainer.setPrice(rs.getDouble("price"));
                trainer.setTrainer_code(rs.getString("trainer_code"));

                // Lấy object Account
                Account acc = new Account();
                acc.setAccountId(rs.getInt("account_id"));
                acc.setUsername(rs.getString("username"));
                acc.setAvatar(rs.getBytes("avatar"));
                trainer.setAccountId(acc);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // In lỗi nếu có
        }
        return trainer;
    }

    public List<Trainers> searchTrainers(String searchTerm, String experience, String rating) throws SQLException {
        List<Trainers> trainersList = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT t.*, a.* FROM trainers t JOIN accounts a ON t.account_id = a.account_id WHERE 1=1");

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (a.username LIKE ? OR t.full_name LIKE ?)");
        }

        if (experience != null && !experience.isEmpty()) {
            sql.append(" AND t.experience_years >= ?");
        }

        if (rating != null && !rating.isEmpty()) {
            sql.append(" AND t.rating >= ?");
        }

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;

            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchTerm + "%");
                ps.setString(paramIndex++, "%" + searchTerm + "%");
            }

            if (experience != null && !experience.isEmpty()) {
                ps.setInt(paramIndex++, Integer.parseInt(experience));
            }

            if (rating != null && !rating.isEmpty()) {
                ps.setFloat(paramIndex++, Float.parseFloat(rating));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Trainers trainer = new Trainers();
                trainer.setTrainerId(rs.getInt("trainer_id"));
                trainer.setFullName(rs.getString("full_name"));
                trainer.setEmail(rs.getString("email"));
                trainer.setPhone(rs.getString("phone"));
                trainer.setBio(rs.getString("bio"));
                trainer.setExperienceYears(rs.getInt("experience_years"));
                trainer.setRating(rs.getFloat("rating"));
                trainer.setPrice(rs.getDouble("price"));

                Account account = new Account();
                account.setAccountId(rs.getInt("account_id"));
                account.setUsername(rs.getString("username"));
                trainer.setAccountId(account);

                trainersList.add(trainer);
            }
        }
        return trainersList;
    }
    //===================NHAT KHANG========================

    public Trainers getTrainerByAccountId(int accountId) {
        Trainers trainer = null;
        String sql = "SELECT t.*, a.* FROM trainers t JOIN accounts a ON t.account_id = a.account_id WHERE a.account_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
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
                trainer.setPrice(rs.getDouble("price"));

                // Create Account object
                Account acc = new Account();
                acc.setAccountId(rs.getInt("account_id"));
                acc.setUsername(rs.getString("username"));
                acc.setAvatar(rs.getBytes("avatar"));
                acc.setRole(rs.getString("role"));
                trainer.setAccountId(acc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trainer;
    }

    //===================NHAT KHANG========================
    public boolean updateTrainerWithAvatar(Trainers trainer, InputStream avatarStream) {
        Connection conn = null;
        PreparedStatement psUpdateTrainer = null;
        PreparedStatement psUpdateAvatar = null;
        boolean success = false;

        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            // Update trainer information
            String trainerSql = "UPDATE trainers SET full_name = ?, email = ?, phone = ?, bio = ?, experience_years = ?, rating = ?, price = ? WHERE trainer_id = ?";
            psUpdateTrainer = conn.prepareStatement(trainerSql);
            psUpdateTrainer.setString(1, trainer.getFullName());
            psUpdateTrainer.setString(2, trainer.getEmail());
            psUpdateTrainer.setString(3, trainer.getPhone());
            psUpdateTrainer.setString(4, trainer.getBio());
            psUpdateTrainer.setInt(5, trainer.getExperienceYears());
            psUpdateTrainer.setFloat(6, trainer.getRating());
            psUpdateTrainer.setDouble(7, trainer.getPrice());
            psUpdateTrainer.setInt(8, trainer.getTrainerId());

            int trainerRowsAffected = psUpdateTrainer.executeUpdate();

            // Update avatar if provided
            int avatarRowsAffected = 0;
            if (avatarStream != null) {
                String avatarSql = "UPDATE accounts SET avatar = ? WHERE account_id = ?";
                psUpdateAvatar = conn.prepareStatement(avatarSql);
                psUpdateAvatar.setBinaryStream(1, avatarStream);
                psUpdateAvatar.setInt(2, trainer.getAccountId().getAccountId());
                avatarRowsAffected = psUpdateAvatar.executeUpdate();
            } else {
                avatarRowsAffected = 1; // Consider it successful if no avatar update needed
            }

            // Commit if both operations were successful or if only trainer info was updated
            if (trainerRowsAffected > 0 && avatarRowsAffected > 0) {
                conn.commit();
                success = true;
            } else {
                conn.rollback();
            }
        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException se) {
                se.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (psUpdateTrainer != null) {
                    psUpdateTrainer.close();
                }
                if (psUpdateAvatar != null) {
                    psUpdateAvatar.close();
                }
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }
        return success;
    }

    public boolean updateTrainerPassword(int trainerId, String newPassword) {
        String sql = "UPDATE Trainers SET password = ? WHERE trainer_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setInt(2, trainerId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.out.println("Error updating trainer password: " + e.getMessage());
            return false;
        }
    }

    //===================NHAT KHANG========================
    public boolean updateAccountPassword(int accountId, String newPassword) {
        String sql = "UPDATE Accounts SET password = ? WHERE account_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setInt(2, accountId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.out.println("Error updating account password: " + e.getMessage());
            return false;
        }
    }

    // Kiểm tra email tồn tại, loại trừ trainerId hiện tại (cho edit)
    public boolean isEmailExistsExceptTrainer(String email, int trainerId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM trainers WHERE email = ? AND trainer_id != ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setInt(2, trainerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

// Tương tự cho phone
    public boolean isPhoneExistsExceptTrainer(String phone, int trainerId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM trainers WHERE phone = ? AND trainer_id != ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, phone);
            stmt.setInt(2, trainerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    // New method: Check if email exists in trainers
    public boolean isEmailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM trainers WHERE email = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    // New method: Check if phone exists in trainers
    public boolean isPhoneExists(String phone) throws SQLException {
        String sql = "SELECT COUNT(*) FROM trainers WHERE phone = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, phone);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }
}
