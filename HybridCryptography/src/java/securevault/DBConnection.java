package securevault;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
        "jdbc:mysql://localhost:3309/securevault?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root";      // 🔹 change as needed
    private static final String PASSWORD = "root";  // 🔹 change as needed

    private static Connection con = null;

    /** Get or open a reusable database connection */
    public static synchronized Connection getConnection() {
        try {
            if (con == null || con.isClosed()) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(URL, USER, PASSWORD);
                System.out.println("✅ Database connected successfully.");
            }
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL Driver not found: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("❌ SQL Connection error: " + e.getMessage());
        }
        return con;
    }

    /** Close connection safely */
    public static synchronized void closeConnection() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
                System.out.println("🔒 Connection closed.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /** Deregister MySQL driver & stop cleanup thread — called from contextDestroyed() */
    public static void closeDriver() {
        try {
            // Deregister driver
            java.sql.Driver driver = DriverManager.getDriver(URL);
            if (driver != null) {
                DriverManager.deregisterDriver(driver);
                System.out.println("✅ MySQL JDBC driver deregistered.");
            }

            // Stop MySQL background thread (Connector/J 8.x)
            try {
                com.mysql.cj.jdbc.AbandonedConnectionCleanupThread.checkedShutdown();
                System.out.println("🧹 AbandonedConnectionCleanupThread stopped.");
            } catch (Exception ex) {
                System.err.println("⚠️ Error stopping cleanup thread: " + ex.getMessage());
            }

        } catch (SQLException e) {
            System.err.println("⚠️ Error deregistering driver: " + e.getMessage());
        }
    }
}
