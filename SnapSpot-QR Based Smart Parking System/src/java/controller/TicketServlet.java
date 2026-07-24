package controller;

import constant.AppConstants;
import dao.BookingDAO;
import dao.ParkingAreaDAO;
import dao.ParkingSlotDAO;
import dao.VehicleDAO;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Booking;
import model.ParkingArea;
import model.ParkingSlot;
import model.User;
import model.Vehicle;

public class TicketServlet extends HttpServlet {

    private BookingDAO bookingDAO;
    private VehicleDAO vehicleDAO;
    private ParkingSlotDAO slotDAO;
    private ParkingAreaDAO areaDAO;

    @Override
    public void init() throws ServletException {

        bookingDAO = new BookingDAO();
        vehicleDAO = new VehicleDAO();
        slotDAO = new ParkingSlotDAO();
        areaDAO = new ParkingAreaDAO();

    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/user/login.jsp");

            return;

        }

        User user =
                (User) session.getAttribute(
                        AppConstants.SESSION_USER);

        if (user == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/user/login.jsp");

            return;

        }

        Integer bookingId =
                (Integer) session.getAttribute(
                        "bookingId");

        if (bookingId == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/user/dashboard.jsp");

            return;

        }

        try {

            Booking booking =
                    bookingDAO.getBookingById(
                            bookingId);

            if (booking == null) {

                session.setAttribute(
                        "errorMessage",
                        "Booking not found.");

                response.sendRedirect(
                        request.getContextPath()
                        + "/user/dashboard.jsp");

                return;

            }

            Vehicle vehicle =
                    vehicleDAO.getVehicleById(
                            booking.getVehicleId());

            ParkingSlot slot =
                    slotDAO.getSlotById(
                            booking.getSlotId());

            ParkingArea area =
                    areaDAO.getAreaBySlotId(
                            booking.getSlotId());

            request.setAttribute(
                    "booking",
                    booking);

            request.setAttribute(
                    "vehicle",
                    vehicle);

            request.setAttribute(
                    "slot",
                    slot);

            request.setAttribute(
                    "area",
                    area);

            request.getRequestDispatcher(
                    "/user/ticket.jsp")
                    .forward(request, response);

        } catch (Exception ex) {

            ex.printStackTrace();

            session.setAttribute(
                    "errorMessage",
                    "Unable to load ticket.");

            response.sendRedirect(
                    request.getContextPath()
                    + "/user/dashboard.jsp");

        }

    }

}