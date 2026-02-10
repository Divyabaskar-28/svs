
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

        Connection con = null;
        PreparedStatement psLatest = null;
        PreparedStatement psInsert = null;
        PreparedStatement psUpdate = null;
        ResultSet rsLatest = null;

        try {
            HttpSession session = request.getSession();
            String paidBy = "Unknown";
            if (session.getAttribute("admin_username") != null) {
                paidBy = session.getAttribute("admin_username").toString();
            }

            String customerName = request.getParameter("customer_name");
            double paidAmount = Double.parseDouble(request.getParameter("paid_amount"));
            double returnAmount = Double.parseDouble(request.getParameter("return_amount"));
            String paymentMode = request.getParameter("payment_mode");

            con = DBConnection.getConnection();

            // 🔹 1️⃣ Get latest bill for this customer
            String latestSql
                    = "SELECT invoice_no, total_amount FROM bills "
                    + "WHERE customer_name=? ORDER BY created_at DESC LIMIT 1";

            psLatest = con.prepareStatement(latestSql);
            psLatest.setString(1, customerName);
            rsLatest = psLatest.executeQuery();

            if (!rsLatest.next()) {
                response.sendRedirect("Payment.jsp?status=notfound");
                return;
            }

            String invoiceNo = rsLatest.getString("invoice_no");
            double totalAmount = rsLatest.getDouble("total_amount");

            double newBalance;

            if (paidAmount == 0.0 && returnAmount == 0.0) {
                newBalance = totalAmount;
            } else {
                newBalance = totalAmount - paidAmount - returnAmount;
            }

// negative allowed 👍
// negative allowed 👍
// ❌ Negative allowed – DO NOT clamp
            // 🔹 3️⃣ Insert into payment_history
            String insertSql = "INSERT INTO payment_history "
                    + "(invoice_no, customer_name, paid_amount, return_amount, balance_after, "
                    + "payment_mode, paid_by, payment_time) "
                    + "VALUES (?,?,?,?,?,?,?,CURRENT_TIMESTAMP)";
            psInsert = con.prepareStatement(insertSql);
            psInsert.setString(1, invoiceNo);
            psInsert.setString(2, customerName);
            psInsert.setDouble(3, paidAmount);
            psInsert.setDouble(4, returnAmount);
            psInsert.setDouble(5, newBalance);
            psInsert.setString(6, paymentMode);
            psInsert.setString(7, paidBy);
            psInsert.executeUpdate();

            // 🔹 4️⃣ Update latest bill balance
            String updateSql = "UPDATE bills SET balance=?, paid_amount=?, return_amount=?, "
                    + "payment_mode=?, paid_by=?, payment_time=CURRENT_TIMESTAMP "
                    + "WHERE invoice_no=?";
            psUpdate = con.prepareStatement(updateSql);
            psUpdate.setDouble(1, newBalance);
            psUpdate.setDouble(2, paidAmount);
            psUpdate.setDouble(3, returnAmount);
            psUpdate.setString(4, paymentMode);
            psUpdate.setString(5, paidBy);
            psUpdate.setString(6, invoiceNo);
            psUpdate.executeUpdate();

            response.sendRedirect("Payment.jsp?status=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Payment.jsp?status=error");
        } finally {
            try {
                if (rsLatest != null) {
                    rsLatest.close();
                }
            } catch (Exception e) {
            }
            try {
                if (psLatest != null) {
                    psLatest.close();
                }
            } catch (Exception e) {
            }
            try {
                if (psInsert != null) {
                    psInsert.close();
                }
            } catch (Exception e) {
            }
            try {
                if (psUpdate != null) {
                    psUpdate.close();
                }
            } catch (Exception e) {
            }
            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception e) {
            }
        }
    }
}
