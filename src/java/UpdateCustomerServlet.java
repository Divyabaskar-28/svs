
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UpdateCustomerServlet")
public class UpdateCustomerServlet extends HttpServlet {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/svs";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String organisation = request.getParameter("organisation");
        String place = request.getParameter("place");
        String district = request.getParameter("district");
        String state = request.getParameter("state");
        String pincode = request.getParameter("pincode");
        String mobile = request.getParameter("mobile");
        String altMobile = request.getParameter("alt_mobile");
        String gstNumber = request.getParameter("gst_number");
        String distanceStr = request.getParameter("distance");
        String email = request.getParameter("email");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            float distance = distanceStr != null && !distanceStr.isEmpty() ? Float.parseFloat(distanceStr) : 0;

            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);

            String sql = "UPDATE customers SET name=?, organisation=?, place=?, district=?, state=?, pincode=?, mobile=?, alt_mobile=?, gst_number=?, distance=?, email=? WHERE id=?";
            ps = con.prepareStatement(sql);

            ps.setString(1, name);
            ps.setString(2, organisation);
            ps.setString(3, place);
            ps.setString(4, district);
            ps.setString(5, state);
            ps.setString(6, pincode);
            ps.setString(7, mobile);
            ps.setString(8, altMobile);
            ps.setString(9, gstNumber);
            ps.setFloat(10, distance);
            ps.setString(11, email);
            ps.setInt(12, id);

            int updated = ps.executeUpdate();

            if (updated > 0) {
                response.sendRedirect("CustomerDetails.jsp"); // <-- change to your page
            } else {
                response.getWriter().println("Failed to update customer.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
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
