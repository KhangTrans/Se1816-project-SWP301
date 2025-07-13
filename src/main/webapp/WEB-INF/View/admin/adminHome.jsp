<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/View/admin/headAdmin.jsp" %>
<%    Model.Account acc = (Model.Account) session.getAttribute("account");
    String role = acc != null ? acc.getRole() : "";
    // Kiểm tra nếu người dùng không phải là 'admin' hoặc 'staff'
    if (acc == null || (!role.equals("admin") && !role.equals("staff"))) {
        // Nếu người dùng không có quyền, chuyển hướng về trang đăng nhập
        response.sendRedirect(request.getContextPath() + "/loginAdmin"); // Hoặc trang lỗi như 'accessDenied.jsp'
        return;
    }
%>
<style>
    .dashboard__stats {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
        gap: 16px;
        margin: 20px 0;
    }

    .stat-card {
        background: #f8f9fa;
        border-radius: 10px;
        text-align: center;
        padding: 20px;
        font-size: 14px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        transition: transform 0.2s ease;
    }
    .stat-card strong {
        font-size: 22px;
        color: #007bff;
    }
    .stat-card:hover {
        transform: translateY(-5px);
    }
    .chart-container {
        width: 100%;
        max-width: 600px;
        margin: 40px auto;
    }
</style>
<div class="dashboard">
    <%@include file="/WEB-INF/View/admin/sidebar.jsp" %>
    <main class="main-content">
        <div class="main-content__header">
            <h1 class="main-content__title">Admin Dashboard</h1>
            <p class="main-content__subtitle">System and Data Management</p>
        </div>
        <div class="dashboard__stats">

<!--            <div class="stat-card" onclick="AdminDashboard.showTable('accountTable')"><br>Accounts<br><strong><%= request.getAttribute("accountCount")%></strong></div>
            <div class="stat-card" onclick="AdminDashboard.showTable('staffsTable')"><br>Staff<br><strong><%= request.getAttribute("staffCount")%></strong></div>-->
            <%-- Chỉ hiển thị phần "Accounts" nếu người dùng là admin --%>
            <% if ("admin".equals(role)) {%>
            <div class="stat-card" onclick="AdminDashboard.showTable('accountTable')"><br>Accounts<br><strong><%= request.getAttribute("accountCount")%></strong></div>
                <% } %>

            <%-- Chỉ hiển thị phần "Staff" nếu người dùng là admin --%>
            <% if ("admin".equals(role)) {%>
            <div class="stat-card" onclick="AdminDashboard.showTable('staffsTable')"><br>Staff<br><strong><%= request.getAttribute("staffCount")%></strong></div>
                <% }%>

            <%-- Hiển thị phần "Trainers", "Members", "Products", etc. cho tất cả người dùng --%>
            <div class="stat-card" onclick="AdminDashboard.showTable('trainersTable')"><br>Trainers<br><strong><%= request.getAttribute("trainerCount")%></strong></div>
            <div class="stat-card" onclick="AdminDashboard.showTable('customersTable')"><br>Members<br><strong><%= request.getAttribute("memberCount")%></strong></div>
            <div class="stat-card" onclick="AdminDashboard.showTable('productsTable')"><br>Products<br><strong><%= request.getAttribute("productCount")%></strong></div>
            <div class="stat-card" onclick="AdminDashboard.showTable('vouchersTable')">️<br>Vouchers<br><strong><%= request.getAttribute("voucherCount")%></strong></div>
            <div class="stat-card" onclick="AdminDashboard.showTable('ordersTable')"><br>Orders<br><strong><%= request.getAttribute("orderCount")%></strong></div>            <div class="stat-card" onclick="AdminDashboard.showTable('blogTable')">📝<br>Blogs<br><strong><%= request.getAttribute("blogCount")%></strong></div>

        </div>
        <button onclick="toggleChart()" id="toggleChartBtn"
                style="padding: 6px 12px;
                background-color:#007bff;
                color:white; border:none;
                border-radius:5px;
                margin-bottom: 10px">
            Biểu đồ
        </button>


        <div id="chartWrapper" style="width: 100%; max-width: 90%; height: 500px; margin: 40px auto;">
            <div style="display:flex; justify-content: space-between; align-items:center; margin-bottom: 10px;">
                <h3 style="margin: 0;"> Thống kê số sản phẩm bán ra</h3>
                <select id="rangeSelect" onchange="loadChartData()">
                    <option value="7">7 ngày gần đây</option>
                    <option value="30">30 ngày gần đây</option>
                    <option value="today">Hôm nay</option>
                </select>
            </div>
            <canvas id="salesChart" height="300" width="700"></canvas> <!-- Cũng giảm height nếu cần -->
        </div>
        <%@include file="/WEB-INF/View/admin/accounts/list.jsp" %>
        <%@include file="/WEB-INF/View/admin/products/list.jsp" %>
        <%@include file="/WEB-INF/View/admin/vouchers/list.jsp" %>
        <%@include file="/WEB-INF/View/admin/staffs/list.jsp" %>
        <%@include file="/WEB-INF/View/admin/trainers/list.jsp" %>
        <%@include file="/WEB-INF/View/admin/members/list.jsp" %>
        <%@include file="/WEB-INF/View/admin/blogs/list.jsp" %>
        <%@include file="/WEB-INF/View/admin/loginLog/loginLog.jsp" %>
        <%@include file="/WEB-INF/View/admin/packages/list.jsp" %>
        <%@include file="/WEB-INF/View/admin/orders/list.jsp" %>
        <%@include file="/WEB-INF/View/admin/memberPackages/list.jsp" %>
        <%@include file="/WEB-INF/View/admin/categori/list.jsp" %>
    </main>
</div>

<%@include file="/WEB-INF/View/admin/footerAdmin.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
                    let chart;

                    function loadChartData() {
                        const range = document.getElementById("rangeSelect").value;
                        fetch(`statistics?range=${range}`)
                                .then(res => res.json())
                                .then(data => {
                                    const labels = Object.keys(data);
                                    const values = Object.values(data);

                                    const ctx = document.getElementById('salesChart').getContext('2d');
                                    if (chart)
                                        chart.destroy();

                                    chart = new Chart(ctx, {
                                        type: 'line',
                                        data: {
                                            labels: labels,
                                            datasets: [{
                                                    label: 'Sản phẩm bán ra',
                                                    data: values,
                                                    fill: true,
                                                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                                                    borderColor: 'rgba(75, 192, 192, 1)',
                                                    tension: 0.4,
                                                    borderWidth: 2,
                                                    pointBackgroundColor: 'rgba(75, 192, 192, 1)'
                                                }]
                                        },
                                        options: {
                                            responsive: true,
                                            plugins: {
                                                legend: {display: true}
                                            },
                                            scales: {
                                                y: {
                                                    beginAtZero: true,
                                                    ticks: {precision: 0}
                                                }
                                            }
                                        }
                                    });
                                });
                    }

                    document.addEventListener("DOMContentLoaded", loadChartData);

                    // Override showTable để ẩn biểu đồ khi mở bảng
                    const originalShowTable = AdminDashboard.showTable;

                    AdminDashboard.showTable = function (tableId) {
                        // Ẩn biểu đồ
                        document.getElementById("chartWrapper").style.display = "none";

                        // Ẩn tất cả bảng
                        document.querySelectorAll(".table-container").forEach(el => el.style.display = "none");

                        // Hiện bảng được chọn
                        const table = document.getElementById(tableId);
                        if (table)
                            table.style.display = "block";

                        // Gọi lại hàm gốc nếu cần
                        if (originalShowTable) {
                            originalShowTable.call(this, tableId);
                        }
                    };

                    // Toggle biểu đồ (ẩn/hiện)
                    function toggleChart() {
                        const chartWrapper = document.getElementById("chartWrapper");
                        const isVisible = chartWrapper.style.display === "block";

                        if (isVisible) {
                            chartWrapper.style.display = "none";
                        } else {
                            // Ẩn tất cả bảng
                            document.querySelectorAll(".table-container").forEach(el => el.style.display = "none");

                            // Hiện lại biểu đồ
                            chartWrapper.style.display = "block";
                            loadChartData();
                        }
                    }
</script>

