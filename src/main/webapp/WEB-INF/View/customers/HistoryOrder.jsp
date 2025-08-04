<%@page import="Model.Order"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@include file="/WEB-INF/include/head.jsp" %>
<%@include file="/WEB-INF/include/Login.jsp" %>
<%@include file="/WEB-INF/include/Register.jsp" %>
<%@include file="/WEB-INF/include/forgotPassword.jsp" %>
<%@include file="/WEB-INF/include/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/historyOrder.css">

<main>
    <header class="page-header">
        <h1 class="page-header__title">Your Order History</h1>
    </header>

    <div class="container">
        <%
            java.util.List<java.util.Map<String, Object>> orderHistory = (java.util.List<java.util.Map<String, Object>>) request.getAttribute("orderHistory");
            if (orderHistory != null && !orderHistory.isEmpty()) {
                for (java.util.Map<String, Object> order : orderHistory) {
                    int orderId = (Integer) order.get("orderId");
                    String referralCode = (String) order.get("referralCode");
        %>
        <article class="order-card" id="order-<%= orderId %>">
            <div class="order-card__content">
                <section class="product-info">
                    <%
                        Integer imageId = (Integer) order.get("imageId");
                        if (imageId != null && imageId > 0) {
                    %>
                    <img src="<%= request.getContextPath() + "/ImagesServlet?type=product&imageId=" + imageId%>" alt="<%= order.get("productName")%>" class="product-info__image">
                    <%
                    } else {
                    %>
                    <img src="<%= request.getContextPath()%>/img/default-product.jpg" alt="Product" class="product-info__image">
                    <%
                        }
                    %>
                    <div class="product-info__details">
                        <h2 class="product-info__name"><%= order.get("productName")%></h2>
                        <%
                            Boolean hasMultipleItems = (Boolean) order.get("hasMultipleItems");
                            if (hasMultipleItems != null && hasMultipleItems) {
                        %>
                        <p class="product-info__additional-items"><%= order.get("additionalItemsText")%></p>
                        <%
                            }
                        %>
                        <div class="product-info__meta">
                            <span class="product-info__quantity">x<%= order.get("quantity")%></span>
                            <span class="product-info__code"><%= referralCode%></span>
                            <%
                                String status = (String) order.get("status");
                                String statusClass = "";
                                if ("pending".equalsIgnoreCase(status)) {
                                    statusClass = "product-info__status--pending";
                                } else if ("processing".equalsIgnoreCase(status)) {
                                    statusClass = "product-info__status--processing";
                                } else if ("shipped".equalsIgnoreCase(status)) {
                                    statusClass = "product-info__status--shipped";
                                } else if ("cancelled".equalsIgnoreCase(status)) {
                                    statusClass = "product-info__status--cancelled";
                                }
                            %>
                            <span class="product-info__status <%= statusClass%>"><%= status != null ? status.toUpperCase() : ""%></span>
                        </div>
                        <div class="product-info__price">
                            <%
                                java.math.BigDecimal totalAmount = (java.math.BigDecimal) order.get("totalAmount");
                                String priceStr = totalAmount != null ? String.format("%,.0f₫", totalAmount) : "0₫";
                            %>
                            <%= priceStr%>
                        </div>
                    </div>
                </section>

                <section class="button-info">
                    <!-- Add View Details Button -->
                    <button class="action-button view-button" onclick="viewGroupedOrderDetails('<%= referralCode%>')">
                        <i class="fas fa-eye"></i> Details
                    </button>
                    <% if ("cancelled".equalsIgnoreCase((String) order.get("status")) || "shipped".equalsIgnoreCase((String) order.get("status"))) { %>
                        <button class="action-button edit-button disabled" disabled>
                            <i class="fas fa-edit"></i> Edit
                        </button>
                    <% } else { %>
                        <button class="action-button edit-button" onclick="openEditModal(<%= orderId %>)">
                            <i class="fas fa-edit"></i> Edit
                        </button>
                    <% } %>
                    
                    <% if ("cancelled".equalsIgnoreCase((String) order.get("status")) || "shipped".equalsIgnoreCase((String) order.get("status"))) { %>
                        <button class="action-button delete-button disabled" disabled>
                            <i class="fas fa-cancel"></i> Cancel
                        </button>
                    <% } else { %>
                        <button class="action-button delete-button" onclick="deleteOrder(<%= orderId %>)">
                            <i class="fas fa-cancel"></i> Cancel
                        </button>
                    <% } %>
                </section>
            </div>
        </article>
        <%
            }
        } else {
        %>
        <div class="empty-state">
            <div class="empty-state__icon">📦</div>
            <h3 class="empty-state__title">No Orders Found</h3>
            <p class="empty-state__message">You haven't placed any orders yet.</p>
            <a href="<%= request.getContextPath()%>/shopAll" class="empty-state__button">Shop Now</a>
        </div>
        <%
            }
        %>
    </div>
</main>

<!-- Order Details Modal -->
<div id="orderDetailsModal" class="modal">
    <div class="modal-content">
        <span class="close-modal" onclick="closeDetailsModal()">&times;</span>
        <h2>Order Details</h2>
        
        <div class="order-details-container">
            <div class="order-header">
                <div class="order-date">Date: <span id="modal-order-date"></span></div>
                <div class="order-code">Order Code: <span id="modal-order-code"></span></div>
            </div>
            
            <!-- Container for multiple products -->
            <div id="order-products-container">
                <!-- Products will be dynamically inserted here -->
            </div>
            
            <div class="order-customer-details">
                <h3>Customer Information</h3>
                <p><strong>Name:</strong> <span id="modal-customer-name"></span></p>
                <p><strong>Phone:</strong> <span id="modal-customer-phone"></span></p>
                <p><strong>Address:</strong> <span id="modal-customer-address"></span></p>
            </div>
            
            <div class="order-payment-details">
                <h3>Payment Information</h3>
                <p class="price-line"><strong>Original Price:</strong> <span id="modal-payment-subtotal"></span></p>
                <p class="price-line voucher-line"><strong>Voucher:</strong><span id="modal-discountVoucher"></span></p>
                <div id="voucher-info-container">
                    <p class="price-line"><strong>Voucher Code:</strong> <span id="modal-voucher-code"></span></p>
                    <p class="price-line discount-amount"><strong>Discount Amount:</strong> <span id="modal-discount-amount"></span></p>
                </div>
                <p class="total-amount"><strong>Total Price:</strong> <span id="modal-total-amount"></span></p>
            </div>
        </div>
    </div>
</div>

<!-- Import modal chỉnh sửa đơn hàng -->
<%@include file="editOrderModal.jsp" %>

<!-- Import JavaScript cho trang -->
<script src="${pageContext.request.contextPath}/js/historyOrder.js"></script>

<%@include file="/WEB-INF/include/footer.jsp" %>
