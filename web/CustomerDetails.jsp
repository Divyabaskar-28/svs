<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="DBConnection.DBConnection" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Customer Details - SVS Sweets</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

        <style>
            body {
                background-color: #fff8f0;
                font-family: 'Segoe UI', sans-serif;
            }
            .container {
                margin-top: 50px;
            }
            h2 {
                color: #d60000;
                text-align: center;
                margin-bottom: 30px;
            }
            thead {
                background-color: #d60000;
                color: white;
            }
            .btn-edit {
                background-color: #DC143C;
                color: white;
                padding: 5px 10px;
                border: none;
                border-radius: 4px;
            }
            .btn-edit:hover {
                background-color: #b01030;
            }
        </style>
    </head>
    <body>

        <%@ include file="AdminHeader.jsp" %>

        <div class="container-fluid px-3">
            <div class="mb-3" style="margin-left:1246px;margin-top:20px;">
                <a href="AdminDashboard.jsp" class="btn btn-danger">
                    <i class="bi bi-arrow-left"></i> Back 
                </a>
            </div>

            <h2>Customer Details</h2>

            <!-- 🔍 Real-Time Search Box -->
            <div class="mb-4">
                <input type="text" id="searchBox" class="form-control" placeholder="Search...">
            </div>

            <table class="table table-bordered table-hover table-striped" id="customerTable">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Organisation</th>
                        <th>Place</th>
                        <th>District</th>
                        <th>State</th>
                        <th>Pincode</th>
                        <th>Mobile</th>
                        <th>Alt Mobile</th>
                        <th>GST Number</th>
                        <th>Distance (km)</th>
                        <th>Email</th>
                        <th>Created By</th>
                        <th>Created At</th>
                        <th>Edit</th>
                    </tr>
                </thead>
                <tbody>
                <tbody>
                    <%    boolean hasResults = false;

                        try (
                                Connection conn = DBConnection.getConnection();
                                PreparedStatement stmt
                                = conn.prepareStatement("SELECT * FROM customers ORDER BY created_at DESC");
                                ResultSet rs = stmt.executeQuery();) {

                            while (rs.next()) {
                                hasResults = true;
                    %>
                    <tr>
                        <td><%= rs.getString("name")%></td>
                        <td><%= rs.getString("organisation")%></td>
                        <td><%= rs.getString("place")%></td>
                        <td><%= rs.getString("district")%></td>
                        <td><%= rs.getString("state")%></td>
                        <td><%= rs.getString("pincode")%></td>
                        <td><%= rs.getString("mobile")%></td>
                        <td><%= rs.getString("alt_mobile")%></td>
                        <td><%= rs.getString("gst_number")%></td>
                        <td><%= rs.getFloat("distance")%></td>
                        <td><%= rs.getString("email")%></td>
                        <td><%= rs.getString("created_by")%></td>
                        <td>
                            <%= new java.text.SimpleDateFormat("dd-MM-yyyy")
                .format(rs.getTimestamp("created_at"))%>
                        </td>
                        <td>
                            <form method="get" action="EditCustomer.jsp">
                                <input type="hidden" name="id" value="<%= rs.getInt("id")%>">
                                <button type="submit" class="btn-edit">Edit</button>
                            </form>
                        </td>
                    </tr>
                    <%
                        }

                        if (!hasResults) {
                    %>
                    <tr>
                        <td colspan="14" class="text-center text-danger">
                            No customers found.
                        </td>
                    </tr>
                    <%
                        }

                    } catch (Exception e) {
                    %>
                    <tr>
                        <td colspan="14" class="text-danger text-center">
                            Error: <%= e.getMessage()%>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>

            </table>
        </div>

        <script>
            function filterTable() {
                const input = document.getElementById("searchBox").value.toLowerCase();
                const rows = document.querySelectorAll("#customerTable tbody tr");

                rows.forEach(row => {
                    const name = row.cells[0].textContent.toLowerCase();
                    const organisation = row.cells[1].textContent.toLowerCase();
                    const place = row.cells[2].textContent.toLowerCase();
                    const district = row.cells[3].textContent.toLowerCase();
                    const state = row.cells[4].textContent.toLowerCase();
                    const mobile = row.cells[6].textContent.toLowerCase();
                    const email = row.cells[10].textContent.toLowerCase();
                    const createdBy = row.cells[11].textContent.toLowerCase();

                    // Show the row if any column matches the search term
                    if (
                            name.includes(input) ||
                            organisation.includes(input) ||
                            place.includes(input) ||
                            district.includes(input) ||
                            state.includes(input) ||
                            mobile.includes(input) ||
                            email.includes(input) ||
                            createdBy.includes(input)
                            ) {
                        row.style.display = "";
                    } else {
                        row.style.display = "none";
                    }
                });
            }

            document.getElementById("searchBox").addEventListener("keyup", filterTable);
        </script>


    </body>
</html>
