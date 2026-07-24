package dao;

import model.Booking;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;

import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    /**
     * Create Booking
     */
    public boolean createBooking(Booking booking)
        throws SQLException {

    String sql =
            "INSERT INTO bookings("
            + "user_id,"
            + "vehicle_id,"
            + "slot_id,"
            + "booking_date,"
            + "entry_time,"
            + "exit_time,"
            + "total_amount,"
            + "status,"
            + "payment_status,"
            + "qr_code)"
            + " VALUES(?,?,?,?,?,?,?,?,?,?)";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(
                 sql,
                 PreparedStatement.RETURN_GENERATED_KEYS)) {

        ps.setInt(1, booking.getUserId());
        ps.setInt(2, booking.getVehicleId());
        ps.setInt(3, booking.getSlotId());

        ps.setDate(4, booking.getBookingDate());
        ps.setTime(5, booking.getEntryTime());
        ps.setTime(6, booking.getExitTime());

        ps.setDouble(7, booking.getTotalAmount());

        ps.setString(8, booking.getBookingStatus());
        ps.setString(9, booking.getPaymentStatus());
        ps.setString(10, booking.getQrCode());

        int rows = ps.executeUpdate();

        if (rows > 0) {

            ResultSet rs = ps.getGeneratedKeys();

            if (rs.next()) {

                booking.setBookingId(rs.getInt(1));

            }

            return true;

        }

        return false;

    }

}

    /**
     * Get Active Booking
     */
    public Booking getActiveBooking(int userId)
            throws SQLException {

        Booking booking = null;

        String sql =
                "SELECT b.*,"
                + "v.vehicle_number, "
                + "v.vehicle_type, "
                + "ps.slot_code "
                + "FROM bookings b "
                + "JOIN vehicles v "
                    + "ON b.vehicle_id = v.vehicle_id "
                + "JOIN parking_slots ps "
                    + "ON b.slot_id = ps.slot_id "
                + "WHERE b.user_id=? "
                + "AND b.payment_status='SUCCESS' "
                + "AND b.status IN ('ACTIVE') "
                + "ORDER BY b.booking_id DESC "
                + "LIMIT 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                booking.setVehicleNumber(
                        
                rs.getString("vehicle_number"));

                booking.setVehicleType(
                        rs.getString("vehicle_type"));

                booking.setSlotCode(
                        rs.getString("slot_code"));

            }

        }

        return booking;

    }

    /**
     * Booking History
     */
    public List<Booking> getBookingHistory(int userId)
            throws SQLException {

        List<Booking> bookings =
                new ArrayList<>();

        String sql =
                "SELECT * FROM bookings "
                + "WHERE user_id=? "
                + "ORDER BY booking_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                bookings.add(
                        mapBooking(rs));

            }

        }

        return bookings;

    }

    /**
     * Get Booking By ID
     */
    public Booking getBookingById(int bookingId)
            throws SQLException {

        Booking booking = null;

        String sql =
                "SELECT * FROM bookings "
                + "WHERE booking_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bookingId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                booking = mapBooking(rs);

            }

        }

        return booking;

    }

    /**
     * Cancel Booking
     */
    public boolean cancelBooking(int bookingId)
            throws SQLException {

        String sql =
                "UPDATE bookings "
                + "SET status='CANCELLED' "
                + "WHERE booking_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bookingId);

            return ps.executeUpdate() > 0;

        }

    }

    /**
     * Common Mapper
     */
private Booking mapBooking(ResultSet rs) throws SQLException {

    Booking booking = new Booking();

    booking.setBookingId(rs.getInt("booking_id"));
    booking.setUserId(rs.getInt("user_id"));
    booking.setVehicleId(rs.getInt("vehicle_id"));
    booking.setSlotId(rs.getInt("slot_id"));

//    booking.setUserName(rs.getString("full_name"));
    
    booking.setBookingDate(rs.getDate("booking_date"));
    booking.setEntryTime(rs.getTime("entry_time"));
    booking.setExitTime(rs.getTime("exit_time"));

    booking.setTotalAmount(rs.getDouble("total_amount"));

    booking.setBookingStatus(rs.getString("status"));
    booking.setPaymentStatus(rs.getString("payment_status"));
    booking.setQrCode(rs.getString("qr_code"));

    booking.setCreatedAt(rs.getTimestamp("created_at"));

    booking.setVehicleNumber(rs.getString("vehicle_number"));
    booking.setVehicleType(rs.getString("vehicle_type"));
    booking.setSlotCode(rs.getString("slot_code"));

    return booking;
}
public boolean updatePaymentStatus(int bookingId,
                                   String paymentStatus)
        throws SQLException {

    String sql =
            "UPDATE bookings "
          + "SET payment_status=? "
          + "WHERE booking_id=?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, paymentStatus);
        ps.setInt(2, bookingId);

        return ps.executeUpdate() > 0;

    }

}
public boolean updateBookingStatus(int bookingId,
                                   String status)
        throws SQLException {

    String sql =
            "UPDATE bookings "
          + "SET status=? "
          + "WHERE booking_id=?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, status);
        ps.setInt(2, bookingId);

        return ps.executeUpdate() > 0;

    }

}
public boolean updateQRCode(int bookingId,
                            String qrCode)
        throws SQLException {

    String sql =
            "UPDATE bookings "
          + "SET qr_code=? "
          + "WHERE booking_id=?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, qrCode);
        ps.setInt(2, bookingId);

        return ps.executeUpdate() > 0;

    }

}
public List<Booking> getBookingsByUserId(int userId)
        throws SQLException {

    List<Booking> bookings = new ArrayList<>();

    String sql =
            "SELECT b.*, "
          + "v.vehicle_number, "
          + "v.vehicle_type, "
          + "ps.slot_code "
          + "FROM bookings b "
          + "JOIN vehicles v "
          + "ON b.vehicle_id = v.vehicle_id "
          + "JOIN parking_slots ps "
          + "ON b.slot_id = ps.slot_id "
          + "WHERE b.user_id = ? "
          + "ORDER BY b.booking_date DESC, "
          + "b.booking_id DESC";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, userId);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

            Booking booking = new Booking();

            booking.setBookingId(
                    rs.getInt("booking_id"));

            booking.setUserId(
                    rs.getInt("user_id"));

            booking.setVehicleId(
                    rs.getInt("vehicle_id"));

            booking.setSlotId(
                    rs.getInt("slot_id"));

            booking.setBookingDate(
                    rs.getDate("booking_date"));
            
            booking.setVehicleNumber(
                    rs.getString("vehicle_number"));

            booking.setVehicleType(
                    rs.getString("vehicle_type"));

            booking.setSlotCode(
                    rs.getString("slot_code"));
            
            booking.setEntryTime(
                    rs.getTime("entry_time"));

            booking.setExitTime(
                    rs.getTime("exit_time"));

            booking.setTotalAmount(
                    rs.getDouble("total_amount"));

            booking.setPaymentStatus(
                    rs.getString("payment_status"));

            booking.setBookingStatus(
                    rs.getString("status"));

            booking.setQrCode(
                    rs.getString("qr_code"));

            bookings.add(booking);

        }

    }

    return bookings;

}
public List<Booking> getActiveBookingsByUserId(int userId, int limit)
        throws SQLException {

    List<Booking> bookings = new ArrayList<>();

    String sql =
            "SELECT b.*, "
          + "v.vehicle_number, "
          + "v.vehicle_type, "
          + "ps.slot_code "
          + "FROM bookings b "
          + "JOIN vehicles v "
          + "ON b.vehicle_id = v.vehicle_id "
          + "JOIN parking_slots ps "
          + "ON b.slot_id = ps.slot_id "
          + "WHERE b.user_id = ? "
          + "AND b.status IN ('ACTIVE') "
          + "ORDER BY b.booking_date DESC, "
          + "b.booking_id DESC";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, userId);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

            Booking booking = new Booking();

            booking.setBookingId(
                    rs.getInt("booking_id"));

            booking.setUserId(
                    rs.getInt("user_id"));

            booking.setVehicleId(
                    rs.getInt("vehicle_id"));

            booking.setSlotId(
                    rs.getInt("slot_id"));

            booking.setBookingDate(
                    rs.getDate("booking_date"));
            
            booking.setVehicleNumber(
                    rs.getString("vehicle_number"));

            booking.setVehicleType(
                    rs.getString("vehicle_type"));

            booking.setSlotCode(
                    rs.getString("slot_code"));
            
            booking.setEntryTime(
                    rs.getTime("entry_time"));

            booking.setExitTime(
                    rs.getTime("exit_time"));

            booking.setTotalAmount(
                    rs.getDouble("total_amount"));

            booking.setPaymentStatus(
                    rs.getString("payment_status"));

            booking.setBookingStatus(
                    rs.getString("status"));

            booking.setQrCode(
                    rs.getString("qr_code"));

            bookings.add(booking);

        }

    }

    return bookings;

}
public int getBookingCount(int userId) throws SQLException {

    String sql =
            "SELECT COUNT(*) FROM bookings WHERE user_id=?";

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
public int getQrTicketCount(int userId) throws SQLException {

    String sql =
            "SELECT COUNT(*) FROM bookings "
          + "WHERE user_id=? "
          + "AND qr_code IS NOT NULL";

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
public List<Booking> getAllBookings() throws SQLException {

    List<Booking> bookingList = new ArrayList<>();

    String sql =
        "SELECT b.*, " +
        "v.vehicle_number, " +
        "v.vehicle_type, " +
        "ps.slot_code, " +
        "IFNULL(p.payment_status,'PENDING') AS payment_status " +
        "FROM bookings b " +
        "INNER JOIN vehicles v " +
        "ON b.vehicle_id = v.vehicle_id " +
        "INNER JOIN parking_slots ps " +
        "ON b.slot_id = ps.slot_id " +
        "LEFT JOIN payments p " +
        "ON b.booking_id = p.booking_id " +
        "ORDER BY b.booking_id DESC";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {

            bookingList.add(mapBooking(rs));

        }

    }

    return bookingList;
}
}