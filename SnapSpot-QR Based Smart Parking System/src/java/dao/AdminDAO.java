package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.Admin;
import util.DBConnection;

public class AdminDAO {

    public Admin login(String email)
            throws SQLException {

        Admin admin = null;

        String sql =
                "SELECT * FROM admins "
              + "WHERE email=? "
              + "AND status='ACTIVE'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                admin = new Admin();

                admin.setAdminId(
                        rs.getInt("admin_id"));

                admin.setFullName(
                        rs.getString("full_name"));

                admin.setEmail(
                        rs.getString("email"));

                admin.setPasswordHash(
                        rs.getString("password_hash"));

                admin.setStatus(
                        rs.getString("status"));

                admin.setCreatedAt(
                        rs.getTimestamp("created_at"));

                admin.setUpdatedAt(
                        rs.getTimestamp("updated_at"));

            }

        }

        return admin;

    }

}