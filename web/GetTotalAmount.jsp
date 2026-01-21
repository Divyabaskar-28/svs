<%@ page import="java.sql.*, org.json.JSONObject" %>
<%@ page contentType="application/json" %>

<%
    String customer = request.getParameter("customer");
    JSONObject json = new JSONObject();

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/svs", "root", "");
        PreparedStatement ps = con.prepareStatement("SELECT SUM(total_amount) AS total FROM bills WHERE customer_name = ?");
        ps.setString(1, customer);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            json.put("total", rs.getDouble("total"));
        } else {
            json.put("total", 0);
        }
        con.close();
    } catch (Exception e) {
        json.put("total", 0);
    }

    out.print(json.toString());
%>
