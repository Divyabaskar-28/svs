
import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/svs";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uname = request.getParameter("username");
        String pass = request.getParameter("password");

        try {
            Class.forName("com.mysql.jdbc.Driver"); // Or com.mysql.cj.jdbc.Driver if using newer MySQL
            Connection con = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);

            PreparedStatement ps = con.prepareStatement("SELECT * FROM admin_login WHERE username=? AND password=?");
            ps.setString(1, uname);
            ps.setString(2, pass);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                // Success: store session
                HttpSession session = request.getSession();
                session.setAttribute("admin_username", rs.getString("username")); // Session from DB value

                response.sendRedirect("AdminDashboard.jsp"); // Redirect after login
            } else {
                response.setContentType("text/html");
                response.getWriter().println("<script>alert('Invalid Username or Password!'); location='Login.jsp';</script>");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
