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

        // 🔹 Customer Count
        ps = con.prepareStatement("SELECT COUNT(*) FROM customers");
        rs = ps.executeQuery();
        if (rs.next()) {
            customerCount = rs.getInt(1);
        }
        rs.close();
        ps.close();

        // 🔹 Today Bill Amount (MySQL + PostgreSQL compatible)
        String billQuery;
        if (isMySQL) {
            billQuery = "SELECT COALESCE(SUM(total_amount),0) FROM bills WHERE DATE(created_at)=CURRENT_DATE()";
        } else { // PostgreSQL
            billQuery = "SELECT COALESCE(SUM(total_amount),0) FROM bills WHERE DATE(created_at)=CURRENT_DATE";
        }
        ps = con.prepareStatement(billQuery);
        rs = ps.executeQuery();
        if (rs.next()) {
            todayBillAmount = rs.getDouble(1);
        }
        rs.close();
        ps.close();

        // 🔹 Today Payment Amount
        String paymentQuery;
        if (isMySQL) {
            paymentQuery = "SELECT COALESCE(SUM(paid_amount),0) FROM payment_history WHERE DATE(payment_time)=CURRENT_DATE()";
        } else {
            paymentQuery = "SELECT COALESCE(SUM(paid_amount),0) FROM payment_history WHERE DATE(payment_time)=CURRENT_DATE";
        }
        ps = con.prepareStatement(paymentQuery);
        rs = ps.executeQuery();
        if (rs.next()) {
            todayPaymentAmount = rs.getDouble(1);
        }
        rs.close();
        ps.close();

        // 🔹 Today Return Amount
        String returnQuery;
        if (isMySQL) {
            returnQuery = "SELECT COALESCE(SUM(return_amount),0) FROM bills WHERE DATE(return_time)=CURRENT_DATE() AND return_time IS NOT NULL";
        } else {
            returnQuery = "SELECT COALESCE(SUM(return_amount),0) FROM bills WHERE DATE(return_time)=CURRENT_DATE AND return_time IS NOT NULL";
        }
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
                background:#f3f3f3;
            }

            .main-content{
                margin-left:250px;
                padding:35px;
                min-height:100vh;
                background:#fff;
                border-top-left-radius:25px;
            }

            .dashboard-box{
                background:#ffffff;
                border-radius:18px;
                padding:30px 20px;
                text-align:center;
                border:2px solid #c40000;
                box-shadow:0 8px 20px rgba(196,0,0,0.15);
                transition:0.3s;
            }

            .dashboard-box:hover{
                transform:translateY(-6px);
                box-shadow:0 0 0 3px rgba(196,0,0,0.15),
                    0 18px 40px rgba(196,0,0,0.25);
            }

            .dashboard-box i{
                font-size:42px;
                color:#c40000;
                margin-bottom:10px;
            }

            .dashboard-box h5{
                font-size:18px;
                font-weight:600;
                color:#333;
            }

            .dashboard-box h3{
                font-weight:700;
                color:#000;
            }

            .card {
                border-radius: 18px;
                border: none;
            }

            #filter {
                width: 150px;
                border-radius: 25px;
                border: 2px solid #c40000;
                padding: 8px 15px;
                font-weight: 500;
            }
        </style>
    </head>

    <body>
        <jsp:include page="ADashboard.jsp" />

        <div class="main-content">
            <h3 class="mb-4">📊 Admin Dashboard</h3>

            <div style="text-align:center; margin-bottom:25px;">
                <i class="bi bi-person-circle" style="font-size:28px; color:#c40000;"></i><br>
                <strong style="font-size:18px;">Welcome, <%= adminName%>!</strong>
            </div>

            <div class="row g-4">
                <!-- Customers -->
                <div class="col-md-3">
                    <div class="dashboard-box">
                        <i class="bi bi-people-fill"></i>
                        <h5>Total Customers</h5>
                        <h3><%= customerCount%></h3>
                    </div>
                </div>

                <!-- Today Billing -->
                <div class="col-md-3">
                    <div class="dashboard-box">
                        <i class="bi bi-receipt-cutoff"></i>
                        <h5>Today's Billing</h5>
                        <h3>₹ <%= String.format("%,.2f", todayBillAmount)%></h3>
                    </div>
                </div>

                <!-- Today Payments -->
                <div class="col-md-3">
                    <div class="dashboard-box">
                        <i class="bi bi-cash-coin"></i>
                        <h5>Today's Payments</h5>
                        <h3>₹ <%= String.format("%,.2f", todayPaymentAmount)%></h3>
                    </div>
                </div>

                <!-- Today Return -->
                <div class="col-md-3">
                    <div class="dashboard-box">
                        <i class="bi bi-arrow-counterclockwise"></i>
                        <h5>Today's Return</h5>
                        <h3>₹ <%= String.format("%,.2f", todayReturnAmount)%></h3>
                    </div>
                </div>
            </div>

            <div class="card mt-5 p-4 shadow">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="mb-0">📈 Sales Analytics</h5>
                    <select id="filter" class="form-select w-auto">
                        <option value="week">Current Week</option>
                        <option value="month">Month Wise</option>
                        <option value="year">Year Wise</option>
                    </select>

                </div>

                <canvas id="salesChart" height="100"></canvas>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            let chart;

            function loadChart(filter) {
                fetch("SalesChartServlet?filter=" + filter)
                        .then(response => response.json())
                        .then(data => {
                            if (chart) {
                                chart.destroy();
                            }

                            const ctx = document.getElementById('salesChart').getContext('2d');

                            chart = new Chart(ctx, {
                                type: 'line',
                                data: {
                                    labels: data.labels,
                                    datasets: [
                                        {
                                            label: 'Billing',
                                            data: data.bill,
                                            borderColor: '#c40000',
                                            backgroundColor: 'rgba(196,0,0,0.05)',
                                            tension: 0.4,
                                            fill: true,
                                            borderWidth: 3,
                                            pointBackgroundColor: '#c40000',
                                            pointRadius: 4
                                        },
                                        {
                                            label: 'Payment',
                                            data: data.payment,
                                            borderColor: '#28a745',
                                            backgroundColor: 'rgba(40,167,69,0.05)',
                                            tension: 0.4,
                                            fill: true,
                                            borderWidth: 3,
                                            pointBackgroundColor: '#28a745',
                                            pointRadius: 4
                                        },
                                        {
                                            label: 'Return',
                                            data: data.return,
                                            borderColor: '#ffc107',
                                            backgroundColor: 'rgba(255,193,7,0.05)',
                                            tension: 0.4,
                                            fill: true,
                                            borderWidth: 3,
                                            pointBackgroundColor: '#ffc107',
                                            pointRadius: 4
                                        }
                                    ]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: true,
                                    plugins: {
                                        legend: {
                                            position: 'top',
                                            labels: {
                                                usePointStyle: true,
                                                padding: 20,
                                                font: {size: 12, weight: '500'}
                                            }
                                        },
                                        tooltip: {
                                            mode: 'index',
                                            intersect: false,
                                            callbacks: {
                                                label: function (context) {
                                                    let label = context.dataset.label || '';
                                                    let value = context.raw || 0;
                                                    return label + ': ₹ ' + value.toLocaleString('en-IN', {
                                                        minimumFractionDigits: 2,
                                                        maximumFractionDigits: 2
                                                    });
                                                }
                                            }
                                        }
                                    },
                                    scales: {
                                        x: {
                                            grid: {display: false},
                                            title: {
                                                display: true,
                                                text: filter === 'year' ? 'Month' :
                                                        filter === 'month' ? 'Week' : 'Date',

                                                font: {weight: '500', size: 12}
                                            }
                                        },
                                        y: {
                                            beginAtZero: true,
                                            grid: {color: 'rgba(0,0,0,0.05)'},
                                            title: {
                                                display: true,
                                                text: 'Amount (₹)',
                                                font: {weight: '500', size: 12}
                                            },
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
                        .catch(error => {
                            console.error("Error loading chart:", error);
                            alert("Failed to load chart data. Please try again.");
                        });
            }

            // Filter change event
            document.getElementById("filter").addEventListener("change", function () {
                loadChart(this.value);
            });

            // Initial load
            loadChart("week");

        </script>
    </body>
</html>