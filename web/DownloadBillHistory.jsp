<%@ page import="java.sql.*, java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="DBConnection.DBConnection" %>

<%
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment; filename=BillHistory.xls");

    PrintWriter outExcel = response.getWriter();

    // Excel Header
    outExcel.println("Invoice No\tCustomer Name\tBilling Date\tDay's Amount\tCreated By\tCreated At");

    SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");

    try (
        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(
            "SELECT * FROM bills ORDER BY created_at DESC"
        );
        ResultSet rs = ps.executeQuery();
    ) {

        while (rs.next()) {
            String invoice = rs.getString("invoice_no");
            String customer = rs.getString("customer_name");
            Date billDate = rs.getDate("bill_date");
            double daysAmount = rs.getDouble("days_amount");
            String createdBy = rs.getString("created_by");
            Timestamp createdAt = rs.getTimestamp("created_at");

            outExcel.println(
                invoice + "\t" +
                customer + "\t" +
                (billDate != null ? dateFormat.format(billDate) : "") + "\t" +
                daysAmount + "\t" +
                (createdBy != null ? createdBy : "") + "\t" +
                (createdAt != null ? dateFormat.format(createdAt) : "")
            );
        }

    } catch (Exception e) {
        outExcel.println("Error\t" + e.getMessage());
    }
%>
