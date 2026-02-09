<%@ page import="java.sql.*" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="DBConnection.DBConnection" %>
<%@ page contentType="application/json;charset=UTF-8" %>

<%
    String customer = request.getParameter("customer");
    JSONObject json = new JSONObject();

    double totalOutstanding = 0.0;

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(
              "SELECT total_amount FROM bills " +
             "WHERE customer_name=? " +
             "ORDER BY created_at DESC LIMIT 1"
         )) {

        ps.setString(1, customer);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                totalOutstanding = rs.getDouble(1);
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
        json.put("error", e.getMessage());
    }

    json.put("balance", String.format("%.2f", totalOutstanding));
    out.print(json.toJSONString());
%>
