package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * ============================================================
 * SNAPSPOT - Database Connection Utility
 * ============================================================
 * 
 * Purpose:
 * - Provides database connections to the application.
 * - Centralizes database configuration.
 * - Prevents duplication of connection code.
 *
 * Author  : SNAPSPOT Team
 * Version : 1.0
 * ============================================================
 */
public final class DBConnection {

    /* ============================================================
     * Database Configuration
     * ============================================================
     */

    private static final String DRIVER =
            "com.mysql.jdbc.Driver";      // MySQL 5.x

    private static final String URL =
            "jdbc:mysql://localhost:3309/snapspot";

    private static final String USERNAME =
            "root";

    private static final String PASSWORD =
            "root";

    /*
     * Private Constructor
     * Prevent object creation.
     */
    private DBConnection() {

    }

    /* ============================================================
     * Get Database Connection
     * ============================================================
     */

    public static Connection getConnection() throws SQLException {

        try {

            Class.forName(DRIVER);

        } catch (ClassNotFoundException ex) {

            throw new SQLException(
                    "Unable to load MySQL JDBC Driver.",
                    ex);

        }

        return DriverManager.getConnection(
                URL,
                USERNAME,
                PASSWORD
        );

    }

    /* ============================================================
     * Close Connection Safely
     * ============================================================
     */

    public static void close(Connection connection) {

        if (connection != null) {

            try {

                connection.close();

            } catch (SQLException ex) {

                ex.printStackTrace();

            }

        }

    }

}