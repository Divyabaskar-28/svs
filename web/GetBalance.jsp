<%@ page import="java.sql.*, org.json.simple.JSONObject" %>
<%@ page contentType="application/json;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="DBConnection.DBConnection" %>
<%@ page contentType="application/json;charset=UTF-8" %>

<%
String customerName = request.getParameter("customer");
JSONObject json = new JSONObject();

if (customerName != null && !customerName.trim().isEmpty()) {

    try (Connection con = DBConnection.getConnection()) {

        PreparedStatement ps = con.prepareStatement(
            "SELECT balance FROM bills WHERE customer_name=? ORDER BY created_at DESC LIMIT 1"
        );
        ps.setString(1, customerName);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            json.put("balance", rs.getDouble("balance"));
        } else {
            json.put("balance", 0);
        }

        rs.close();
        ps.close();

    } catch (Exception e) {
        json.put("error", e.getMessage());
    }

} else {
    json.put("balance", 0);
}

out.print(json.toJSONString());
%>
