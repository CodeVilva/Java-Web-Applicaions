package controller;

import constant.AppConstants;
import model.Booking;
import model.User;
import service.BookingService;
import service.ServiceResult;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class BookSlotServlet extends HttpServlet {

    private BookingService bookingService;

    @Override
    public void init() throws ServletException {

        bookingService = new BookingService();

    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/user/user.jsp");

            return;

        }

        User user =
                (User) session.getAttribute(
                        AppConstants.SESSION_USER);

        if (user == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/user/user.jsp");

            return;

        }

        /*------------------------------------------
            Read Form Data
        ------------------------------------------*/
        String vehicleId =
                request.getParameter("vehicleId");

        String slotId =
                request.getParameter("slotId");

        String bookingDate =
                request.getParameter("bookingDate");

        String entryTime =
                request.getParameter("entryTime");

        String exitTime =
                request.getParameter("exitTime");
        
        System.out.println(vehicleId);
        System.out.println(slotId);
        System.out.println(bookingDate);
        System.out.println(entryTime);
        System.out.println(exitTime);
        
        /*------------------------------------------
            Validate Input
        ------------------------------------------*/
        if (vehicleId == null || vehicleId.trim().isEmpty()
                || slotId == null || slotId.trim().isEmpty()
                || bookingDate == null || bookingDate.trim().isEmpty()
                || entryTime == null || entryTime.trim().isEmpty()
                || exitTime == null || exitTime.trim().isEmpty()) {

            session.setAttribute(
                    "errorMessage",
                    "Please fill all booking details.");

            response.sendRedirect(
                    request.getContextPath()
                    + "/BookSlotPageServlet");

            return;

        }

        try {

            Booking booking = new Booking();

            booking.setUserId(
                    user.getUserId());

            booking.setVehicleId(
                    Integer.parseInt(vehicleId));

            booking.setSlotId(
                    Integer.parseInt(slotId));

            booking.setBookingDate(
                    Date.valueOf(bookingDate));

            booking.setEntryTime(
                    Time.valueOf(entryTime + ":00"));

            booking.setExitTime(
                    Time.valueOf(exitTime + ":00"));

            ServiceResult result =
                    bookingService.createBooking(booking);
            
//            Booking booking =(Booking);?
            
            if (result.isSuccess()) {

                /*
                 * Store booking temporarily.
                 * Dummy Payment page will use this.
                 */
                
                session.setAttribute(
                "bookingId",
                booking.getBookingId());
                
                session.setAttribute(
                        "successMessage",
                        "Booking created successfully. Please complete the payment.");

                response.sendRedirect(
                        request.getContextPath()
                        + "/PaymentPageServlet");

            } else {

                session.setAttribute(
                        "errorMessage",
                        result.getMessage());

                response.sendRedirect(
                        request.getContextPath()
                        + "/BookSlotPageServlet");

            }

        } catch (Exception ex) {

            ex.printStackTrace();

            session.setAttribute(
                    "errorMessage",
                    ex.getMessage());

            response.sendRedirect(
                    request.getContextPath()
                    + "/BookSlotPageServlet");

        }

    }

}