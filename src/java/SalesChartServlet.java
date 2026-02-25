import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.YearMonth;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import DBConnection.DBConnection;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/SalesChartServlet")
public class SalesChartServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        JSONArray labels = new JSONArray();
        JSONArray billData = new JSONArray();
        JSONArray paymentData = new JSONArray();
        JSONArray returnData = new JSONArray();

        String filter = request.getParameter("filter");
        if (filter == null) filter = "week";   // ✅ default current week

        String yearParam = request.getParameter("year");
        String monthParam = request.getParameter("month");

        LocalDate today = LocalDate.now();
        int year = (yearParam != null) ? Integer.parseInt(yearParam) : today.getYear();
        int month = (monthParam != null) ? Integer.parseInt(monthParam) : today.getMonthValue();

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = null;
            String query = "";

            // =========================================================
            // ✅ 1️⃣ WEEK FILTER (Default → Current Week days wise)
            // =========================================================
            if ("week".equals(filter)) {

                LocalDate startOfWeek = today.minusDays(today.getDayOfWeek().getValue() - 1);

                query = "SELECT DATE(created_at) as day, " +
                        "COALESCE(SUM(total_amount),0) as bill, " +
                        "COALESCE(SUM(paid_amount),0) as payment, " +
                        "COALESCE(SUM(return_amount),0) as return_amt " +
                        "FROM bills " +
                        "WHERE created_at >= ? AND created_at < ? " +
                        "GROUP BY DATE(created_at) " +
                        "ORDER BY DATE(created_at)";

                ps = con.prepareStatement(query);
                ps.setDate(1, java.sql.Date.valueOf(startOfWeek));
                ps.setDate(2, java.sql.Date.valueOf(startOfWeek.plusDays(7)));

                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    labels.put(rs.getString("day"));
                    billData.put(rs.getDouble("bill"));
                    paymentData.put(rs.getDouble("payment"));
                    returnData.put(rs.getDouble("return_amt"));
                }
                rs.close();
            }

            // =========================================================
            // ✅ 2️⃣ MONTH FILTER (Week wise inside selected month)
            // =========================================================
            else if ("month".equals(filter)) {

                query = "SELECT EXTRACT(WEEK FROM created_at) as week_no, " +
                        "COALESCE(SUM(total_amount),0) as bill, " +
                        "COALESCE(SUM(paid_amount),0) as payment, " +
                        "COALESCE(SUM(return_amount),0) as return_amt " +
                        "FROM bills " +
                        "WHERE EXTRACT(YEAR FROM created_at)=? " +
                        "AND EXTRACT(MONTH FROM created_at)=? " +
                        "GROUP BY week_no " +
                        "ORDER BY week_no";

                ps = con.prepareStatement(query);
                ps.setInt(1, year);
                ps.setInt(2, month);

                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    labels.put("Week " + rs.getInt("week_no"));
                    billData.put(rs.getDouble("bill"));
                    paymentData.put(rs.getDouble("payment"));
                    returnData.put(rs.getDouble("return_amt"));
                }
                rs.close();
            }

            // =========================================================
            // ✅ 3️⃣ YEAR FILTER (Month wise inside selected year)
            // =========================================================
            else if ("year".equals(filter)) {

                query = "SELECT EXTRACT(MONTH FROM created_at) as month_no, " +
                        "COALESCE(SUM(total_amount),0) as bill, " +
                        "COALESCE(SUM(paid_amount),0) as payment, " +
                        "COALESCE(SUM(return_amount),0) as return_amt " +
                        "FROM bills " +
                        "WHERE EXTRACT(YEAR FROM created_at)=? " +
                        "GROUP BY month_no " +
                        "ORDER BY month_no";

                ps = con.prepareStatement(query);
                ps.setInt(1, year);

                ResultSet rs = ps.executeQuery();

                String[] months = {
                        "", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
                        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
                };

                while (rs.next()) {
                    int m = rs.getInt("month_no");
                    labels.put(months[m]);
                    billData.put(rs.getDouble("bill"));
                    paymentData.put(rs.getDouble("payment"));
                    returnData.put(rs.getDouble("return_amt"));
                }
                rs.close();
            }

            JSONObject json = new JSONObject();
            json.put("labels", labels);
            json.put("bill", billData);
            json.put("payment", paymentData);
            json.put("return", returnData);

            out.print(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            JSONObject error = new JSONObject();
            error.put("error", e.getMessage());
            out.print(error.toString());
        }
    }
}
