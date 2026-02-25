package com.svs;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import org.json.JSONArray;
import org.json.JSONObject;
import DBConnection.DBConnection;

public class SalesChartServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        String filter = request.getParameter("filter"); // week | month | year

        JSONArray labels = new JSONArray();
        JSONArray billArr = new JSONArray();
        JSONArray paymentArr = new JSONArray();
        JSONArray returnArr = new JSONArray();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            String query = "";

            if ("week".equals(filter)) {
                query =
                  "SELECT TO_CHAR(created_at, 'DD Mon') AS label, " +
                  "COALESCE(SUM(total_amount),0) AS bill, " +
                  "0 AS payment, " +
                  "0 AS ret " +
                  "FROM bills " +
                  "WHERE created_at >= CURRENT_DATE - INTERVAL '6 days' " +
                  "GROUP BY label ORDER BY MIN(created_at)";

            } else if ("month".equals(filter)) {
                query =
                  "SELECT 'Week ' || EXTRACT(WEEK FROM created_at) AS label, " +
                  "COALESCE(SUM(total_amount),0) AS bill, " +
                  "0 AS payment, " +
                  "0 AS ret " +
                  "FROM bills " +
                  "WHERE DATE_TRUNC('month', created_at) = DATE_TRUNC('month', CURRENT_DATE) " +
                  "GROUP BY label ORDER BY label";

            } else { // year
                query =
                  "SELECT TO_CHAR(created_at, 'Mon') AS label, " +
                  "COALESCE(SUM(total_amount),0) AS bill, " +
                  "0 AS payment, " +
                  "0 AS ret " +
                  "FROM bills " +
                  "WHERE DATE_TRUNC('year', created_at) = DATE_TRUNC('year', CURRENT_DATE) " +
                  "GROUP BY label ORDER BY MIN(created_at)";
            }

            ps = con.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                labels.put(rs.getString("label"));
                billArr.put(rs.getDouble("bill"));
                paymentArr.put(0);  // future ready
                returnArr.put(0);
            }

            JSONObject json = new JSONObject();
            json.put("labels", labels);
            json.put("bill", billArr);
            json.put("payment", paymentArr);
            json.put("return", returnArr);

            out.print(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}