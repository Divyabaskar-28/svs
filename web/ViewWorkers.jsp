<%@ page import="java.sql.*" %>
<%@ page import="DBConnection.DBConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    HttpSession session1 = request.getSession(false);
    if (session1 == null || session1.getAttribute("role") == null ||
        !"Admin".equalsIgnoreCase(session1.getAttribute("role").toString())) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>View Workers - SVS Sweets</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body{
            background:#f3f3f3;
            font-family:'Segoe UI', sans-serif;
        }

        .container-box{
            margin-left:360px;
            margin-top:40px;
            max-width:900px;
            background:#fff;
            padding:30px;
            border-radius:18px;
            border:2px solid #c40000;
            box-shadow:0 10px 25px rgba(196,0,0,0.15);
        }

        h3{
            text-align:center;
            color:#c40000;
            font-weight:700;
            margin-bottom:25px;
        }

        table th{
            background:#c40000;
            color:#fff;
            text-align:center;
        }

        table td{
            text-align:center;
            vertical-align:middle;
        }

        .badge-worker{
            background:#6c757d;
        }
    </style>
</head>

<body>

<jsp:include page="ADashboard.jsp" />

<div class="container-box">
    <h3>Workers List</h3>

    <table class="table table-bordered table-striped text-center align-middle">
        <thead class="table-danger">
            <tr>
                <th>#</th>
                <th>Username</th>
                <th>Password</th>
                <th>Role</th>
                
            </tr>
        </thead>
        <tbody>

        <%
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                     "SELECT username, password, role FROM admin_login WHERE role = 'Worker'"
                 );
                 ResultSet rs = ps.executeQuery()) {

                int count = 1;
                while (rs.next()) {
        %>
            <tr>
                <td><%= count++ %></td>
                <td><%= rs.getString("username") %></td>
                <td><%= rs.getString("password") %></td>
                <td>
                    <span class="badge badge-worker">
                        <%= rs.getString("role") %>
                    </span>
                </td>
            </tr>
        <%
                }
            } catch (Exception e) {
        %>
            <tr>
                <td colspan="3" class="text-danger text-center">
                    Error: <%= e.getMessage() %>
                </td>
            </tr>
        <%
            }
        %>

        </tbody>
    </table>
</div>

</body>
</html>
