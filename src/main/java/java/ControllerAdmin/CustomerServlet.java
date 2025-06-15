package ControllerAdmin;

import DAO.AccountDao;
import DAO.CustomerDao;
import Model.Customer;
import Model.Account;
import com.google.gson.Gson;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "CustomerServlet", urlPatterns = {"/admin/customer"})
public class CustomerServlet extends HttpServlet {

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
                    List<Customer> customers = customerDao.getAllCustomers();
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    new Gson().toJson(customers, response.getWriter());
                    break;
                }
                case "edit": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Customer customer = customerDao.getCustomerById(id);
                    request.setAttribute("customer", customer);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/View/admin/customers/edit.jsp");
                    dispatcher.forward(request, response);
                    break;
                }
                case "createForm": {
                    // Lấy danh sách tài khoản chưa là customer
                    AccountDao accountDao = new AccountDao();
                    List<Account> availableAccounts = accountDao.getAllCustomerAccountsNotInCustomerTable();
                    request.setAttribute("availableAccounts", availableAccounts);

                    // Mở form create
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/View/admin/members/create.jsp");
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "create": {
                    // Lấy dữ liệu từ form
                    int accountId = Integer.parseInt(request.getParameter("accountId"));
                    String fullName = request.getParameter("fullName");
                    String email = request.getParameter("email");
                    String phone = request.getParameter("phone");
                    String customerCode = request.getParameter("customerCode");
                    String address = request.getParameter("address");

                    Customer customer = new Customer();
                    customer.setFullName(fullName);
                    customer.setEmail(email);
                    customer.setPhone(phone);
                    customer.setCustomerCode(customerCode);
                    customer.setAddress(address);

                    Account account = new Account();
                    account.setAccountId(accountId);
                    customer.setAccount(account);

                    try {
                        customerDao.createCustomer(customer);
                    } catch (SQLException ex) {
                        Logger.getLogger(CustomerServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    response.setContentType("text/plain");
                    response.getWriter().write("OK");
                    break;
                }
                case "update": {
                    int customerId = Integer.parseInt(request.getParameter("customerId"));
                    String fullName = request.getParameter("fullName");
                    String email = request.getParameter("email");
                    String phone = request.getParameter("phone");
                    String customerCode = request.getParameter("customerCode");
                    String address = request.getParameter("address");

                    Customer customer = new Customer();
                    customer.setCustomerId(customerId);
                    customer.setFullName(fullName);
                    customer.setEmail(email);
                    customer.setPhone(phone);
                    customer.setCustomerCode(customerCode);
                    customer.setAddress(address);

                    customerDao.updateCustomer(customer);
                    response.setContentType("text/plain");
                    response.getWriter().write("OK");
                    break;
                }

                case "delete": {
                    int customerId = Integer.parseInt(request.getParameter("customerId"));
                    customerDao.deleteCustomer(customerId);
                    response.setContentType("text/plain");
                    response.getWriter().write("OK");
                    break;
                }

                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action không hợp lệ");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý dữ liệu khách hàng");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet quản lý khách hàng";
    }
}
