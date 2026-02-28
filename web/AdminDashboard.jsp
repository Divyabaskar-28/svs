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

        ps = con.prepareStatement("SELECT COUNT(*) FROM customers");
        rs = ps.executeQuery();
        if (rs.next()) customerCount = rs.getInt(1);
        rs.close(); ps.close();

        String billQuery = isMySQL ?
            "SELECT COALESCE(SUM(day_amount),0) FROM bills WHERE DATE(created_at)=CURRENT_DATE()" :
            "SELECT COALESCE(SUM(day_amount),0) FROM bills WHERE DATE(created_at)=CURRENT_DATE";

        ps = con.prepareStatement(billQuery);
        rs = ps.executeQuery();
        if (rs.next()) todayBillAmount = rs.getDouble(1);
        rs.close(); ps.close();

        String paymentQuery = isMySQL ?
            "SELECT COALESCE(SUM(paid_amount),0) FROM payment_history WHERE DATE(payment_time)=CURRENT_DATE()" :
            "SELECT COALESCE(SUM(paid_amount),0) FROM payment_history WHERE DATE(payment_time)=CURRENT_DATE";

        ps = con.prepareStatement(paymentQuery);
        rs = ps.executeQuery();
        if (rs.next()) todayPaymentAmount = rs.getDouble(1);
        rs.close(); ps.close();

        String returnQuery = isMySQL ?
            "SELECT COALESCE(SUM(return_amount),0) FROM bills WHERE DATE(return_time)=CURRENT_DATE() AND return_time IS NOT NULL" :
            "SELECT COALESCE(SUM(return_amount),0) FROM bills WHERE DATE(return_time)=CURRENT_DATE AND return_time IS NOT NULL";

        ps = con.prepareStatement(returnQuery);
        rs = ps.executeQuery();
        if (rs.next()) todayReturnAmount = rs.getDouble(1);

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
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
            padding:35px 30px;
            min-height:100vh;
        }

        .welcome-box{
            text-align:center;
            margin-bottom:25px;
        }

        .welcome-box i{
            font-size:26px;
            color:#c40000;
        }

        .welcome-box h5{
            margin-top:6px;
            font-weight:600;
            font-size:18px;
        }

        /* Compact Cards */
        .dashboard-box{
            background:#fff;
            border-radius:12px;
            padding:18px 15px;   /* 🔥 reduced padding */
            text-align:center;
            box-shadow:0 4px 12px rgba(0,0,0,0.06);
            transition:0.2s;
            border:1px solid #eee;
        }

        .dashboard-box:hover{
            transform:translateY(-3px);
            box-shadow:0 8px 18px rgba(0,0,0,0.08);
        }

        .dashboard-box i{
            font-size:26px;   /* 🔥 smaller icon */
            color:#c40000;
            margin-bottom:6px;
        }

        .dashboard-box h6{
            font-size:13px;
            margin-bottom:4px;
            color:#666;
            font-weight:500;
        }

        .dashboard-box h4{
            font-size:18px;
            font-weight:700;
            margin:0;
        }

        .analytics-card{
            margin-top:45px;
            padding:25px;
            border-radius:14px;
            background:#fff;
            box-shadow:0 6px 20px rgba(0,0,0,0.06);
        }

        #filter{
            border-radius:20px;
            padding:4px 12px;
            font-size:13px;
        }
    </style>
</head>

<body>

<jsp:include page="ADashboard.jsp" />

<div class="main-content">

    <div class="welcome-box">
        <i class="bi bi-person-circle"></i>
        <h5>Welcome, <%= adminName %> 👋</h5>
    </div>

    <!-- Compact Stats Cards -->
    <div class="row g-3">

        <div class="col-lg-3 col-md-6">
            <div class="dashboard-box">
                <i class="bi bi-people-fill"></i>
                <h6>Total Customers</h6>
                <h4><%= customerCount %></h4>
            </div>
        </div>

        <div class="col-lg-3 col-md-6">
            <div class="dashboard-box">
                <i class="bi bi-receipt-cutoff"></i>
                <h6>Today's Billing</h6>
                <h4>₹ <%= String.format("%,.2f", todayBillAmount) %></h4>
            </div>
        </div>

        <div class="col-lg-3 col-md-6">
            <div class="dashboard-box">
                <i class="bi bi-cash-coin"></i>
                <h6>Today's Payments</h6>
                <h4>₹ <%= String.format("%,.2f", todayPaymentAmount) %></h4>
            </div>
        </div>

        <div class="col-lg-3 col-md-6">
            <div class="dashboard-box">
                <i class="bi bi-arrow-counterclockwise"></i>
                <h6>Today's Return</h6>
                <h4>₹ <%= String.format("%,.2f", todayReturnAmount) %></h4>
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

        if(chart) chart.destroy();

        const ctx = document.getElementById('salesChart').getContext('2d');

        chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: data.labels,
                datasets: [{
                    label: 'Billing',
                    data: data.bill,
                    borderColor: '#c40000',
                    tension: 0.4,
                    fill: false,
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins:{ legend:{ position:'top' }},
                scales:{
                    y:{
                        beginAtZero:true,
                        ticks:{
                            callback:function(value){
                                return '₹ ' + value.toLocaleString('en-IN');
                            }
                        }
                    }
                }
            }
        });

    });
}

document.getElementById("filter").addEventListener("change", function () {
    loadChart(this.value);
});

loadChart("week");
</script>

</body>
</html>