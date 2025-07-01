package ControllerAdmin;

import DAO.PackageDao;
import Model.Package;
import com.google.gson.Gson;
import db.DBcontext;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@MultipartConfig
@WebServlet(name = "PackageServlet", urlPatterns = {"/admin/packages"})
public class PackageServlet extends HttpServlet {

    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");

        // Lấy tham số id từ request
        String idParam = request.getParameter("id");

        PackageDao dao = new PackageDao();
        PrintWriter out = response.getWriter();

        try {
            if (idParam != null) {  // Kiểm tra nếu có id thì lấy một package cụ thể
                int id = Integer.parseInt(idParam); // Chuyển id thành kiểu int
                Package pkg = dao.getPackageById(id);

                if (pkg != null) {  // Nếu package tồn tại, trả về dữ liệu dưới dạng JSON
                    String json = gson.toJson(pkg);
                    out.print(json);
                } else {  // Nếu không tìm thấy package, trả về lỗi 404
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Package not found");
                }
            } else {  // Nếu không có id thì trả về tất cả các package
                List<Package> packages = dao.getAllPackages();
                String json = gson.toJson(packages);
                out.print(json);
            }
        } catch (NumberFormatException e) {  // Xử lý trường hợp không phải số
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid package ID");
        } finally {
            out.close();  // Đảm bảo đóng PrintWriter sau khi hoàn thành
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain");

        String action = request.getParameter("action");
        System.out.println("action: " + action);
        PackageDao dao = new PackageDao();

        try {
            if ("create".equals(action)) {
                Package pkg = new Package(
                        0,
                        request.getParameter("name"),
                        request.getParameter("description"),
                        Integer.parseInt(request.getParameter("duration")),
                        Double.parseDouble(request.getParameter("price")),
                        "1".equals(request.getParameter("isActive")) // ✅ fix parse boolean
                );
                boolean success = dao.insertPackage(pkg);
                response.getWriter().write(success ? "success" : "fail");
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("packageId"));

                // Chuyển đổi "1"/"0" thành boolean
                boolean isActive = "1".equals(request.getParameter("isActive"));

                Package pkg = new Package(
                        id,
                        request.getParameter("name"),
                        request.getParameter("description"),
                        Integer.parseInt(request.getParameter("duration")),
                        Double.parseDouble(request.getParameter("price")),
                        isActive
                );
                System.out.println("👉 Update: ID = " + id);
                System.out.println("Name: " + pkg.getName());
                System.out.println("Duration: " + pkg.getDurationDays());
                System.out.println("Price: " + pkg.getPrice());
                System.out.println("Active: " + pkg.isIsActive());

                boolean success = dao.updatePackage(pkg);
                response.getWriter().write(success ? "success" : "fail");
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("packageId"));
                boolean success = dao.softDeletePackage(id);
                response.getWriter().write(success ? "deleted" : "fail");

            } else {
                response.getWriter().write("unknown action");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet to manage membership packages";
    }
}
