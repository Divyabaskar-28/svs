<%@ page import="java.sql.*, org.json.simple.JSONObject, DBConnection.DBConnection" %>
<%@ page contentType="application/json;charset=UTF-8" %>

<%
String customerName = request.getParameter("customer");
JSONObject json = new JSONObject();
double balance = 0;

if (customerName != null && !customerName.trim().isEmpty()) {

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(
            "SELECT CASE " +
            "WHEN paid_amount > 0 OR return_amount > 0 " +
            "THEN balance " +
            "ELSE total_amount " +
            "END AS due " +
            "FROM bills " +
            "WHERE customer_name=? " +
            "ORDER BY created_at DESC LIMIT 1"
         )) {

        ps.setString(1, customerName);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            balance = rs.getDouble("due");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
}

json.put("balance", balance);
out.print(json.toJSONString());
%>
