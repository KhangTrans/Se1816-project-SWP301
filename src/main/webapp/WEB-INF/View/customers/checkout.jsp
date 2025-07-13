<%@page import="Model.Voucher"%>
<%@page import="DAO.CheckoutDao"%>
<%@page import="Model.Customer"%>
<%@page import="DAO.UserDao"%>
<%@ page import="java.util.List" %>
<%@ page import="Model.CartItem" %>
<%@ page import="Model.Products" %>
<%@ page import="DAO.ProductDao" %>
<%@ include file="/WEB-INF/include/head.jsp" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Checkout</title>
        <link rel="stylesheet" href="styles.css">
    </head>
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
            width: 25%; /* ??m b?o m?i c?t chi?m 1/4 chi?u r?ng c?a b?ng */
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

        /* T?o không gian gi?a các ph?n */
        br {
            margin-bottom: 10px;
        }

        /* Các yêu c?u khác */
        input[type="hidden"] {
            display: none;
        }

    </style>
<body>
<div class="checkout-container">
    <h1>Checkout</h1>
    <h2>Your Order Summary</h2>
    <%
        List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cart");
        Double total = 0.0;
        StringBuilder stockError = new StringBuilder();
        boolean hasStockError = false;
        ProductDao productDao = new ProductDao();

        if (cartItems != null && !cartItems.isEmpty()) {
            for (CartItem item : cartItems) {
                Products product = item.getProduct();
                int quantity = item.getQuantity();
                int stockQty = 0;
                double price = 0;
                String name = "Unknown";
                if (product != null) {
                    price = product.getPrice();
                    name = product.getName();
                    // L?y s? l??ng t?n kho m?i nh?t t? DB
                    Products fresh = productDao.getProductById(product.getProductId());
                    if (fresh != null) stockQty = fresh.getStockQuantity();
                    if (quantity > stockQty) {
                        hasStockError = true;
                        stockError.append("Number of products <b>")
                                .append(name)
                                .append("</b> left <b>")
                                .append(stockQty)
                                .append("</b> products. Please select the appropriate quantity.<br>");
                    }
                }
                double subtotal = price * quantity;
                total += subtotal;
            }
        }
    %>
    <!-- Hi?n th? thông báo l?i s? l??ng t?n kho -->
    <% if (hasStockError) { %>
        <div class="error"><%= stockError.toString() %></div>
    <% } %>

    <form action="checkoutsuccess" method="post">
        <p><strong>Name:</strong> <input type="text" name="customerName" required></p>
        <p><strong>Phone:</strong>
            <input type="text" name="customerPhone" pattern="09\d{8}" title="Phone number must start with 09 and be followed by 8 digits" required>
        </p>
        <label for="shippingAddress"><strong>Shipping Address</strong></label>
        <input type="text" id="shippingAddress" name="shippingAddress" required><br><br>

        <!-- Ph?n Voucher n?u có -->
        <p><strong>Voucher:</strong>
            <%
                Voucher voucher = (Voucher) request.getAttribute("voucher");
                if (voucher != null) {
            %>
                <span>
                    <%= voucher.getCode()%> - <%= voucher.getDiscountPercent()%>% Discount
                </span>
            <%
                } else {
            %>
                <span>No voucher applied</span>
            <%
                }
            %>
        </p>

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
                if (cartItems != null && !cartItems.isEmpty()) {
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
            %>
                <tr>
                    <td><%= name%></td>
                    <td><%= quantity%></td>
                    <td><%= String.format("%,.0f", price)%> VND</td>
                    <td><%= String.format("%,.0f", subtotal)%> VND</td>
                </tr>
            <%
                    }
                } else {
            %>
                <tr>
                    <td colspan="4"><p>Your cart is empty.</p></td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
        <h3>Total: <%= String.format("%,.0f", total)%> VND</h3>

        <label for="paymentMethod">Payment Method</label>
        <select id="paymentMethod" name="paymentMethod" required>
            <option value="cashOnDelivery">Cash on Delivery</option>
        </select><br><br>

        <!-- Ch? cho phép submit n?u không có l?i s? l??ng t?n kho -->
        <% if (!hasStockError) { %>
            <button type="submit">Confirm Order</button>
        <% } %>
    </form>
</div>
</body>
</html>
<%@ include file="/WEB-INF/include/footer.jsp" %>
