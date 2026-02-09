
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

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBConnection.getConnection();

        // 🔹 Customer Count
        ps = con.prepareStatement("SELECT COUNT(*) FROM customers");
        rs = ps.executeQuery();
        if (rs.next()) {
            customerCount = rs.getInt(1);
        }
        rs.close();
        ps.close();

        // 🔹 Today Bill Amount
        ps = con.prepareStatement(
            "SELECT COALESCE(SUM(total_amount),0) FROM bills WHERE DATE(created_at)=CURDATE()"
        );
        rs = ps.executeQuery();
        if (rs.next()) {
            todayBillAmount = rs.getDouble(1);
        }
        rs.close();
        ps.close();

        // 🔹 Today Payment Amount
        ps = con.prepareStatement(
            "SELECT COALESCE(SUM(paid_amount),0) FROM payment_history WHERE DATE(payment_time)=CURDATE()"
        );
        rs = ps.executeQuery();
        if (rs.next()) {
            todayPaymentAmount = rs.getDouble(1);
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        // ❌ Do NOT close connection here (DBConnection manages it)
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
        </style>
    </head>

    <body>

        <jsp:include page="ADashboard.jsp" />

        <div class="main-content">

            <h3 class="mb-3">Admin Dashboard</h3>

            <div style="text-align:center; margin-bottom:25px;">
                <i class="bi bi-person-circle" style="font-size:28px;"></i><br>
                <strong><%= adminName%></strong>
            </div>

            <div class="row g-4">

                <!-- Customers -->
                <div class="col-md-4">
                    <div class="dashboard-box">
                        <i class="bi bi-people-fill"></i>
                        <h5>Total Customers</h5>
                        <h3><%= customerCount%></h3>
                    </div>
                </div>

                <!-- Today Billing -->
                <div class="col-md-4">
                    <div class="dashboard-box">
                        <i class="bi bi-receipt-cutoff"></i>
                        <h5>Today's Billing</h5>
                        <h3>₹ <%= String.format("%.2f", todayBillAmount)%></h3>
                    </div>
                </div>

                <!-- Today Payments -->
                <div class="col-md-4">
                    <div class="dashboard-box">
                        <i class="bi bi-cash-coin"></i>
                        <h5>Today's Payments</h5>
                        <h3>₹ <%= String.format("%.2f", todayPaymentAmount)%></h3>
                    </div>
                </div>

            </div>
        </div>

    </body>
</html>
