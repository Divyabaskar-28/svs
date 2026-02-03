<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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


/* MAIN CONTENT */
.main-content{
    margin-left:260px;
    padding:35px;
    min-height:100vh;
    background:#fff;
    border-top-left-radius:25px;
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


</style>
</head>

<body>
    <jsp:include page="ADashboard.jsp" />
<!-- ⚪ MAIN -->
<div class="main-content">
    <div class="page-title">Admin Dashboard</div>

    <div class="row g-4">
        <div class="col-md-4">
            <div class="dashboard-box">
                <i class="bi bi-people-fill"></i>
                <h5>Customers</h5>
            </div>
        </div>

        <div class="col-md-4">
            <div class="dashboard-box">
                <i class="bi bi-receipt-cutoff"></i>
                <h5>Billing</h5>
            </div>
        </div>

        <div class="col-md-4">
            <div class="dashboard-box">
                <i class="bi bi-cash-coin"></i>
                <h5>Payments</h5>
            </div>
        </div>
    </div>
</div>

</body>
</html>
