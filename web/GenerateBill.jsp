<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="DBConnection.DBConnection" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Generate Bill - SVS Sweets</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <style>
            body {
                background-color: #f4f4f4;
                font-family: 'Segoe UI', sans-serif;
                margin: 0;
                padding: 20px;
            }

            /* Printable Bill Design */
            .bill-wrapper {
                display: flex;
                justify-content: center;
                align-items: flex-start;  /* important */
                min-height: auto;         /* remove full height */
                padding: 0;
            }

            .bill-container {
                /*max-width: 550px;*/
                width: 100%;
                /*background: white;*/
                /*border: 2px solid #DC143C;  crimson border */
                /*transition: transform 0.3s ease, box-shadow 0.3s ease;*/
                /*box-shadow: 0 0 20px rgba(0,0,0,0.2);*/
                font-size: 12pt;
                line-height: 1.4;
                /*margin: 20px auto;*/
                /*margin-left:505px;*/
            }

            .bill-content {
                padding: 25px 20px;
            }
            .bill-container,
            .input-section {
                margin: 0;
            }

            /* Bill Header */
            .bill-header {
                text-align: center;
                border-bottom: 2px dashed #333;
                padding-bottom: 15px;
                margin-bottom: 15px;
            }

            .shop-name {
                font-size: 24px;
                font-weight: bold;
                letter-spacing: 2px;
                text-transform: uppercase;
                margin: 0;
            }

            .shop-sub {
                font-size: 11px;
                letter-spacing: 1px;
                margin: 5px 0 0;
            }

            .gst-info {
                font-size: 10px;
                margin-top: 5px;
            }

            /* Bill Info Section */
            .bill-info {
                margin-bottom: 8px;   /* reduced */
                padding: 6px 0;
            }


            .info-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 5px;
                font-size: 11pt;
            }

            .info-label {
                font-weight: bold;
            }

            /* Items Table */
            .items-table {
                width: 100%;
                border-collapse: collapse;
                margin: 15px 0;
            }

            .items-table th {
                border-top: 1px solid #333;
                border-bottom: 1px solid #333;
                padding: 8px 5px;
                font-size: 11pt;
                text-align: center;
            }

            .items-table td {
                padding: 5px;
                font-size: 11pt;
                border-bottom: 1px dotted #999;
            }

            .items-table td:first-child {
                text-align: left;
            }

            .items-table td:not(:first-child) {
                text-align: right;
            }

            .item-row td {
                padding: 5px;
            }

            /* Bill Summary */
            .bill-summary {
                margin-top: 15px;
                border-top: 2px double #333;
                padding-top: 10px;
            }

            .summary-row {
                display: flex;
                justify-content: space-between;
                padding: 3px 0;
                font-size: 11pt;
            }

            .summary-row.total {
                border-top: 1px solid #333;
                margin-top: 5px;
                padding-top: 5px;
                font-weight: bold;
                font-size: 13pt;
            }

            /* Bill Footer */
            .bill-footer {
                margin-top: 30px;
                text-align: center;
                border-top: 1px dashed #333;
                padding-top: 15px;
            }

            .signature-area {
                display: flex;
                justify-content: space-between;
                margin-top: 30px;
                padding: 0 10px;
            }

            .signature-line {
                border-top: 1px solid #333;
                width: 150px;
                text-align: center;
                padding-top: 5px;
                font-size: 10px;
            }
            .main-container {
                max-width: 550px;
                /*margin: 30px auto;*/
                background: #fff;
                border: 2px solid #DC143C;
                box-shadow: 0 0 20px rgba(0,0,0,0.15);
            }

            /* Input Section (Non-printable) */
            .input-section {
                max-width: 549px;
                margin: 0 auto;      /* reduce gap */
                padding: 15px 20px;  /* reduce height */
                border-bottom: 2px solid grey;
                background: #fff;
            }


            .input-section .form-control {
                margin-bottom: 0px;
            }   

            .btn-section {
                max-width: 400px;
                margin: 20px auto;
                text-align: center;
            }

            @media print {

                body {
                    background: #fff;
                    margin: 0;
                    padding: 0;
                }
                .main-container {
                    width: 550px;          /* Same as screen */
                    margin: 0 auto;        /* Center in A4 */
                    border: none;
                    box-shadow: none;
                }

                .no-print,
                .input-section,
                .btn-section,
                .btn-print,
                nav,
                header,
                footer {
                    display: none !important;
                }

                .bill-wrapper {
                    display: block;
                    min-height: auto;
                    margin: 0;
                }

                .bill-container {
                    width: 100%;
                    border: 1px solid #000;
                }


                .bill-content {
                    padding: 20px;
                }

                table {
                    page-break-inside: avoid;
                }

                tr {
                    page-break-inside: avoid;
                }
            }

            /* Control Buttons */
            .control-btn {
                background: #DC143C;
                color: white;
                border: none;
                padding: 10px 30px;
                font-size: 14px;
                border-radius: 5px;
                cursor: pointer;
                margin: 0 10px;
            }

            .control-btn:hover {
                background: #a01030;
            }

            .add-row-btn {
                background: #28a745;
                color: white;
                border: none;
                padding: 5px 15px;
                border-radius: 3px;
                cursor: pointer;
            }

            .remove-btn {
                background: #dc3545;
                color: white;
                border: none;
                padding: 3px 8px;
                border-radius: 3px;
                cursor: pointer;
            }

            table input {
                width: 100%;
                padding: 5px;
                border: 1px solid #ddd;
                border-radius: 3px;
            }
            @page {
                size: A4;
                margin: 10mm;
            }


        </style>
    </head>
    <body>
        <div class="no-print">
            <jsp:include page="ADashboard.jsp" />
        </div>

        <div class="main-container" style="border: 2px solid #DC143C; /* crimson border */
             transition: transform 0.3s ease, box-shadow 0.3s ease;margin-left:500px;">
            <!-- Input Section (Non-printable) -->
            <div class="input-section no-print">
                <h4 class="text-center mb-3">Generate New Bill</h4>
                <div class="row">
                    <div class="col-12" style="margin-bottom:5px;">
                        <select id="customerName" class="form-control" onchange="updateDisplay()" required>
                            <option value="">-- Select Customer --</option>
                            <% try (Connection con = DBConnection.getConnection();
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
                    <div class="col-12">
                        <input type="date" id="billDate" class="form-control" oninput="updateDisplay()" required>
                    </div>
                </div>
            </div>

            <!-- Bill Container - Exact Bill Design -->
            <div class="bill-wrapper">
                <div class="bill-container" id="printArea">
                    <div class="bill-content">

                        <!-- Bill Information -->
                        <div class="bill-info">
                            <div class="info-row">
                                <span class="info-label">Invoice No:</span>
                                <span id="invoiceNumber">__________</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Date:</span>
                                <span id="dateDisplay">__________</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Customer Name:</span>
                                <span id="nameDisplay">__________</span>
                            </div>
                        </div>

                        <!-- Items Table -->
                        <table class="items-table" id="billTable">
                            <thead>
                                <tr>
                                    <th>Item</th>
                                    <th>Qty</th>
                                    <th>Price</th>
                                    <th>Amount</th>
                                    <th class="no-print">Action</th>
                                </tr>
                            </thead>
                            <tbody id="billBody">
                                <tr class="item-row">
                                    <td><input type="text" class="form-control item" placeholder="Item"></td>
                                    <td><input type="number" class="form-control qty" value="" min="1"></td>
                                    <td><input type="number" class="form-control amt" value="" min="0" step="0.01"></td>
                                    <td class="amount-column">0.00</td>
                                    <td class="no-print"><button type="button" class="remove-btn" onclick="removeRow(this)">✕</button></td>
                                </tr>
                            </tbody>
                        </table>

                        <!-- Add Row Button (Non-printable) -->
                        <div class="text-center no-print mb-3">
                            <button type="button" class="add-row-btn" onclick="addRow()">+ Add More Item</button>
                        </div>

                        <!-- Bill Summary -->
                        <div class="bill-summary">
                            <div class="summary-row">
                                <span>Day's Amount:</span>
                                <span id="daysAmount">0.00</span>
                            </div>
                            <div class="summary-row">
                                <span>Previous Balance:</span>
                                <span><input type="number" id="balance" class="form-control" value="0" readonly style="width: 100px; text-align: right; border: none; background: transparent; font-weight: normal;"></span>
                            </div>
                            <div class="summary-row total">
                                <span>Total Amount:</span>
                                <span id="totalAmount">0.00</span>
                            </div>
                        </div>

                        <!-- Amount in Words -->
                        <div style="margin-top: 15px; font-size: 10pt; border-top: 1px dashed #333; padding-top: 10px;">
                            <span class="info-label">Amount in Words:</span><br>
                            <span id="amountInWords">__________________________________</span>
                        </div>

                        <!-- Bill Footer -->
                        <div class="bill-footer">
                            <div>* Thank you for your order. Please order again *</div>
                            <!--                        <div style="font-size: 9px; margin-top: 5px;">This is a computer generated invoice</div>
                            
                                                    <div class="signature-area">
                                                        <div class="signature-line">Customer Signature</div>
                                                        <div class="signature-line">Authorized Signature</div>
                                                    </div>
                            
                                                    <div style="font-size: 9px; margin-top: 15px;">
                                                        Subject to City Jurisdiction | E.& O.E.
                                                    </div>-->
                        </div>
                    </div>
                </div>

            </div>
            <div class="btn-section no-print">
                <button class="control-btn" onclick="printBill()">Print Bill</button>
                <!--<button class="control-btn" style="background: #17a2b8;" onclick="previewBill()">Preview</button>-->
            </div>
        </div>

        <!-- Action Buttons (Non-printable) -->


        <!-- Hidden form for submission -->
        <form id="billForm" action="SaveBillServlet" method="post" class="no-print">
            <input type="hidden" name="invoice_no" id="formInvoice">
            <input type="hidden" name="customer_name" id="formName">
            <input type="hidden" name="bill_date" id="formDate">
            <input type="hidden" name="days_amount" id="formDays">
            <input type="hidden" name="balance" id="formBalance">
            <input type="hidden" name="total_amount" id="formTotal">
            <input type="hidden" name="items_json" id="formItems">
        </form>

        <script>
            let currentInvoiceNumber = "";

            // Number to Words converter
            function numberToWords(num) {
                if (num === 0)
                    return "Zero";

                const ones = ['', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine',
                    'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'];
                const tens = ['', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'];

                if (num < 20)
                    return ones[num];
                if (num < 100)
                    return tens[Math.floor(num / 10)] + (num % 10 ? ' ' + ones[num % 10] : '');
                if (num < 1000)
                    return ones[Math.floor(num / 100)] + ' Hundred' + (num % 100 ? ' ' + numberToWords(num % 100) : '');
                if (num < 100000)
                    return numberToWords(Math.floor(num / 1000)) + ' Thousand' + (num % 1000 ? ' ' + numberToWords(num % 1000) : '');
                if (num < 10000000)
                    return numberToWords(Math.floor(num / 100000)) + ' Lakh' + (num % 100000 ? ' ' + numberToWords(num % 100000) : '');
                return numberToWords(Math.floor(num / 10000000)) + ' Crore' + (num % 10000000 ? ' ' + numberToWords(num % 10000000) : '');
            }

            // Add New Row
            function addRow() {
                const tbody = document.getElementById("billBody");
                const row = document.createElement("tr");
                row.className = "item-row";
                row.innerHTML = `
                    <td><input type="text" class="form-control item" placeholder="Item"></td>
                    <td><input type="number" class="form-control qty" min="1"></td>
                    <td><input type="number" class="form-control amt" min="0" step="0.01"></td>
                    <td class="amount-column">0.00</td>
                    <td class="no-print"><button type="button" class="remove-btn" onclick="removeRow(this)">✕</button></td>
                `;
                tbody.appendChild(row);
            }

            // Remove Row
            function removeRow(btn) {
                if (document.querySelectorAll("#billBody tr").length > 1) {
                    btn.closest("tr").remove();
                    calculateTotal();
                } else {
                    alert("At least one item row is required.");
                }
            }

            // Auto Calculate When Typing
            document.addEventListener("input", function (e) {
                if (e.target.classList.contains("qty") || e.target.classList.contains("amt")) {
                    calculateTotal();
                }
            });

            // Calculate Total
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
                let balance = parseFloat(document.getElementById("balance").value) || 0;
                let finalTotal = total + balance;
                document.getElementById("totalAmount").innerText = finalTotal.toFixed(2);

                // Update amount in words
                document.getElementById("amountInWords").innerText = numberToWords(Math.round(finalTotal)) + " Rupees Only";
            }

            // Update Customer & Date Display + Fetch Balance
            function updateDisplay() {
                const name = document.getElementById("customerName").value;
                document.getElementById("nameDisplay").innerText = name || "__________";

                const dateInput = document.getElementById("billDate").value;
                if (dateInput) {
                    const dateObj = new Date(dateInput);
                    const day = String(dateObj.getDate()).padStart(2, '0');
                    const month = String(dateObj.getMonth() + 1).padStart(2, '0');
                    const year = dateObj.getFullYear();
                    document.getElementById("dateDisplay").innerText = day + "/" + month + "/" + year;
                } else {
                    document.getElementById("dateDisplay").innerText = "__________";
                }

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

            // Generate Invoice Number
            function generateInvoiceNumber() {
                const now = new Date();
                return "SVS/" +
                        now.getFullYear() + "/" +
                        ("0" + (now.getMonth() + 1)).slice(-2) +
                        ("0" + now.getDate()).slice(-2) + "/" +
                        ("0" + now.getHours()).slice(-2) +
                        ("0" + now.getMinutes()).slice(-2) +
                        ("0" + now.getSeconds()).slice(-2);
            }

            // Preview Bill
            function previewBill() {
                updateDisplay();
                currentInvoiceNumber = generateInvoiceNumber();
                document.getElementById("invoiceNumber").innerText = currentInvoiceNumber;
                calculateTotal();
                window.scrollTo({
                    top: document.querySelector('.bill-container').offsetTop - 20,
                    behavior: 'smooth'
                });
            }

            function printBill() {

                const name = document.getElementById("customerName").value.trim();
                const date = document.getElementById("billDate").value.trim();

                if (!name || !date) {
                    alert("Please select customer and date.");
                    return;
                }

                previewBill();

                // Fill hidden form
                document.getElementById("formInvoice").value = currentInvoiceNumber;
                document.getElementById("formName").value = name;
                document.getElementById("formDate").value = date;
                document.getElementById("formDays").value = document.getElementById("daysAmount").innerText;
                document.getElementById("formBalance").value = document.getElementById("balance").value;
                document.getElementById("formTotal").value = document.getElementById("totalAmount").innerText;

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

                // 🔥 FIRST PRINT
                window.print();

            }
            window.onafterprint = function () {
                document.getElementById("billForm").submit();
            };

            // On Page Load
            window.addEventListener("DOMContentLoaded", function () {
                currentInvoiceNumber = generateInvoiceNumber();
                document.getElementById("invoiceNumber").innerText = currentInvoiceNumber;
                calculateTotal();

                // Set today's date as default
                const today = new Date().toISOString().split('T')[0];
                document.getElementById("billDate").value = today;
                updateDisplay();
            });
        </script>
    </body>
</html>