package ControllerAdmin;

import DAO.OrderDao;
import Model.Account;
import Model.Order;
import Model.OrderItem;
import Model.Products;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.TypeAdapter;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "OrderServlet", urlPatterns = {"/admin/orders"})
public class OrderServlet extends HttpServlet {

    private OrderDao orderDao;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDao();
        
        // Tạo các adapter cho mỗi loại đối tượng
        TypeAdapter<Account> accountAdapter = new AccountAdapter();
        TypeAdapter<Products> productsAdapter = new ProductsAdapter();
        TypeAdapter<OrderItem> orderItemAdapter = new OrderItemAdapter();
        TypeAdapter<Order> orderAdapter = new OrderAdapter(orderItemAdapter);
        
        // Cấu hình GSON với các adapter tùy chỉnh
        gson = new GsonBuilder()
            .serializeNulls()  // Bao gồm các trường null
            .setDateFormat("yyyy-MM-dd HH:mm:ss")  // Định dạng ngày tháng
            .registerTypeAdapter(Account.class, accountAdapter)
            .registerTypeAdapter(Products.class, productsAdapter)
            .registerTypeAdapter(OrderItem.class, orderItemAdapter)
            .registerTypeAdapter(Order.class, orderAdapter)
            .create();
        
        System.out.println("OrderServlet initialized with custom adapters, OrderDao: " + orderDao);
    }

    // Type adapters to handle circular references
    private static class AccountAdapter extends TypeAdapter<Account> {
        @Override
        public void write(JsonWriter out, Account account) throws IOException {
            if (account == null) {
                out.nullValue();
                return;
            }
            
            out.beginObject();
            out.name("accountId").value(account.getAccountId());
            out.name("username").value(account.getUsername());
            // Chỉ xuất ra thông tin cơ bản để tránh vòng lặp vô hạn
            out.endObject();
        }
        
        @Override
        public Account read(JsonReader in) throws IOException {
            throw new UnsupportedOperationException("Not implemented");
        }
    }
    
    private static class ProductsAdapter extends TypeAdapter<Products> {
        @Override
        public void write(JsonWriter out, Products product) throws IOException {
            if (product == null) {
                out.nullValue();
                return;
            }
            
            out.beginObject();
            out.name("productId").value(product.getProductId());
            out.name("name").value(product.getName());
            // Chỉ xuất ra thông tin cơ bản để tránh vòng lặp vô hạn
            out.endObject();
        }
        
        @Override
        public Products read(JsonReader in) throws IOException {
            throw new UnsupportedOperationException("Not implemented");
        }
    }

    // Thêm adapter cho OrderItem để tránh vòng lặp vô hạn khi serialize
    private static class OrderItemAdapter extends TypeAdapter<OrderItem> {
        @Override
        public void write(JsonWriter out, OrderItem item) throws IOException {
            if (item == null) {
                out.nullValue();
                return;
            }
            
            out.beginObject();
            out.name("orderItemId").value(item.getOrderItemId());
            out.name("productId").value(item.getProductId());
            out.name("productName").value(item.getProductName());
            out.name("quantity").value(item.getQuantity());
            
            // Xử lý unitPrice
            if (item.getUnitPrice() != null) {
                out.name("unitPrice").value(item.getUnitPrice().toString());
                // Calculate price as quantity * unitPrice to ensure it's always correct
                double calculatedPrice = item.getQuantity() * item.getUnitPrice().doubleValue();
                out.name("price").value(calculatedPrice);
            } else {
                out.name("unitPrice").nullValue();
                out.name("price").value(0);
            }
            
            // Không serialize trường order để tránh vòng lặp vô hạn
            out.endObject();
        }
        
        @Override
        public OrderItem read(JsonReader in) throws IOException {
            throw new UnsupportedOperationException("Not implemented");
        }
    }

    // Thêm adapter cho Order để kiểm soát quá trình serialize
    private static class OrderAdapter extends TypeAdapter<Order> {
        private TypeAdapter<OrderItem> orderItemAdapter;
        
        public OrderAdapter(TypeAdapter<OrderItem> orderItemAdapter) {
            this.orderItemAdapter = orderItemAdapter;
        }
        
        @Override
        public void write(JsonWriter out, Order order) throws IOException {
            if (order == null) {
                out.nullValue();
                return;
            }
            
            out.beginObject();
            out.name("orderId").value(order.getOrderId());
            
            // Xử lý account an toàn
            if (order.getAccount() != null) {
                out.name("accountId").value(order.getAccount().getAccountId());
            } else {
                out.name("accountId").nullValue();
            }
            
            // Xử lý orderDate
            if (order.getOrderDate() != null) {
                out.name("orderDate").value(order.getOrderDate().toString());
            } else {
                out.name("orderDate").nullValue();
            }
            
            // Xử lý totalAmount
            if (order.getTotalAmount() != null) {
                out.name("totalAmount").value(order.getTotalAmount().toString());
            } else {
                out.name("totalAmount").nullValue();
            }
            
            // Các trường còn lại
            out.name("shippingAddress").value(order.getShippingAddress() != null ? order.getShippingAddress() : "");
            out.name("status").value(order.getStatus() != null ? order.getStatus() : "");
            out.name("referralCode").value(order.getReferralCode() != null ? order.getReferralCode() : "");
            out.name("customerName").value(order.getCustomerName() != null ? order.getCustomerName() : "");
            out.name("customerPhoneNumber").value(order.getCustomerPhoneNumber() != null ? order.getCustomerPhoneNumber() : "");
            
            // Serialize orderItems sử dụng adapter tùy chỉnh
            out.name("orderItems");
            out.beginArray();
            if (order.getOrderItems() != null) {
                for (OrderItem item : order.getOrderItems()) {
                    orderItemAdapter.write(out, item);
                }
            }
            out.endArray();
            
            out.endObject();
        }
        
        @Override
        public Order read(JsonReader in) throws IOException {
            throw new UnsupportedOperationException("Not implemented");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy action từ request parameter
        String action = request.getParameter("action");
        System.out.println("OrderServlet - GET action: " + action);

        // Xử lý các action khác nhau
        if (action == null || action.isEmpty() || action.equals("list")) {
                listOrders(request, response);
        } else if (action.equals("ajaxList")) {
            System.out.println("DEBUG - Calling ajaxListOrders");
                ajaxListOrders(request, response);
        } else if (action.equals("delete")) {
            deleteOrder(request, response);
        } else if (action.equals("getOrder")) {
                getOrder(request, response);
        } else if (action.equals("search")) {
                searchOrders(request, response);
        } else {
            // Mặc định hiển thị danh sách nếu action không hợp lệ
                listOrders(request, response);
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("Bắt đầu listOrders");
        List<Order> orderList = orderDao.getAllOrders();
        System.out.println("Số đơn hàng lấy được từ DAO: " + (orderList != null ? orderList.size() : "null"));
        request.setAttribute("orderList", orderList);
        System.out.println("Đã truyền orderList đến JSP, kích thước: " + (orderList != null ? orderList.size() : "null"));
        
        // Forward to admin home page which includes the orders list
        request.getRequestDispatcher("/WEB-INF/View/admin/adminHome.jsp").forward(request, response);
        System.out.println("Đã forward đến JSP");
    }
    
    private void ajaxListOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            // Get search parameters
            String searchTerm = request.getParameter("search");
            String status = request.getParameter("status");
            String fromDate = request.getParameter("fromDate");
            String toDate = request.getParameter("toDate");
            
            System.out.println("DEBUG - ajaxListOrders parameters: search=" + searchTerm + 
                              ", status=" + status + 
                              ", fromDate=" + fromDate + 
                              ", toDate=" + toDate);
            
            // Use the searchOrders method to get filtered orders
            List<Order> orderList = orderDao.searchOrders(searchTerm, status, fromDate, toDate);
            
            System.out.println("DEBUG - Found " + orderList.size() + " orders");
            
            // Convert to JSON and send response
            String json = gson.toJson(orderList);
            out.write(json);
        } catch (Exception e) {
            System.out.println("ERROR in ajaxListOrders: " + e.getMessage());
            e.printStackTrace();
            sendJsonError(response, 500, "Server error: " + e.getMessage());
        }
    }
    
    private void getOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            Order order = orderDao.getOrderById(orderId);
            
            if (order != null) {
                // Ensure non-null values for all fields before converting to JSON
                if (order.getStatus() == null) {
                    order.setStatus("pending");
                }
                if (order.getShippingAddress() == null) {
                    order.setShippingAddress("");
                }
                if (order.getCustomerName() == null) {
                    order.setCustomerName("");
                }
                if (order.getOrderItems() == null) {
                    order.setOrderItems(new ArrayList<OrderItem>());
                }
                
                // Log order details for debugging
                System.out.println("Fetched order: ID=" + order.getOrderId() + 
                                   ", Status=" + order.getStatus());
                
                String json = gson.toJson(order);
                response.getWriter().print(json);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                Map<String, String> error = new HashMap<>();
                error.put("message", "Order not found");
                response.getWriter().print(gson.toJson(error));
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            Map<String, String> error = new HashMap<>();
            error.put("message", "Invalid order ID format");
            response.getWriter().print(gson.toJson(error));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, String> error = new HashMap<>();
            error.put("message", "Error retrieving order: " + e.getMessage());
            response.getWriter().print(gson.toJson(error));
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String formAction = request.getParameter("formAction");
        System.out.println("OrderServlet - POST formAction: " + formAction);
        
        if (formAction == null || formAction.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "FormAction parameter is required");
            return;
        }
        
        switch (formAction) {
            case "updateStatus":
                updateOrderStatus(request, response);
                break;
            case "editOrder":
                editOrder(request, response);
                break;
            case "deleteOrder":
                deleteOrder(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + formAction);
                break;
        }
    }
    
    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");
            
            System.out.println("DEBUG - updateOrderStatus called with orderId=" + orderId + ", status='" + status + "'");
            
            if (status == null || status.isEmpty()) {
                System.out.println("ERROR - Status parameter is required");
                sendJsonError(response, HttpServletResponse.SC_BAD_REQUEST, "Status parameter is required");
                return;
            }
            
            boolean updated = orderDao.updateOrderStatus(orderId, status);
            System.out.println("DEBUG - Order status update result: " + (updated ? "success" : "failed"));
            
            JsonObject jsonResponse = new JsonObject();
            
            if (updated) {
                jsonResponse.addProperty("status", "updated");
                jsonResponse.addProperty("message", "Order status updated successfully");
                System.out.println("DEBUG - Order " + orderId + " status updated to '" + status + "' successfully");
            } else {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Failed to update order status");
                System.out.println("ERROR - Failed to update order " + orderId + " status to '" + status + "'");
            }
            
            response.getWriter().print(jsonResponse);
        } catch (NumberFormatException e) {
            System.out.println("ERROR - Invalid order ID format: " + e.getMessage());
            sendJsonError(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid order ID format");
        } catch (Exception e) {
            System.out.println("ERROR - Exception in updateOrderStatus: " + e.getMessage());
            sendJsonError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating order status: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void editOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            System.out.println("DEBUG - editOrder method called");
            
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");
            String shippingAddress = request.getParameter("shippingAddress");
            String customerName = request.getParameter("customerName");
            String customerPhoneNumber = request.getParameter("customerPhoneNumber");
            String referralCode = request.getParameter("referralCode");
            
            System.out.println("DEBUG - Order parameters: orderId=" + orderId + 
                              ", status=" + status + 
                              ", address=" + shippingAddress + 
                              ", name=" + customerName + 
                              ", phone=" + customerPhoneNumber +
                              ", referralCode=" + referralCode);
            
            // Check if updating order item
            Integer orderItemId = null;
            Integer quantity = null;
            
            if (request.getParameter("orderItemId") != null && !request.getParameter("orderItemId").isEmpty()) {
                try {
                    orderItemId = Integer.parseInt(request.getParameter("orderItemId"));
                    if (request.getParameter("quantity") != null && !request.getParameter("quantity").isEmpty()) {
                        quantity = Integer.parseInt(request.getParameter("quantity"));
                    }
                } catch (NumberFormatException e) {
                    System.out.println("DEBUG - Invalid orderItemId or quantity format: " + e.getMessage());
                }
            }
            
            // Call updateOrder method with all parameters
            boolean updated = orderDao.updateOrder(orderId, status, shippingAddress, customerName, customerPhoneNumber, referralCode, orderItemId, quantity);
            
            JsonObject jsonResponse = new JsonObject();
            
            if (updated) {
                jsonResponse.addProperty("status", "success");
                jsonResponse.addProperty("message", "Order updated successfully");
                System.out.println("DEBUG - Order updated successfully: " + orderId);
            } else {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Failed to update order");
                System.out.println("DEBUG - Order update failed: " + orderId);
            }
            
            out.print(jsonResponse.toString());
        } catch (NumberFormatException e) {
            System.out.println("ERROR - Invalid order ID format: " + e.getMessage());
            sendJsonError(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid order ID format");
        } catch (Exception e) {
            System.out.println("ERROR - Exception in editOrder: " + e.getMessage());
            sendJsonError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating order: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void deleteOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        System.out.println("DEBUG - Starting deleteOrder method");
        
        try {
            // Lấy orderId từ request
            String orderIdParam = request.getParameter("orderId");
            System.out.println("DEBUG - Order ID parameter: " + orderIdParam);
            
            if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
                response.setStatus(400);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Order ID is required\"}");
                return;
            }
            
            int orderId = Integer.parseInt(orderIdParam);
            System.out.println("DEBUG - Parsed Order ID: " + orderId);
            
            // Thực hiện xóa đơn hàng
            boolean deleted = orderDao.deleteOrder(orderId);
            
            if (deleted) {
                System.out.println("DEBUG - Order deleted successfully");
                response.getWriter().write("{\"status\":\"deleted\",\"message\":\"Order deleted successfully\"}");
            } else {
                System.out.println("DEBUG - Failed to delete order");
                response.setStatus(404);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Failed to delete order - not found or cannot be deleted\"}");
            }
        } catch (NumberFormatException e) {
            System.out.println("ERROR - Invalid order ID format: " + e.getMessage());
            response.setStatus(400);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Invalid order ID format\"}");
        } catch (Exception e) {
            System.out.println("ERROR - Exception in deleteOrder: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Error deleting order: " + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
    
    private void searchOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            String searchTerm = request.getParameter("term") != null ? request.getParameter("term") : "";
            
            // Use the searchOrders with minimal parameters to get all matching orders
            List<Order> allResults = orderDao.searchOrders(searchTerm, null, null, null);
            
            // Format results for autocomplete
            List<Map<String, String>> formattedResults = new ArrayList<>();
            for (Order order : allResults) {
                Map<String, String> item = new HashMap<>();
                item.put("id", String.valueOf(order.getOrderId()));
                item.put("label", String.valueOf(order.getOrderId()) + " - " + order.getCustomerName());
                item.put("value", String.valueOf(order.getOrderId()));
                formattedResults.add(item);
            }
            
            String json = gson.toJson(formattedResults);
            out.print(json);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, String> error = new HashMap<>();
            error.put("message", "Error searching orders: " + e.getMessage());
            response.getWriter().print(gson.toJson(error));
            e.printStackTrace();
        }
    }
    
    private void sendJsonError(HttpServletResponse response, int statusCode, String message) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(statusCode);
        
        JsonObject jsonError = new JsonObject();
        jsonError.addProperty("status", "error");
        jsonError.addProperty("message", message);
        
        response.getWriter().print(jsonError);
    }
} 