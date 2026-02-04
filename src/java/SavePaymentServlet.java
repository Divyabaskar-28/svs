
import DBConnection.DBConnection;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import DBConnection.DBConnection;   // ✅ import your DBConnection class

@WebServlet("/SavePaymentServlet")
public class SavePaymentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;
        PreparedStatement psInsert = null;
        PreparedStatement psUpdate = null;
        PreparedStatement psGet = null;
        ResultSet rs = null;

        try {
            HttpSession session = request.getSession(); // 🔥 FIX HERE

            String paidBy = "Unknown";
            if (session.getAttribute("admin_username") != null) {
                paidBy = session.getAttribute("admin_username").toString();
            }

            String customerName = request.getParameter("customer_name");
            double paidAmount = Double.parseDouble(request.getParameter("paid_amount"));
            double returnAmount = Double.parseDouble(request.getParameter("return_amount"));
            String paymentMode = request.getParameter("payment_mode");

            con = DBConnection.getConnection();

            // 🔴 1️⃣ Get latest invoice & current balance
            String getSql
                    = "SELECT invoice_no, balance FROM bills "
                    + "WHERE customer_name=? ORDER BY created_at DESC LIMIT 1";

            psGet = con.prepareStatement(getSql);
            psGet.setString(1, customerName);
            rs = psGet.executeQuery();

            if (!rs.next()) {
                response.sendRedirect("Payment.jsp?status=notfound");
                return;
            }

            String invoiceNo = rs.getString("invoice_no");
            double oldBalance = rs.getDouble("balance");

            // 🔴 2️⃣ Calculate new balance
            double newBalance = oldBalance - paidAmount - returnAmount;

            // 🔴 3️⃣ INSERT payment history (IMPORTANT)
            String insertSql
                    = "INSERT INTO payment_history "
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

            // 🔴 4️⃣ UPDATE bills (ONLY balance)
            String updateSql
                    = "UPDATE bills SET balance=?, payment_time=CURRENT_TIMESTAMP WHERE invoice_no=?";

            psUpdate = con.prepareStatement(updateSql);
            psUpdate.setDouble(1, newBalance);
            psUpdate.setString(2, invoiceNo);
            psUpdate.executeUpdate();

            response.sendRedirect("Payment.jsp?status=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Payment.jsp?status=error");
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
            }
            try {
                if (psGet != null) {
                    psGet.close();
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
