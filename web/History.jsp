<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page import="DBConnection.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    String adminUser = (String) session.getAttribute("admin_username");
    boolean canEditDelete =
            "Divya".equalsIgnoreCase(adminUser) ||
            "Shanmu".equalsIgnoreCase(adminUser);
%>

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

    <!-- FILTERS -->
    <div class="row mb-3">
        <div class="col-md-4">
            <input type="text" id="nameSearch" class="form-control"
                   placeholder="Search by customer name...">
        </div>
        <div class="col-md-3 offset-md-3">
            <input type="date" id="dateFilter" class="form-control">
        </div>
        <div class="col-md-2">
            <button class="btn btn-secondary w-100" onclick="clearFilters()">Clear</button>
        </div>
    </div>

    <!-- TABLE -->
    <table class="table table-bordered table-striped text-center align-middle" id="billingTable">
        <thead class="table-danger">
        <tr>
            <th>S.No</th>
            <!--<th>Date</th>-->
            <th>Customer</th>
            <th>Invoice No</th>
            <th>Amount</th>
            <th>Items</th>
            <th>Created By</th>
            <th>Created At</th>
            <th>Download</th>
            <% if (canEditDelete) { %>
                <th>Delete</th>
            <% } %>
        </tr>
        </thead>

        <tbody>
        <%
            int sno = 1;
            SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
            SimpleDateFormat dtf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

            Connection con = DBConnection.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM bills ORDER BY created_at DESC");

            StringBuilder modals = new StringBuilder();

            while (rs.next()) {
                String invoice = rs.getString("invoice_no");
        %>

        <tr>
            <td><%= sno++ %></td>
           
            <td><%= rs.getString("customer_name") %></td>
            <td><%= invoice %></td>
            <td>₹ <%= rs.getDouble("days_amount") %></td>

            <td>
                <button class="btn btn-info btn-sm"
                        data-bs-toggle="modal"
                        data-bs-target="#itemsModal_<%= invoice %>">
                    <i class="bi bi-eye"></i>
                </button>
            </td>

            <td><%= rs.getString("created_by") %></td>
            <td><%= dtf.format(rs.getTimestamp("created_at")) %></td>

            <td>
                <a href="DownloadInvoicePDF.jsp?invoice=<%= invoice %>"
                   class="btn btn-success btn-sm">
                    <i class="bi bi-download"></i>
                </a>
            </td>

            <% if (canEditDelete) { %>
            <td>
                <a href="DeleteBill.jsp?invoice=<%= invoice %>"
                   class="btn btn-danger btn-sm"
                   onclick="return confirm('Delete this invoice?')">
                    <i class="bi bi-trash"></i>
                </a>
            </td>
            <% } %>
        </tr>

        <%
            // -------- MODAL START ----------
            modals.append(
                "<div class='modal fade' id='itemsModal_" + invoice + "' tabindex='-1'>" +
                "<div class='modal-dialog modal-lg modal-dialog-centered'>" +
                "<div class='modal-content'>" +
                "<div class='modal-header bg-danger text-white'>" +
                "<h5 class='modal-title'>Invoice Items - " + invoice + "</h5>" +
                "<button type='button' class='btn-close' data-bs-dismiss='modal'></button>" +
                "</div><div class='modal-body'>" +
                "<table class='table table-bordered text-center'>" +
                "<thead class='table-secondary'><tr>" +
                "<th>Item</th><th>Qty</th><th>Price</th><th>Amount</th>"
            );

            if (canEditDelete) modals.append("<th>Edit</th><th>Delete</th>");

            modals.append("</tr></thead><tbody>");

            PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM bill_items WHERE invoice_no=?");
            ps.setString(1, invoice);
            ResultSet irs = ps.executeQuery();

            while (irs.next()) {
                int itemId = irs.getInt("item_id");

                modals.append(
                    "<tr>" +
                    "<td><input class='form-control form-control-sm' id='name_" + itemId + "' value='" + irs.getString("item_name") + "' disabled></td>" +
                    "<td><input type='number' class='form-control form-control-sm' id='qty_" + itemId + "' value='" + irs.getInt("quantity") + "' disabled></td>" +
                    "<td><input type='number' class='form-control form-control-sm' id='price_" + itemId + "' value='" + irs.getDouble("price") + "' disabled></td>" +
                    "<td><input class='form-control form-control-sm' id='amt_" + itemId + "' value='" + irs.getDouble("amount") + "' disabled></td>"
                );

                if (canEditDelete) {
                    modals.append(
                        "<td>" +
                        "<button class='btn btn-warning btn-sm' onclick='enableEdit(" + itemId + ")'><i class='bi bi-pencil'></i></button> " +
                        "<button class='btn btn-success btn-sm d-none' id='save_" + itemId + "' onclick='saveItem(" + itemId + ")'><i class='bi bi-check'></i></button>" +
                        "</td>" +
                        "<td><button class='btn btn-danger btn-sm' onclick=\"if(confirm('Delete this item?')) location.href='DeleteItem.jsp?id=" + itemId + "'\"><i class='bi bi-trash'></i></button></td>"
                    );
                }

                modals.append("</tr>");
            }

            modals.append("</tbody></table></div></div></div></div>");

            irs.close();
            ps.close();
        %>

        <%
            }
            rs.close(); st.close(); con.close();
        %>

        </tbody>
    </table>

    <%= modals.toString() %>
</div>

<script>
const nameInput = document.getElementById("nameSearch");
const dateInput = document.getElementById("dateFilter");

function filterTable() {
    const name = nameInput.value.toLowerCase();
    const date = dateInput.value;

    document.querySelectorAll("#billingTable tbody tr").forEach(row => {
        const customer = row.children[2].innerText.toLowerCase();
        const rowDate = row.children[1].innerText.split("-").reverse().join("-");
        row.style.display = (customer.includes(name) && (!date || rowDate === date)) ? "" : "none";
    });
}

nameInput.addEventListener("keyup", filterTable);
dateInput.addEventListener("change", filterTable);

function clearFilters() {
    nameInput.value = "";
    dateInput.value = "";
    filterTable();
}

function enableEdit(id) {
    document.getElementById("name_" + id).disabled = false;
    document.getElementById("qty_" + id).disabled = false;
    document.getElementById("price_" + id).disabled = false;
    document.getElementById("save_" + id).classList.remove("d-none");
}

function saveItem(id) {
    let name = document.getElementById("name_" + id).value;
    let qty = document.getElementById("qty_" + id).value;
    let price = document.getElementById("price_" + id).value;

    let xhr = new XMLHttpRequest();
    xhr.open("POST", "UpdateItemAjax.jsp", true);
    xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhr.send("id=" + id + "&name=" + name + "&qty=" + qty + "&price=" + price);

    xhr.onload = () => location.reload();
}
</script>

</body>
</html>
