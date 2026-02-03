
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import DBConnection.DBConnection;   // ✅ Import common DB connection

@WebServlet("/AddCustomerServlet")
public class AddCustomerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

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
        String altMobile = request.getParameter("alt_mobile").trim();
        String gstNumber = request.getParameter("gst").trim();
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
            // ✅ Dynamic DB connection
            conn = DBConnection.getConnection();

            // 🔍 Check if customer already exists
            String checkSql = "SELECT id FROM customers WHERE name = ?";
            checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, name);
            rs = checkStmt.executeQuery();

            if (rs.next()) {
                response.sendRedirect("AddCustomer.jsp?error=exists");
                return;
            }

            // ➕ Insert customer
            String insertSql
                    = "INSERT INTO customers "
                    + "(name, organisation, place, district, state, pincode, mobile, alt_mobile, gst_number, distance, email, created_by) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setString(1, name);
            insertStmt.setString(2, organisation);
            insertStmt.setString(3, place);
            insertStmt.setString(4, district);
            insertStmt.setString(5, state);
            insertStmt.setString(6, pincode);
            insertStmt.setString(7, mobile);
            insertStmt.setString(8, altMobile);
            insertStmt.setString(9, gstNumber);
            insertStmt.setFloat(10, distance);
            insertStmt.setString(11, email);
            insertStmt.setString(12, createdBy);

            int rows = insertStmt.executeUpdate();

            if (rows > 0) {

                response.setContentType("text/html");
                java.io.PrintWriter out = response.getWriter();

                out.println("<script type='text/javascript'>");
                out.println("alert('Customer added successfully!');");
                out.println("window.location='AdminDashboard.jsp';");
                out.println("</script>");

            } else {
                response.sendRedirect("AddCustomer.jsp?error=insert_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AddCustomer.jsp?error=exception");
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
