<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Bill History - SVS Sweets</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <style>
            body {
                background-color: #fff8f0;
                font-family: 'Segoe UI', sans-serif;
                padding: 40px;
            }
            .table-container {
                max-width: 1300px;
                margin: auto;
                background: white;
                padding: 20px;
                border-radius: 15px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            h2 {
                text-align: center;
                color: #DC143C;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>

        <%@ include file="AdminHeader.jsp" %>

        <div class="mb-3 d-flex justify-content-between">
            <a href="DownloadBillHistory.jsp" class="btn btn-success" style="margin-left:1060px">
                <i class="bi bi-download"></i> Download 
            </a>
            <a href="AdminDashboard.jsp" class="btn btn-danger">
                <i class="bi bi-arrow-left"></i> Back 
            </a>
        </div>


        <div class="table-container">
            <h2>Billing History</h2>

            <!-- 🔍 Search Box -->
            <!--            <div class="mb-3">
                            <input type="text" id="searchBox" class="form-control" placeholder="Search by Customer Name..." onkeyup="filterTable()">
                        </div>-->

            <table class="table table-bordered table-striped text-center">
                <thead class="table-danger">
                    <tr>
                        <th>Invoice No</th>
                        <th>Customer Name</th>
                        <th>Billing Date</th>
                        <th>Day's Amount</th>

                        <th>Created By</th>
                        <th>Created At</th>
                    </tr>
                </thead>

                <tbody>
                    <%                try {
                            Class.forName("com.mysql.jdbc.Driver");
                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/svs", "root", "");
                            Statement stmt = con.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT * FROM bills ORDER BY created_at DESC");

                           SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");

                            while (rs.next()) {
                                String invoice = rs.getString("invoice_no");
                                String customer = rs.getString("customer_name");
                                Date billDate = rs.getDate("bill_date");
                                double daysAmount = rs.getDouble("days_amount");

                                String createdBy = rs.getString("created_by");
                                Timestamp createdAt = rs.getTimestamp("created_at");
                    %>
                    <tr>
                        <td><%= invoice%></td>
                        <td><%= customer%></td>
                        <td><%= (billDate != null ? sdf.format(billDate) : "")%></td>
                        <td><%= daysAmount%></td>

                        <td><%= (createdBy != null ? createdBy : "")%></td>
                        <td><%= (createdAt != null ? sdf.format(createdAt) : "")%></td>
                    </tr>
                    <%
                            }
                            rs.close();
                            stmt.close();
                            con.close();
                        } catch (Exception e) {
                            out.println("<tr><td colspan='6' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>

        <!-- 🔍 Filter Script -->
        <script>
            function filterTable() {
                const input = document.getElementById("searchBox").value.toLowerCase();
                const rows = document.querySelectorAll("tbody tr");

                rows.forEach(row => {
                    const customer = row.cells[1].textContent.toLowerCase(); // Customer Name column
                    row.style.display = customer.includes(input) ? "" : "none";
                });
            }
        </script>

    </body>
</html>
