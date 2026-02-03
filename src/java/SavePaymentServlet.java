package DBConnection;

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

        // Get session and paid_by from session
        HttpSession session = request.getSession(false);
        String paidBy = (session != null && session.getAttribute("admin_username") != null)
                ? (String) session.getAttribute("admin_username")
                : "Unknown";

        String customerName = request.getParameter("customer_name");
        double paidAmount = Double.parseDouble(request.getParameter("paid_amount"));
        double returnAmount = Double.parseDouble(request.getParameter("return_amount"));
        double balance = Double.parseDouble(request.getParameter("balance"));
        String paymentMode = request.getParameter("payment_mode");
        String returnTime = request.getParameter("return_time"); // may be null

        Connection con = null;
        PreparedStatement ps = null;

        try {
            // ✅ Dynamic DB connection (local MySQL or Render PostgreSQL)
            con = DBConnection.getConnection();

            // ============================
            // Update the latest row for this customer
            // ============================
            String sql = "UPDATE bills SET "
                    + "paid_amount = ?, return_amount = ?, balance = ?, "
                    + "payment_mode = ?, payment_time = CURRENT_TIMESTAMP, "
                    + "return_time = ?, paid_by = ? "
                    + "WHERE id = (SELECT id FROM bills WHERE customer_name = ? "
                    + "ORDER BY created_at DESC LIMIT 1)";

            ps = con.prepareStatement(sql);
            ps.setDouble(1, paidAmount);
            ps.setDouble(2, returnAmount);
            ps.setDouble(3, balance);
            ps.setString(4, paymentMode);
            ps.setString(5, (returnTime != null && !returnTime.isEmpty()) ? returnTime : null);
            ps.setString(6, paidBy);
            ps.setString(7, customerName);

            int rows = ps.executeUpdate();

            response.setContentType("text/html");
            PrintWriter out = response.getWriter();

            if (rows > 0) {
                // ✅ Success alert + redirect
                out.println("<script type='text/javascript'>");
                out.println("alert('Payment submitted successfully!');");
                out.println("window.location.href = 'GenerateBill.jsp';"); // redirect
                out.println("</script>");
            } else {
                out.println("<script type='text/javascript'>");
                out.println("alert('Payment record not found!');");
                out.println("window.location.href = 'Payment.jsp';"); 
                out.println("</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<script type='text/javascript'>");
            out.println("alert('Exception occurred!');");
            out.println("window.location.href = 'Payment.jsp';"); 
            out.println("</script>");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) { }
            try { if (con != null) con.close(); } catch (Exception e) { }
        }
    }
}
