//package DAO;
//
//import Model.Payment;
//import db.DBcontext;
//import java.math.BigDecimal;
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//import java.sql.Statement;
//import java.sql.Timestamp;
//
///**
// *
// * @author Admin
// */
//public class PaymentDao extends DBcontext {
//
//    public int createPayment(int membershipId, BigDecimal amount, String method) throws SQLException {
//        String query = "INSERT INTO payments (membership_id, amount, method, payment_date) VALUES (?, ?, ?, ?)";
//
//        // Khai báo PreparedStatement và ResultSet
//        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
//
//            // Sử dụng PreparedStatement để set giá trị tham số
//            ps.setInt(1, membershipId); // Tham số membership_id
//            ps.setBigDecimal(2, amount); // Tham số amount (số tiền thanh toán)
//            ps.setString(3, method); // Tham số method (phương thức thanh toán)
//            ps.setTimestamp(4, new Timestamp(System.currentTimeMillis())); // Tham số payment_date (thời gian thanh toán)
//
//            // Thực thi câu lệnh và kiểm tra số dòng bị ảnh hưởng
//            int affectedRows = ps.executeUpdate();
//
//            // Nếu có dòng bị ảnh hưởng, lấy generated key (ID giao dịch mới)
//            if (affectedRows > 0) {
//                try ( ResultSet rs = ps.getGeneratedKeys()) {
//                    if (rs.next()) {
//                        return rs.getInt(1); // Trả về ID của giao dịch thanh toán
//                    }
//                }
//            }
//
//        } catch (SQLException e) {
//            // In ra thông báo lỗi nếu có lỗi trong quá trình thực thi
//            e.printStackTrace();
//            throw new SQLException("Error while creating payment: " + e.getMessage());
//        }
//
//        return -1; // Trả về -1 nếu không thể tạo giao dịch thanh toán
//    }
//    
//    
//    // Hàm lấy thông tin thanh toán của một giao dịch dựa trên payment_id
//    public Payment getPaymentById(int paymentId) throws SQLException {
//        String query = "SELECT * FROM payments WHERE payment_id = ?";
//
//        // Khai báo PreparedStatement và ResultSet
//        try (Connection conn = getConnection(); 
//             PreparedStatement ps = conn.prepareStatement(query)) {
//
//            // Sử dụng PreparedStatement để set giá trị tham số
//            ps.setInt(1, paymentId);  // Tham số payment_id
//
//            try (ResultSet rs = ps.executeQuery()) {
//                if (rs.next()) {
//                    // Nếu tìm thấy kết quả, tạo đối tượng Payment và gán các giá trị
//                    Payment payment = new Payment();
//                    payment.setPaymentId(rs.getInt("payment_id"));
//                    payment.setAccountId(rs.getInt("account_id"));
//                    payment.setAmount(rs.getBigDecimal("amount"));
//                    payment.setMethod(rs.getString("method"));
//                    payment.setPaymentDate(rs.getTimestamp("payment_date"));
//                    return payment;  // Trả về đối tượng Payment
//                }
//            }
//
//        } catch (SQLException e) {
//            // In ra thông báo lỗi nếu có lỗi trong quá trình thực thi
//            e.printStackTrace();
//            throw new SQLException("Error while fetching payment details: " + e.getMessage());
//        }
//
//        return null; // Trả về null nếu không tìm thấy giao dịch thanh toán
//    }
//}
