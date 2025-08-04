package Controller;

import DAO.PackageDao;
import Model.Package;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/package-details")
public class PackageDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PackageDao packageDao = new PackageDao();
        String idStr = request.getParameter("id");

        // Lấy lỗi từ session (nếu có)
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("membershipError") != null) {
            request.setAttribute("membershipError", session.getAttribute("membershipError"));
            session.removeAttribute("membershipError");
        }

        try {
            if (idStr != null) {
                int packageId = Integer.parseInt(idStr);
                Package pkg = packageDao.getPackageById(packageId);
                if (pkg != null) {
                    request.setAttribute("pkg", pkg);
                    request.getRequestDispatcher("/WEB-INF/include/membershipCardDetails.jsp")
                            .forward(request, response);
                } else {
                    response.sendRedirect("error.jsp");
                }
            } else {
                response.sendRedirect("error.jsp");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("error.jsp");
        }
    }
}
