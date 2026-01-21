<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Customer Payment - SVS Sweets</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <style>
            body {
                background-color: #fff8f0;
                font-family: 'Segoe UI', sans-serif;
                padding: 40px;
            }
            .container {
                max-width: 600px;
                margin: auto;
                background: #fff;
                padding: 30px;
                border-radius: 15px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            h2 {
                color: #DC143C;
                text-align: center;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>

        <%@ include file="AdminHeader.jsp" %>
        <div class="mb-3">
            <a href="AdminDashboard.jsp" class="btn btn-danger" style="margin-left:1160px">
                <i class="bi bi-arrow-left"></i> Back 
            </a>
        </div>

        <div class="container">
            <h2>Customer Payment</h2>
            <form action="SavePaymentServlet" method="post" onsubmit="return validateForm()">
                <div class="mb-3">
                    <label>Customer Name</label>
                    <select name="customer_name" id="customerSelect" class="form-select" onchange="fetchTotalAmount()" required>
                        <option value="">-- Select Customer --</option>
                        <%                    try {
                                Class.forName("com.mysql.jdbc.Driver");
                                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/svs", "root", "");
                                Statement st = con.createStatement();
                                ResultSet rs = st.executeQuery("SELECT DISTINCT customer_name FROM bills");
                                while (rs.next()) {
                        %>
                        <option value="<%= rs.getString("customer_name")%>"><%= rs.getString("customer_name")%></option>
                        <%
                                }
                                con.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        %>
                    </select>
                </div>

                <div class="mb-3">
                    <label>Total Amount</label>
                    <input type="number" step="0.01" name="total_amount" id="totalAmount" class="form-control" readonly>
                </div>

                <div class="mb-3">
                    <label>Paid Amount</label>
                    <input type="number" step="0.01" name="paid_amount" id="paidAmount" class="form-control" required oninput="calculateBalance()">
                </div>

                <div class="mb-3">
                    <label>Return Amount</label>
                    <input type="number" step="0.01" name="return_amount" id="returnAmount" class="form-control" required oninput="calculateBalance()">
                </div>

                <input type="hidden" name="balance" id="balance">
                <input type="hidden" name="return_time" id="returnTime">



                <div class="mb-3">
                    <label>Payment Mode</label>
                    <select name="payment_mode" class="form-select" required>
                        <option value="">-- Select Mode --</option>
                        <option value="Cash">Cash</option>
                        <option value="Bank Transfer">Bank Transfer</option>
                        <option value="Net Banking">Net Banking</option>
                        <option value="Cheque">Cheque</option>
                    </select>
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-danger">Submit Payment</button>
                </div>
            </form>
        </div>

        <script>
            function fetchTotalAmount() {
                const customer = document.getElementById("customerSelect").value;
                if (!customer)
                    return;

                fetch("GetTotalAmount.jsp?customer=" + encodeURIComponent(customer))
                        .then(response => response.json())
                        .then(data => {
                            document.getElementById("totalAmount").value = data.total || 0;
                            calculateBalance();
                        });
            }

            function calculateBalance() {
                const total = parseFloat(document.getElementById("totalAmount").value) || 0;
                const paid = parseFloat(document.getElementById("paidAmount").value) || 0;
                const ret = parseFloat(document.getElementById("returnAmount").value) || 0;
                const balance = total - paid - ret;
                document.getElementById("balance").value = balance.toFixed(2); // stored in hidden field

                // Set return time only if return amount is greater than 0
                if (ret > 0) {
                    const now = new Date();
                    const formatted = now.getFullYear() + '-' +
                            String(now.getMonth() + 1).padStart(2, '0') + '-' +
                            String(now.getDate()).padStart(2, '0') + ' ' +
                            String(now.getHours()).padStart(2, '0') + ':' +
                            String(now.getMinutes()).padStart(2, '0') + ':' +
                            String(now.getSeconds()).padStart(2, '0');
                    document.getElementById("returnTime").value = formatted;
                } else {
                    document.getElementById("returnTime").value = "";
                }
            }



            function validateForm() {
                const paid = document.getElementById("paidAmount").value;
                const ret = document.getElementById("returnAmount").value;
                if (paid === "" || ret === "") {
                    alert("Please enter both Paid and Return amount.");
                    return false;
                }
                return true;
            }
        </script>

    </body>
</html>
