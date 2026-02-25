<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="DBConnection.DBConnection" %>

<%
    HttpSession session1 = request.getSession(false);
    if (session1 == null || session1.getAttribute("admin_username") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    String adminName = session1.getAttribute("admin_username").toString();

    int customerCount = 0;
    double todayBillAmount = 0;
    double todayPaymentAmount = 0;
    double todayReturnAmount = 0;

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBConnection.getConnection();
        String dbType = con.getMetaData().getDatabaseProductName();
        boolean isMySQL = dbType.toLowerCase().contains("mysql");
        boolean isPostgreSQL = dbType.toLowerCase().contains("postgresql");

        ps = con.prepareStatement("SELECT COUNT(*) FROM customers");
        rs = ps.executeQuery();
        if (rs.next()) {
            customerCount = rs.getInt(1);
        }
        rs.close();
        ps.close();

        String billQuery = isMySQL
                ? "SELECT COALESCE(SUM(total_amount),0) FROM bills WHERE DATE(created_at)=CURRENT_DATE()"
                : "SELECT COALESCE(SUM(total_amount),0) FROM bills WHERE DATE(created_at)=CURRENT_DATE";

        ps = con.prepareStatement(billQuery);
        rs = ps.executeQuery();
        if (rs.next()) {
            todayBillAmount = rs.getDouble(1);
        }
        rs.close();
        ps.close();

        String paymentQuery = isMySQL
                ? "SELECT COALESCE(SUM(paid_amount),0) FROM payment_history WHERE DATE(payment_time)=CURRENT_DATE()"
                : "SELECT COALESCE(SUM(paid_amount),0) FROM payment_history WHERE DATE(payment_time)=CURRENT_DATE";

        ps = con.prepareStatement(paymentQuery);
        rs = ps.executeQuery();
        if (rs.next()) {
            todayPaymentAmount = rs.getDouble(1);
        }
        rs.close();
        ps.close();

        String returnQuery = isMySQL
                ? "SELECT COALESCE(SUM(return_amount),0) FROM bills WHERE DATE(return_time)=CURRENT_DATE() AND return_time IS NOT NULL"
                : "SELECT COALESCE(SUM(return_amount),0) FROM bills WHERE DATE(return_time)=CURRENT_DATE AND return_time IS NOT NULL";

        ps = con.prepareStatement(returnQuery);
        rs = ps.executeQuery();
        if (rs.next()) {
            todayReturnAmount = rs.getDouble(1);
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) {
                rs.close();
            }
        } catch (Exception e) {
        }
        try {
            if (ps != null) {
                ps.close();
            }
        } catch (Exception e) {
        }
        try {
            if (con != null) {
                con.close();
            }
        } catch (Exception e) {
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Admin Dashboard - SVS Sweets</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <style>
            body{
                margin:0;
                font-family:'Segoe UI', sans-serif;
                background:#f4f6f9;
            }

            .main-content{
                margin-left:250px;
                padding:25px;
                min-height:100vh;
            }

            .stat-card{
                background:#ffffff;
                border-radius:14px;
                padding:18px;
                border:1px solid #eee;
                box-shadow:0 4px 12px rgba(0,0,0,0.05);
                transition:0.3s;
            }

            .stat-card:hover{
                transform:translateY(-4px);
                box-shadow:0 8px 18px rgba(0,0,0,0.08);
            }

            .stat-icon{
                font-size:28px;
                color:#c40000;
            }

            .stat-title{
                font-size:14px;
                color:#666;
                margin-bottom:5px;
            }

            .stat-value{
                font-size:20px;
                font-weight:600;
                color:#111;
            }

            .analytics-card{
                background:#fff;
                border-radius:16px;
                padding:25px;
                margin-top:30px;
                box-shadow:0 4px 16px rgba(0,0,0,0.06);
            }

            #filter{
                border-radius:20px;
                padding:5px 15px;
                font-size:14px;
            }

        </style>
    </head>

    <body>

        <jsp:include page="ADashboard.jsp" />

        <div class="main-content">

            <h4 class="mb-3">📊 Admin Dashboard</h4>

            <div class="mb-4">
                <i class="bi bi-person-circle" style="font-size:22px;color:#c40000;"></i>
                <span style="font-weight:500;"> Welcome, <%= adminName%>!</span>
            </div>

            <!-- Stats Row -->
            <div class="row g-3">

                <div class="col-md-3">
                    <div class="stat-card text-center">
                        <i class="bi bi-people-fill stat-icon"></i>
                        <div class="stat-title mt-2">Total Customers</div>
                        <div class="stat-value"><%= customerCount%></div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="stat-card text-center">
                        <i class="bi bi-receipt stat-icon"></i>
                        <div class="stat-title mt-2">Today's Billing</div>
                        <div class="stat-value">₹ <%= String.format("%,.2f", todayBillAmount)%></div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="stat-card text-center">
                        <i class="bi bi-cash-coin stat-icon"></i>
                        <div class="stat-title mt-2">Today's Payments</div>
                        <div class="stat-value">₹ <%= String.format("%,.2f", todayPaymentAmount)%></div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="stat-card text-center">
                        <i class="bi bi-arrow-counterclockwise stat-icon"></i>
                        <div class="stat-title mt-2">Today's Return</div>
                        <div class="stat-value">₹ <%= String.format("%,.2f", todayReturnAmount)%></div>
                    </div>
                </div>

            </div>

            <!-- Analytics -->
            <div class="analytics-card">

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="mb-0">📈 Sales Analytics</h6>

                    <select id="filter" class="form-select w-auto">
                        <option value="week">Current Week</option>
                        <option value="month">Month Wise</option>
                        <option value="year">Year Wise</option>
                    </select>
                </div>

                <canvas id="salesChart" height="90"></canvas>

            </div>

        </div>

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            let chart;

            function loadChart(filter) {
                fetch("SalesChartServlet?filter=" + filter)
                        .then(res => res.json())
                        .then(data => {

                            if (chart)
                                chart.destroy();

                            const ctx = document.getElementById('salesChart').getContext('2d');

                            chart = new Chart(ctx, {
                                type: 'bar', // ✅ BAR GRAPH
                                data: {
                                    labels: data.labels,
                                    datasets: [
                                        {
                                            label: 'Billing',
                                            data: data.bill,
                                            backgroundColor: '#c40000'
                                        },
                                        {
                                            label: 'Payment',
                                            data: data.payment,
                                            backgroundColor: '#28a745'
                                        },
                                        {
                                            label: 'Return',
                                            data: data.return,
                                            backgroundColor: '#ffc107'
                                        }
                                    ]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: true,
                                    plugins: {
                                        legend: {
                                            position: 'top'
                                        }
                                    },
                                    scales: {
                                        y: {
                                            beginAtZero: true,
                                            ticks: {
                                                callback: function (value) {
                                                    return '₹ ' + value.toLocaleString('en-IN');
                                                }
                                            }
                                        }
                                    }
                                }
                            });

                        })
                        .catch(err => console.error(err));
            }

            document.getElementById("filter").addEventListener("change", function () {
                loadChart(this.value);
            });

            loadChart("week");
        </script>

    </body>
</html>