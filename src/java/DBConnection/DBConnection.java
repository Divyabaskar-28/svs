package DBConnection;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final boolean USE_ONLINE_DB = true;

    public static Connection getConnection() throws Exception {

        String url;
        String username;
        String password;

        if (USE_ONLINE_DB) {

            Class.forName("org.postgresql.Driver");

            // 🔥 GET VALUES FROM RENDER ENVIRONMENT
            url = System.getenv("DB_URL");
            username = System.getenv("DB_USER");
            password = System.getenv("DB_PASSWORD");

        } else {

            Class.forName("com.mysql.cj.jdbc.Driver");

            url = "jdbc:mysql://localhost:3306/svs";
            username = "root";
            password = "";
        }

        Connection con = DriverManager.getConnection(url, username, password);
        System.out.println("Connected successfully!");
        return con;
    }
}