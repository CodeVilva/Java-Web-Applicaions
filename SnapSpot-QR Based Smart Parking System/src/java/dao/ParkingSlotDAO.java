package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.ParkingSlot;
import util.DBConnection;

public class ParkingSlotDAO {

    /**
     * Returns all available slots for a vehicle type.
     * (Later we'll also filter by date & time.)
     */
    public List<ParkingSlot> getAvailableSlots(String vehicleType)
            throws SQLException {

        List<ParkingSlot> slots = new ArrayList<>();

        String sql =
                "SELECT * FROM parking_slots "
              + "WHERE vehicle_type=? "
              + "AND status='AVAILABLE' "
              + "ORDER BY slot_code";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, vehicleType);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

    ParkingSlot slot = new ParkingSlot();

    slot.setSlotId(rs.getInt("slot_id"));
    slot.setFloorId(rs.getInt("floor_id"));
    slot.setSlotCode(rs.getString("slot_code"));
    slot.setVehicleType(rs.getString("vehicle_type"));
    slot.setStatus(rs.getString("status"));

    slots.add(slot);

}

        }

        return slots;

    }

    /**
     * Get slot by ID
     */
    public ParkingSlot getSlotById(int slotId)
            throws SQLException {

        ParkingSlot slot = null;

        String sql =
                "SELECT * FROM parking_slots WHERE slot_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, slotId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                slot = new ParkingSlot();

slot.setSlotId(rs.getInt("slot_id"));
slot.setFloorId(rs.getInt("floor_id"));
slot.setSlotCode(rs.getString("slot_code"));
slot.setVehicleType(rs.getString("vehicle_type"));
slot.setStatus(rs.getString("status"));
            }

        }

        return slot;

    }

    /**
     * Update slot status
     */
    public boolean updateSlotStatus(int slotId,
                                    String status)
            throws SQLException {

        String sql =
                "UPDATE parking_slots "
              + "SET status=? "
              + "WHERE slot_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, slotId);

            return ps.executeUpdate() > 0;

        }

    }

    /**
     * Get all parking slots
     */
   public List<ParkingSlot> getAllAvailableSlots()
        throws SQLException {

    List<ParkingSlot> slots = new ArrayList<>();

    String sql =
    "SELECT * FROM parking_slots "
  + "WHERE status='AVAILABLE' "
  + "ORDER BY slot_code";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {

    ParkingSlot slot = new ParkingSlot();

    slot.setSlotId(rs.getInt("slot_id"));
    slot.setFloorId(rs.getInt("floor_id"));
    slot.setSlotCode(rs.getString("slot_code"));
    slot.setVehicleType(rs.getString("vehicle_type"));
    slot.setStatus(rs.getString("status"));

    slots.add(slot);

}

    }

    return slots;

}

    /**
     * Get slots by floor
     */
    public List<ParkingSlot> getSlotsByFloor(String floorId)
            throws SQLException {

        List<ParkingSlot> slots = new ArrayList<>();

        String sql =
                "SELECT * FROM parking_slots "
              + "WHERE floor_id=? "
              + "ORDER BY slot_code";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, floorId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

    ParkingSlot slot = new ParkingSlot();

    slot.setSlotId(rs.getInt("slot_id"));
    slot.setFloorId(rs.getInt("floor_id"));
    slot.setSlotCode(rs.getString("slot_code"));
    slot.setVehicleType(rs.getString("vehicle_type"));
    slot.setStatus(rs.getString("status"));

    slots.add(slot);

}

        }

        return slots;

    }
    public List<ParkingSlot> getAvailableSlotsByArea(int areaId)
        throws SQLException {

    List<ParkingSlot> slotList = new ArrayList<>();

    String sql =
            "SELECT ps.* " +
            "FROM parking_slots ps " +
            "INNER JOIN parking_floors pf " +
            "ON ps.floor_id = pf.floor_id " +
            "WHERE pf.area_id=? " +
            "AND ps.status='AVAILABLE' " +
            "ORDER BY ps.slot_code";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, areaId);

        try (ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                ParkingSlot slot = new ParkingSlot();

                slot.setSlotId(rs.getInt("slot_id"));
                slot.setFloorId(rs.getInt("floor_id"));
                slot.setSlotCode(rs.getString("slot_code"));
                slot.setVehicleType(rs.getString("vehicle_type"));
                slot.setStatus(rs.getString("status"));

                slotList.add(slot);

            }

        }

    }

    return slotList;
}
}