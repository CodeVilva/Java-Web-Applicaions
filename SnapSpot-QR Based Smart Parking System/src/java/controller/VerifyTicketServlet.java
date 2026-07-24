package controller;

import constant.AppConstants;

import dao.BookingDAO;
import dao.ParkingSlotDAO;
import dao.EntryExitLogDAO;

import model.Booking;
import model.EntryExitLog;
import model.TicketChecker;

import java.io.IOException;

import java.sql.Timestamp;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalTime;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class VerifyTicketServlet extends HttpServlet {

    private BookingDAO bookingDAO;

    private ParkingSlotDAO slotDAO;

    private EntryExitLogDAO entryExitLogDAO;

    @Override
    public void init()
            throws ServletException {

        bookingDAO = new BookingDAO();

        slotDAO = new ParkingSlotDAO();

        entryExitLogDAO = new EntryExitLogDAO();

    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
                session.getAttribute(
                        AppConstants.SESSION_TICKET_CHECKER) == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/ticket-checker/login.jsp");

            return;

        }

        TicketChecker checker =
                (TicketChecker) session.getAttribute(
                        AppConstants.SESSION_TICKET_CHECKER);

        try {

            int bookingId;

            String qrData =
                    request.getParameter("qrData");

            if (qrData != null &&
                    !qrData.trim().isEmpty()) {

                qrData = qrData.trim();

                if (qrData.contains("|")) {

                    String[] parts =
                            qrData.split("\\|");

                    bookingId =
                            Integer.parseInt(parts[1]);

                }
                else if (qrData.startsWith("BOOKING_")) {

                    bookingId =
                            Integer.parseInt(
                                    qrData.replace(
                                            "BOOKING_",
                                            ""));

                }
                else {

                    bookingId =
                            Integer.parseInt(qrData);

                }

            }
            else {

                bookingId =
                        Integer.parseInt(
                                request.getParameter(
                                        "bookingId"));

            }

            Booking booking =
                    bookingDAO.getBookingById(
                            bookingId);

            if (booking == null) {

                forward(
                        request,
                        response,
                        "FAILED",
                        "Invalid Ticket.",
                        null);

                return;

            }

            if (!AppConstants.PAYMENT_SUCCESS
                    .equalsIgnoreCase(
                            booking.getPaymentStatus())) {

                forward(
                        request,
                        response,
                        "FAILED",
                        "Payment not completed.",
                        booking);

                return;

            }

            LocalDate today =
                    LocalDate.now();

            LocalTime now =
                    LocalTime.now();

            LocalDate bookingDate =
                    booking.getBookingDate()
                            .toLocalDate();

            LocalTime entryTime =
                    booking.getEntryTime()
                            .toLocalTime();

            LocalTime exitTime =
                    booking.getExitTime()
                            .toLocalTime();

            if (!bookingDate.equals(today)) {

                forward(
                        request,
                        response,
                        "FAILED",
                        "Ticket expired.",
                        booking);

                return;

            }

            LocalTime allowedEntryTime =
                    entryTime.minusMinutes(
                            AppConstants.ENTRY_WINDOW_MINUTES);

            if (now.isBefore(
                    allowedEntryTime)) {

                forward(
                        request,
                        response,
                        "FAILED",
                        "Entry allowed only after "
                        + allowedEntryTime,
                        booking);

                return;

            }

            if (now.isAfter(exitTime)) {

                forward(
                        request,
                        response,
                        "FAILED",
                        "Booking time expired.",
                        booking);

                return;

            }

            /*
             * PART 2 STARTS HERE
             *
             * if (BOOKING_CONFIRMED)
             * else if (BOOKING_ACTIVE)
             * else if (BOOKING_COMPLETED)
             */
            /*------------------------------------------------------
                ENTRY
            ------------------------------------------------------*/

            if (AppConstants.BOOKING_CONFIRMED.equalsIgnoreCase(
                    booking.getBookingStatus())) {

                EntryExitLog log =
                        new EntryExitLog();

                log.setBookingId(
                        booking.getBookingId());

                log.setCheckerId(
                        checker.getCheckerId());

                log.setEntryTime(
                        new Timestamp(
                                System.currentTimeMillis()));

                boolean logCreated =
                        entryExitLogDAO.createEntryLog(
                                log);

                boolean bookingUpdated =
                        bookingDAO.updateBookingStatus(
                                bookingId,
                                AppConstants.BOOKING_ACTIVE);

                boolean slotUpdated =
                        slotDAO.updateSlotStatus(
                                booking.getSlotId(),
                                AppConstants.SLOT_OCCUPIED);

                if (!logCreated ||
                    !bookingUpdated ||
                    !slotUpdated) {

                    forward(
                            request,
                            response,
                            "FAILED",
                            "Unable to register vehicle entry.",
                            booking);

                    return;

                }

                booking.setBookingStatus(
                        AppConstants.BOOKING_ACTIVE);

                forward(
                        request,
                        response,
                        "ENTRY",
                        "Vehicle Entry Allowed",
                        booking);

                return;

            }

            /*------------------------------------------------------
                EXIT
            ------------------------------------------------------*/

            else if (AppConstants.BOOKING_ACTIVE.equalsIgnoreCase(
                    booking.getBookingStatus())) {

                EntryExitLog log =
                        entryExitLogDAO.getActiveLogByBooking(
                                bookingId);

                if (log == null) {

                    forward(
                            request,
                            response,
                            "FAILED",
                            "Entry record not found.",
                            booking);

                    return;

                }

                Timestamp exitTimeStamp =
                        new Timestamp(
                                System.currentTimeMillis());

                log.setExitTime(
                        exitTimeStamp);

                int duration =
                        entryExitLogDAO.calculateDuration(
                                log.getEntryTime(),
                                exitTimeStamp);

                log.setDurationMinutes(
                        duration);

                int bookedMinutes =
                        (int) Duration.between(
                                booking.getEntryTime().toLocalTime(),
                                booking.getExitTime().toLocalTime())
                                .toMinutes();

                double extraCharge =
                        entryExitLogDAO.calculateExtraCharge(
                                duration,
                                bookedMinutes);

                log.setExtraCharge(
                        extraCharge);

                boolean logUpdated =
                        entryExitLogDAO.updateExitLog(
                                log);
                
                log.setCheckerId(
                        checker.getCheckerId());
                
                boolean bookingUpdated =
                        bookingDAO.updateBookingStatus(
                                bookingId,
                                AppConstants.BOOKING_COMPLETED);

                boolean slotUpdated =
                        slotDAO.updateSlotStatus(
                                booking.getSlotId(),
                                AppConstants.SLOT_AVAILABLE);

                if (!logUpdated ||
                    !bookingUpdated ||
                    !slotUpdated) {

                    forward(
                            request,
                            response,
                            "FAILED",
                            "Unable to register vehicle exit.",
                            booking);

                    return;

                }

                booking.setBookingStatus(
                        AppConstants.BOOKING_COMPLETED);
                
                log.setCheckerId(checker.getCheckerId());

                forward(
                        request,
                        response,
                        "EXIT",
                        "Vehicle Exit Completed",
                        booking);

                return;

            }

            /*------------------------------------------------------
                ALREADY USED
            ------------------------------------------------------*/

            else if (AppConstants.BOOKING_COMPLETED.equalsIgnoreCase(
                    booking.getBookingStatus())) {

                forward(
                        request,
                        response,
                        "FAILED",
                        "Ticket already used.",
                        booking);

                return;

            }

            /*------------------------------------------------------
                INVALID STATUS
            ------------------------------------------------------*/

            else {

                forward(
                        request,
                        response,
                        "FAILED",
                        "Invalid booking status.",
                        booking);

                return;

            }
        }
        catch (NumberFormatException ex) {

            ex.printStackTrace();

            forward(
                    request,
                    response,
                    "FAILED",
                    "Invalid QR Code / Booking ID.",
                    null);

        }
        catch (Exception ex) {

            ex.printStackTrace();

            forward(
                    request,
                    response,
                    "FAILED",
                    "Verification failed.",
                    null);

        }

    }
            /**
             * Common Forward Method
             */
            private void forward(
                    HttpServletRequest request,
                    HttpServletResponse response,
                    String status,
                    String message,
                    Booking booking)
                    throws ServletException, IOException {

                request.setAttribute(
                        "status",
                        status);

                request.setAttribute(
                        "message",
                        message);

                if (booking != null) {

                    request.setAttribute(
                            "booking",
                            booking);

                }

                request.getRequestDispatcher(
                        "/ticket-checker/verification-result.jsp")
                        .forward(
                                request,
                                response);

            }

        }