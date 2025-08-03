/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 *
 * @author Phương
 */
package ControllerAdmin;

import DAO.categoriDao;
import Model.Categories;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "CategoriServlet", urlPatterns = {"/Categori"})
@MultipartConfig
public class CategoriServlet extends HttpServlet {

    private categoriDao categori = new categoriDao(); // Tạo đối tượng DAO để truy cập dữ liệu

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String searchTerm = request.getParameter("searchTerm");

        if (action != null && action.equals("json")) {
            List<Categories> categories = null;
            try {
                if (searchTerm != null && !searchTerm.isEmpty()) {
                    categories = categori.searchCategoriesByName(searchTerm);
                } else {
                    categories = categori.getAllCategories();
                }
                if (categories == null) {
                    categories = new ArrayList<>(); // Tránh null pointer
                }
                String jsonResponse = new Gson().toJson(categories);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                out.print(jsonResponse);
                out.flush();
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Error: " + e.getMessage());
                System.out.println("Error in doGet: " + e.getMessage());
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String formAction = request.getParameter("formAction");
        System.out.println("Received action: " + formAction);  // Kiểm tra xem action có được gửi đúng không
        if (formAction == null) {
            response.getWriter().write("Error: Action parameter is missing");
            return;
        }
        try {
            if ("create".equals(formAction)) {
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                if (name == null || description == null) {
                    response.getWriter().write("Failed: Missing name or description");
                    return;
                }
                boolean result = categori.addCategory(name, description);
                response.getWriter().write(result ? "Category added successfully" : "Failed to add category");
            } else if ("edit".equals(formAction)) {
                String categoryIdStr = request.getParameter("categoryId");
                if (categoryIdStr == null) {
                    response.getWriter().write("Failed: Missing categoryId");
                    return;
                }
                int categoryId = Integer.parseInt(categoryIdStr);
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                if (name == null || description == null) {
                    response.getWriter().write("Failed: Missing name or description");
                    return;
                }
                boolean result = categori.updateCategory(categoryId, name, description);
                response.getWriter().write(result ? "Category updated successfully" : "Failed to update category");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("Failed: Invalid categoryId");
            System.out.println("NumberFormatException: " + e.getMessage());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error: " + e.getMessage());
            System.out.println("Error in doPost: " + e.getMessage());
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
