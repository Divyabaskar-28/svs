
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AddCustomerServlet")
public class AddCustomerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/svs";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String createdBy = (session != null) ? (String) session.getAttribute("admin_username") : null;

        if (createdBy == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String name = request.getParameter("name").trim();
        String organisation = request.getParameter("organisation").trim();
        String place = request.getParameter("place").trim();
        String district = request.getParameter("district").trim();
        String state = request.getParameter("state").trim();
        String pincode = request.getParameter("pincode").trim();
        String mobile = request.getParameter("mobile").trim();
        String alt_mobile = request.getParameter("alt_mobile").trim();
        String gst_number = request.getParameter("gst").trim();
        String distanceStr = request.getParameter("distance").trim();
        String email = request.getParameter("email").trim();

        float distance = 0;
        try {
            distance = Float.parseFloat(distanceStr);
        } catch (NumberFormatException e) {
            distance = 0;
        }

        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement insertStmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);

            // Check if customer name already exists
            String checkSql = "SELECT id FROM customers WHERE name = ?";
            checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, name);
            rs = checkStmt.executeQuery();

            if (rs.next()) {
                // Customer with same name exists
                response.sendRedirect("AddCustomer.jsp?error=exists");
                return;
            }

            // Proceed to insert
            String insertSql = "INSERT INTO customers (name, organisation, place, district, state, pincode, mobile, alt_mobile, gst_number, distance, email, created_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setString(1, name);
            insertStmt.setString(2, organisation);
            insertStmt.setString(3, place);
            insertStmt.setString(4, district);
            insertStmt.setString(5, state);
            insertStmt.setString(6, pincode);
            insertStmt.setString(7, mobile);
            insertStmt.setString(8, alt_mobile);
            insertStmt.setString(9, gst_number);
            insertStmt.setFloat(10, distance);
            insertStmt.setString(11, email);
            insertStmt.setString(12, createdBy);

            int rows = insertStmt.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("AdminDashboard.jsp");
            } else {
                response.sendRedirect("AddCustomer.jsp?error=insert_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AddCustomer.jsp?error=insert_failed");
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
            }
            try {
                if (checkStmt != null) {
                    checkStmt.close();
                }
            } catch (Exception e) {
            }
            try {
                if (insertStmt != null) {
                    insertStmt.close();
                }
            } catch (Exception e) {
            }
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
            }
        }
    }
}
