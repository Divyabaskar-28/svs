<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@ page import="DBConnection.DBConnection" %>

<%
    session = request.getSession(false);
    String role = (session != null) ? (String) session.getAttribute("role") : null;

    if (role == null || !role.equalsIgnoreCase("Admin")) {
        response.sendRedirect("Homepage.jsp");
        return;
    }
%>


<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Add Admin</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>
            body{
                background:#f3f3f3;
                font-family:'Segoe UI', sans-serif;
            }
            .card{
                max-width:450px;
                margin:80px auto;
                padding:25px;
                border-radius:15px;
                box-shadow:0 10px 25px rgba(0,0,0,0.15);
            }
            h3{
                color:#c40000;
                font-weight:700;
                text-align:center;
                margin-bottom:25px;
            }
            .btn-danger{
                width:100%;
            }
        </style>
    </head>

    <body>
        <jsp:include page="ADashboard.jsp" />
        <div class="card" style=" border: 2px solid #DC143C; /* crimson border */
             transition: transform 0.3s ease, box-shadow 0.3s ease;margin-left:590px;">
            <h3>Add New Admin</h3>

            <form method="post">
                <div class="mb-3">
                    <label class="form-label">Username</label>
                    <input type="text" name="username" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Role</label>
                    <select name="role" class="form-select" required>
                        <option value="">-- Select Role --</option>
                        <option value="Admin">Admin</option>
                        <option value="Worker">Worker</option>
                    </select>
                </div>

                <button type="submit" name="addAdmin" class="btn btn-danger">
                    Add Admin
                </button>
            </form>

            <%
                if (request.getParameter("addAdmin") != null) {

                    String username = request.getParameter("username");
                    String password = request.getParameter("password");
                    String roleInput = request.getParameter("role");

                    Connection con = null;
                    PreparedStatement ps = null;

                    try {
                        con = DBConnection.getConnection();

                        ps = con.prepareStatement(
                                "INSERT INTO admin_login(username, password, role) VALUES (?, ?, ?)"
                        );
                        ps.setString(1, username);
                        ps.setString(2, password);
                        ps.setString(3, roleInput);

                        int result = ps.executeUpdate();

                        if (result > 0) {
            %>
            <div class="alert alert-success mt-3">
                User added successfully!
            </div>
            <%
                }

            } catch (Exception e) {
            %>
            <div class="alert alert-danger mt-3">
                Error: <%= e.getMessage()%>
            </div>
            <%
                    } finally {
                        if (ps != null) {
                            ps.close();
                        }
                        if (con != null) {
                            con.close();
                        }
                    }
                }
            %>


        </div>

    </body>
</html>
