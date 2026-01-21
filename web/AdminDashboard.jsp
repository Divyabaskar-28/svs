<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Admin Dashboard - SVS Sweets</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            body {
                background: linear-gradient(to right, #ffe6e6, #fff5f5);
                font-family: 'Segoe UI', sans-serif;
                margin: 0;
                padding: 0;
            }

            .dashboard-container {
                padding: 60px 20px;
                text-align: center;
            }

            .dashboard-title {
                font-size: 32px;
                font-weight: bold;
                color: #d60000;
                margin-bottom: 40px;
            }

            .card-box {
                background-color: #fff;
                border-radius: 20px;
                padding: 30px 20px;
                box-shadow: 0 8px 20px rgba(0,0,0,0.1);
                transition: transform 0.3s ease;
                border-left: 6px solid #d60000;
            }

            .card-box:hover {
                transform: translateY(-5px);
            }

            .card-box i {
                font-size: 36px;
                margin-bottom: 15px;
                color: #d60000;
            }

            .card-box h5 {
                font-size: 20px;
                color: #333;
                font-weight: 600;
            }

            .logout-btn {
                margin-top: 40px;
            }

            .btn-logout {
                background-color: #d60000;
                color: white;
                padding: 10px 30px;
                border-radius: 30px;
                font-size: 16px;
                transition: 0.3s;
            }

            .btn-logout:hover {
                background-color: #a00000;
            }
        </style>
    </head>
    <body>
<%@ include file="AdminHeader.jsp" %>


        <div class="container dashboard-container">
            <div class="dashboard-title">Welcome, Admin</div>

            <div class="row g-4 justify-content-center">
                <div class="col-md-4">
                    <a href="AddCustomer.jsp" class="text-decoration-none">
                        <div class="card-box">
                            <i class="bi bi-person-plus-fill"></i>
                            <h5>Add Customer</h5>
                        </div>
                    </a>
                </div>
                <div class="col-md-4">
                    <a href="CustomerDetails.jsp" class="text-decoration-none">
                        <div class="card-box">
                            <i class="bi bi-person-lines-fill"></i>
                            <h5>Customer Details</h5>
                        </div>
                    </a>
                </div>
                <div class="col-md-4">
                    <a href="GenerateBill.jsp" class="text-decoration-none">
                        <div class="card-box">
                            <i class="bi bi-receipt-cutoff"></i>
                            <h5>Generate Bill</h5>
                        </div>
                    </a>
                </div>
                <div class="col-md-4">
                    <a href="History.jsp" class="text-decoration-none">
                        <div class="card-box">
                            <i class="bi bi-clock-history"></i>

                            <h5>History</h5>
                        </div>
                    </a>
                </div>
                <div class="col-md-4">
                    <a href="Payment.jsp" class="text-decoration-none">
                        <div class="card-box">
                           <i class="bi bi-credit-card-2-front-fill"></i>
                            <h5>Payment</h5>
                        </div>
                    </a>
                </div>

            </div>

            <div class="logout-btn">
                <a href="Homepage.jsp" class="btn btn-logout">
                    <i class="bi bi-box-arrow-right"></i> Logout
                </a>
            </div>
        </div>

    </body>
</html>
