<%@ page import="java.sql.*" %>
<%@ page import="DBConnection.DBConnection" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession session1 = request.getSession(false);
    if(session1 == null || session1.getAttribute("admin_username") == null){
        response.sendRedirect("Login.jsp");
        return;
    }
%>

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
                /*max-width: 600px;*/
                width:400px;
                margin: auto;
                background: #fff;
                padding: 35px;
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

        <jsp:include page="ADashboard.jsp" />
        <%
            String status = request.getParameter("status");
            if ("success".equals(status)) {
        %>
        <script>alert("Payment submitted successfully!");</script>
        <%
        } else if ("error".equals(status)) {
        %>
        <script>alert("Something went wrong!");</script>
        <%
        } else if ("notfound".equals(status)) {
        %>
        <script>alert("No payment record found!");</script>
        <%
            }
        %>


        <div class="container" style="width:600px; margin-left:475px;border: 2px solid #DC143C; /* crimson border */
             transition: transform 0.3s ease, box-shadow 0.3s ease;">
            <h2>Customer Payment</h2>
            <form action="SavePaymentServlet" method="post" onsubmit="return validateForm()">
                <div class="mb-3">
                    <label>Customer Name</label>
                    <select name="customer_name" id="customerSelect" class="form-select" onchange="fetchTotalAmount()" required>
                        <option value="">-- Select Customer --</option>
                        <%
                            try {
                                Connection con = DBConnection.getConnection();
                                Statement st = con.createStatement();
                                ResultSet rs = st.executeQuery(
                                        "SELECT DISTINCT customer_name FROM bills"
                                );

                                while (rs.next()) {
                        %>
                        <option value="<%= rs.getString("customer_name")%>">
                            <%= rs.getString("customer_name")%>
                        </option>
                        <%
                                }
                                rs.close();
                                st.close();
                                con.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        %>

                    </select>
                </div>

                <div class="mb-3">
                    <label>Total Outstanding</label>
                    <input type="number" id="totalOutstanding"
                           class="form-control" readonly>

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

                fetch("GetOutstanding.jsp?customer=" + encodeURIComponent(customer))
                        .then(res => res.json())
                        .then(data => {
                            document.getElementById("totalOutstanding").value =
                                    data.total_due || 0;
                            calculateBalance();
                        });
            }


            function calculateBalance() {
                const outstanding =
                        parseFloat(document.getElementById("totalOutstanding").value) || 0;
                const paid =
                        parseFloat(document.getElementById("paidAmount").value) || 0;
                const ret =
                        parseFloat(document.getElementById("returnAmount").value) || 0;

                const newBalance = outstanding - paid - ret;
                document.getElementById("balance").value = newBalance.toFixed(2);
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
