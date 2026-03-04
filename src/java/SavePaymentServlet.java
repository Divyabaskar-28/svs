import DBConnection.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SavePaymentServlet")
public class SavePaymentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String paidBy = "Unknown";
        if (session.getAttribute("admin_username") != null) {
            paidBy = session.getAttribute("admin_username").toString();
        }

        String customerName = request.getParameter("customer_name");
        String paymentMode = request.getParameter("payment_mode");
        double paidAmount = 0.0;

        try {
            paidAmount = Double.parseDouble(request.getParameter("paid_amount"));
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("Payment.jsp?status=error");
            return;
        }

        String latestSql = "SELECT invoice_no, total_amount, paid_amount, balance " +
                           "FROM bills WHERE customer_name=? ORDER BY created_at DESC LIMIT 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement psLatest = con.prepareStatement(latestSql)) {

            psLatest.setString(1, customerName);
            try (ResultSet rsLatest = psLatest.executeQuery()) {

                if (!rsLatest.next()) {
                    response.sendRedirect("Payment.jsp?status=notfound");
                    return;
                }

                String invoiceNo = rsLatest.getString("invoice_no");
                double totalAmount = rsLatest.getDouble("total_amount");

                // Null-safe fetch of balance and paid_amount
                double currentBalance = rsLatest.getDouble("balance");
                if (rsLatest.wasNull()) currentBalance = totalAmount;

                double currentPaid = rsLatest.getDouble("paid_amount");
                if (rsLatest.wasNull()) currentPaid = 0.0;

                // Calculate new balance and cumulative paid
                double newBalance = currentBalance - paidAmount;
                double newPaid = currentPaid + paidAmount;

                // Round to 2 decimals
                newBalance = Math.round(newBalance * 100.0) / 100.0;
                newPaid = Math.round(newPaid * 100.0) / 100.0;

                // Begin transaction
                

                // 1️⃣ Insert into payment_history
                String insertSql = "INSERT INTO payment_history " +
                        "(invoice_no, customer_name, paid_amount, balance_after, payment_mode, paid_by, payment_time) " +
                        "VALUES (?,?,?,?,?,?,CURRENT_TIMESTAMP)";
                try (PreparedStatement psInsert = con.prepareStatement(insertSql)) {
                    psInsert.setString(1, invoiceNo);
                    psInsert.setString(2, customerName);
                    psInsert.setDouble(3, paidAmount);
                    psInsert.setDouble(4, newBalance);
                    psInsert.setString(5, paymentMode);
                    psInsert.setString(6, paidBy);
                    psInsert.executeUpdate();
                }

                // 2️⃣ Update bills table
                String updateSql = "UPDATE bills SET balance=?, paid_amount=?, payment_mode=?, paid_by=?, payment_time=CURRENT_TIMESTAMP " +
                                   "WHERE invoice_no=?";
                try (PreparedStatement psUpdate = con.prepareStatement(updateSql)) {
                    psUpdate.setDouble(1, newBalance);
                    psUpdate.setDouble(2, newPaid);
                    psUpdate.setString(3, paymentMode);
                    psUpdate.setString(4, paidBy);
                    psUpdate.setString(5, invoiceNo);
                    psUpdate.executeUpdate();
                }

                // Commit transaction
                
                response.sendRedirect("Payment.jsp?status=success");

            } catch (SQLException e) {
                
                e.printStackTrace();
                response.sendRedirect("Payment.jsp?status=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Payment.jsp?status=error");
        }
    }
}