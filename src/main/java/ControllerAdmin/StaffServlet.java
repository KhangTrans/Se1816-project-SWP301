package ControllerAdmin;

import DAO.UserDao;
import Model.Account;
import Model.Staff;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@MultipartConfig
@WebServlet(name = "StaffServlet", urlPatterns = {"/admin/staffs"})
public class StaffServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "loadAccounts": {
                    List<Account> availableStaffAccounts = userDao.getStaffsThatNotStaffYet();
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write(new Gson().toJson(availableStaffAccounts));
                    return;
                }

                case "ajaxList": {
                    String searchStaff = request.getParameter("searchStaff"); // Tìm kiếm theo tên hoặc username
                    String searchPhone = request.getParameter("searchPhone"); // Tìm kiếm theo tên hoặc username
                    String staffFilter = request.getParameter("staffFilter");  // Lọc theo kinh nghiệm

                    List<Staff> staffList;
                    // Nếu có tham số tìm kiếm hoặc lọc, gọi hàm searchTrainers
                    if (searchStaff != null || searchPhone != null || staffFilter != null) {
                        staffList = userDao.searchStaffs(searchStaff, searchPhone, staffFilter);
                    } else {
                        // Nếu không có tham số tìm kiếm, trả về tất cả huấn luyện viên
                        staffList = userDao.getAllStaffs();
                    }
                    // Trả kết quả dưới dạng JSON
                    Gson gson = new GsonBuilder()
                            .registerTypeAdapter(LocalDateTime.class, new JsonSerializer<LocalDateTime>() {
                                @Override
                                public com.google.gson.JsonElement serialize(LocalDateTime src, java.lang.reflect.Type typeOfSrc, JsonSerializationContext context) {
                                    return src == null ? null : new com.google.gson.JsonPrimitive(src.toString());
                                }
                            })
                            .create();

                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write(gson.toJson(staffList));

                    break;
                }
                default: {
                    List<Staff> staffList = userDao.getAllStaffs();
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    String json = new Gson().toJson(staffList);
                    response.getWriter().write(json);
                    break;
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(StaffServlet.class.getName()).log(Level.SEVERE, null, e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Staff data processing error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        System.out.println("📥 [StaffServlet] POST called.");
        System.out.println("📥 action = " + request.getParameter("action"));
        if (action == null) {
            action = "";
        }
        try {
            switch (action) {
                case "create": {
                    int accountId = Integer.parseInt(request.getParameter("accountId"));
                    String fullName = request.getParameter("fullName");
                    String email = request.getParameter("email");
                    String phone = request.getParameter("phone");
                    String position = request.getParameter("position");

                    Account account = userDao.getStaffAccountById(accountId);
                    if (account != null) {
                        Staff staff = new Staff();
                        staff.setAccount(account);
                        staff.setFullName(fullName);
                        staff.setEmail(email);
                        staff.setPhone(phone);
                        staff.setPosition(position);
                        staff.setStatus("active");

                        userDao.addStaff(staff);
                    }

                    response.sendRedirect("staffs");
                    break;
                }

                case "edit": {
                    int accountId = Integer.parseInt(request.getParameter("accountId"));
                    String fullName = request.getParameter("fullName");
                    String email = request.getParameter("email");
                    String phone = request.getParameter("phone");
                    String position = request.getParameter("position");
                    String status = request.getParameter("status");

                    Account account = userDao.getAccountById(accountId);
                    if (account == null) {
                        response.sendRedirect("staffs?error=account_not_found");
                        return;
                    }

                    Part avatarPart = request.getPart("avatar");
                    InputStream avatarStream = null;
                    if (avatarPart != null && avatarPart.getSize() > 0) {
                        avatarStream = avatarPart.getInputStream();
                    }

                    // Truyền thêm email xuống hàm update
                    userDao.updateStaff(accountId, fullName, email, phone, position, status, avatarStream);

                    response.sendRedirect("staffs");
                    break;
                }
                case "delete": {
                    int staffId = Integer.parseInt(request.getParameter("staffId"));
                    int accountId = userDao.getAccountIdByStaffId(staffId);

                    if (accountId == -1) {
                        response.getWriter().write("STAFF_NOT_FOUND");
                        return;
                    }

                    userDao.demoteStaff(staffId);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("OK");
                    return;

                }

                default: {
                    response.sendRedirect("staffs?error=action_not_found");
                    break;
                }
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect("staffs?error=1");
        }
    }

    @Override
    public String getServletInfo() {
        return "Staff management servlet for admin.";
    }
}
