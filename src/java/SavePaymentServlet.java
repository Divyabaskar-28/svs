
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import DBConnection.DBConnection;   // ✅ import DBConnection

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
            // ✅ Dynamic DB connection
            con = DBConnection.getConnection();

            String sql = "UPDATE bills SET paid_amount = ?, return_amount = ?, balance = ?, "
                    + "payment_mode = ?, payment_time = CURRENT_TIMESTAMP(), "
                    + "return_time = ?, paid_by = ? "
                    + "WHERE customer_name = ? "
                    + "ORDER BY created_at DESC LIMIT 1";

            ps = con.prepareStatement(sql);
            ps.setDouble(1, paidAmount);
            ps.setDouble(2, returnAmount);
            ps.setDouble(3, balance);
            ps.setString(4, paymentMode);
            ps.setString(5, (returnTime != null && !returnTime.isEmpty()) ? returnTime : null);
            ps.setString(6, paidBy);
            ps.setString(7, customerName);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("AdminDashboard.jsp?success=true");
            } else {
                response.sendRedirect("Payment.jsp?error=not_found");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Payment.jsp?error=exception");
        } finally {
            try {
                if (ps != null) {
                    ps.close();
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
