package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import model.Payment;
import util.DBConnection;

public class PaymentDAO {

    public boolean createPayment(Payment payment)
            throws SQLException {

        String sql =
                "INSERT INTO payments("
              + "booking_id,"
              + "transaction_id,"
              + "payment_method,"
              + "gateway,"
              + "payment_status,"
              + "amount,"
              + "paid_at)"
              + " VALUES(?,?,?,?,?,?,NOW())";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, payment.getBookingId());
            ps.setString(2, payment.getTransactionId());
            ps.setString(3, payment.getPaymentMethod());
            ps.setString(4, payment.getGateway());
            ps.setString(5, payment.getPaymentStatus());
            ps.setDouble(6, payment.getAmount());

            return ps.executeUpdate() > 0;

        }

    }

}