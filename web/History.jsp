<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page import="DBConnection.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Billing History - SVS Sweets</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <style>
        body {
            background:#fff8f0;
            font-family:'Segoe UI',sans-serif;
            padding:40px;
        }
        .table-container {
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

<jsp:include page="ADashboard.jsp" />

<div class="table-container" style="width:1010px;margin-left:270px;">
    <h2>Billing History</h2>

    <!-- 🔍 FILTERS -->
    <div class="row mb-3" style="margin-top:20px;">
        <div class="col-md-4">
            <input type="text" id="nameSearch" class="form-control"
                   placeholder="Search by customer name...">
        </div>

        <div class="col-md-3" style="margin-left:240px;">
            <input type="date" id="dateFilter" class="form-control">
        </div>

        <div class="col-md-2">
            <button class="btn btn-secondary w-100" onclick="clearFilters()">Clear</button>
        </div>
    </div>

    <!-- 📋 TABLE -->
    <table class="table table-bordered table-striped text-center align-middle"
           id="billingTable">
        <thead class="table-danger">
        <tr>
            <th>S.No</th>
            <th>Date</th>
            <th>Customer</th>
            <th>Invoice No</th>
            <th>Amount</th>
            <th>View</th>
            <th>Created By</th>
            <th>Created At</th>
            <th>Download</th>
        </tr>
        </thead>

        <tbody>
        <%
            int sno = 1;
            SimpleDateFormat dateFmt = new SimpleDateFormat("dd-MM-yyyy");
            SimpleDateFormat dateTimeFmt = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

            Connection con = DBConnection.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(
                "SELECT * FROM bills ORDER BY created_at DESC"
            );

            while (rs.next()) {
                String invoice = rs.getString("invoice_no");
        %>
        <tr>
            <td><%= sno++ %></td>
            <td><%= rs.getDate("bill_date") != null ? dateFmt.format(rs.getDate("bill_date")) : "" %></td>
            <td><%= rs.getString("customer_name") %></td>
            <td><%= invoice %></td>
            <td>₹ <%= rs.getDouble("total_amount") %></td>

            <td>
                <button class="btn btn-info btn-sm"
                        data-bs-toggle="modal"
                        data-bs-target="#itemsModal_<%= invoice %>">
                    <i class="bi bi-eye"></i>
                </button>
            </td>

            <td><%= rs.getString("created_by") %></td>
            <td><%= dateTimeFmt.format(rs.getTimestamp("created_at")) %></td>

            <td>
                <a href="DownloadInvoicePDF.jsp?invoice=<%= invoice %>"
                   class="btn btn-success btn-sm">
                    <i class="bi bi-download"></i>
                </a>
            </td>
        </tr>

       
        </tbody>
    </table>
                    <!-- 🔍 MODAL FOR THIS INVOICE -->
        <div class="modal fade" id="itemsModal_<%= invoice %>" tabindex="-1">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">

                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title">Invoice Items - <%= invoice %></h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">
                        <table class="table table-bordered text-center">
                            <thead class="table-secondary">
                            <tr>
                                <th>Item</th>
                                <th>Qty</th>
                                <th>Price</th>
                                <th>Amount</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                PreparedStatement ps =
                                    con.prepareStatement(
                                        "SELECT * FROM bill_items WHERE invoice_no=?"
                                    );
                                ps.setString(1, invoice);
                                ResultSet irs = ps.executeQuery();

                                while (irs.next()) {
                            %>
                            <tr>
                                <td><%= irs.getString("item_name") %></td>
                                <td><%= irs.getInt("quantity") %></td>
                                <td>₹ <%= irs.getDouble("price") %></td>
                                <td>₹ <%= irs.getDouble("amount") %></td>
                            </tr>
                            <%
                                }
                                irs.close();
                                ps.close();
                            %>
                            </tbody>
                        </table>
                    </div>

                </div>
            </div>
        </div>

        <%
            }
            rs.close();
            st.close();
            con.close();
        %>
</div>

<!-- 🔎 FILTER SCRIPT -->
<script>
    const nameInput = document.getElementById("nameSearch");
    const dateInput = document.getElementById("dateFilter");
    const rows = document.querySelectorAll("#billingTable tbody tr");

    function filterTable() {
        const name = nameInput.value.toLowerCase();
        const date = dateInput.value;

        rows.forEach(row => {
            const customer = row.children[2].innerText.toLowerCase();
            const rowDate = row.children[1].innerText.split("-").reverse().join("-");

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
