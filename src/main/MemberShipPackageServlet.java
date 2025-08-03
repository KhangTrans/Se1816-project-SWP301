/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ControllerAdmin;

import DAO.MemberShipPackageDao;
import DAO.PackageDao;
import Model.CustomerMembership;
import Model.MembershipPackage;
import Model.Package;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Date;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "MemberShipPackageServlet", urlPatterns = {"/MemberShipPackageServlet"})
public class MemberShipPackageServlet extends HttpServlet {

    private MemberShipPackageDao memberShipPackageDao = new MemberShipPackageDao();
    private PackageDao packageDao = new PackageDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("json".equals(action)) {
                System.out.println("action là: " + action);
                String username = request.getParameter("username");
                String packageName = request.getParameter("packageName");
                Date startDate = request.getParameter("startDate") != null ? Date.valueOf(request.getParameter("startDate")) : null;
                Date endDate = request.getParameter("endDate") != null ? Date.valueOf(request.getParameter("endDate")) : null;
                String paymentStatus = request.getParameter("paymentStatus");

                List<CustomerMembership> memberPackages = memberShipPackageDao.searchCustomerMemberships(username, packageName, paymentStatus);
                String json = new Gson().toJson(memberPackages);
                response.setContentType("application/json");
                response.getWriter().write(json);
            }

            if ("loadPackages".equals(action)) {
                List<Package> packages = packageDao.getAllPackages();
                String json = new Gson().toJson(packages);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(json);
            }
        } catch (IOException | IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);  // Lỗi 500
            response.getWriter().write("An error occurred while processing your request: " + e.getMessage());
        }
        
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("updateStatus".equals(action)) {
            // Nhận dữ liệu từ client
            String json = request.getReader().lines().collect(Collectors.joining(System.lineSeparator()));
            Gson gson = new Gson();
            JsonObject jsonObject = gson.fromJson(json, JsonObject.class);
            int membershipId = jsonObject.get("membershipId").getAsInt();
            String status = jsonObject.get("status").getAsString();

            // Kiểm tra giá trị status trước khi gọi DAO
            System.out.println("Received status: " + status);

            // Thêm kiểm tra backend để đảm bảo không update nếu đã hết hạn
            CustomerMembership membership = memberShipPackageDao.getCustomerMembershipById(membershipId); // Giả sử bạn thêm method này trong DAO
            if (membership != null && membership.getEndDate().isBefore(java.time.LocalDate.now())) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"error\": \"Cannot update status for expired memberships.\"}");
                return;
            }

            boolean success = memberShipPackageDao.editCustomerMembership(membershipId, status);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": " + success + "}");
        }
    }

}
