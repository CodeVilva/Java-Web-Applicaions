package controller;

import constant.AppConstants;
import dao.BookingDAO;
import dao.ParkingRateDAO;
import dao.VehicleDAO;
import model.Booking;
import model.ParkingRate;
import model.User;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UserDashboardServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final VehicleDAO vehicleDAO = new VehicleDAO();
    private final ParkingRateDAO parkingRateDAO = new ParkingRateDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {

            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;

        }

        User user =
                (User) session.getAttribute(AppConstants.SESSION_USER);

        if (user == null) {

            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;

        }

        try {

            List<Booking> activeBookings =
                    bookingDAO.getActiveBookingsByUserId(
                            user.getUserId(),
                            4);

            request.setAttribute(
                    "activeBookings",
                    activeBookings);

            
            List<ParkingRate> parkingRates =
                    parkingRateDAO.getParkingRates();

            request.setAttribute("parkingRates", parkingRates);

            int vehicleCount =
                    vehicleDAO.getVehicleCount(
                            user.getUserId());

            request.setAttribute(
                    "vehicleCount",
                    vehicleCount);

            int bookingCount =
                    bookingDAO.getBookingCount(
                            user.getUserId());

            request.setAttribute(
                    "bookingCount",
                    bookingCount);

            int qrTicketCount =
                    bookingDAO.getQrTicketCount(
                            user.getUserId());

            request.setAttribute(
                    "qrTicketCount",
                    qrTicketCount);

            request.getRequestDispatcher(
                    "/user/dashboard.jsp")
                    .forward(
                            request,
                            response);

        } catch (SQLException ex) {

            ex.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to load dashboard.");

            request.getRequestDispatcher(
                    "/user/dashboard.jsp")
                    .forward(
                            request,
                            response);

        }

    }

}