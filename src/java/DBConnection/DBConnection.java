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

            url = "jdbc:postgresql://db.zoaafspbjvqzbxovoyrd.supabase.co:5432/postgres?sslmode=require";
            username = "postgres";
            password = "kfQKrgLTL7SjEcST";

        } else {
            Class.forName("com.mysql.cj.jdbc.Driver");

            url = "jdbc:mysql://localhost:3306/svs";
            username = "root";
            password = "";
        }

        return DriverManager.getConnection(url, username, password);
    }
}