import DBConnection.DBConnection;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.text.SimpleDateFormat;

@WebServlet("/PaymentHistoryPDFServlet")
public class PaymentHistoryPDFServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int paymentId = Integer.parseInt(request.getParameter("payment_id"));

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "SELECT * FROM payment_history WHERE payment_id=?"
            );
            ps.setInt(1, paymentId);
            rs = ps.executeQuery();

            if (!rs.next()) {
                response.getWriter().println("Payment not found");
                return;
            }

            // 📄 PDF response
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition",
                    "attachment; filename=Payment_" + paymentId + ".pdf");

            Document document = new Document(PageSize.A4);
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16);
            Font headFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11);
            Font bodyFont = FontFactory.getFont(FontFactory.HELVETICA, 11);

            // 🧾 Title
            Paragraph title = new Paragraph("Payment Receipt", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);

            // 📋 Table
            PdfPTable table = new PdfPTable(2);
            table.setWidthPercentage(100);
            table.setSpacingBefore(10);
            table.setWidths(new int[]{3, 5});

            SimpleDateFormat sdf =
                new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

            addRow(table, "Customer Name", rs.getString("customer_name"), headFont, bodyFont);
            addRow(table, "Invoice No", rs.getString("invoice_no"), headFont, bodyFont);
            addRow(table, "Paid Amount", "₹ " + rs.getDouble("paid_amount"), headFont, bodyFont);
            addRow(table, "Return Amount", "₹ " + rs.getDouble("return_amount"), headFont, bodyFont);
            addRow(table, "Balance Amount", "₹ " + rs.getDouble("balance_after"), headFont, bodyFont);
            addRow(table, "Payment Mode", rs.getString("payment_mode"), headFont, bodyFont);
            addRow(table, "Paid By", rs.getString("paid_by"), headFont, bodyFont);
            addRow(table, "Payment Time",
                    sdf.format(rs.getTimestamp("payment_time")),
                    headFont, bodyFont);

            document.add(table);

            document.add(new Paragraph("\n\nThank you for your payment!",
                    FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 10)));

            document.close();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs!=null) rs.close(); } catch(Exception e){}
            try { if(ps!=null) ps.close(); } catch(Exception e){}
            try { if(con!=null) con.close(); } catch(Exception e){}
        }
    }

    // 🔹 helper method
    private void addRow(PdfPTable table,
                        String label,
                        String value,
                        Font head,
                        Font body) {

        PdfPCell c1 = new PdfPCell(new Phrase(label, head));
        c1.setPadding(6);
        table.addCell(c1);

        PdfPCell c2 = new PdfPCell(new Phrase(value, body));
        c2.setPadding(6);
        table.addCell(c2);
    }
}
