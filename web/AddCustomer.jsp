<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<!DOCTYPE html>
<html>
    <head>
        <title>Add Customer - SVS Sweets</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <style>
            body {
                background-color: #fff8f0;
                font-family: 'Segoe UI', sans-serif;
                
            }
            .container {
        max-width: 500px;
        background: white; /* subtle red gradient */
        padding: 40px;
        border-radius: 15px;
        /*box-shadow: 0 8px 20px rgba(220, 20, 60, 0.3);  red tinted shadow */
        border: 2px solid #DC143C; /* crimson border */
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .container:hover {
        transform: translateY(-5px);
        box-shadow: 0 12px 30px rgba(220, 20, 60, 0.5);
    }
    h2 {
        color: #DC143C;
        font-weight: 700;
        text-shadow: 1px 1px 2px #ffccd5;
    }
/*    input.form-control {
        border: 1px solid #DC143C;
        transition: 0.3s;
    }
    input.form-control:focus {
        border-color: #FF1493;  deeper pink/red on focus 
        box-shadow: 0 0 8px rgba(255, 20, 147, 0.3);
        outline: none;
    }
    label {
        font-weight: 600;
        color: #B22222;  firebrick labels 
    }*/
    .btn-danger {
        background-color: #DC143C;
        border-color: #B22222;
        transition: 0.3s;
    }
    .btn-danger:hover {
        background-color: #FF1493;
        border-color: #DC143C;
    }
        </style>
    </head>
    <body>
        <%--<%@ include file="AdminHeader.jsp" %>--%>
        <jsp:include page="ADashboard.jsp" />

        <%-- Show alert if customer exists --%>
        <% String error = request.getParameter("error");
            if ("exists".equals(error)) {
        %>
        <script>
            alert("Customer with this name already exists.");
            window.location.href = "AddCustomer.jsp";
        </script>
        <% } else if ("insert_failed".equals(error)) { %>
        <script>
            alert("Failed to insert customer. Please try again.");
        </script>
        <% }%>

<!--         Back Button 
        <div class="text-start ms-4 mt-4">
            <a href="AdminDashboard.jsp" class="btn btn-danger d-inline-flex align-items-center" style="margin-left:1200px;">
                <i class="bi bi-arrow-left me-2"></i> Back 
            </a>
        </div>-->

        <!-- Form -->
        <div class="container" style="margin-left:400px;width:800px;margin-top:50px;padding:50px;">
            <h2 class="text-center mb-4">Add New Customer</h2>
            <form name="customerForm" action="AddCustomerServlet" method="post" onsubmit="return validateForm()">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label>Customer Name</label>
                        <input type="text" name="name" class="form-control">
                    </div>
                    <div class="col-md-6">
                        <label>Organisation Name</label>
                        <input type="text" name="organisation" class="form-control">
                    </div>
                    <div class="col-md-6">
                        <label>Place</label>
                        <input type="text" name="place" class="form-control">
                    </div>
                    <div class="col-md-6">
                        <label>District</label>
                        <input type="text" name="district" class="form-control">
                    </div>
                    <div class="col-md-6">
                        <label>State</label>
                        <input type="text" name="state" class="form-control">
                    </div>
                    <div class="col-md-6">
                        <label>Pincode</label>
                        <input type="text" name="pincode" class="form-control">
                    </div>
                    <div class="col-md-6">
                        <label>Mobile Number</label>
                        <input type="text" name="mobile" class="form-control">
                    </div>
                    <div class="col-md-6">
                        <label>Alternate Mobile Number (optional)</label>
                        <input type="text" name="alt_mobile" class="form-control">
                    </div>
                    <div class="col-md-6">
                        <label>GST Number (optional)</label>
                        <input type="text" name="gst" class="form-control">
                    </div>
                    <div class="col-md-6">
                        <label>Distance (in KM)</label>
                        <input type="text" name="distance" class="form-control">
                    </div>
                    <div class="col-md-12">
                        <label>Email Address</label>
                        <input type="text" name="email" class="form-control">
                    </div>
                </div>
                <div class="text-center mt-4">
                    <button type="submit" class="btn btn-danger">Submit</button>
                    <button type="reset" class="btn btn-danger">Clear</button>
                </div>
            </form>
        </div>

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

                const emailRegex = /^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$/;
                const mobileRegex = /^\\d{10}$/;
                const pincodeRegex = /^\\d{6}$/;

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
                if (pincode.length !== 6) {
                    alert("Pincode must be exactly 6 digits.");
                    form.pincode.focus();
                    return false;
                }
                if (mobile.length !== 10) {
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
                if (email === "") {
                    alert("Please enter a valid email address.");
                    form.email.focus();
                    return false;
                }

                return true;
            }
        </script>
    </body>
</html>
