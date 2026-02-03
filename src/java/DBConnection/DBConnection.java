package DBConnection;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    // true → use online PostgreSQL (Render)
    // false → use local MySQL
    private static final boolean USE_ONLINE_DB = true;

    public static Connection getConnection() throws Exception {
        String url;
        String username;
        String password;

        if (USE_ONLINE_DB) {
            // ===== Online PostgreSQL (Render) =====
            Class.forName("org.postgresql.Driver");
            
           
            url = "jdbc:postgresql://dpg-d5sqhqnpm1nc73ciort0-a.singapore-postgres.render.com:5432/svsdb?sslmode=require";
            username = "svsdb_user";
            password = "qQJbW7HKaALzEbq56aF55Pd9gIEdQDmG";
        } else {
            // ===== Local MySQL (XAMPP) =====
            Class.forName("com.mysql.jdbc.Driver");
            
            url = "jdbc:mysql://localhost:3306/svs";
            username = "root";
            password = "";
        }

        return DriverManager.getConnection(url, username, password);
    }
}
