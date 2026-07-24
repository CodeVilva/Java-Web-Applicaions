package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.ParkingRate;
import util.DBConnection;

public class ParkingRateDAO {

    public List<ParkingRate> getAllRates() throws SQLException {

        List<ParkingRate> rateList = new ArrayList<>();

        String sql = "SELECT * FROM parking_rates ORDER BY vehicle_type";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                ParkingRate rate = new ParkingRate();

                rate.setRateId(rs.getInt("rate_id"));
                rate.setVehicleType(rs.getString("vehicle_type"));
                rate.setHourlyRate(rs.getDouble("hourly_rate"));
                rate.setCreatedAt(rs.getTimestamp("created_at"));

                rateList.add(rate);

            }

        }

        return rateList;

    }

    public ParkingRate getRateByVehicleType(String vehicleType)
            throws SQLException {

        ParkingRate rate = null;

        String sql =
                "SELECT * FROM parking_rates WHERE vehicle_type=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, vehicleType);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                rate = new ParkingRate();

                rate.setRateId(rs.getInt("rate_id"));
                rate.setVehicleType(rs.getString("vehicle_type"));
                rate.setHourlyRate(rs.getDouble("hourly_rate"));
                rate.setCreatedAt(rs.getTimestamp("created_at"));

            }

        }

        return rate;

    }

    public boolean updateRate(ParkingRate rate)
            throws SQLException {

        String sql =
                "UPDATE parking_rates "
              + "SET hourly_rate=? "
              + "WHERE vehicle_type=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDouble(1, rate.getHourlyRate());
            ps.setString(2, rate.getVehicleType());

            return ps.executeUpdate() > 0;

        }

    }
public List<ParkingRate> getParkingRates() throws SQLException {

    List<ParkingRate> list =
            new ArrayList<>();

    String sql =
            "SELECT * FROM parking_rates ";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {

            ParkingRate rate =
                    new ParkingRate();

            rate.setRateId(
                    rs.getInt("rate_id"));

            rate.setVehicleType(
                    rs.getString("vehicle_type"));

            rate.setHourlyRate(
                    rs.getDouble("hourly_rate"));

            list.add(rate);

        }

    }

    return list;

}
}