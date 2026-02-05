<%@ page import="java.sql.*" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="DBConnection.DBConnection" %>
<%@ page contentType="application/json;charset=UTF-8" %>

<%
    String customer = request.getParameter("customer");
    JSONObject json = new JSONObject();

    double previousBalance = 0.0;
    double currentTotal = 0.0;

    try (Connection con = DBConnection.getConnection()) {

        // 1️⃣ Previous unpaid balance
        try (PreparedStatement ps1 = con.prepareStatement(
            "SELECT COALESCE(SUM(balance),0) " +
            "FROM bills WHERE customer_name=? AND balance>0 " +
            "AND invoice_no != (" +
            "SELECT invoice_no FROM bills WHERE customer_name=? " +
            "ORDER BY created_at DESC LIMIT 1)"
        )) {
            ps1.setString(1, customer);
            ps1.setString(2, customer);

            try (ResultSet rs = ps1.executeQuery()) {
                if (rs.next()) {
                    previousBalance = rs.getDouble(1);
                }
            }
        }

        // 2️⃣ Current bill total
        try (PreparedStatement ps2 = con.prepareStatement(
            "SELECT total_amount FROM bills " +
            "WHERE customer_name=? ORDER BY created_at DESC LIMIT 1"
        )) {
            ps2.setString(1, customer);

            try (ResultSet rs = ps2.executeQuery()) {
                if (rs.next()) {
                    currentTotal = rs.getDouble(1);
                }
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
        json.put("error", e.getMessage());
    }

    double totalOutstanding = previousBalance + currentTotal;

    json.put("balance", String.format("%.2f", totalOutstanding));
    out.print(json.toJSONString());
%>
