
import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import DBConnection.DBConnection;   // ✅ import DBConnection

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uname = request.getParameter("username");
        String pass = request.getParameter("password");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // ✅ Dynamic DB connection
            con = DBConnection.getConnection();

            ps = con.prepareStatement(
                    "SELECT * FROM admin_login WHERE username=? AND password=?"
            );
            ps.setString(1, uname);
            ps.setString(2, pass);

            rs = ps.executeQuery();

            if (rs.next()) {
                // ✅ Login success → create session
                HttpSession session = request.getSession();
                session.setAttribute("admin_username", rs.getString("username"));

                response.sendRedirect("AdminDashboard.jsp");
            } else {
                response.setContentType("text/html");
                response.getWriter().println(
                        "<script>alert('Invalid Username or Password!'); location='Login.jsp';</script>"
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
            }
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
