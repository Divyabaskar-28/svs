<%@ page import="java.sql.*" %>
<%@ page import="DBConnection.DBConnection" %>
<%@ page contentType="application/json;charset=UTF-8" %>

<%
    String customer = request.getParameter("customer");
    double totalDue = 0;

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBConnection.getConnection();

        String sql =
            "SELECT COALESCE(SUM(balance), 0) AS total_due " +
            "FROM bills WHERE customer_name = ?";

        ps = con.prepareStatement(sql);
        ps.setString(1, customer);
        rs = ps.executeQuery();

        if (rs.next()) {
            totalDue = rs.getDouble("total_due");
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }

    // 🔥 JSON output
    out.print("{\"total_due\": " + totalDue + "}");
%>
