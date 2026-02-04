<%@ page import="java.sql.*,java.text.SimpleDateFormat" %>
<%@ page import="DBConnection.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Payment History</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <style>
        table th, table td {
            text-align: center;
            vertical-align: middle;
        }
        .btn-download {
            background: green;
            color: #fff;
            border-radius: 4px;
            padding: 6px 10px;
            font-size: 13px;
        }
        .btn-download:hover {
            background: darkgreen;
            color: #fff;
        }
         .table-container {
             margin-top:30px;
            background:#fff;
            padding:25px;
            border-radius:15px;
            box-shadow:0 0 10px rgba(0,0,0,0.1);
        }
        h2 {
            text-align:center;
            color:#DC143C;
            margin-bottom:20px;
        }
    </style>
</head>

<body>

<!-- ✅ Sidebar -->
<jsp:include page="ADashboard.jsp" />


<div class="table-container" style="width:1060px;margin-left:280px;">
    <h2>Payment History</h2>

                    <!-- 🔍 FILTERS -->
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <input type="text" id="nameSearch"
                                   class="form-control"
                                   placeholder="Search by customer name">
                        </div>

                        <div class="col-md-3">
                            <input type="date" id="dateFilter" class="form-control">
                        </div>

                        <div class="col-md-2">
                            <button class="btn btn-secondary w-100"
                                    onclick="clearFilters()">Clear</button>
                        </div>
                    </div>

                    <!-- 📋 TABLE -->
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover"
                               id="paymentTable">
                            <thead class="table-secondary">
                                <tr>
                                    <th>#</th>
                                    <th>Customer Name</th>
                                    <th>Invoice No</th>
                                    <th>Paid Amount</th>
                                    <th>Return Amount</th>
                                    <th>Balance Amount</th>
                                    <th>Payment Mode</th>
                                    <th>Paid By</th>
                                    <th>Payment Time</th>
                                    <th>Download</th>
                                </tr>
                            </thead>
                            <tbody>

<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;
int i = 1;

SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
SimpleDateFormat dateOnly = new SimpleDateFormat("dd-MM-yyyy");

try {
    con = DBConnection.getConnection();
    ps = con.prepareStatement(
        "SELECT * FROM payment_history ORDER BY payment_time DESC"
    );
    rs = ps.executeQuery();

    while(rs.next()) {
        int paymentId = rs.getInt("payment_id");
        Timestamp ts = rs.getTimestamp("payment_time");
%>
                                <tr>
                                    <td><%= i++ %></td>
                                    <td><%= rs.getString("customer_name") %></td>
                                    <td><%= rs.getString("invoice_no") %></td>
                                    <td>₹ <%= rs.getDouble("paid_amount") %></td>
                                    <td>₹ <%= rs.getDouble("return_amount") %></td>
                                    <td>₹ <%= rs.getDouble("balance_after") %></td>
                                    <td><%= rs.getString("payment_mode") %></td>
                                    <td><%= rs.getString("paid_by") %></td>

                                    <!-- date text for filter -->
                                    <td data-date="<%= dateOnly.format(ts) %>">
                                        <%= sdf.format(ts) %>
                                    </td>

                                    <td>
                                        <a href="PaymentHistoryPDFServlet?payment_id=<%= paymentId %>"
                                           class="btn-download">
                                            <i class="bi bi-download"></i>
                                        </a>
                                    </td>
                                </tr>
<%
    }
} catch(Exception e) {
    e.printStackTrace();
} finally {
    try { if(rs!=null) rs.close(); } catch(Exception e){}
    try { if(ps!=null) ps.close(); } catch(Exception e){}
    try { if(con!=null) con.close(); } catch(Exception e){}
}
%>

                            </tbody>
                        </table>
                   
    </div>
</div>

<!-- 🔎 FILTER SCRIPT -->
<script>
    const nameInput = document.getElementById("nameSearch");
    const dateInput = document.getElementById("dateFilter");
    const rows = document.querySelectorAll("#paymentTable tbody tr");

    function filterTable() {
        const name = nameInput.value.toLowerCase();
        const date = dateInput.value; // yyyy-mm-dd

        rows.forEach(row => {
            const customer =
                row.children[1].innerText.toLowerCase();

            const rowDate =
                row.children[8].getAttribute("data-date")
                    .split("-").reverse().join("-"); // yyyy-mm-dd

            const matchName = customer.includes(name);
            const matchDate = !date || rowDate === date;

            row.style.display = (matchName && matchDate) ? "" : "none";
        });
    }

    nameInput.addEventListener("keyup", filterTable);
    dateInput.addEventListener("change", filterTable);

    function clearFilters() {
        nameInput.value = "";
        dateInput.value = "";
        filterTable();
    }
</script>

</body>
</html>
