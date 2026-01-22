<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="DBConnection.DBConnection" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Edit Customer - SVS Sweets</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #fff8f0;
                font-family: 'Segoe UI', sans-serif;
            }
            .container {
                max-width: 700px;
                margin: 50px auto;
                background: #fff;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            h2 {
                text-align: center;
                color: #d60000;
                margin-bottom: 25px;
            }
            label {
                font-weight: bold;
            }
            .btn-save {
                background-color: #DC143C;
                color: white;
                font-weight: bold;
            }
            .btn-save:hover {
                background-color: #b01030;
            }
        </style>

        <!-- ✅ Validation Script -->
        <script>
            function validateForm() {
                const form = document.customerForm;
                const name = form.name.value.trim();
                const organisation = form.organisation.value.trim();
                const place = form.place.value.trim();
                const district = form.district.value.trim();
                const state = form.state.value.trim();
                const pincode = form.pincode.value.trim();
                const mobile = form.mobile.value.trim();
                const alt_mobile = form.alt_mobile.value.trim();
                const distance = form.distance.value.trim();
                const email = form.email.value.trim();

                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                const mobileRegex = /^\d{10}$/;
                const pincodeRegex = /^\d{6}$/;

                if (name === "") {
                    alert("Customer name is required.");
                    form.name.focus();
                    return false;
                }
                if (organisation === "") {
                    alert("Organisation name is required.");
                    form.organisation.focus();
                    return false;
                }
                if (place === "") {
                    alert("Place is required.");
                    form.place.focus();
                    return false;
                }
                if (district === "") {
                    alert("District is required.");
                    form.district.focus();
                    return false;
                }
                if (state === "") {
                    alert("State is required.");
                    form.state.focus();
                    return false;
                }
                if (!pincodeRegex.test(pincode)) {
                    alert("Pincode must be exactly 6 digits.");
                    form.pincode.focus();
                    return false;
                }
                if (!mobileRegex.test(mobile)) {
                    alert("Mobile number must be exactly 10 digits.");
                    form.mobile.focus();
                    return false;
                }
                if (alt_mobile && !mobileRegex.test(alt_mobile)) {
                    alert("Alternate mobile number must be exactly 10 digits.");
                    form.alt_mobile.focus();
                    return false;
                }
                if (distance === "" || isNaN(distance) || Number(distance) < 0) {
                    alert("Please enter a valid distance.");
                    form.distance.focus();
                    return false;
                }
                if (email === "" || !emailRegex.test(email)) {
                    alert("Please enter a valid email address.");
                    form.email.focus();
                    return false;
                }

                return true;
            }
        </script>
    </head>
    <body>

        <%@ include file="AdminHeader.jsp" %>

        <div class="container">
            <h2>Edit Customer</h2>

            <%               int id = Integer.parseInt(request.getParameter("id"));

                try (
                        Connection con = DBConnection.getConnection();
                        PreparedStatement ps = con.prepareStatement(
                                "SELECT * FROM customers WHERE id = ?"
                        )) {
                    ps.setInt(1, id);
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
            %>


            <!-- ✅ Add name="customerForm" for JS validation -->
            <form name="customerForm" action="UpdateCustomerServlet" method="post" onsubmit="return validateForm();">
                <input type="hidden" name="id" value="<%= id%>">

                <div class="mb-3">
                    <label>Name</label>
                    <input type="text" name="name" class="form-control" value="<%= rs.getString("name")%>">
                </div>

                <div class="mb-3">
                    <label>Organisation</label>
                    <input type="text" name="organisation" class="form-control" value="<%= rs.getString("organisation")%>">
                </div>

                <div class="mb-3">
                    <label>Place</label>
                    <input type="text" name="place" class="form-control" value="<%= rs.getString("place")%>">
                </div>

                <div class="mb-3">
                    <label>District</label>
                    <input type="text" name="district" class="form-control" value="<%= rs.getString("district")%>">
                </div>

                <div class="mb-3">
                    <label>State</label>
                    <input type="text" name="state" class="form-control" value="<%= rs.getString("state")%>">
                </div>

                <div class="mb-3">
                    <label>Pincode</label>
                    <input type="text" name="pincode" class="form-control" value="<%= rs.getString("pincode")%>">
                </div>

                <div class="mb-3">
                    <label>Mobile</label>
                    <input type="text" name="mobile" class="form-control" value="<%= rs.getString("mobile")%>">
                </div>

                <div class="mb-3">
                    <label>Alt Mobile</label>
                    <input type="text" name="alt_mobile" class="form-control" value="<%= rs.getString("alt_mobile")%>">
                </div>

                <div class="mb-3">
                    <label>GST Number</label>
                    <input type="text" name="gst_number" class="form-control" value="<%= rs.getString("gst_number")%>">
                </div>

                <div class="mb-3">
                    <label>Distance (km)</label>
                    <input type="text" name="distance" class="form-control" value="<%= rs.getString("distance")%>">
                </div>

                <div class="mb-3">
                    <label>Email</label>
                    <input type="email" name="email" class="form-control" value="<%= rs.getString("email")%>">
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-save">Update Customer</button>
                </div>
            </form>

            <%
                    } else {
                        out.println("<p class='text-danger text-center'>No customer found with ID " + id + "</p>");
                    }
                } catch (Exception e) {
                    out.println("<p class='text-danger'>Error: " + e.getMessage() + "</p>");
                }
            %>


        </div>
    </body>
</html>
