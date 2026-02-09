import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import DBConnection.DBConnection;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uname = request.getParameter("username");
        String pass = request.getParameter("password");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT username, role FROM admin_login WHERE username=? AND password=?"
             )) {

            ps.setString(1, uname);
            ps.setString(2, pass);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    // ✅ Login success
                    HttpSession session = request.getSession(true);

                    session.setAttribute("admin_username", rs.getString("username"));
                    session.setAttribute("role", rs.getString("role")); // 🔥 IMPORTANT

                    response.sendRedirect("AdminDashboard.jsp");
                } else {
                    response.setContentType("text/html");
                    response.getWriter().println(
                        "<script>alert('Invalid Username or Password!'); location='Login.jsp';</script>"
                    );
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
