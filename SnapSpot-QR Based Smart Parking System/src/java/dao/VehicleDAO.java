package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ParkingRate;
import model.Vehicle;
import util.DBConnection;

/**
 * ============================================================
 * VehicleDAO
 * ============================================================
 * Handles all database operations related to the vehicles table.
 * ============================================================
 */
public class VehicleDAO {

    /**
     * Add Vehicle
     */
    public boolean addVehicle(Vehicle vehicle) throws SQLException {

        String sql = "INSERT INTO vehicles "
                + "(user_id, vehicle_number, vehicle_type, is_default) "
                + "VALUES (?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, vehicle.getUserId());
            ps.setString(2, vehicle.getVehicleNumber());
            ps.setString(3, vehicle.getVehicleType());
            ps.setBoolean(4, vehicle.isDefaultVehicle());

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Get All Vehicles of a User
     */
    public List<Vehicle> getVehiclesByUserId(int userId) throws SQLException {

        List<Vehicle> vehicles = new ArrayList<>();

        String sql = "SELECT * FROM vehicles WHERE user_id=? ORDER BY vehicle_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Vehicle vehicle = new Vehicle();

                vehicle.setVehicleId(rs.getInt("vehicle_id"));
                vehicle.setUserId(rs.getInt("user_id"));
                vehicle.setVehicleNumber(rs.getString("vehicle_number"));
                vehicle.setVehicleType(rs.getString("vehicle_type"));
                vehicle.setDefaultVehicle(rs.getBoolean("is_default"));
                vehicle.setCreatedAt(rs.getTimestamp("created_at"));

                vehicles.add(vehicle);
            }
        }

        return vehicles;
    }
public Vehicle getVehicleById(int vehicleId) throws SQLException {

    Vehicle vehicle = null;

    String sql = "SELECT * FROM vehicles WHERE vehicle_id=?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, vehicleId);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {

            vehicle = new Vehicle();

            vehicle.setVehicleId(rs.getInt("vehicle_id"));
            vehicle.setUserId(rs.getInt("user_id"));
            vehicle.setVehicleNumber(rs.getString("vehicle_number"));
            vehicle.setVehicleType(rs.getString("vehicle_type"));
            vehicle.setDefaultVehicle(rs.getBoolean("is_default"));
            vehicle.setCreatedAt(rs.getTimestamp("created_at"));

        }

    }

    return vehicle;

}
    /**
     * Get Default Vehicle
     */
    public Vehicle getDefaultVehicle(int userId) throws SQLException {

        String sql = "SELECT * FROM vehicles "
                + "WHERE user_id=? AND is_default=1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Vehicle vehicle = new Vehicle();

                vehicle.setVehicleId(rs.getInt("vehicle_id"));
                vehicle.setUserId(rs.getInt("user_id"));
                vehicle.setVehicleNumber(rs.getString("vehicle_number"));
                vehicle.setVehicleType(rs.getString("vehicle_type"));
                vehicle.setDefaultVehicle(rs.getBoolean("is_default"));
                vehicle.setCreatedAt(rs.getTimestamp("created_at"));

                return vehicle;
            }
        }

        return null;
    }

    /**
     * Update Vehicle
     */
    public boolean updateVehicle(Vehicle vehicle) throws SQLException {

        String sql = "UPDATE vehicles "
                + "SET vehicle_number=?, vehicle_type=?, is_default=? "
                + "WHERE vehicle_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, vehicle.getVehicleNumber());
            ps.setString(2, vehicle.getVehicleType());
            ps.setBoolean(3, vehicle.isDefaultVehicle());
            ps.setInt(4, vehicle.getVehicleId());

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Delete Vehicle
     */
public boolean deleteVehicle(int vehicleId) throws SQLException {

    String deletePayments =
        "DELETE p FROM payments p " +
        "INNER JOIN bookings b ON p.booking_id = b.booking_id " +
        "WHERE b.vehicle_id=?";

    String deleteEntryLogs =
        "DELETE e FROM entry_exit_logs e " +
        "INNER JOIN bookings b ON e.booking_id = b.booking_id " +
        "WHERE b.vehicle_id=?";

    String deleteBookings =
        "DELETE FROM bookings WHERE vehicle_id=?";

    String deleteVehicle =
        "DELETE FROM vehicles WHERE vehicle_id=?";

    Connection con = null;

    try {

        con = DBConnection.getConnection();
        con.setAutoCommit(false);

        try (PreparedStatement ps1 = con.prepareStatement(deletePayments);
             PreparedStatement ps2 = con.prepareStatement(deleteEntryLogs);
             PreparedStatement ps3 = con.prepareStatement(deleteBookings);
             PreparedStatement ps4 = con.prepareStatement(deleteVehicle)) {

            ps1.setInt(1, vehicleId);
            ps1.executeUpdate();

            ps2.setInt(1, vehicleId);
            ps2.executeUpdate();

            ps3.setInt(1, vehicleId);
            ps3.executeUpdate();

            ps4.setInt(1, vehicleId);
            int rows = ps4.executeUpdate();

            con.commit();

            return rows > 0;
        }

    } catch (SQLException e) {

        if (con != null) {
            con.rollback();
        }

        throw e;

    } finally {

        if (con != null) {
            con.setAutoCommit(true);
            con.close();
        }

    }
}
public int getVehicleCount(int userId) throws SQLException {

    String sql =
            "SELECT COUNT(*) FROM vehicles "
          + "WHERE user_id=?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, userId);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {

            return rs.getInt(1);

        }

    }

    return 0;

}

}