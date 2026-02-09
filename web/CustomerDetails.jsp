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
            body{
                background:#fff8f0;
                font-family:'Segoe UI',sans-serif;
            }
            h2{
                color:#d60000;
                text-align:center;
                margin-bottom:25px;
            }
            thead{
                background:#d60000;
                color:white;
            }
            .btn-view{
                background:#198754;
                color:white;
                border:none;
                padding:4px 10px;
                border-radius:4px;
            }
            .btn-edit{
                background:#DC143C;
                color:white;
                border:none;
                padding:4px 10px;
                border-radius:4px;
            }
            /* Main content area beside sidebar */
            .main-content{
                /* adjust based on ADashboard sidebar width */
                padding: 20px;

            }

            /* Card style container */
            .card-container{
                width:1025px;
                margin-top:30px;
                margin-left: 300px;
                background: #ffffff;
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 6px 15px rgba(214,0,0,0.15);

            }

        </style>
    </head>

    <body>

        <!-- 🔹 Dashboard Include -->
        <jsp:include page="ADashboard.jsp" />

        <!--<div class="main-content">-->
        <div class="card-container">


            <h2>Customer Details</h2>

            <!-- 🔍 Search -->
            <input type="text" id="searchBox" class="form-control mb-3" placeholder="Search customer...">

            <table class="table table-bordered table-striped text-center align-middle" id="customerTable">
                <thead class="table-danger">
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Organisation</th>
                        <th>Mobile</th>
                        <th>Place</th>
                        <th>Email</th>
                        <th>View</th>
                        <th>Edit</th>
                    </tr>
                </thead>

                <tbody>
                    <%
                        try (
                                Connection con = DBConnection.getConnection();
                                PreparedStatement ps = con.prepareStatement("SELECT * FROM customers ORDER BY created_at DESC");
                                ResultSet rs = ps.executeQuery();) {
                            int count = 1;
                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= count++%></td>
                        <td><%= rs.getString("name")%></td>
                        <td><%= rs.getString("organisation")%></td>
                        <td><%= rs.getString("mobile")%></td>
                        <td><%= rs.getString("place")%></td>
                        <td><%= rs.getString("email")%></td>

                        <!-- VIEW BUTTON -->
                        <td>
                            <button class="btn-view"
                                    data-bs-toggle="modal"
                                    data-bs-target="#viewModal"
                                    data-name="<%=rs.getString("name")%>"
                                    data-org="<%=rs.getString("organisation")%>"
                                    data-place="<%=rs.getString("place")%>"
                                    data-district="<%=rs.getString("district")%>"
                                    data-state="<%=rs.getString("state")%>"
                                    data-pincode="<%=rs.getString("pincode")%>"
                                    data-mobile="<%=rs.getString("mobile")%>"
                                    data-alt="<%=rs.getString("alt_mobile")%>"
                                    data-gst="<%=rs.getString("gst_number")%>"
                                    data-distance="<%=rs.getString("distance")%>"
                                    data-email="<%=rs.getString("email")%>"
                                    data-created="<%=rs.getString("created_by")%>"
                                    data-createdat="<%= rs.getString("created_at")%>">
                                View
                            </button>

                        </td>

                        <!-- EDIT (UNCHANGED) -->
                        <td>
                            <button class="btn-edit"
                                    data-bs-toggle="modal"
                                    data-bs-target="#editModal"
                                    data-id="<%=rs.getInt("id")%>"
                                    data-name="<%=rs.getString("name")%>"
                                    data-org="<%=rs.getString("organisation")%>"
                                    data-place="<%=rs.getString("place")%>"
                                    data-district="<%=rs.getString("district")%>"
                                    data-state="<%=rs.getString("state")%>"
                                    data-pincode="<%=rs.getString("pincode")%>"
                                    data-mobile="<%=rs.getString("mobile")%>"
                                    data-alt="<%=rs.getString("alt_mobile")%>"
                                    data-gst="<%=rs.getString("gst_number")%>"
                                    data-distance="<%=rs.getString("distance")%>"
                                    data-email="<%=rs.getString("email")%>">
                                Edit
                            </button>

                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
        <!--</div>-->


        <!-- 🔴 VIEW MODAL -->
        <div class="modal fade" id="viewModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">

                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title">Customer Full Details</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">
                        <table class="table table-bordered">
                            <tr><th>Name</th><td id="mName"></td></tr>
                            <tr><th>Organisation</th><td id="mOrg"></td></tr>
                            <tr><th>Place</th><td id="mPlace"></td></tr>
                            <tr><th>District</th><td id="mDistrict"></td></tr>
                            <tr><th>State</th><td id="mState"></td></tr>
                            <tr><th>Pincode</th><td id="mPincode"></td></tr>
                            <tr><th>Mobile</th><td id="mMobile"></td></tr>
                            <tr><th>Alt Mobile</th><td id="mAlt"></td></tr>
                            <tr><th>GST</th><td id="mGst"></td></tr>
                            <tr><th>Distance</th><td id="mDistance"></td></tr>
                            <tr><th>Email</th><td id="mEmail"></td></tr>
                            <tr><th>Created By</th><td id="mCreated"></td></tr>
                            <tr><th>Created At</th><td id="mCreatedAt"></td></tr>

                        </table>
                    </div>

                </div>
            </div>
        </div>
        <!-- 🔵 EDIT MODAL -->
        <div class="modal fade" id="editModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">

                    <form action="UpdateCustomerServlet" method="post" onsubmit="return validateForm();">

                        <div class="modal-header bg-danger text-white">
                            <h5 class="modal-title">Edit Customer</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>

                        <div class="modal-body">

                            <input type="hidden" name="id" id="eId">

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label>Name</label>
                                    <input type="text" name="name" id="eName" class="form-control">
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label>Organisation</label>
                                    <input type="text" name="organisation" id="eOrg" class="form-control">
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label>Place</label>
                                    <input type="text" name="place" id="ePlace" class="form-control">
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label>District</label>
                                    <input type="text" name="district" id="eDistrict" class="form-control">
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label>State</label>
                                    <input type="text" name="state" id="eState" class="form-control">
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label>Pincode</label>
                                    <input type="text" name="pincode" id="ePincode" class="form-control">
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label>Mobile</label>
                                    <input type="text" name="mobile" id="eMobile" class="form-control">
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label>Alt Mobile</label>
                                    <input type="text" name="alt_mobile" id="eAlt" class="form-control">
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label>GST</label>
                                    <input type="text" name="gst_number" id="eGst" class="form-control">
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label>Distance</label>
                                    <input type="text" name="distance" id="eDistance" class="form-control">
                                </div>

                                <div class="col-md-12 mb-3">
                                    <label>Email</label>
                                    <input type="email" name="email" id="eEmail" class="form-control">
                                </div>

                            </div>

                        </div>

                        <div class="modal-footer">
                            <button type="submit" class="btn btn-danger">Update Customer</button>
                        </div>

                    </form>

                </div>
            </div>
        </div>


        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                        document.getElementById('viewModal').addEventListener('show.bs.modal', function (event) {
                            const btn = event.relatedTarget;

                            document.getElementById("mName").innerText = btn.dataset.name;
                            document.getElementById("mOrg").innerText = btn.dataset.org;
                            document.getElementById("mPlace").innerText = btn.dataset.place;
                            document.getElementById("mDistrict").innerText = btn.dataset.district;
                            document.getElementById("mState").innerText = btn.dataset.state;
                            document.getElementById("mPincode").innerText = btn.dataset.pincode;
                            document.getElementById("mMobile").innerText = btn.dataset.mobile;
                            document.getElementById("mAlt").innerText = btn.dataset.alt;
                            document.getElementById("mGst").innerText = btn.dataset.gst;
                            document.getElementById("mDistance").innerText = btn.dataset.distance;
                            document.getElementById("mEmail").innerText = btn.dataset.email;
                            document.getElementById("mCreated").innerText = btn.dataset.created;
                            const rawDate = btn.dataset.createdat; // yyyy-mm-dd hh:mm:ss

                            if (rawDate) {
                                const parts = rawDate.split(" ");
                                const datePart = parts[0]; // yyyy-mm-dd
                                const timePart = parts[1]; // hh:mm:ss

                                const dateArr = datePart.split("-");
                                const formattedDate =
                                        dateArr[2] + "-" + dateArr[1] + "-" + dateArr[0] + " " + timePart;

                                document.getElementById("mCreatedAt").innerText = formattedDate;
                            }


                        });

                        document.getElementById("searchBox").addEventListener("keyup", function () {
                            const val = this.value.toLowerCase();
                            document.querySelectorAll("#customerTable tbody tr").forEach(row => {
                                row.style.display = row.innerText.toLowerCase().includes(val) ? "" : "none";
                            });
                        });

                        document.getElementById('editModal').addEventListener('show.bs.modal', function (event) {
                            const btn = event.relatedTarget;

                            document.getElementById("eId").value = btn.dataset.id;
                            document.getElementById("eName").value = btn.dataset.name;
                            document.getElementById("eOrg").value = btn.dataset.org;
                            document.getElementById("ePlace").value = btn.dataset.place;
                            document.getElementById("eDistrict").value = btn.dataset.district;
                            document.getElementById("eState").value = btn.dataset.state;
                            document.getElementById("ePincode").value = btn.dataset.pincode;
                            document.getElementById("eMobile").value = btn.dataset.mobile;
                            document.getElementById("eAlt").value = btn.dataset.alt;
                            document.getElementById("eGst").value = btn.dataset.gst;
                            document.getElementById("eDistance").value = btn.dataset.distance;
                            document.getElementById("eEmail").value = btn.dataset.email;
                        });

        </script>

    </body>
</html>
