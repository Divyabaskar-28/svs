<%@ page import="java.sql.*" %>
<%@ page import="DBConnection.DBConnection" %>

<%
    int itemId = Integer.parseInt(request.getParameter("id"));
    String name = request.getParameter("name");
    int qty = Integer.parseInt(request.getParameter("qty"));
    double price = Double.parseDouble(request.getParameter("price"));

    double amount = qty * price;

    Connection con = null;
    PreparedStatement ps = null;
    PreparedStatement ps2 = null;
    PreparedStatement ps3 = null;
    ResultSet rs = null;

    try {
        con = DBConnection.getConnection();
        con.setAutoCommit(false); // ? transaction start

        // 1?? Update bill_items
        ps = con.prepareStatement(
                "UPDATE bill_items SET item_name=?, quantity=?, price=?, amount=? WHERE item_id=?"
        );
        ps.setString(1, name);
        ps.setInt(2, qty);
        ps.setDouble(3, price);
        ps.setDouble(4, amount);
        ps.setInt(5, itemId);
        ps.executeUpdate();

        // 2?? Get invoice_no for this item
        ps2 = con.prepareStatement(
                "SELECT invoice_no FROM bill_items WHERE item_id=?"
        );
        ps2.setInt(1, itemId);
        rs = ps2.executeQuery();

        String invoiceNo = null;
        if (rs.next()) {
            invoiceNo = rs.getString("invoice_no");
        }

        // 3?? Recalculate total_amount
        // 3?? Recalculate total_amount AND days_amount
        ps3 = con.prepareStatement(
                "UPDATE bills SET "
                + "total_amount = (SELECT IFNULL(SUM(amount),0) FROM bill_items WHERE invoice_no=?), "
                + "days_amount = (SELECT IFNULL(SUM(amount),0) FROM bill_items WHERE invoice_no=?) "
                + "WHERE invoice_no=?"
        );
        ps3.setString(1, invoiceNo);
        ps3.setString(2, invoiceNo);
        ps3.setString(3, invoiceNo);
        ps3.executeUpdate();

        con.commit(); // ? success

        out.print("success");

    } catch (Exception e) {
        if (con != null) {
            con.rollback();
        }
        out.print("error");
        e.printStackTrace();
    } finally {
        if (rs != null) {
            rs.close();
        }
        if (ps != null) {
            ps.close();
        }
        if (ps2 != null) {
            ps2.close();
        }
        if (ps3 != null) {
            ps3.close();
        }
        if (con != null) {
            con.close();
        }
    }
%>
