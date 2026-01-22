package DBConnection;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    private static final boolean USE_ONLINE_DB = true;

    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");

        String url;
        String username;
        String password;

        if (USE_ONLINE_DB) {
            url = "jdbc:mysql://sql12.freesqldatabase.com:3306/sql12814967?useSSL=false&allowPublicKeyRetrieval=true";
            username = "sql12814967";
            password = "HMF8FUaECZ";
        } else {
            url = "jdbc:mysql://localhost:3306/svs";
            username = "root";
            password = "";
        }

        return DriverManager.getConnection(url, username, password);
    }
}
