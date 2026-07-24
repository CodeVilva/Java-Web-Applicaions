package dao;

import model.EntryExitLog;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;

import java.util.ArrayList;
import java.util.List;

public class EntryExitLogDAO {

    /**
     * Create Entry Log
     */
    public boolean createEntryLog(
            EntryExitLog log)
            throws SQLException {
        
        String sql =
            "INSERT INTO entry_exit_logs("
          + "booking_id,"
          + "entry_checker_id,"
          + "entry_time)"
          + " VALUES(?,?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, log.getBookingId());
        ps.setInt(2, log.getCheckerId());   // Java field stays the same
        ps.setTimestamp(3, log.getEntryTime());

            return ps.executeUpdate() > 0;

        }

    }

    /**
     * Get Active Log
     */
    public EntryExitLog getActiveLogByBooking(
            int bookingId)
            throws SQLException {

        EntryExitLog log = null;

        String sql =
                "SELECT * FROM entry_exit_logs "
              + "WHERE booking_id=? "
              + "AND exit_time IS NULL "
              + "ORDER BY log_id DESC "
              + "LIMIT 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bookingId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                log = mapLog(rs);

            }

        }

        return log;

    }

    /**
     * Update Exit Log
     */
    public boolean updateExitLog(
            EntryExitLog log)
            throws SQLException {

        String sql =
            "UPDATE entry_exit_logs "
          + "SET exit_checker_id=?,"
          + "exit_time=?,"
          + "duration_minutes=?,"
          + "extra_charge=? "
          + "WHERE log_id=?";
        
        String sql1 = "UPDATE parking_slots SET status='AVAILABLE'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
                PreparedStatement ps1 = con.prepareStatement(sql1);) {

            ps.setInt(1, log.getCheckerId());
            ps.setTimestamp(2, log.getExitTime());
            ps.setInt(3, log.getDurationMinutes());
            ps.setDouble(4, log.getExtraCharge());
            ps.setInt(5, log.getLogId());
            
            int updated = ps.executeUpdate();

            ps1.executeUpdate();

            return updated > 0;

        }

    }

    /**
     * Calculate Parking Duration
     */
    public int calculateDuration(
            Timestamp entryTime,
            Timestamp exitTime) {

        LocalDateTime entry =
                entryTime.toLocalDateTime();

        LocalDateTime exit =
                exitTime.toLocalDateTime();

        return (int) Duration
                .between(entry, exit)
                .toMinutes();

    }

    /**
     * Calculate Extra Charge
     *
     * First 60 minutes are free after booked
     * duration. Afterwards:
     * ₹20 per extra hour.
     */
    public double calculateExtraCharge(
            int durationMinutes,
            int bookedMinutes) {

        if (durationMinutes <= bookedMinutes) {

            return 0;

        }

        int extraMinutes =
                durationMinutes - bookedMinutes;

        int extraHours =
                (int) Math.ceil(extraMinutes / 60.0);

        return extraHours * 20;

    }

    /**
     * Get Logs By Booking
     */
    public List<EntryExitLog> getLogsByBooking(
            int bookingId)
            throws SQLException {

        List<EntryExitLog> logs =
                new ArrayList<>();

        String sql =
                "SELECT * FROM entry_exit_logs "
              + "WHERE booking_id=? "
              + "ORDER BY log_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bookingId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                logs.add(mapLog(rs));

            }

        }

        return logs;

    }

    /**
     * Get All Logs
     */
    public List<EntryExitLog> getAllLogs()
            throws SQLException {

        List<EntryExitLog> logs =
                new ArrayList<>();

        String sql =
                "SELECT * FROM entry_exit_logs "
              + "ORDER BY log_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                logs.add(mapLog(rs));

            }

        }

        return logs;

    }

    /**
     * Common Mapper
     */
    private EntryExitLog mapLog(
            ResultSet rs)
            throws SQLException {

        EntryExitLog log =
                new EntryExitLog();

        log.setLogId(
                rs.getInt("log_id"));

        log.setBookingId(
                rs.getInt("booking_id"));

        log.setCheckerId(
                rs.getInt("entry_checker_id"));

        log.setEntryTime(
                rs.getTimestamp("entry_time"));

        log.setExitTime(
                rs.getTimestamp("exit_time"));

        log.setDurationMinutes(
                rs.getInt("duration_minutes"));

        log.setExtraCharge(
                rs.getDouble("extra_charge"));

        return log;

    }
public int getTodayEntryCount(int checkerId) throws SQLException {

    String sql = "SELECT COUNT(*) FROM entry_exit_logs " +
                 "WHERE entry_checker_id=? AND DATE(entry_time)=CURDATE()";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, checkerId);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            return rs.getInt(1);
        }
    }

    return 0;
}
public int getTodayExitCount(int checkerId) throws SQLException {

    String sql = "SELECT COUNT(*) FROM entry_exit_logs " +
                 "WHERE exit_checker_id=? AND DATE(exit_time)=CURDATE()";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, checkerId);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            return rs.getInt(1);
        }
    }

    return 0;
}
public int getActiveVehicleCount() throws SQLException {

    String sql = "SELECT COUNT(*) FROM entry_exit_logs " +
                 "WHERE entry_time IS NOT NULL " +
                 "AND exit_time IS NULL";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            return rs.getInt(1);
        }
    }

    return 0;
}
}
