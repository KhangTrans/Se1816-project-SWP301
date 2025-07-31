package ControllerAdmin;

import DAO.AccountDao;
import DAO.CustomerDao;
import DAO.UserDao;
import Model.Customer;
import Model.Account;
import com.google.gson.Gson;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "CustomerServlet", urlPatterns = {"/admin/customer"})
@MultipartConfig
public class CustomerServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();
    private CustomerDao customerDao;
    private AccountDao accountDao;

    @Override
    public void init() throws ServletException {
        customerDao = new CustomerDao();
        accountDao = new AccountDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "ajaxList": {
                    String fullName = request.getParameter("fullName");
                    List<Customer> customers;
                    if (fullName == null || fullName.isEmpty()) {
                        customers = customerDao.getAllCustomers();
                    } else {
                        customers = customerDao.searchCustomersByFullName(fullName);
                    }
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    new Gson().toJson(customers, response.getWriter());
                    break;
                }
                case "loadAccounts": {
                    List<Account> list = customerDao.getCustomerThatNotStaffYet();
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write(new Gson().toJson(list));
                    return;
                }
                case "edit": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Customer customer = customerDao.getCustomerById(id);
                    request.setAttribute("customer", customer);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/View/admin/customers/edit.jsp");
                    dispatcher.forward(request, response);
                    break;
                }

                default: {
                    List<Customer> customers = customerDao.getAllCustomers();
                    request.setAttribute("customerList", customers);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/View/admin/customers/list.jsp");
                    dispatcher.forward(request, response);
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý khách hàng");
        }
    }

    private String generateMemberCode() throws SQLException {
        String code;
        do {
            int number = (int) (Math.random() * 1_000_000);
            code = String.format("CUS%06d", number);
        } while (customerDao.isMemberCodeExists(code));
        return code;
    }

@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        System.out.println("Received action: " + action);
        if (action == null) {
            action = "";
        }
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try {
            switch (action) {
                case "create": {
                    int accountId = Integer.parseInt(request.getParameter("accountCusId"));
                    String fullName = request.getParameter("fullName").trim();
                    String email = request.getParameter("email").trim();
                    String phone = request.getParameter("phone").trim();
                    String address = request.getParameter("address");
                    Account acc = customerDao.getCustomerAccountById(accountId);

                    if (acc != null) {
                        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
                            response.getWriter().write("{\"status\":\"error\", \"message\":\"Invalid email format.\"}");
                            return;
                        }
                        if (!phone.matches("^(0|\\+84)[1-9]\\d{8,9}$")) {
                            response.getWriter().write("{\"status\":\"error\", \"message\":\"Phone number must be in Vietnamese format.\"}");
                            return;
                        }

                        if (customerDao.isEmailExists(email)) {
                            response.getWriter().write("{\"status\":\"error\", \"message\":\"Email is already in use.\"}");
                            return;
                        }
                        if (customerDao.isPhoneExists(phone)) {
                            response.getWriter().write("{\"status\":\"error\", \"message\":\"Phone number is already in use.\"}");
                            return;
                        }

                        Customer customer = new Customer();
                        customer.setAccount(acc);
                        customer.setFullName(fullName);
                        customer.setEmail(email);
                        customer.setPhone(phone);
                        customer.setCustomerCode(generateMemberCode());
                        customer.setAddress(address);

                        customerDao.createCustomer(customer);
                        response.getWriter().write("{\"status\":\"success\", \"message\":\"Customer created successfully.\"}");
                    } else {
                        response.getWriter().write("{\"status\":\"error\", \"message\":\"Account not found.\"}");
                    }
                    break;
                }
                case "update": {
int customerId = Integer.parseInt(request.getParameter("customerId"));
                    String fullName = request.getParameter("fullName").trim();
                    String email = request.getParameter("email").trim();
                    String phone = request.getParameter("phone").trim();
                    String customerCode = request.getParameter("customerCode");
                    String address = request.getParameter("address");

                    if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
                        response.getWriter().write("{\"status\":\"error\", \"message\":\"Invalid email format.\"}");
                        return;
                    }
                    if (!phone.matches("^(0|\\+84)[1-9]\\d{8,9}$")) {
                        response.getWriter().write("{\"status\":\"error\", \"message\":\"Phone number must be in Vietnamese format.\"}");
                        return;
                    }

                    if (customerDao.isEmailExistsExceptCustomer(email, customerId)) {
                        response.getWriter().write("{\"status\":\"error\", \"message\":\"Email is already in use by another customer.\"}");
                        return;
                    }
                    if (customerDao.isPhoneExistsExceptCustomer(phone, customerId)) {
                        response.getWriter().write("{\"status\":\"error\", \"message\":\"Phone number is already in use by another customer.\"}");
                        return;
                    }

                    Customer customer = new Customer();
                    customer.setCustomerId(customerId);
                    customer.setFullName(fullName);
                    customer.setEmail(email);
                    customer.setPhone(phone);
                    customer.setCustomerCode(customerCode);
                    customer.setAddress(address);

                    boolean updated = customerDao.updateCustomer(customer);
                    if (updated) {
                        response.getWriter().write("{\"status\":\"success\", \"message\":\"Customer updated successfully.\"}");
                    } else {
                        response.getWriter().write("{\"status\":\"error\", \"message\":\"Update failed. Please check the data.\"}");
                    }
                    break;
                }
                case "delete": {
                    int customerId = Integer.parseInt(request.getParameter("customerId"));
                    
                    boolean deleted = customerDao.deleteCustomer(customerId);
                    if (deleted) {
                        response.getWriter().write("{\"status\":\"success\", \"message\":\"Customer deleted successfully.\"}");
                    } else {
                        response.getWriter().write("{\"status\":\"error\", \"message\":\"Deletion failed. Please check again.\"}");
                    }
                    break;
                }
                default:
response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\":\"error\", \"message\":\"An error occurred while processing customer data.\"}");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet managing customers";
    }
}