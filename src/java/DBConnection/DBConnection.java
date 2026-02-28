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
            // PostgreSQL driver
            Class.forName("org.postgresql.Driver");

            // Use your database name here (likely "postgres")
            url = "jdbc:postgresql://db.zoaafspbjvqzbxovoyrd.supabase.co:5432/postgres?sslmode=require";
            username = "postgres";
            password = "kfQKrgLTL7SjEcST";

        } else {
            // Local MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            url = "jdbc:mysql://localhost:3306/svs";
            username = "root";
            password = "";
        }

        Connection con = DriverManager.getConnection(url, username, password);
        System.out.println("Connected successfully to Supabase!");
        return con;
    }

    public static void main(String[] args) {
        try {
            Connection con = getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}