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
    .card-metric {
        background: #fff;
        border-radius: 14px;
        padding: 18px 18px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        min-width: 200px;
    }

    .metric-label {
        font-size: 15px;
        margin-bottom: 4px;
    }

    .metric-value {
        font-size: 23px;
        font-weight: bold;
        letter-spacing: 1px;
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

        <div id="chartWrapper"
             style="width: 100%; max-width: 1100px; margin: 0px auto; display: flex; gap: 32px; align-items: flex-start; justify-content: center;">
            <!---->
            <div style="flex: 0 0 260px; display: flex; flex-direction: column; gap: 22px;">
                <div class="card-metric">
                    <div class="metric-label">Completed Orders Rate</div>
                    <div class="metric-value" id="completedOrderRateValue">0%</div>
                </div>
                <div class="card-metric">
                    <div class="metric-label">Cancel Orders Rate</div>
                    <div class="metric-value" id="cancelOrderRateValue">0%</div>
                </div>
            </div>
            <!---->
            <div style="flex:1; display: flex; flex-direction: column; align-items: center; justify-content: center; max-width:700px">
                <select id="rangeSelect" onchange="loadChartData()" style="min-width: 140px;">
                    <option value="7">7 ngày gần đây</option>
                    <option value="30">30 ngày gần đây</option>
                    <option value="today">Hôm nay</option>
                </select>
                <canvas id="statusDonutChart" style="max-width:100%; margin-top: 10px"></canvas>
            </div>
            <!---->
            <div style="flex: 0 0 260px; display: flex; flex-direction: column; gap: 22px;">

                <div class="card-metric">
                    <div class="metric-label">Total Sell Revenue</div>
                    <div class="metric-value" id="revenueValue">0 VND</div>
                </div>
                <div class="card-metric">
                    <div class="metric-label">Completed Orders</div>
                    <div class="metric-value" id="completedOrderValue">0</div>
                </div>
            </div>

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
                    let donutChart;


                    function loadChartData() {
                        const range = document.getElementById("rangeSelect").value;

                        // 1. Gọi API donut chart
                        fetch(`statistics?type=status&range=` + range)
                                .then(res => res.json())
                                .then(data => {
                                    const statusOrder = ['pending', 'processing', 'shipped', 'cancelled'];
                                    const statusLabelMap = {
                                        pending: "pending",
                                        processing: "processing",
                                        shipped: "shipped",
                                        cancelled: "cancelled"
                                    };
                                    const labels = statusOrder.map(s => statusLabelMap[s]);
                                    const values = statusOrder.map(s => data[s] || 0);
                                    const bgColors = [
                                        'rgb(255, 205, 86)', 
                                        'rgb(54, 162, 235)', 
                                        'rgb(75, 192, 192)', 
                                        'rgb(255, 99, 132)'  
                                    ];

                                    const ctx = document.getElementById('statusDonutChart').getContext('2d');
                                    if (donutChart)
                                        donutChart.destroy();

                                    donutChart = new Chart(ctx, {
                                        type: 'doughnut',
                                        data: {
                                            labels: labels,
                                            datasets: [{
                                                    data: values,
                                                    backgroundColor: bgColors,
                                                    borderWidth: 1
                                                }]
                                        },
                                        options: {
                                            responsive: true,
                                            plugins: {
                                                legend: {position: 'bottom'}
                                            }
                                        }
                                    });     
                                    const total = values.reduce((sum, v) => sum + v, 0);
                                    const shipped = data.shipped || 0;
                                    const cancelled = data.cancelled || 0;
                                    const completeRate = total === 0 ? 0 : Math.round(shipped * 1000 / total) / 10; // 1 số thập phân
                                    const cancelRate = total === 0 ? 0 : Math.round(cancelled * 1000 / total) / 10;

                                    document.getElementById('completedOrderRateValue').innerText = completeRate + '%';
                                    document.getElementById('cancelOrderRateValue').innerText = cancelRate + '%';
                                });


                        fetch(`statistics?type=summary&range=` + range)
                                .then(res => res.json())
                                .then(data => {
                                    document.getElementById('revenueValue').innerText =
                                            (data.revenue ? Number(data.revenue).toLocaleString() : 0) + " VND";
                                    document.getElementById('completedOrderValue').innerText =
                                            data.completedOrders || 0;
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
                            chartWrapper.style.display = "flex";

                            loadChartData();
                        }
                    }
</script>