<%@ page import="java.sql.*, org.json.simple.JSONObject, DBConnection.DBConnection" %>
<%@ page contentType="application/json;charset=UTF-8" %>

<%
String customerName = request.getParameter("customer");
JSONObject json = new JSONObject();
double balance = 0.0;

if (customerName != null && !customerName.trim().isEmpty()) {

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(
            "SELECT total_amount, paid_amount, return_amount " +
            "FROM bills " +
            "WHERE customer_name = ? " +
            "ORDER BY created_at DESC " +
            "LIMIT 1"
         )) {

        ps.setString(1, customerName);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            double totalAmount  = rs.getDouble("total_amount");
            double paidAmount   = rs.getDouble("paid_amount");
            double returnAmount = rs.getDouble("return_amount");

            // 🔥 YOUR CONDITION
            if (paidAmount == 0.0 && returnAmount == 0.0) {
                balance = totalAmount;
            } else {
                balance = totalAmount - paidAmount - returnAmount;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
}

json.put("balance", balance);
out.print(json.toJSONString());
%>
