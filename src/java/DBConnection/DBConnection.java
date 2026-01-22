package DBConnection;

import java.sql.*;
import java.util.Properties;
import java.io.InputStream;

public class DBConnection {

    // Change this flag to switch between local XAMPP and online DB
    private static final boolean USE_ONLINE_DB = true;

    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");

        String url;
        String username;
        String password;

        if(USE_ONLINE_DB) {
            // Online DB (freesqldatabase.com)
            url = "jdbc:mysql://sql12.freesqldatabase.com:3306/sql12814967";
            username = "sql12814967";
            password = "HMF8FUaECZ";
        } else {
            // Localhost DB (XAMPP)
            url = "jdbc:mysql://localhost:3306/svs";
            username = "root";
            password = "";
        }

        return DriverManager.getConnection(url, username, password);
    }
}
