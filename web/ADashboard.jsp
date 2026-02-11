<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    HttpSession session1 = request.getSession(false);
    if (session1 == null || session1.getAttribute("role") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    String role = session1.getAttribute("role").toString();
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

        /* 🔴 SIDEBAR */
        .sidebar{
            width:260px;
            height:100vh;
            position:fixed;
            top:0;
            left:0;
            background:linear-gradient(180deg,#c40000,#8b0000);
            display:flex;
            flex-direction:column;
            color:#fff;
        }

        /* 🔒 FIXED LOGO */
        .logo-box{
            background:#ffffff;
            margin:20px;
            padding:15px;
            border-radius:14px;
            text-align:center;
            box-shadow:0 6px 15px rgba(0,0,0,0.15);
            flex-shrink:0;   /* Important */
        }

        .logo-box img{
            max-width:100%;
            height:50px;
            object-fit:contain;
        }

        /* 🔽 SCROLLABLE MENU */
        .menu-section{
            flex:1;
            overflow-y:auto;
            padding-bottom:20px;
        }

        .sidebar a{
            display:flex;
            align-items:center;
            gap:12px;
            padding:13px 28px;
            color:#fff;
            text-decoration:none;
            font-size:15px;
            opacity:0.9;
        }

        .sidebar a:hover{
            background:rgba(255,255,255,0.15);
            border-left:4px solid #fff;
            padding-left:24px;
            opacity:1;
        }

    </style>
</head>

<body>

<!-- 🔴 SIDEBAR -->
<div class="sidebar">

    <!-- 🔒 Fixed Logo -->
    <div class="logo-box">
        <img src="./Images/logo.png" alt="SVS Sweets Logo">
    </div>

    <!-- 🔽 Scrollable Menu -->
    <div class="menu-section">

        <a href="AdminDashboard.jsp">
            <i class="bi bi-speedometer2"></i> Dashboard
        </a>

        <% if ("Admin".equalsIgnoreCase(role)) { %>

        <a href="AddAdmin.jsp">
            <i class="bi bi-person-badge-fill"></i> Add Workers
        </a>

        <a href="ViewWorkers.jsp">
            <i class="bi bi-people-fill"></i> View Workers
        </a>

        <% } %>

        <a href="AddCustomer.jsp">
            <i class="bi bi-person-plus-fill"></i> Add Customer
        </a>

        <a href="CustomerDetails.jsp">
            <i class="bi bi-person-lines-fill"></i> Customer Details
        </a>

        <a href="GenerateBill.jsp">
            <i class="bi bi-receipt"></i> Generate Hand Bill
        </a>

        <a href="History.jsp">
            <i class="bi bi-clock-history"></i> Hand Bill History
        </a>

        <a href="Payment.jsp">
            <i class="bi bi-credit-card-2-front-fill"></i> Payment
        </a>

        <a href="PaymentHistory.jsp">
            <i class="bi bi-cash-stack"></i> Payment History
        </a>

        <a href="ReturnUpdate.jsp">
            <i class="bi bi-arrow-counterclockwise"></i> Return Update
        </a>

        <a href="ViewReturnUpdate.jsp">
            <i class="bi bi-journal-text"></i> Return History
        </a>

        <a href="Login.jsp">
            <i class="bi bi-box-arrow-right"></i> Logout
        </a>

    </div>

</div>
<script>
    const menuSection = document.querySelector(".menu-section");

    // 🔹 Restore scroll position when page loads
    window.addEventListener("load", function () {
        const savedScroll = localStorage.getItem("sidebarScroll");
        if (savedScroll !== null) {
            menuSection.scrollTop = savedScroll;
        }
    });

    // 🔹 Save scroll position when scrolling
    menuSection.addEventListener("scroll", function () {
        localStorage.setItem("sidebarScroll", menuSection.scrollTop);
    });
</script>

</body>
</html>
