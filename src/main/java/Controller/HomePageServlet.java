package Controller;

import DAO.PackageDao;
import Model.Package;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "HomePageServlet", urlPatterns = {"/homepage"})
public class HomePageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PackageDao dao = new PackageDao();
        List<Package> packages = dao.getAllPackages();
        request.setAttribute("membership_packages", packages);

        request.getRequestDispatcher("/WEB-INF/View/customers/HomePage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    public String getServletInfo() {
        return "HomePageServlet - Fetches gym packages from the mock data";
    }
}
