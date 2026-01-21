<%@ page import="java.sql.*, org.json.simple.JSONObject" %>
<%@ page contentType="application/json;charset=UTF-8" %>
<%
    String customerName = request.getParameter("customer");
    JSONObject json = new JSONObject();
    if (customerName != null && !customerName.trim().isEmpty()) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/svs", "root", "");
            PreparedStatement ps = con.prepareStatement(
                "SELECT balance FROM bills WHERE customer_name = ? ORDER BY created_at DESC LIMIT 1"
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
            con.close();
        } catch (Exception e) {
            json.put("error", e.toString());
        }
    } else {
        json.put("balance", 0);
    }
    out.print(json.toJSONString());
%>
