<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="DBConnection.DBConnection" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Generate Bill</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>
            body{
                background:#f4f4f4;
                font-family:'Segoe UI',sans-serif;
            }

            /* Main Card */
            .bill-card{
    width:600px;
    margin:40px auto;
    margin-left:500px;   /* you can adjust */
    background:#fff;
    border:2px solid #c82333;
    padding:25px;
    border-radius:15px;
}

            /* Header */
            .invoice-header{
                /*border-bottom:2px dashed #333;*/
                padding-bottom:10px;
                margin-bottom:15px;
            }

            .row1{
                display:flex;
                justify-content:space-between;
                font-weight:600;
            }

            .row2{
                margin-top:5px;
                font-weight:600;
            }

            .row3{
                display:flex;
                gap:10px;
                margin-top:10px;
            }

            .row3 select,
            .row3 input{
                height:38px;
                border-radius:6px;
                border:1px solid #ccc;
                padding:5px 10px;
                min-width:200px;
            }

            /* Table */
            #billTable{
                margin-top:15px;
            }

            #billTable th{
                background:#e6e6e6;
                text-align:center;
            }

            #billTable td{
                text-align:center;
                vertical-align:middle;
            }

            .amount-column{
                font-weight:600;
                text-align:right;
            }

            /* Buttons */
            .add-btn{
                background:#28a745;
                color:#fff;
                border:none;
                padding:6px 20px;
                border-radius:5px;
            }

            .remove-btn{
                background:#dc3545;
                border:none;
                color:#fff;
                padding:4px 10px;
                border-radius:4px;
            }

            .print-btn{
                background:#c82333;
                color:#fff;
                border:none;
                padding:10px 30px;
                border-radius:6px;
                margin-top:20px;
            }

            /* PRINT FORMAT */
@media print{

    body{
        background:#fff !important;
    }

    body *{
        visibility:hidden;
    }

    #printArea, #printArea *{
        visibility:visible;
    }

    #printArea{
        position:relative !important;
        margin:0 auto !important;     /* always center */
        width:700px !important;       /* fixed width */
        border:2px solid #000 !important;
        border-radius:15px !important;
        padding:25px !important;
        left:auto !important;         /* prevent left shift */
    }

    .no-print,
    .print-btn,
    .add-btn,
    .row3{
        display:none !important;
    }
}
        </style>
    </head>

    <body>

        <jsp:include page="ADashboard.jsp" />

        <div class="bill-card" id="printArea">

            <div class="invoice-header">

                <div class="row1">
                    <div>
                        Customer Name: <span id="nameDisplay">__________</span>
                    </div>
                    <div>
                        Invoice No: <span id="invoiceNumber"></span>
                    </div>
                </div>

                <div class="row2">
                    Date: <span id="dateDisplay">__________</span>
                </div>

                <div class="row3">
                    <select id="customerName" onchange="updateDisplay()" required>
                        <option value="">Select Customer</option>
                        <% try (Connection con = DBConnection.getConnection();
                                    Statement stmt = con.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT name FROM customers ORDER BY name ASC")) {
                                while (rs.next()) {
                                    String custName = rs.getString("name");
                        %>
                        <option value="<%= custName%>"><%= custName%></option>
                        <% }
                            } catch (Exception e) {
                            }%>
                    </select>

                    <input type="date" id="billDate" oninput="updateDisplay()" required>
                </div>

            </div>

            <!-- SINGLE TABLE -->
            <table class="table table-bordered text-center" id="billTable">

                <thead>
                    <tr>
                        <th>Item</th>
                        <th width="80">Qty</th>
                        <th width="100">Price</th>
                        <th width="120">Amount</th>
                        <th width="80" class="no-print">Remove</th>
                    </tr>
                </thead>

                <tbody id="billBody">

                    <tr>
                        <td><input type="text" class="form-control item"></td>
                        <td><input type="number" class="form-control qty" min="1"></td>
                        <td><input type="number" class="form-control amt" min="0" step="0.01"></td>
                        <td class="amount-column">0.00</td>
                        <td class="no-print">
                            <button type="button" class="remove-btn" onclick="removeRow(this)">X</button>
                        </td>
                    </tr>

                    <tr>
                        <td colspan="5">
                            <button type="button" class="add-btn" onclick="addRow()">+ Add Row</button>
                        </td>
                    </tr>

                    <tr>
                        <td colspan="3" class="text-end fw-bold">Day's Amount</td>
                        <td colspan="2" id="daysAmount">0.00</td>
                    </tr>

                    <tr>
                        <td colspan="3" class="text-end fw-bold">Previous Balance</td>
                        <td colspan="2">
                            <input type="number" id="balance" value="0" readonly
                                   style="width:120px;text-align:right;border:none;background:#fff;">
                        </td>
                    </tr>

                    <tr>
                        <td colspan="3" class="text-end fw-bold">Total Amount</td>
                        <td colspan="2" id="totalAmount">0.00</td>
                    </tr>

                </tbody>
            </table>

            <div class="text-center">
                <button class="print-btn" onclick="printBill()">Print Bill</button>
            </div>

        </div>

        <script>

            let currentInvoiceNumber = "";

            function addRow() {
                const tbody = document.getElementById("billBody");
                const row = document.createElement("tr");
                row.innerHTML = `
                <td><input type="text" class="form-control item"></td>
                <td><input type="number" class="form-control qty" min="1"></td>
                <td><input type="number" class="form-control amt" min="0" step="0.01"></td>
                <td class="amount-column">0.00</td>
                <td><button type="button" class="remove-btn" onclick="removeRow(this)">X</button></td>
            `;
                tbody.insertBefore(row, tbody.children[tbody.children.length - 4]);
            }

            function removeRow(btn) {
                if (document.querySelectorAll("#billBody tr").length > 5) {
                    btn.closest("tr").remove();
                    calculateTotal();
                }
            }

            document.addEventListener("input", function (e) {
                if (e.target.classList.contains("qty") || e.target.classList.contains("amt")) {
                    calculateTotal();
                }
            });

            function calculateTotal() {
                let total = 0;
                document.querySelectorAll("#billBody tr").forEach(row => {
                    const qtyField = row.querySelector(".qty");
                    const priceField = row.querySelector(".amt");
                    if (qtyField && priceField) {
                        const qty = parseFloat(qtyField.value) || 0;
                        const price = parseFloat(priceField.value) || 0;
                        const amount = qty * price;
                        row.querySelector(".amount-column").innerText = amount.toFixed(2);
                        total += amount;
                    }
                });
                document.getElementById("daysAmount").innerText = total.toFixed(2);
                let balance = parseFloat(document.getElementById("balance").value) || 0;
                document.getElementById("totalAmount").innerText = (total + balance).toFixed(2);
            }

            /* 🔥 BALANCE FETCH ADDED (Same as your first code) */
            function updateDisplay() {

                const name = document.getElementById("customerName").value;

                if (name) {
                    document.getElementById("nameDisplay").innerText = name;

                    if (currentInvoiceNumber === "") {
                        currentInvoiceNumber = generateInvoiceNumber();
                        document.getElementById("invoiceNumber").innerText = currentInvoiceNumber;
                    }

                    fetch("GetBalance.jsp?customer=" + encodeURIComponent(name))
                            .then(res => res.json())
                            .then(data => {
                                document.getElementById("balance").value = data.balance || 0;
                                calculateTotal();
                            })
                            .catch(err => console.error("Balance fetch error:", err));

                } else {
                    document.getElementById("nameDisplay").innerText = "__________";
                    document.getElementById("invoiceNumber").innerText = "";
                    document.getElementById("balance").value = 0;
                    currentInvoiceNumber = "";
                    calculateTotal();
                }

                const dateInput = document.getElementById("billDate").value;
                if (dateInput) {
                    const d = new Date(dateInput);
                    document.getElementById("dateDisplay").innerText =
                            String(d.getDate()).padStart(2, '0') + "/" +
                            String(d.getMonth() + 1).padStart(2, '0') + "/" +
                            d.getFullYear();
                } else {
                    document.getElementById("dateDisplay").innerText = "__________";
                }
            }

            function generateInvoiceNumber() {
                const now = new Date();
                return "INV" + now.getFullYear() +
                        ("" + (now.getMonth() + 1)).padStart(2, '0') +
                        ("" + now.getDate()).padStart(2, '0') +
                        ("" + now.getHours()).padStart(2, '0') +
                        ("" + now.getMinutes()).padStart(2, '0');
            }

            function printBill() {

                const name = document.getElementById("customerName").value.trim();
                const date = document.getElementById("billDate").value.trim();

                if (!name || !date) {
                    alert("Select customer and date");
                    return;
                }

                // 🔥 Collect Items
                let items = [];
                document.querySelectorAll("#billBody tr").forEach(row => {
                    const item = row.querySelector(".item");
                    const qty = row.querySelector(".qty");
                    const amt = row.querySelector(".amt");

                    if (item && qty && amt && item.value.trim() !== "") {
                        const quantity = parseFloat(qty.value) || 0;
                        const price = parseFloat(amt.value) || 0;

                        items.push({
                            item: item.value,
                            qty: quantity,
                            amt: price,
                            amount: quantity * price
                        });
                    }
                });

                if (items.length === 0) {
                    alert("Add at least one item");
                    return;
                }

                // 🔥 Prepare Form Data
                const formData = new URLSearchParams();
                formData.append("invoice_no", currentInvoiceNumber);
                formData.append("customer_name", name);
                formData.append("bill_date", date);
                formData.append("days_amount", document.getElementById("daysAmount").innerText);
                formData.append("balance", document.getElementById("balance").value);
                formData.append("total_amount", document.getElementById("totalAmount").innerText);
                formData.append("items_json", JSON.stringify(items));

                // 🔥 SAVE FIRST
                fetch("SaveBillServlet", {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: formData.toString()
                })
                        .then(res => {
                            if (res.ok) {
                                // 🔥 After save → Print
                                window.print();
                            } else {
                                alert("Error saving bill");
                            }
                        })
                        .catch(err => {
                            console.error(err);
                            alert("Server error");
                        });
            }
            window.onafterprint = function () {
                location.reload();   // 🔥 Page Reload
            };
            window.onload = function () {
                const today = new Date().toISOString().split('T')[0];
                document.getElementById("billDate").value = today;
                document.getElementById("invoiceNumber").innerText = "";
            };

        </script>

    </body>
</html>