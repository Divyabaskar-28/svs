<%@ page import="java.io.*,java.sql.*,java.text.SimpleDateFormat" %>
<%@ page import="com.itextpdf.text.*,com.itextpdf.text.pdf.*" %>
<%@ page import="DBConnection.DBConnection" %>

<%
    String invoice = request.getParameter("invoice");

    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition",
            "attachment; filename=Invoice_" + invoice + ".pdf");

    Document document = new Document(PageSize.A4, 36, 36, 36, 36);
    PdfWriter.getInstance(document, response.getOutputStream());
    document.open();

    /* ================= FONTS ================= */
    Font titleFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD);
    Font boldFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD);
    Font normalFont = new Font(Font.FontFamily.HELVETICA, 10);

    /* ================= LOGO ================= */
    String logoPath = application.getRealPath("/Images/logo.png");
    Image logo = Image.getInstance(logoPath);
    logo.scaleAbsolute(70, 70);
    logo.setAlignment(Image.ALIGN_CENTER);
    document.add(logo);

    /* ================= COMPANY NAME ================= */
    Paragraph head = new Paragraph("COTTAGE INDUSTRY\n", titleFont);
    head.setAlignment(Element.ALIGN_CENTER);
    document.add(head);

    Paragraph addr = new Paragraph(
            "616/1, Vaikunda Samy Nagar, Eachanari\n"
            + "Tamil Nadu 641021\n"
            + "GST: 33AHTPT5363M1ZH | Phone: 9442641997\n\n",
            normalFont);
    addr.setAlignment(Element.ALIGN_CENTER);
    document.add(addr);

    /* ================= BILL INFO ================= */
    Connection con = DBConnection.getConnection();
    PreparedStatement ps = con.prepareStatement(
            "SELECT b.*, c.organisation, c.place, c.state, c.mobile "
            + "FROM bills b "
            + "LEFT JOIN customers c ON b.customer_name = c.name "
            + "WHERE b.invoice_no=?"
    );

    ps.setString(1, invoice);
    ResultSet rs = ps.executeQuery();

    PdfPTable info = new PdfPTable(2);
    info.setWidthPercentage(100);
    info.setWidths(new int[]{60, 40});

    if (rs.next()) {
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");

        String billTo
                = "Bill To:\n"
                + rs.getString("customer_name") + "\n"
                + rs.getString("organisation") + "\n"
                + rs.getString("place") + ", " + rs.getString("state") + "\n"
                + "Mobile: " + rs.getString("mobile");

        info.addCell(cell(billTo, normalFont));

        info.addCell(cell("TAX INVOICE\nInvoice No : " + invoice
                + "\nDate : " + sdf.format(rs.getDate("bill_date")), normalFont));
    }
    document.add(info);
    document.add(new Paragraph(" "));

    /* ================= ITEM TABLE ================= */
    PdfPTable table = new PdfPTable(5);
    table.setWidthPercentage(100);
    table.setWidths(new int[]{1, 4, 2, 2, 2});

    addHeader(table, "S.No");
    addHeader(table, "Particulars");
    addHeader(table, "Qty");
   
    addHeader(table, "Rate");
    addHeader(table, "Amount");

    PreparedStatement ips = con.prepareStatement(
            "SELECT * FROM bill_items WHERE invoice_no=?");
    ips.setString(1, invoice);
    ResultSet irs = ips.executeQuery();

    int i = 1;
    double total = 0;

    while (irs.next()) {
        table.addCell(cell(String.valueOf(i++), normalFont));
        table.addCell(cell(irs.getString("item_name"), normalFont));
        table.addCell(cell(String.valueOf(irs.getInt("quantity")), normalFont));

        table.addCell(cell("" + irs.getDouble("price"), normalFont));
        table.addCell(cell("" + irs.getDouble("amount"), normalFont));
        total += irs.getDouble("amount");
    }
    document.add(table);

    /* ================= TOTAL ================= */
    PdfPTable totalTbl = new PdfPTable(2);
    totalTbl.setWidthPercentage(40);
    totalTbl.setHorizontalAlignment(Element.ALIGN_RIGHT);

    totalTbl.addCell(cell("Total Amount", boldFont));
    totalTbl.addCell(cell("" + total, boldFont));

    document.add(new Paragraph(" "));
    document.add(totalTbl);

    document.add(new Paragraph(
            "\nFor SVS COTTAGE INDUSTRY\n\nAuthorised Signatory",
            normalFont));

    document.close();
    con.close();
%>

<%!
    PdfPCell cell(String text, Font f) {
        PdfPCell c = new PdfPCell(new Phrase(text, f));
        c.setPadding(5);
        return c;
    }

    void addHeader(PdfPTable t, String s) {
        PdfPCell c = new PdfPCell(new Phrase(
                s, new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD)));
        c.setBackgroundColor(BaseColor.LIGHT_GRAY);
        c.setPadding(5);
        t.addCell(c);
    }
%>
