package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.ParkingArea;
import util.DBConnection;

public class ParkingAreaDAO {

    public List<ParkingArea> getAllActiveAreas() throws SQLException {

        List<ParkingArea> areaList = new ArrayList<>();

        String sql =
                "SELECT * FROM parking_areas "
              + "WHERE status='ACTIVE' "
              + "ORDER BY area_name";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                ParkingArea area = new ParkingArea();

                area.setAreaId(rs.getInt("area_id"));
                area.setAreaName(rs.getString("area_name"));
                area.setStatus(rs.getString("status"));

                areaList.add(area);

            }

        }

        return areaList;

    }
    
    public ParkingArea getAreaBySlotId(int slotId)
        throws SQLException {

    ParkingArea area = null;

    String sql =
            "SELECT pa.* " +
            "FROM parking_areas pa " +
            "INNER JOIN parking_floors pf " +
            "ON pa.area_id = pf.area_id " +
            "INNER JOIN parking_slots ps " +
            "ON pf.floor_id = ps.floor_id " +
            "WHERE ps.slot_id = ?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, slotId);

        try (ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                area = new ParkingArea();

                area.setAreaId(rs.getInt("area_id"));
                area.setAreaName(rs.getString("area_name"));
                area.setStatus(rs.getString("status"));

            }

        }

    }

    return area;

}
public List<ParkingArea> getAllParkingAreas() {

    List<ParkingArea> parkingAreaList = new ArrayList<>();

    String sql = "SELECT * FROM parking_areas ORDER BY area_id ASC";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {

            ParkingArea area = new ParkingArea();

            area.setAreaId(rs.getInt("area_id"));
            area.setAreaName(rs.getString("area_name"));
            area.setStatus(rs.getString("status"));

            parkingAreaList.add(area);
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return parkingAreaList;
}
}