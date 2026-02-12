
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import DBConnection.DBConnection;

@WebServlet("/PaymentGraphServlet")
public class PaymentGraphServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        String from = request.getParameter("from");
        String to = request.getParameter("to");

        // 🔥 If no filter selected → default today
        if (from == null || from.isEmpty() || to == null || to.isEmpty()) {
            LocalDate today = LocalDate.now();
            from = today.toString();
            to = today.toString();
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        StringBuilder labels = new StringBuilder("[");
        StringBuilder amounts = new StringBuilder("[");

        try {
            con = DBConnection.getConnection();

            String sql =
                "SELECT DATE(payment_time) as pdate, " +
                "COALESCE(SUM(paid_amount),0) as total " +
                "FROM payment_history " +
                "WHERE DATE(payment_time) BETWEEN ? AND ? " +
                "GROUP BY DATE(payment_time) ORDER BY pdate";

            ps = con.prepareStatement(sql);
            ps.setString(1, from);
            ps.setString(2, to);

            rs = ps.executeQuery();

            while (rs.next()) {
                labels.append("'").append(rs.getString("pdate")).append("',");
                amounts.append(rs.getDouble("total")).append(",");
            }

            if (labels.length() > 1)
                labels.setLength(labels.length() - 1);
            if (amounts.length() > 1)
                amounts.setLength(amounts.length() - 1);

            labels.append("]");
            amounts.append("]");

            out.print("{\"labels\":" + labels + ",\"amounts\":" + amounts + "}");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
