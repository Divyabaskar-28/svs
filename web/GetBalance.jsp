<%@ page import="java.sql.*, org.json.simple.JSONObject, DBConnection.DBConnection" %>
<%@ page contentType="application/json;charset=UTF-8" %>

<%
String customerName = request.getParameter("customer");
JSONObject json = new JSONObject();

if (customerName != null && !customerName.trim().isEmpty()) {

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // ✅ Dynamic DB connection (local MySQL or Render PostgreSQL)
        con = DBConnection.getConnection();

        // PostgreSQL & MySQL compatible query
        String sql = "SELECT balance FROM bills WHERE customer_name = ? ORDER BY created_at DESC LIMIT 1";
        ps = con.prepareStatement(sql);
        ps.setString(1, customerName);

        rs = ps.executeQuery();

        if (rs.next()) {
            json.put("balance", rs.getDouble("balance"));
        } else {
            json.put("balance", 0);
        }

    } catch (Exception e) {
        e.printStackTrace();
        json.put("error", e.getMessage());
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }

} else {
    json.put("balance", 0);
}

out.print(json.toJSONString());
%>
