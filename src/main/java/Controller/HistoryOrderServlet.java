/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller;

import DAO.HistoryOrderDao;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONObject;

/**
 *
 * @author Khaang
 */
@WebServlet(name="HistoryOrderServlet", urlPatterns={"/historyorder", "/historyorder/details", "/historyorder/update", "/historyorder/delete"})
public class HistoryOrderServlet extends HttpServlet {
   
    private HistoryOrderDao historyOrderDao;
  
    @Override
    public void init() {
        historyOrderDao = new HistoryOrderDao();
    }
  

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        if (accountId == null) {
            response.sendRedirect(request.getContextPath() + "/login"); // Redirect to login page if no session
            return;
        }
        
        String path = request.getServletPath();
        
        // Handle different URL patterns
        if (path.equals("/historyorder/details")) {
            getOrderDetails(request, response, accountId);
        } else {
            // Default path - show order history
            showOrderHistory(request, response, accountId);
        }
    }
    
    /**
     * Shows the order history page
     */
    private void showOrderHistory(HttpServletRequest request, HttpServletResponse response, int accountId)
    throws ServletException, IOException {
        // Get order history for the logged-in account
        List<Map<String, Object>> orderHistory = historyOrderDao.getOrderHistory(accountId);
        
        // Format the price for each order for display
        for (Map<String, Object> order : orderHistory) {
            // Get the order ID
            int orderId = (int) order.get("orderId");
            
            // Get the total price directly from the database using the dedicated method
            double totalPrice = historyOrderDao.getOrderTotalPrice(orderId);
            
            // Store as a String to avoid JSP conversion issues
            order.put("formattedPrice", String.format("$%.2f", totalPrice));
        }
        
        // Pass the order history to the JSP
        request.setAttribute("orderHistory", orderHistory);
        
        // Forward to the history order JSP page
        request.getRequestDispatcher("/WEB-INF/View/customers/HistoryOrder.jsp").forward(request, response);
    } 
    
    /**
     * Gets details for a specific order and returns as JSON
     */
    private void getOrderDetails(HttpServletRequest request, HttpServletResponse response, int accountId)
    throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject result = new JSONObject();
        
        try {
            String orderId = request.getParameter("id");
            if (orderId == null || orderId.isEmpty()) {
                result.put("success", false);
                result.put("message", "Order ID is required");
                out.print(result.toString());
                return;
            }
            
            Map<String, Object> orderDetails = historyOrderDao.getOrderDetails(Integer.parseInt(orderId), accountId);
            
            if (orderDetails != null && !orderDetails.isEmpty()) {
                // Simplify price handling - ensure we have both unitPrice and price fields
                if (orderDetails.containsKey("unitPrice")) {
                    double unitPrice = 0;
                    Object priceObj = orderDetails.get("unitPrice");
                    
                    if (priceObj instanceof Double) {
                        unitPrice = (Double) priceObj;
                    } else if (priceObj instanceof Integer) {
                        unitPrice = ((Integer) priceObj).doubleValue();
                    } else if (priceObj instanceof String) {
                        try {
                            unitPrice = Double.parseDouble((String) priceObj);
                        } catch (NumberFormatException e) {
                            // Handle parsing error
                            unitPrice = 0;
                        }
                    }
                    
                    // Make sure both price fields are available
                    orderDetails.put("unitPrice", unitPrice);
                    orderDetails.put("price", unitPrice);
                    
                    // Add formatted price values
                    orderDetails.put("formattedUnitPrice", String.format("$%.2f", unitPrice));
                    orderDetails.put("formattedPrice", String.format("$%.2f", unitPrice));
                }
                
                // Format total price if available
                if (orderDetails.containsKey("totalPrice")) {
                    double totalPrice = 0;
                    Object priceObj = orderDetails.get("totalPrice");
                    
                    if (priceObj instanceof Double) {
                        totalPrice = (Double) priceObj;
                    } else if (priceObj instanceof Integer) {
                        totalPrice = ((Integer) priceObj).doubleValue();
                    } else if (priceObj instanceof String) {
                        try {
                            totalPrice = Double.parseDouble((String) priceObj);
                        } catch (NumberFormatException e) {
                            // Handle parsing error
                        }
                    }
                    
                    orderDetails.put("formattedTotalPrice", String.format("$%.2f", totalPrice));
                    orderDetails.put("totalPrice", totalPrice); // Ensure it's stored as a double
                }
                
                // Add a debug log to see what we're sending to the client
                System.out.println("Order details being sent to client: " + new JSONObject(orderDetails).toString());
                
                result.put("success", true);
                result.put("order", new JSONObject(orderDetails));
            } else {
                result.put("success", false);
                result.put("message", "Order not found or you don't have permission to view it");
            }
            
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Invalid order ID format");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Error retrieving order details: " + e.getMessage());
        }
        
        out.print(result.toString());
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        if (accountId == null) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            JSONObject result = new JSONObject();
            result.put("success", false);
            result.put("message", "You must be logged in to perform this action");
            out.print(result.toString());
            return;
        }
        
        String path = request.getServletPath();
        
        if (path.equals("/historyorder/update")) {
            updateOrder(request, response, accountId);
        } else if (path.equals("/historyorder/delete")) {
            deleteOrder(request, response, accountId);
        } else {
            doGet(request, response);
        }
    }
    
    /**
     * Updates an order
     */
    private void updateOrder(HttpServletRequest request, HttpServletResponse response, int accountId)
    throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject result = new JSONObject();
        
        try {
            // Get parameters from request
            String orderId = request.getParameter("orderId");
            String customerName = request.getParameter("customerName");
            String customerPhone = request.getParameter("customerPhone");
            String shippingAddress = request.getParameter("shippingAddress");
            
            // Validate required fields
            if (orderId == null || orderId.isEmpty() ||
                customerName == null || customerName.isEmpty() ||
                customerPhone == null || customerPhone.isEmpty() ||
                shippingAddress == null || shippingAddress.isEmpty()) {
                
                result.put("success", false);
                result.put("message", "All fields are required");
                out.print(result.toString());
                return;
            }
            
            // Kiểm tra trạng thái đơn hàng trước khi cập nhật
            int orderIdInt = Integer.parseInt(orderId);
            Map<String, Object> orderDetails = historyOrderDao.getOrderDetails(orderIdInt, accountId);
            
            if (orderDetails != null) {
                String status = (String) orderDetails.get("status");
                if ("cancelled".equalsIgnoreCase(status)) {
                    result.put("success", false);
                    result.put("message", "Không thể chỉnh sửa đơn hàng đã hủy");
                    out.print(result.toString());
                    return;
                }
                if ("shipped".equalsIgnoreCase(status)) {
                    result.put("success", false);
                    result.put("message", "Không thể chỉnh sửa đơn hàng đã giao");
                    out.print(result.toString());
                    return;
                }
            }
            
            // Update the order
            boolean updated = historyOrderDao.updateOrder(
                orderIdInt,
                accountId,
                customerName,
                customerPhone,
                shippingAddress
            );
            
            if (updated) {
                result.put("success", true);
                result.put("message", "Order updated successfully");
            } else {
                result.put("success", false);
                result.put("message", "Failed to update order or you don't have permission");
            }
            
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Invalid order ID format");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Error updating order: " + e.getMessage());
        }
        
        out.print(result.toString());
    }
    
    /**
     * Deletes an order
     */
    private void deleteOrder(HttpServletRequest request, HttpServletResponse response, int accountId)
    throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject result = new JSONObject();
        
        try {
            String orderId = request.getParameter("id");
            if (orderId == null || orderId.isEmpty()) {
                result.put("success", false);
                result.put("message", "Order ID is required");
                out.print(result.toString());
                return;
            }
            
            // Kiểm tra trạng thái đơn hàng trước khi hủy
            int orderIdInt = Integer.parseInt(orderId);
            Map<String, Object> orderDetails = historyOrderDao.getOrderDetails(orderIdInt, accountId);
            
            if (orderDetails != null) {
                String status = (String) orderDetails.get("status");
                if ("cancelled".equalsIgnoreCase(status)) {
                    result.put("success", false);
                    result.put("message", "Đơn hàng đã bị hủy trước đó");
                    out.print(result.toString());
                    return;
                }
                if ("shipped".equalsIgnoreCase(status)) {
                    result.put("success", false);
                    result.put("message", "Không thể hủy đơn hàng đã giao");
                    out.print(result.toString());
                    return;
                }
            }
            
            boolean deleted = historyOrderDao.deleteOrder(orderIdInt, accountId);
            
            if (deleted) {
                result.put("success", true);
                result.put("message", "Order deleted successfully");
            } else {
                result.put("success", false);
                result.put("message", "Failed to delete order or you don't have permission");
            }
            
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Invalid order ID format");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Error deleting order: " + e.getMessage());
        }
        
        out.print(result.toString());
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
