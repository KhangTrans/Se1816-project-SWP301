<%@page import="Model.Voucher"%>
<%@page import="DAO.CheckoutDao"%>
<%@page import="Model.Customer"%>
<%@page import="DAO.UserDao"%>
<%@ page import="java.util.List" %>
<%@ page import="Model.CartItem" %>
<%@ page import="Model.Products" %>
<%@ page import="DAO.ProductDao" %>

<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Checkout</title>
        <link rel="stylesheet" href="styles.css">
         <style>
        /* C? b?n c?u trúc và font ch? */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }

        .checkout-container {
            width: 80%;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        h2 {
            color: #333;
            margin-bottom: 15px;
        }

        h3 {
            color: #4CAF50;
            margin-top: 20px;
            margin-bottom: 20px;
        }

        /* ??nh d?ng b?ng thông tin ??n hàng */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        table th, table td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }

        table th {
            background-color: #f2f2f2;
            font-weight: bold;
        }

        table td {
            background-color: #fff;
        }

        /* ??nh d?ng các tr??ng nh?p thông tin */
        input[type="text"], select {
            width: 100%;
            padding: 10px;
            margin: 5px 0 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }

        input[type="text"]:focus, select:focus {
            border-color: #4CAF50;
            outline: none;
        }

        /* Nút "Confirm Order" */
        button[type="submit"] {
            width: 100%;
            padding: 12px;
            background-color: #4CAF50;
            color: white;
            font-size: 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button[type="submit"]:hover {
            background-color: #45a049;
        }

        /* Thông báo n?u gi? hàng r?ng */
        p {
            color: #ff4747;
            font-size: 18px;
        }

        /* T?o không gian ? d??i */
        br {
            margin-bottom: 10px;
        }

        /* Các y?u t? khác */
        input[type="hidden"] {
            display: none;
        }

    </style>
    </head>   
    <body>
        <div class="checkout-container"><h1>Checkout</h1>
            <h2>Your Order Summary</h2>
            <form action="checkout" method="post">
                <p><strong>Name:</strong> <input type="text" name="customerName" required></p>
                <p><strong>Phone:</strong> 
                    <input type="text" name="customerPhone" pattern="09\d{8}" title="Phone number must start with 09 and be followed by 8 digits" required>
                </p>
                <label for="shippingAddress"><strong>Shipping Address</strong></label>
                <input type="text" id="shippingAddress" name="shippingAddress" required><br><br>

                <!-- Thêm ph?n ch?n Voucher ? ?ây -->
                <p><strong>Voucher:</strong>
                    <%
                        Voucher voucher = (Voucher) request.getAttribute("voucher");
                        if (voucher != null) {
                            System.out.println("Voucher code: " + voucher.getCode());
                    %>
                    <span>
                        <%= voucher.getCode()%> - <%= voucher.getDiscountPercent()%>% Discount
                    </span>
                    <%
                    } else {
                        System.out.println("No voucher applied.");
                    %>
                    <span>No voucher applied</span>
                    <%
                        }
                    %>
                </p>


                <!-- B?ng gi? hàng -->
                <%
                    List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cart");
                    Customer customer = (Customer) request.getAttribute("customer");
                    Double total = (Double) request.getAttribute("total");
                %>
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
                            if (cartItems == null || cartItems.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="4"><p>Your cart is empty.</p></td>
                        </tr>
                        <%
                        } else {
                            for (CartItem item : cartItems) {
                                Products product = item.getProduct();
                                int quantity = item.getQuantity();
                                double price = 0;
                                String name = "Unknown";
                                if (product != null) {
                                    price = product.getPrice();
                                    name = product.getName();
                                }
                                double subtotal = price * quantity;
                                total += subtotal;
                        %>
                        <tr>
                            <td><%= name%></td>
                            <td><%= quantity%></td>
                            <td><%= String.format("%,.0f", price)%> VND</td>
                            <td><%= String.format("%,.0f", subtotal)%> VND</td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>

                <h3>Total: <%= String.format("%,.0f", total)%> VND</h3>
                <label for="paymentMethod">Payment Method</label>
                <select id="paymentMethod" name="paymentMethod" required>
                    <option value="paypal">PayPal</option>
                    <option value="cashOnDelivery">Cash on Delivery</option>
                </select><br><br>
                <button type="submit">Confirm Order</button>
            </form>
            </>
    </body>

</html>
<%@ include file="/WEB-INF/include/footer.jsp" %>