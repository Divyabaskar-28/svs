<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.itextpdf.text.*" %>
<%@ page import="com.itextpdf.text.pdf.*" %>
<%@ page import="DBConnection.DBConnection" %>
<%@ page import="java.text.SimpleDateFormat" %>


<%
    String invoice = request.getParameter("invoice");

    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition",
            "attachment; filename=Invoice_" + invoice + ".pdf");

    Document document = new Document(PageSize.A4);
    PdfWriter.getInstance(document, response.getOutputStream());
    document.open();

    Font titleFont = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD);
    Font headerFont = new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD);
    Font normalFont = new Font(Font.FontFamily.HELVETICA, 10);

    // ? TITLE
    Paragraph title = new Paragraph("SVS Sweets - Invoice", titleFont);
    title.setAlignment(Element.ALIGN_CENTER);
    document.add(title);
    document.add(new Paragraph(" "));

    Connection con = DBConnection.getConnection();

    // ? BILL DETAILS
    PreparedStatement billPs
            = con.prepareStatement("SELECT * FROM bills WHERE invoice_no=?");
    billPs.setString(1, invoice);
    ResultSet billRs = billPs.executeQuery();

    if (billRs.next()) {
        document.add(new Paragraph("Invoice No : " + invoice, normalFont));
        document.add(new Paragraph("Customer   : "
                + billRs.getString("customer_name"), normalFont));
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

        java.sql.Date billDate = billRs.getDate("bill_date");
        String formattedDate = (billDate != null) ? sdf.format(billDate) : "";

        document.add(new Paragraph("Bill Date  : " + formattedDate, normalFont));

        document.add(new Paragraph("Total Amt  :"
                + billRs.getDouble("total_amount"), normalFont));
    }

    document.add(new Paragraph(" "));
    document.add(new Paragraph("Item Details", headerFont));
    document.add(new Paragraph(" "));

    // ? ITEMS TABLE (WITH S.NO)
    PdfPTable table = new PdfPTable(5);   // ? 5 columns
    table.setWidthPercentage(100);
    table.setWidths(new int[]{1, 4, 2, 2, 2});

    table.addCell(new PdfPCell(new Phrase("S.No", headerFont)));
    table.addCell(new PdfPCell(new Phrase("Item", headerFont)));
    table.addCell(new PdfPCell(new Phrase("Qty", headerFont)));
    table.addCell(new PdfPCell(new Phrase("Price", headerFont)));
    table.addCell(new PdfPCell(new Phrase("Amount", headerFont)));

    PreparedStatement itemPs
            = con.prepareStatement(
                    "SELECT * FROM bill_items WHERE invoice_no=?");
    itemPs.setString(1, invoice);
    ResultSet itemRs = itemPs.executeQuery();

    int sno = 1;
    while (itemRs.next()) {
        table.addCell(new Phrase(String.valueOf(sno++), normalFont));
        table.addCell(new Phrase(itemRs.getString("item_name"), normalFont));
        table.addCell(new Phrase(
                String.valueOf(itemRs.getInt("quantity")), normalFont));
        table.addCell(new Phrase(
                "" + itemRs.getDouble("price"), normalFont));
        table.addCell(new Phrase(
                "" + itemRs.getDouble("amount"), normalFont));
    }

    document.add(table);

    document.add(new Paragraph(" "));
//    document.add(new Paragraph("Thank you! Visit Again ?", normalFont));

    document.close();

    billRs.close();
    itemRs.close();
    billPs.close();
    itemPs.close();
    con.close();
%>
