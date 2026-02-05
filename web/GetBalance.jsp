<%@ page import="java.sql.*, org.json.simple.JSONObject, DBConnection.DBConnection" %>
<%@ page contentType="application/json;charset=UTF-8" %>

<%
String customerName = request.getParameter("customer");
JSONObject json = new JSONObject();

double balance = 0;

if (customerName != null && !customerName.trim().isEmpty()) {

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(
            "SELECT total_amount FROM bills WHERE customer_name = ? ORDER BY created_at DESC LIMIT 1"
         )) {

        ps.setString(1, customerName);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                balance = rs.getDouble("total_amount");
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
        json.put("error", e.getMessage());
    }
}

json.put("balance", balance);
out.print(json.toJSONString());
%>
