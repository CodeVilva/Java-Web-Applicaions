package service;

import constant.AppConstants;
import dao.BookingDAO;
import dao.ParkingSlotDAO;
import dao.VehicleDAO;
import model.Booking;
import model.ParkingSlot;
import model.Vehicle;

import java.sql.SQLException;
import java.sql.Time;
import java.time.Duration;
import java.time.LocalTime;

public class BookingService {

    private BookingDAO bookingDAO;
    private ParkingSlotDAO parkingSlotDAO;
    private VehicleDAO vehicleDAO;

    public BookingService() {

        bookingDAO = new BookingDAO();
        parkingSlotDAO = new ParkingSlotDAO();
        vehicleDAO = new VehicleDAO();

    }

    public ServiceResult createBooking(Booking booking)
            throws SQLException {

        /*---------------------------------------------------
            Check Active Booking
        ---------------------------------------------------*/
        Booking activeBooking =
                bookingDAO.getActiveBooking(
                        booking.getUserId());

        if (activeBooking != null) {

            return ServiceResult.failure(
                    "You already have an active booking.");

        }

        /*---------------------------------------------------
            Validate Vehicle
        ---------------------------------------------------*/
        Vehicle vehicle =
                vehicleDAO.getVehicleById(
                        booking.getVehicleId());

        if (vehicle == null) {

            return ServiceResult.failure(
                    "Vehicle not found.");

        }

        /*---------------------------------------------------
            Validate Slot
        ---------------------------------------------------*/
        ParkingSlot slot =
                parkingSlotDAO.getSlotById(
                        booking.getSlotId());

        if (slot == null) {

            return ServiceResult.failure(
                    "Parking slot not found.");

        }

        if (!AppConstants.SLOT_AVAILABLE.equalsIgnoreCase(
                slot.getStatus())) {

            return ServiceResult.failure(
                    "Selected parking slot is not available.");

        }

        /*---------------------------------------------------
            Validate Vehicle Type
        ---------------------------------------------------*/
        if (!vehicle.getVehicleType().equalsIgnoreCase(
                slot.getVehicleType())) {

            return ServiceResult.failure(
                    "Selected vehicle is not compatible with the parking slot.");

        }

        /*---------------------------------------------------
            Validate Entry & Exit Time
        ---------------------------------------------------*/
        if (!booking.getExitTime().after(
                booking.getEntryTime())) {

            return ServiceResult.failure(
                    "Exit time must be after entry time.");

        }

        /*---------------------------------------------------
            Calculate Parking Charge
        ---------------------------------------------------*/
        double amount =
                calculateAmount(
                        vehicle.getVehicleType(),
                        booking.getEntryTime(),
                        booking.getExitTime());

        booking.setTotalAmount(amount);

        booking.setBookingStatus(
                AppConstants.BOOKING_PENDING);

        booking.setPaymentStatus(
                AppConstants.PAYMENT_PENDING);

        booking.setQrCode(null);

        /*---------------------------------------------------
            Save Booking
        ---------------------------------------------------*/
        boolean bookingSaved =
                bookingDAO.createBooking(
                        booking);

        if (!bookingSaved) {

            return ServiceResult.failure(
                    "Unable to create booking.");

        }

        /*---------------------------------------------------
            Reserve Parking Slot
        ---------------------------------------------------*/
        boolean slotReserved =
                parkingSlotDAO.updateSlotStatus(
                        booking.getSlotId(),
                        AppConstants.SLOT_RESERVED);

        if (!slotReserved) {

            return ServiceResult.failure(
                    "Unable to reserve parking slot.");

        }

        return ServiceResult.success(
                "Booking created successfully.");

    }

    /**
     * Parking Charge Calculator
     */
    private double calculateAmount(
            String vehicleType,
            Time entryTime,
            Time exitTime) {

        LocalTime entry =
                entryTime.toLocalTime();

        LocalTime exit =
                exitTime.toLocalTime();

        long minutes =
                Duration.between(entry, exit)
                        .toMinutes();

        double hours =
                Math.ceil(minutes / 60.0);

        double rate;

        switch (vehicleType.toUpperCase()) {

            case "BIKE":
                rate = 20.0;
                break;

            case "CAR":
                rate = 50.0;
                break;

            case "BUS":
                rate = 100.0;
                break;

            default:
                rate = 50.0;

        }

        return hours * rate;

    }

}