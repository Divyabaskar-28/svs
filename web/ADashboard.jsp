<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    HttpSession session1 = request.getSession(false);
    if(session1 == null || session1.getAttribute("admin_username") == null){
        response.sendRedirect("Login.jsp");
        return;
    }

    String adminName = session1.getAttribute("admin_username").toString();
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
    margin-top:0;
}

/* 🔴 SIDEBAR */
.sidebar{
    width:260px;
    height:100vh;
    position:fixed;
    background:linear-gradient(180deg,#c40000,#8b0000);
    padding:20px 0;
    color:#fff;
    top: 0;
    left: 0;
}


.sidebar h4{
    text-align:center;
    font-weight:700;
    margin-bottom:35px;
    letter-spacing:1px;
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


/* HEADER */
.page-title{
    font-size:26px;
    font-weight:700;
    color:#c40000;
    margin-bottom:35px;
}

/* DASHBOARD BOX */
.dashboard-box{
    background:#ffffff;
    border-radius:18px;
    padding:30px 20px;
    text-align:center;

    /* 🔴 RED OUTLINE */
    border:2px solid #c40000;

    box-shadow:0 8px 20px rgba(196,0,0,0.15);
    transition:0.3s;
}

.dashboard-box:hover{
    transform:translateY(-6px);

    /* 🔥 STRONG RED GLOW ON HOVER */
    box-shadow:0 0 0 3px rgba(196,0,0,0.15),
               0 18px 40px rgba(196,0,0,0.25);
}


.dashboard-box i{
    font-size:42px;
    color:#c40000;
    margin-bottom:15px;
}

.dashboard-box h5{
    font-size:18px;
    font-weight:600;
    color:#333;
}
.logo-box{
    background:#ffffff;
    margin:0 20px 35px;
    padding:15px;
    border-radius:14px;
    text-align:center;
    box-shadow:0 6px 15px rgba(0,0,0,0.15);
}

.logo-box img{
    max-width:100%;
    height:50px;
    object-fit:contain;
}

</style>
</head>

<body>

    
<!-- 🔴 SIDEBAR -->
<div class="sidebar">
    <div class="logo-box">
    <img src="./Images/logo.png" alt="SVS Sweets Logo">
    </div>

 

<a href="AdminDashboard.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
    <a href="AddAdmin.jsp"><i class="bi bi-person-badge-fill"></i> Add Admin</a>
    <a href="AddCustomer.jsp"><i class="bi bi-person-plus-fill"></i> Add Customer</a>
    <a href="CustomerDetails.jsp"><i class="bi bi-person-lines-fill"></i> Customer Details</a>
    <a href="GenerateBill.jsp"><i class="bi bi-receipt"></i> Generate Bill</a>
     <a href="History.jsp"><i class="bi bi-clock-history"></i> Bill History</a>
    <a href="Payment.jsp"><i class="bi bi-credit-card-2-front-fill"></i> Payment</a>
    <a href="PaymentHistory.jsp"><i class="bi bi-cash-stack"></i> Payment History</a>
   
    <a href="Homepage.jsp"><i class="bi bi-box-arrow-right"></i> Logout</a>
</div>


</body>
</html>
