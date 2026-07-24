package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

import model.TicketChecker;
import util.DBConnection;

public class TicketCheckerDAO {

    public TicketChecker login(String email)
            throws SQLException {

        TicketChecker checker = null;

        String sql =
                "SELECT * FROM ticket_checkers "
              + "WHERE email=? "
              + "AND status='ACTIVE'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                checker = new TicketChecker();

                checker.setCheckerId(
                        rs.getInt("checker_id"));

                checker.setFullName(
                        rs.getString("full_name"));

                checker.setEmail(
                        rs.getString("email"));

                checker.setPasswordHash(
                        rs.getString("password_hash"));

                checker.setStatus(
                        rs.getString("status"));

                checker.setCreatedAt(
                        rs.getTimestamp("created_at"));

                checker.setUpdatedAt(
                        rs.getTimestamp("updated_at"));

            }

        }

        return checker;

    }
public List<TicketChecker> getAllTicketCheckers()
        throws SQLException {

    List<TicketChecker> list = new ArrayList<>();

    String sql =
            "SELECT * FROM ticket_checkers "
          + "ORDER BY checker_id DESC";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {

            TicketChecker checker = new TicketChecker();

            checker.setCheckerId(
                    rs.getInt("checker_id"));

            checker.setFullName(
                    rs.getString("full_name"));

            checker.setEmail(
                    rs.getString("email"));

            checker.setPasswordHash(
                    rs.getString("password_hash"));

            checker.setStatus(
                    rs.getString("status"));

            checker.setCreatedAt(
                    rs.getTimestamp("created_at"));

            checker.setUpdatedAt(
                    rs.getTimestamp("updated_at"));

            list.add(checker);

        }

    }

    return list;

}
public TicketChecker getTicketCheckerById(int checkerId)
        throws SQLException {

    TicketChecker checker = null;

    String sql =
            "SELECT * FROM ticket_checkers "
          + "WHERE checker_id=?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, checkerId);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {

            checker = new TicketChecker();

            checker.setCheckerId(
                    rs.getInt("checker_id"));

            checker.setFullName(
                    rs.getString("full_name"));

            checker.setEmail(
                    rs.getString("email"));

            checker.setPasswordHash(
                    rs.getString("password_hash"));

            checker.setStatus(
                    rs.getString("status"));

            checker.setCreatedAt(
                    rs.getTimestamp("created_at"));

            checker.setUpdatedAt(
                    rs.getTimestamp("updated_at"));

        }

    }

    return checker;

}
public boolean addTicketChecker(
        TicketChecker checker)
        throws SQLException {

    String sql =
            "INSERT INTO ticket_checkers("
          + "full_name,"
          + "email,"
          + "password_hash,"
          + "status)"
          + " VALUES(?,?,?,?)";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1,
                checker.getFullName());

        ps.setString(2,
                checker.getEmail());

        ps.setString(3,
                checker.getPasswordHash());

        ps.setString(4,
                checker.getStatus());

        return ps.executeUpdate() > 0;

    }

}
public boolean updateTicketChecker(
        TicketChecker checker)
        throws SQLException {

    String sql =
            "UPDATE ticket_checkers "
          + "SET full_name=?,"
          + "email=?,"
          + "updated_at=NOW() "
          + "WHERE checker_id=?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1,
                checker.getFullName());

        ps.setString(2,
                checker.getEmail());

        ps.setInt(3,
                checker.getCheckerId());

        return ps.executeUpdate() > 0;

    }

}
public boolean updateStatus(
        int checkerId,
        String status)
        throws SQLException {

    String sql =
            "UPDATE ticket_checkers "
          + "SET status=?,"
          + "updated_at=NOW() "
          + "WHERE checker_id=?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, status);

        ps.setInt(2, checkerId);

        return ps.executeUpdate() > 0;

    }

}
public boolean emailExists(
        String email)
        throws SQLException {

    String sql =
            "SELECT checker_id "
          + "FROM ticket_checkers "
          + "WHERE email=?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, email);

        ResultSet rs = ps.executeQuery();

        return rs.next();

    }

}
}