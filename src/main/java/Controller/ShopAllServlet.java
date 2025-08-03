/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.CategoryDao;
import DAO.ProductDao;
import DAO.VoucherDao;
import Model.Products;
import Model.Voucher;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author PC
 */
@WebServlet(name = "ShopAllServlet", urlPatterns = {"/shopAll"})
public class ShopAllServlet extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDao dao = new ProductDao();

        // Default page
        int currentPage = 1;
        int productsPerPage = 12;

        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException ex) {
                currentPage = 1;
            }
        }

        String sort = request.getParameter("sort");
        String categoryParam = request.getParameter("category");
        String keyword = request.getParameter("q");
        Integer categoryId = null;
        if (categoryParam != null && !categoryParam.isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryParam);
            } catch (NumberFormatException ignore) {
                categoryId = null;
            }
        }

        try {
            int totalProducts;
            int totalPages;
            List<Products> list;

            if (keyword != null && !keyword.trim().isEmpty()) {
                totalProducts = dao.getTotalProductsBySearch(keyword, categoryId);
                totalPages = (int) Math.ceil(totalProducts / (double) productsPerPage);
                list = dao.getProductsBySearch(keyword, categoryId, sort, currentPage, productsPerPage);
            } else if (categoryId != null) {
                totalProducts = dao.getTotalProductsByCategory(categoryId);
                totalPages = (int) Math.ceil(totalProducts / (double) productsPerPage);
                list = dao.getProductsByPageAndFilter(categoryId, sort, currentPage, productsPerPage);
            } else {
                totalProducts = dao.getTotalProducts();
                totalPages = (int) Math.ceil(totalProducts / (double) productsPerPage);
                list = dao.getProductsByPageAndFilter(null, sort, currentPage, productsPerPage);
            }

            // Check if it's an AJAX request
            boolean isAjaxRequest = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

            if (isAjaxRequest) {
                // Return JSON if it's an AJAX request
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                JsonObject jsonResponse = new JsonObject();
                JsonArray productArray = new JsonArray();

                for (Products p : list) {
                    JsonObject productJson = new JsonObject();
                    productJson.addProperty("productId", p.getProductId());
                    productJson.addProperty("name", p.getName());
                    productJson.addProperty("price", p.getPrice());
                    productJson.addProperty("stock", p.getStockQuantity());
                    productJson.addProperty("image", request.getContextPath() + "/ImagesServlet?type=product&imageId=" + dao.getPrimaryImage(p.getProductId()).getImageId());
                    productArray.add(productJson);
                }

                jsonResponse.add("products", productArray);
                jsonResponse.addProperty("totalPages", totalPages);
                jsonResponse.addProperty("currentPage", currentPage);

                response.getWriter().write(jsonResponse.toString());
            } else {
                // For normal requests, forward to JSP
                request.setAttribute("list", list);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("currentPage", currentPage);
                request.setAttribute("sort", sort);
                request.setAttribute("category", categoryId);
                request.setAttribute("q", keyword);

                // Set categories and vouchers for dropdowns
                CategoryDao cdao = new CategoryDao();
                request.setAttribute("categories", cdao.getAllCategories());

                VoucherDao voucherDao = new VoucherDao();
                List<Voucher> voucherList = voucherDao.getActiveVouchers();
                request.setAttribute("voucherList", voucherList);

                request.getRequestDispatcher("/WEB-INF/View/customers/shopAll.jsp").forward(request, response);
            }

        } catch (SQLException ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, ex.getMessage());
        }
    }
}
