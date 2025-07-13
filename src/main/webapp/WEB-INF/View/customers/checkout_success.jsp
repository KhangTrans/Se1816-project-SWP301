<%@page import="Model.Products"%>
<%@page import="Model.CartItem"%>
<%@page import="java.util.List"%>
<%@page import="java.util.List"%>
<%@ include file="/WEB-INF/include/head.jsp" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Payment Successful</title>
        <style>
            body {
                font-family: 'Arial', sans-serif;
                background-color: #f5f5f5;
                margin: 0;
                padding: 0;
                color: #333;
            }

            .container {
                background-color: white;
                width: 80%;
                max-width: 900px;
                margin: 50px auto;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                font-size: 16px;
            }


            h1 {
                text-align: center;
                color: #28a745 !important;
                font-size: 32px;
                margin-bottom: 20px;
            }

            p {
                font-size: 18px;
                color: #555;
                margin: 10px 0;
            }

            .order-summary {
                background-color: #f9f9f9;
                padding: 20px;
                margin-top: 30px;
                border-radius: 8px;
                box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
            }

            .order-summary h3 {
                color: #333;
                font-size: 20px;
                margin-bottom: 15px;
            }

            .order-summary table {
                width: 100%;
                margin-top: 15px;
                border-collapse: collapse;
            }

            .order-summary th,
            .order-summary td {
                padding: 12px;
                text-align: left;
                border: 1px solid #ddd;
                font-size: 16px;
            }

            .order-summary th {
                background-color: #f2f2f2;
                color: #333;
            }

            .order-summary tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            .order-summary td {
                color: #555;
            }

            .btn {
                background-color: #28a745;
                color: white;
                padding: 12px 24px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
                font-size: 18px;
                margin-top: 30px;
            }

            .btn:hover {
                background-color: #218838;
            }

            .btn:focus {
                outline: none;
            }

            .footer {
                text-align: center;
                padding: 20px;
                background-color: #333;
                color: #fff;
                margin-top: 30px;
                width: 100%;
                position: relative;
            }

        </style>

    </head>
    <body>

        <div class="container">
            <h1>Payment Successful!</h1>
            <p>Your order has been successfully processed. Thank you for shopping with us!</p>

            <!-- Order Details -->
            <div class="order-summary">
                <h3>Order Information</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Quantity</th>
                            <th>Price</th>
                            <th>Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cart");
                            Double total = (Double) request.getAttribute("total");
                            if (cartItems != null) {
                                for (CartItem item : cartItems) {
                                    Products product = item.getProduct();
                                    int quantity = item.getQuantity();
                                    double price = product.getPrice();
                                    double subtotal = price * quantity;
                        %>
                        <tr>
                            <td><%= product.getName()%></td>
                            <td><%= quantity%></td>
                            <td><%= String.format("%,.0f", price)%> VND</td>
                            <td><%= String.format("%,.0f", subtotal)%> VND</td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        <tr>
                            <td colspan="3" style="text-align: right;"><strong>Total:</strong></td>
                            <td><strong><%= String.format("%,.0f", total)%> VND</strong></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Payment method -->
            <p><strong>Payment Method:</strong> <%= request.getParameter("paymentMethod")%></p>
        </div>

    </body>
</html>
<%@ include file="/WEB-INF/include/footer.jsp" %>
