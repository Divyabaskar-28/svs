package com.svs;

import java.text.SimpleDateFormat;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import org.json.*;
import DBConnection.DBConnection; // <- Use your DBConnection class

public class SaveBillServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_username") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String createdBy = (String) session.getAttribute("admin_username");

        String invoice = request.getParameter("invoice_no");
        String name = request.getParameter("customer_name");
        String rawDate = request.getParameter("bill_date"); // yyyy-MM-dd
        java.sql.Date sqlDate = java.sql.Date.valueOf(rawDate);  // Keep as yyyy-MM-dd

        String daysAmount = request.getParameter("days_amount");
        String balance = request.getParameter("balance");
        String total = request.getParameter("total_amount");

        String itemsJson = request.getParameter("items_json");

        Connection con = null;
        PreparedStatement ps1 = null, ps2 = null;

        try {
            // ✅ Use dynamic DBConnection class
            con = DBConnection.getConnection();

            // Insert into bill_summary
            String insertBillQuery = "INSERT INTO bills (invoice_no, customer_name, bill_date, days_amount, balance, total_amount, created_by, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
            ps1 = con.prepareStatement(insertBillQuery);
            ps1.setString(1, invoice);
            ps1.setString(2, name);
            ps1.setDate(3, sqlDate);
            ps1.setDouble(4, Double.parseDouble(daysAmount));
            ps1.setDouble(5, Double.parseDouble(balance));
            ps1.setDouble(6, Double.parseDouble(total));
            ps1.setString(7, createdBy);
            ps1.executeUpdate();

            // Parse item JSON and insert into bill_items
            JSONArray items = new JSONArray(itemsJson);
            ps2 = con.prepareStatement("INSERT INTO bill_items (invoice_no, item_name, quantity, price, amount) VALUES (?, ?, ?, ?, ?)");
            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                ps2.setString(1, invoice);
                ps2.setString(2, item.getString("item"));
                ps2.setInt(3, item.getInt("qty"));
                ps2.setDouble(4, item.getDouble("amt"));
                ps2.setDouble(5, item.getDouble("amount"));
                ps2.addBatch();
            }
            ps2.executeBatch();

            response.sendRedirect("AdminDashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        } finally {
            try {
                if (ps1 != null) {
                    ps1.close();
                }
            } catch (Exception e) {
            }
            try {
                if (ps2 != null) {
                    ps2.close();
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
