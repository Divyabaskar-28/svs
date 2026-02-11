
import DBConnection.DBConnection;
import java.io.PrintWriter;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ReturnUpdateServlet")
public class ReturnUpdateServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try (Connection con = DBConnection.getConnection()) {

            String customerName = request.getParameter("customer_name");
            double returnAmount = Double.parseDouble(request.getParameter("return_amount"));

            // 🔹 Get latest bill
            String selectSql = "SELECT invoice_no, balance, return_amount FROM bills "
                    + "WHERE customer_name=? ORDER BY created_at DESC LIMIT 1";

            PreparedStatement psSelect = con.prepareStatement(selectSql);
            psSelect.setString(1, customerName);
            ResultSet rs = psSelect.executeQuery();

            if (!rs.next()) {
                out.println("<script>alert('Customer not found!');window.location='ReturnUpdate.jsp';</script>");
                return;
            }

            String invoiceNo = rs.getString("invoice_no");
            double previousBalance = rs.getDouble("balance");
            double existingReturn = rs.getDouble("return_amount");

            double newBalance = previousBalance - returnAmount;
            double newReturnTotal = existingReturn + returnAmount;

            // 🔹 Update bills table
            String updateBill = "UPDATE bills SET balance=?, return_amount=?, return_time=CURRENT_TIMESTAMP WHERE invoice_no=?";
            PreparedStatement psUpdate = con.prepareStatement(updateBill);
            psUpdate.setDouble(1, newBalance);
            psUpdate.setDouble(2, newReturnTotal);
            psUpdate.setString(3, invoiceNo);
            psUpdate.executeUpdate();

            // 🔹 Get latest payment_id
            String getPaymentId = "SELECT payment_id FROM payment_history WHERE invoice_no=? ORDER BY payment_id DESC LIMIT 1";
            PreparedStatement psGet = con.prepareStatement(getPaymentId);
            psGet.setString(1, invoiceNo);
            ResultSet rsPay = psGet.executeQuery();

            if (rsPay.next()) {

                int paymentId = rsPay.getInt("payment_id");

                String updateHistory = "UPDATE payment_history SET return_amount=?, balance_after=?, return_time=CURRENT_TIMESTAMP WHERE payment_id=?";
                PreparedStatement psHistory = con.prepareStatement(updateHistory);
                psHistory.setDouble(1, returnAmount);
                psHistory.setDouble(2, newBalance);
                psHistory.setInt(3, paymentId);

                int rows = psHistory.executeUpdate();

                System.out.println("Payment history rows updated: " + rows);
            }

            out.println("<script>");
            out.println("alert('Return updated successfully!');");
            out.println("window.location='ReturnUpdate.jsp';");
            out.println("</script>");

        } catch (Exception e) {
            e.printStackTrace();

            out.println("<script>");
            out.println("alert('Error while updating return!');");
            out.println("window.location='ReturnUpdate.jsp';");
            out.println("</script>");
        }
    }
}
