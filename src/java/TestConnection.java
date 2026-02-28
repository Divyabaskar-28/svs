package DBConnection;

import java.sql.Connection;

public class TestConnection {
    public static void main(String[] args) {
        try {
            Connection conn = DBConnection.getConnection(); // Calls your DBConnection class
            if (conn != null) {
                System.out.println("✅ Connection successful!");
                conn.close(); // Close connection after test
            } else {
                System.out.println("❌ Connection failed.");
            }
        } catch (Exception e) {
            e.printStackTrace(); // Prints error if connection fails
        }
    }
}