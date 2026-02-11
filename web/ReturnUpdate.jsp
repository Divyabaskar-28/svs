<%@ page import="java.sql.*" %>
<%@ page import="DBConnection.DBConnection" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Return Update</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .return-card {
                border: 2px solid #DC143C;
                border-radius: 15px;
                padding: 30px;
            }
        </style>

    </head>
    <body>

        <jsp:include page="ADashboard.jsp" />

        <div class="container mt-5" style="margin-left:230px;">
            <div class="row justify-content-center">
                <div class="col-md-7">
                    <div class="card shadow"
                         style="border:2px solid #DC143C; border-radius:15px; padding:30px;">


                        <h4 class="text-center mb-4">Return Update</h4>

                        <form action="ReturnUpdateServlet" method="post">

                            <!-- Customer -->
                            <div class="mb-3">
                                <label class="form-label">Customer Name</label>
                                <select name="customer_name" id="customerName"
                                        class="form-select"
                                        required onchange="fetchOutstanding()">
                                    <option value="">-- Select Customer --</option>
                                    <%
                                        try (Connection con = DBConnection.getConnection();
                                                Statement st = con.createStatement();
                                                ResultSet rs = st.executeQuery("SELECT DISTINCT customer_name FROM bills")) {

                                            while (rs.next()) {
                                    %>
                                    <option value="<%= rs.getString(1)%>">
                                        <%= rs.getString(1)%>
                                    </option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>

                            <!-- Outstanding -->
                            <div class="mb-3">
                                <label class="form-label">Total Outstanding</label>
                                <input type="text" id="outstanding"
                                       class="form-control"
                                       readonly>
                            </div>

                            <!-- Return Type -->
                            <div class="mb-3">
                                <label class="form-label">Return Type</label>
                                <select name="return_type" class="form-select" required>
                                    <option value="Product">Product</option>
                                </select>
                            </div>

                            <!-- Return Amount -->
                            <div class="mb-3">
                                <label class="form-label">Return Amount</label>
                                <input type="number" step="0.01"
                                       name="return_amount"
                                       class="form-control"
                                       required>
                            </div>

                            <div class="d-grid">
                                <button type="submit" class="btn btn-danger">
                                    Update Return
                                </button>
                            </div>

                        </form>

                    </div>
                </div>

            </div>
        </div>


        <script>
            function fetchOutstanding() {
                let customer = document.getElementById("customerName").value;

                fetch("GetOutstanding.jsp?customer=" + encodeURIComponent(customer))
                        .then(res => res.json())
                        .then(data => {
                            document.getElementById("outstanding").value = data.balance;
                        });
            }
        </script>

    </body>
</html>
