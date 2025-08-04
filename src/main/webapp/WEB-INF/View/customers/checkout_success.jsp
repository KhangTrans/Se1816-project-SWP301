<%@page import="java.sql.Array"%>
<%@page import="Model.Products"%>
<%@page import="Model.CartItem"%>
<%@page import="java.util.List"%>
<%@page import="java.math.BigDecimal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/head.jsp" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<%
    // Retrieve cart data set by the controller
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    System.out.println("jsp" +cartItems);
    Double total = (Double) request.getAttribute("total");
    // Convert Double to BigDecimal for consistency with orderConfirmation
    BigDecimal totalAsBigDecimal = BigDecimal.valueOf(total != null ? total : 0);
    BigDecimal discountAmount = BigDecimal.ZERO; // No discount data available, default to zero
    
    // Generate a pseudo order ID
    long orderId = System.currentTimeMillis() % 10000;
%>

        <style>
            body {
        background-color: #111;
        color: #fff;
    }

    .order-confirmation-container {
        max-width: 1000px;
        margin: 60px auto;
        padding: 0 20px;
    }

    .order-confirmation-card {
        background: rgba(25, 25, 25, 0.9);
        border-radius: 20px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        overflow: hidden;
        border: 1px solid rgba(217, 255, 104, 0.3);
                padding: 0;
            }

    .order-header {
        background: linear-gradient(135deg, rgba(25, 25, 25, 0.9) 0%, rgba(40, 40, 40, 0.9) 100%);
        padding: 25px 40px;
        border-bottom: 1px solid rgba(217, 255, 104, 0.2);
        position: relative;
        overflow: hidden;
    }

    .order-header::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: radial-gradient(circle at top right, rgba(217, 255, 104, 0.15) 0%, rgba(0, 0, 0, 0) 70%);
        z-index: 1;
    }

    .order-header h2 {
        color: #d9ff68;
        margin: 0;
        font-size: 32px;
        font-weight: 700;
        letter-spacing: 0.5px;
        text-transform: uppercase;
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        position: relative;
        z-index: 2;
        text-align: center;
            }

    .order-id {
        color: #aaa;
                text-align: center;
        margin-top: 5px;
        font-size: 14px;
        position: relative;
        z-index: 2;
    }

    .order-id span {
        color: #d9ff68;
        font-weight: bold;
    }

    .order-content {
        padding: 30px;
    }

    .section-title {
        color: #d9ff68;
        font-size: 22px;
                margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .section-title i {
        font-size: 20px;
    }

    .order-table {
        width: 100%;
        border-collapse: collapse;
        margin: 20px 0 30px;
        border-radius: 10px;
        overflow: hidden;
    }

    .order-table th, .order-table td {
        padding: 15px;
        text-align: left;
    }

    .order-table th {
        background-color: rgba(26, 42, 58, 0.8);
        color: #d9ff68;
        font-weight: 500;
        text-transform: uppercase;
        font-size: 14px;
        letter-spacing: 0.5px;
    }

    .order-table td {
        background-color: rgba(30, 30, 30, 0.6);
        color: #fff;
        border-bottom: 1px solid rgba(255, 255, 255, 0.05);
    }

    .order-table tr:last-child td {
        border-bottom: none;
    }

    .product-name {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .product-img {
        width: 50px;
        height: 50px;
        border-radius: 8px;
        object-fit: contain;
        background-color: rgba(255, 255, 255, 0.05);
        padding: 5px;
    }

    .price-column {
        text-align: right;
        font-weight: bold;
    }

    .subtotal-row td {
        background-color: rgba(40, 40, 40, 0.6);
        color: #aaa;
    }

    .discount-row td {
        background-color: rgba(40, 40, 40, 0.6);
        color: #ff6b6b;
    }

    .total-row td {
        background-color: rgba(26, 42, 58, 0.8);
        color: #d9ff68;
        font-weight: bold;
                font-size: 18px;
            }

            .order-summary {
        background-color: rgba(30, 30, 30, 0.6);
        border-radius: 12px;
        padding: 25px;
        margin-bottom: 30px;
        border: 1px solid rgba(217, 255, 104, 0.1);
    }

    .summary-row {
        display: flex;
        justify-content: space-between;
        padding: 10px 0;
        border-bottom: 1px solid rgba(255, 255, 255, 0.05);
    }

    .summary-row:last-child {
        border-bottom: none;
    }

    .summary-label {
        color: #aaa;
    }

    .summary-value {
        font-weight: bold;
    }

    .thank-you-section {
        text-align: center;
        padding: 30px 20px;
        background: linear-gradient(135deg, rgba(26, 42, 58, 0.7) 0%, rgba(13, 27, 41, 0.7) 100%);
        border-radius: 12px;
                margin-top: 30px;
        position: relative;
        overflow: hidden;
    }

    .thank-you-section::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: radial-gradient(circle at center, rgba(217, 255, 104, 0.1) 0%, rgba(0, 0, 0, 0) 70%);
        z-index: 1;
            }

    .thank-you-title {
        color: #d9ff68;
        font-size: 28px;
                margin-bottom: 15px;
        position: relative;
        z-index: 2;
            }

    .thank-you-message {
        color: #fff;
                font-size: 16px;
        margin-bottom: 25px;
        max-width: 600px;
        margin-left: auto;
        margin-right: auto;
        line-height: 1.6;
        position: relative;
        z-index: 2;
            }

    .order-status {
        display: inline-block;
        padding: 8px 16px;
        background-color: rgba(217, 255, 104, 0.15);
        color: #d9ff68;
        border-radius: 20px;
        font-size: 14px;
        font-weight: bold;
        margin-bottom: 25px;
        position: relative;
        z-index: 2;
            }

    .order-status i {
        margin-right: 5px;
    }

    .action-buttons {
        display: flex;
        justify-content: center;
        gap: 15px;
        margin-top: 20px;
        position: relative;
        z-index: 2;
            }

            .btn {
        display: inline-block;
        padding: 12px 25px;
        border-radius: 8px;
        font-weight: bold;
        text-decoration: none;
        transition: all 0.3s ease;
                cursor: pointer;
    }

    .btn-primary {
        background: linear-gradient(135deg, #c4ff00 0%, #9ddb00 100%);
        color: #111;
    }

    .btn-primary:hover {
        transform: translateY(-3px);
        box-shadow: 0 7px 15px rgba(217, 255, 104, 0.3);
            }

    .btn-secondary {
        background: rgba(255, 255, 255, 0.1);
        color: #fff;
        border: 1px solid rgba(255, 255, 255, 0.2);
            }

    .btn-secondary:hover {
        background: rgba(255, 255, 255, 0.2);
    }

    .btn i {
        margin-right: 8px;
            }

    .divider {
        height: 1px;
        background: linear-gradient(to right, rgba(217, 255, 104, 0), rgba(217, 255, 104, 0.3), rgba(217, 255, 104, 0));
        margin: 30px 0;
    }

    @media (max-width: 768px) {
        .order-header {
            padding: 20px;
        }
        
        .order-content {
            padding: 20px;
        }
        
        .order-table th, .order-table td {
            padding: 10px;
        }
        
        .product-img {
            display: none;
        }
        
        .action-buttons {
            flex-direction: column;
        }
        
        .btn {
            width: 100%;
            text-align: center;
            }
    }
        </style>

<div class="order-confirmation-container">
    <div class="order-confirmation-card">
        <div class="order-header">
            <h2>Order Confirmation</h2>
            <p class="order-id">Order ID: <span>#<%= orderId %></span></p>
        </div>
        
        <div class="order-content">
            <h3 class="section-title">
                <i class="fas fa-shopping-bag"></i>
                Products in Your Order
            </h3>
            
            <table class="order-table">
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Quantity</th>
                        <th class="price-column">Unit Price</th>
                        <th class="price-column">Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        BigDecimal orderSubtotal = BigDecimal.ZERO;
                            if (cartItems != null) {
                                for (CartItem item : cartItems) {
                                    Products product = item.getProduct();
                                    int quantity = item.getQuantity();
                                    double price = product.getPrice();
                                    double subtotal = price * quantity;
                                orderSubtotal = orderSubtotal.add(BigDecimal.valueOf(subtotal));
                        %>
                        <tr>
                        <td>
                            <div class="product-name">
                                <img src="<%=request.getContextPath()%>/ImagesServlet?type=product&imageId=<%= product.getPrimaryImageId() %>" class="product-img" alt="<%= product.getName() %>">
                                <span><%= product.getName() %></span>
                            </div>
                            </td>
                        <td><%= quantity %></td>
                        <td class="price-column"><%= String.format("%,.0f", price) %> VND</td>
                        <td class="price-column"><%= String.format("%,.0f", subtotal) %> VND</td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    
                    <tr class="subtotal-row">
                        <td colspan="3" class="price-column">Subtotal:</td>
                        <td class="price-column"><%= String.format("%,.0f", orderSubtotal) %> VND</td>
                    </tr>
                    
                    <% if (discountAmount.compareTo(BigDecimal.ZERO) > 0) { %>
                    <tr class="discount-row">
                        <td colspan="3" class="price-column">Discount:</td>
                        <td class="price-column">-<%= String.format("%,.0f", discountAmount) %> VND</td>
                    </tr>
                    <% } %>
                    
                    <tr class="total-row">
                        <td colspan="3" class="price-column">Total:</td>
                        <td class="price-column"><%= String.format("%,.0f", totalAsBigDecimal) %> VND</td>
                        </tr>
                    </tbody>
                </table>
            
            <div class="thank-you-section">
                <div class="order-status"><i class="fas fa-check-circle"></i> Order Confirmed</div>
                <h3 class="thank-you-title">Thank you for shopping with us!</h3>
                <p class="thank-you-message">Your order has been confirmed and is now being processed. We will contact you soon regarding delivery details. Please keep this confirmation for your records.</p>
                
                <div class="action-buttons">
                    <a href="<%=request.getContextPath()%>/homepage" class="btn btn-primary">
                        <i class="fas fa-home"></i> Back to Home
                    </a>
                    <a href="<%=request.getContextPath()%>/historyorder" class="btn btn-secondary">
                        <i class="fas fa-history"></i> View Order History
                    </a>
                </div>
            </div>
        </div>
    </div>
        </div>

<%@ include file="/WEB-INF/include/footer.jsp" %>
