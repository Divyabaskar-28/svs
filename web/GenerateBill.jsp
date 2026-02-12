<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%@ page import="java.sql.*" %>
<%@ page import="DBConnection.DBConnection" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Generate Bill - SVS Sweets</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

        <style>
            body {
                background-color: #fff8f0;
                font-family: 'Segoe UI', sans-serif;
                padding: 15px;
            }

            .bill-container {
                max-width: 590px;
                width: 100%;
                margin: auto;
                background: white;
                padding: 20px;
                border-radius: 15px;
                box-shadow: 0 0 15px rgba(0,0,0,0.1);
                font-size: 12pt;
            }

            table {
                margin-top: 5px;
            }

            th, td {
                text-align: center;
            }

            .total-row {
                font-weight: bold;
                background-color: #f2f2f2;
            }

            .btn-print {
                margin-top: 20px;
            }

            @media print {
                body {
                    margin: 0;
                    padding: 0;
                    background: white;
                }

                .btn-print,
                input[type="text"],
                input[type="number"],
                input[type="date"],
                .btn-danger,
                .btn-success {
                    display: none !important;
                }

                .bill-container {
                    margin: 1in auto;
                    width: 400px;
                    height: auto;
                    box-shadow: none;
                    border: none;
                    padding: 10px;
                    font-size: 12pt;
                }

                table {
                    font-size: 12pt;
                    width: 100%;
                    border-collapse: collapse;
                }

                th, td {
                    padding: 6px;
                    border: 1px solid #000;
                }
            }
            .main-content {
                margin-left: 250px;   /* width of dashboard sidebar */
                padding: 20px;
            }
        </style>
    </head>
    <body>
        <jsp:include page="ADashboard.jsp" />

        <div class="text-start ms-4 mt-4 no-print">

        </div>

        <div class="bill-container" id="printArea" style="margin-left:500px;border: 2px solid #DC143C; /* crimson border */
             transition: transform 0.3s ease, box-shadow 0.3s ease;margin-top:30px;">
            <h5 class="text-center text-danger"></h5>
            <div class="mb-2 d-flex justify-content-between">
                <div>
                    <strong>Customer Name:</strong> <span id="nameDisplay"></span><br>
                    <strong>Date:</strong> <span id="dateDisplay"></span>
                </div>
                <div class="text-end">
                    <strong>Invoice No:</strong> <span id="invoiceNumber"></span>
                </div>
            </div>

            <div class="row mb-3 no-print">
                <div class="col-md-6">
                    <select id="customerName" class="form-select" onchange="updateDisplay()" required>
                        <option value="">-- Select Customer --</option>
                        <%                           try (Connection con = DBConnection.getConnection();
                                    Statement stmt = con.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT name FROM customers ORDER BY name ASC")) {

                                while (rs.next()) {
                                    String custName = rs.getString("name");
                        %>
                        <option value="<%= custName%>"><%= custName%></option>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<option disabled>Error loading customers</option>");
                                e.printStackTrace();
                            }
                        %>

                    </select>
                </div>

                <div class="col-md-6">
                    <input type="date" id="billDate" class="form-control" oninput="updateDisplay()" required>
                </div>
            </div>

            <table class="table table-bordered" id="billTable">
                <thead class="table-secondary">
                    <tr>
                        <th>Item</th>
                        <th>Qty</th>
                        <th>Price</th>
                        <th>Amount</th>
                        <th class="no-print">Remove</th>
                    </tr>
                </thead>
                <tbody id="billBody">
                    <tr>
                        <td><input type="text" class="form-control item" placeholder="Item"></td>
                        <td><input type="number" class="form-control qty" value="" min="1"></td>
                        <td><input type="number" class="form-control amt" value="" min="0"></td>
                        <td class="amount-column align-middle">0</td>
                        <td class="no-print"><button type="button" class="btn btn-danger btn-sm" onclick="removeRow(this)">X</button></td>
                    </tr>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="4" class="no-print">
                            <button type="button" class="btn btn-success btn-sm" onclick="addRow()">+ Add Row</button>
                        </td>
                        <td class="no-print"></td>
                    </tr>
                    <tr class="total-row">
                        <td colspan="3">Day's Amount</td>
                        <td colspan="3" id="daysAmount">0</td>
                    </tr>
                    <tr class="total-row">
                        <td colspan="3">Balance</td>
                        <td colspan="3"><input type="number" id="balance" class="form-control" value="0" readonly>
                        </td>
                        <!--<td colspan="3"><input type="number" id="balance" class="form-control" value="0" onchange="calculateTotal()"></td>-->
                    </tr>
                    <tr class="total-row">
                        <td colspan="3">Total Amount</td>
                        <td colspan="3" id="totalAmount">0</td>
                    </tr>
                </tfoot>
            </table>

            <div class="text-center btn-print">
                <button class="btn btn-danger" onclick="printBill()">Print Bill</button>
            </div>
            <!-- Hidden form for submission -->
            <form id="billForm" action="SaveBillServlet" method="post">
                <input type="hidden" name="invoice_no" id="formInvoice">
                <input type="hidden" name="customer_name" id="formName">
                <input type="hidden" name="bill_date" id="formDate">
                <input type="hidden" name="days_amount" id="formDays">
                <input type="hidden" name="balance" id="formBalance">
                <input type="hidden" name="total_amount" id="formTotal">

                <input type="hidden" name="items_json" id="formItems"> <!-- item rows in JSON -->
            </form>

        </div>
        <script>
            let currentInvoiceNumber = "";

            // 🔹 Add New Row
            function addRow() {
                const tbody = document.getElementById("billBody");
                const row = document.createElement("tr");

                row.innerHTML = `
                    <td><input type="text" class="form-control item" placeholder="Item"></td>
                    <td><input type="number" class="form-control qty" min="1"></td>
                    <td><input type="number" class="form-control amt" min="0" step="0.01"></td>
                    <td class="amount-column align-middle">0.00</td>
                    <td class="no-print">
                        <button type="button" class="btn btn-danger btn-sm" onclick="removeRow(this)">X</button>
                    </td>
                `;

                tbody.appendChild(row);
            }

            // 🔹 Remove Row
            function removeRow(btn) {
                btn.closest("tr").remove();
                calculateTotal();
            }

            // 🔹 Auto Calculate When Typing
            document.addEventListener("input", function (e) {
                if (e.target.classList.contains("qty") ||
                        e.target.classList.contains("amt")) {
                    calculateTotal();
                }
            });

            // 🔹 Calculate Total
            function calculateTotal() {
                let total = 0;

                document.querySelectorAll("#billBody tr").forEach(row => {
                    const qty = parseFloat(row.querySelector(".qty").value) || 0;
                    const price = parseFloat(row.querySelector(".amt").value) || 0;
                    const amount = qty * price;

                    row.querySelector(".amount-column").innerText = amount.toFixed(2);
                    total += amount;
                });

                document.getElementById("daysAmount").innerText = total.toFixed(2);

                const balance = parseFloat(document.getElementById("balance").value) || 0;
                document.getElementById("totalAmount").innerText =
                        (total + balance).toFixed(2);
            }

            // 🔹 Update Customer & Date Display + Fetch Balance
            function updateDisplay() {
                const name = document.getElementById("customerName").value;
                document.getElementById("nameDisplay").innerText = name || "--";

                const dateInput = document.getElementById("billDate").value;
                if (dateInput) {
                    const dateObj = new Date(dateInput);
                    document.getElementById("dateDisplay").innerText =
                            dateObj.toLocaleDateString("en-GB");
                } else {
                    document.getElementById("dateDisplay").innerText = "--";
                }

                // Fetch balance
                if (name) {
                    fetch("GetBalance.jsp?customer=" + encodeURIComponent(name))
                            .then(res => res.json())
                            .then(data => {
                                document.getElementById("balance").value = data.balance || 0;
                                calculateTotal();
                            })
                            .catch(err => console.error("Balance fetch error:", err));
                }
            }

            // 🔹 Generate Invoice Number
            function generateInvoiceNumber() {
                const now = new Date();
                return "INV" +
                        now.getFullYear() +
                        ("0" + (now.getMonth() + 1)).slice(-2) +
                        ("0" + now.getDate()).slice(-2) +
                        ("0" + now.getHours()).slice(-2) +
                        ("0" + now.getMinutes()).slice(-2) +
                        ("0" + now.getSeconds()).slice(-2);
            }

            // 🔹 Print & Save Bill
            function printBill() {
                const name = document.getElementById("customerName").value.trim();
                const date = document.getElementById("billDate").value.trim();

                if (!name || !date) {
                    alert("Please select customer and date.");
                    return;
                }

                updateDisplay();

                currentInvoiceNumber = generateInvoiceNumber();
                document.getElementById("invoiceNumber").innerText = currentInvoiceNumber;

                // Fill hidden form
                document.getElementById("formInvoice").value = currentInvoiceNumber;
                document.getElementById("formName").value = name;
                document.getElementById("formDate").value = date;
                document.getElementById("formDays").value =
                        document.getElementById("daysAmount").innerText;
                document.getElementById("formBalance").value =
                        document.getElementById("balance").value;
                document.getElementById("formTotal").value =
                        document.getElementById("totalAmount").innerText;

                // Collect items
                let items = [];

                document.querySelectorAll("#billBody tr").forEach(row => {
                    const item = row.querySelector(".item").value.trim();
                    const qty = row.querySelector(".qty").value;
                    const amt = row.querySelector(".amt").value;
                    const amount = row.querySelector(".amount-column").innerText;

                    if (item && qty && amt) {
                        items.push({item, qty, amt, amount});
                    }
                });

                if (items.length === 0) {
                    alert("Add at least one item.");
                    return;
                }

                document.getElementById("formItems").value = JSON.stringify(items);

                // Submit form
                document.getElementById("billForm").submit();
            }

            // 🔹 On Page Load
            window.addEventListener("DOMContentLoaded", function () {
                currentInvoiceNumber = generateInvoiceNumber();
                document.getElementById("invoiceNumber").innerText = currentInvoiceNumber;
                calculateTotal();
            });
        </script>


    </body>
</html>
