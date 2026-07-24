package dao;

import constant.AppConstants;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.User;
import util.DBConnection;

/**
 * ============================================================
 * UserDAO
 * ============================================================
 * Handles all database operations related to the users table.
 * ============================================================
 */
public class UserDAO {

    /**
     * Register New User
     */
    public boolean registerUser(User user) throws SQLException {

        String sql = "INSERT INTO users "
                + "(full_name, email, mobile, password_hash, status) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getMobile());
            ps.setString(4, user.getPasswordHash());
            ps.setString(5, AppConstants.STATUS_ACTIVE);

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Check whether email already exists.
     */
    public boolean emailExists(String email) throws SQLException {

        String sql = "SELECT user_id FROM users WHERE email=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            return rs.next();
        }
    }

    /**
     * Check whether mobile already exists.
     */
    public boolean mobileExists(String mobile) throws SQLException {

        String sql = "SELECT user_id FROM users WHERE mobile=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, mobile);

            ResultSet rs = ps.executeQuery();

            return rs.next();
        }
    }

    /**
     * Find user by email.
     */
    public User getUserByEmail(String email) throws SQLException {

        String sql = "SELECT * FROM users WHERE email=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                User user = new User();

                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setMobile(rs.getString("mobile"));
                user.setPasswordHash(rs.getString("password_hash"));
                user.setStatus(rs.getString("status"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setUpdatedAt(rs.getTimestamp("updated_at"));

                return user;
            }

        }

        return null;
    }

}