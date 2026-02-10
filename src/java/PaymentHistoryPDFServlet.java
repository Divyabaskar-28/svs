
import DBConnection.DBConnection;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.sql.*;
import java.text.SimpleDateFormat;

@WebServlet("/PaymentHistoryPDFServlet")
public class PaymentHistoryPDFServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int paymentId = Integer.parseInt(request.getParameter("payment_id"));

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(
                        "SELECT ph.*, c.organisation, c.place, c.state, c.mobile "
                        + "FROM payment_history ph "
                        + "LEFT JOIN customers c ON ph.customer_name = c.name "
                        + "WHERE ph.payment_id=?"
                )) {

            ps.setInt(1, paymentId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                response.getWriter().println("Payment not found");
                return;
            }

            // ===== PDF RESPONSE =====
            response.setContentType("application/pdf");
            response.setHeader(
                    "Content-Disposition",
                    "attachment; filename=PaymentReceipt_" + paymentId + ".pdf"
            );

            Document document = new Document(PageSize.A4, 36, 36, 36, 36);
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // ===== FONTS =====
            Font titleFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD);
            Font boldFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD);
            Font normalFont = new Font(Font.FontFamily.HELVETICA, 10);

            // ===== LOGO =====
            try {
                String logoPath = getServletContext().getRealPath("/Images/logo.png");
                File f = new File(logoPath);
                if (f.exists()) {
                    Image logo = Image.getInstance(logoPath);
                    logo.scaleAbsolute(70, 70);
                    logo.setAlignment(Image.ALIGN_CENTER);
                    document.add(logo);
                }
            } catch (Exception e) {
                // ignore logo errors
            }

            // ===== COMPANY DETAILS =====
            Paragraph head = new Paragraph("COTTAGE INDUSTRY\n", titleFont);
            head.setAlignment(Element.ALIGN_CENTER);
            document.add(head);

            Paragraph addr = new Paragraph(
                    "616/1, Vaikunda Samy Nagar, Eachanari\n"
                    + "Tamil Nadu 641021\n"
                    + "GST: 33AHTPT5363M1ZH | Phone: 9442641997\n\n",
                    normalFont
            );
            addr.setAlignment(Element.ALIGN_CENTER);
            document.add(addr);

            // ===== CUSTOMER + RECEIPT INFO =====
            PdfPTable info = new PdfPTable(2);
            info.setWidthPercentage(100);
            info.setWidths(new int[]{60, 40});

            SimpleDateFormat sdf
                    = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

            String receivedFrom
                    = "Received From:\n"
                    + rs.getString("customer_name") + "\n"
                    + rs.getString("organisation") + "\n"
                    + rs.getString("place") + ", " + rs.getString("state") + "\n"
                    + "Mobile: " + rs.getString("mobile");

            info.addCell(cell(receivedFrom, normalFont));

            info.addCell(cell(
                    "PAYMENT RECEIPT\n"
                    + "Receipt No : " + paymentId + "\n"
                    + "Invoice No : " + rs.getString("invoice_no") + "\n"
                    + "Date : " + sdf.format(rs.getTimestamp("payment_time")),
                    normalFont
            ));

            document.add(info);
            document.add(new Paragraph(" "));

            PdfPTable pay = new PdfPTable(2);
            pay.setWidthPercentage(100);          // full page width
            pay.setSpacingBefore(10);
            pay.setWidths(new int[]{60, 40});     // label wider than value

            pay.addCell(cell("Paid Amount", boldFont));
            pay.addCell(cell("₹ " + rs.getDouble("paid_amount"), normalFont));

            pay.addCell(cell("Return Amount", boldFont));
            pay.addCell(cell("₹ " + rs.getDouble("return_amount"), normalFont));

            pay.addCell(cell("Balance After", boldFont));
            pay.addCell(cell("₹ " + rs.getDouble("balance_after"), normalFont));

            pay.addCell(cell("Payment Mode", boldFont));
            pay.addCell(cell(rs.getString("payment_mode"), normalFont));

            pay.addCell(cell("Paid By", boldFont));
            pay.addCell(cell(rs.getString("paid_by"), normalFont));

            document.add(pay);

            document.add(new Paragraph(
                    "\n\nFor SVS COTTAGE INDUSTRY\n\nAuthorised Signatory",
                    normalFont
            ));

            document.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===== HELPER CELL =====
    private PdfPCell cell(String text, Font f) {
        PdfPCell c = new PdfPCell(new Phrase(text, f));
        c.setPadding(6);
        return c;
    }
}
