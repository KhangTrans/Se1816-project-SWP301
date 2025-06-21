/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.CategoryDao;
import DAO.ProductDao;
import Model.Products;
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

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ShopAllServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ShopAllServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

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

        //Default: first page
        int currentPage = 1;
        //Number of products per page
        int productsPerPage = 15;

        // Lấy số trang từ request
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException ex) {
                currentPage = 1;
            }
        }

        //Sorting filter (asc/desc)
        String sort = request.getParameter("sort");
        //Category filter
        String categoryParam = request.getParameter("category");
        //Search keyword
        String keyword = request.getParameter("q");
        Integer categoryId = null;
        if (categoryParam != null && !categoryParam.isEmpty()) {
            try {
                //Convert category to int
                categoryId = Integer.parseInt(categoryParam);
            } catch (NumberFormatException ignore) {
                categoryId = null;
            }
        }

        try {
            int totalProducts;
            int totalPages;
            List<Products> list;

            //If there is a search keyword, filter by keyword + category
            if (keyword != null && !keyword.trim().isEmpty()) {
                //Get products matching search + category
                totalProducts = dao.getTotalProductsBySearch(keyword, categoryId);
                totalPages = (int) Math.ceil(totalProducts / (double) productsPerPage);

                //Get product matching Search + category + sort + pagination
                list = dao.getProductsBySearch(keyword, categoryId, sort, currentPage, productsPerPage);
            } //If only match category 
            else if (categoryId != null) {
                totalProducts = dao.getTotalProductsByCategory(categoryId);
                totalPages = (int) Math.ceil(totalProducts / (double) productsPerPage);

                //Get product matching category + sort + pagination
                list = dao.getProductsByPageAndFilter(categoryId, sort, currentPage, productsPerPage);
            } // No search, no category filter → get all products, with sorting if needed
            else {
                totalProducts = dao.getTotalProducts();
                totalPages = (int) Math.ceil(totalProducts / (double) productsPerPage);

                //Get product matching products + sort + pagination
                list = dao.getProductsByPageAndFilter(null, sort, currentPage, productsPerPage);
            }

            request.setAttribute("list", list);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("sort", sort);
            request.setAttribute("category", categoryId);
            request.setAttribute("q", keyword);

            //Category dropdown filter
            CategoryDao cdao = new CategoryDao();
            request.setAttribute("categories", cdao.getAllCategories());

            // Forward tới JSP
            request.getRequestDispatcher("/WEB-INF/View/customers/shopAll.jsp").forward(request, response);

        } catch (SQLException ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, ex.getMessage());
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
