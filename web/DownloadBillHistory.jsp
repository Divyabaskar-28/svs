<%@ page import="java.sql.*, java.io.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment; filename=BillHistory.xls");

    PrintWriter outExcel = response.getWriter();

    outExcel.println("Invoice No\tCustomer Name\tBilling Date\tDay's Amount\tCreated By\tCreated At");

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/svs", "root", "");
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM bills ORDER BY created_at DESC");

        // Format date only
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");

        while (rs.next()) {
            String invoice = rs.getString("invoice_no");
            String customer = rs.getString("customer_name");
            Date billDate = rs.getDate("bill_date");
            double daysAmount = rs.getDouble("days_amount");
            String createdBy = rs.getString("created_by");
            Timestamp createdAt = rs.getTimestamp("created_at");

            outExcel.println(invoice + "\t" + customer + "\t"
                    + (billDate != null ? dateFormat.format(billDate) : "") + "\t"
                    + daysAmount + "\t"
                    + (createdBy != null ? createdBy : "") + "\t"
                    + (createdAt != null ? dateFormat.format(createdAt) : ""));
        }

        rs.close();
        stmt.close();
        con.close();
    } catch (Exception e) {
        outExcel.println("Error:\t" + e.getMessage());
    }
%>
