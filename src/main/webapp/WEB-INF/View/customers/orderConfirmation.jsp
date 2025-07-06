<%@page import="Model.Order"%>
<%@page import="Model.OrderItem"%>
<%@page import="Model.Products"%>
<%@page import="java.math.BigDecimal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/head.jsp" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<%
    // Retrieve order data set by the controller
    Order order = (Order) request.getAttribute("order");
%>

<style>
    /* General Styles */
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f6f8;
        margin: 0;
        padding: 0;
    }

    /* Order Confirmation Section */
    .order-summary {
        background-color: white;
        margin-top: 50px;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    h2 {
        text-align: center;
        color: #4CAF50;
        font-size: 2.5em;
        margin-bottom: 20px;
    }

    /* Table Styles */
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }

    table th, table td {
        padding: 12px;
        text-align: left;
        border: 1px solid #ddd;
    }

    table th {
        background-color: #f4f4f4;
    }

    table tr:nth-child(even) {
        background-color: #f9f9f9;
    }

    /* Button Styling */
    .btn {
        display: inline-block;
        padding: 12px 30px;
        background-color: #4CAF50;
        color: white;
        font-size: 1.2em;
        border: none;
        border-radius: 5px;
        text-decoration: none;
        text-align: center;
        transition: background-color 0.3s ease;
    }

    .btn:hover {
        background-color: #45a049;
    }

    /* Status Section */
    .status {
        text-align: center;
        font-size: 1.2em;
        color: #555;
    }

    .status h3 {
        font-size: 2em;
        color: #4CAF50;
    }
</style>

<div class="order-summary container" style="margin-top: 100px">
    <h2>Order Confirmation</h2>

    <!-- Order Items -->
    <div class="order-items ">
        <h3 class="header-content">Products in Your Order</h3>
        <table>
            <thead>
                <tr>
                    <th>Product Name</th>
                    <th>Quantity</th>
                    <th>Unit Price</th>
                    <th>Total Price</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // Loop through order items and display them
                    for (OrderItem item : order.getOrderItems()) {
                        Products product = item.getProduct();  // Assuming Product is already set in OrderItem
                        BigDecimal totalPrice = BigDecimal.valueOf(item.getQuantity()).multiply(item.getUnitPrice());
                %>
                <tr>
                    <td><%= product.getName() %></td>
                    <td><%= item.getQuantity() %></td>
                    <td><%= item.getUnitPrice() %> VND</td>
                    <td><%= totalPrice %> VND</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

    <!-- Confirmation Message -->
    <div class="status">
        <h3>Thank you for shopping with us!</h3>
        <p>Your order has been confirmed. We will contact you soon for delivery.</p>
        <a href="home.jsp" class="btn">Go to Home</a>
    </div>
</div>

<%@ include file="/WEB-INF/include/footer.jsp" %>
