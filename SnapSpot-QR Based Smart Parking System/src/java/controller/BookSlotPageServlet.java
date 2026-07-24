package controller;

import constant.AppConstants;
import dao.BookingDAO;
import dao.ParkingRateDAO;
import dao.ParkingSlotDAO;
import dao.VehicleDAO;
import dao.ParkingAreaDAO;
import model.ParkingArea;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Booking;
import model.ParkingRate;
import model.ParkingSlot;
import model.User;
import model.Vehicle;

public class BookSlotPageServlet extends HttpServlet {

    private VehicleDAO vehicleDAO;
    private ParkingSlotDAO slotDAO;
    private ParkingRateDAO rateDAO;
    private BookingDAO bookingDAO;
    private ParkingAreaDAO areaDAO;

    @Override
    public void init() throws ServletException {

        vehicleDAO = new VehicleDAO();
        slotDAO = new ParkingSlotDAO();
        rateDAO = new ParkingRateDAO();
        bookingDAO = new BookingDAO();
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

        try {
            List<ParkingArea> areaList =
            areaDAO.getAllActiveAreas();

            List<Vehicle> vehicleList =
                    vehicleDAO.getVehiclesByUserId(
                            user.getUserId());

            List<ParkingSlot> slotList =
                    slotDAO.getAllAvailableSlots();

            List<ParkingRate> rateList =
                    rateDAO.getAllRates();

            Booking activeBooking =
                    bookingDAO.getActiveBooking(
                            user.getUserId());
            
            request.setAttribute(
            "areaList",
            areaList);
            
            request.setAttribute(
                    "vehicleList",
                    vehicleList);

            request.setAttribute(
                    "slotList",
                    slotList);

            request.setAttribute(
                    "rateList",
                    rateList);

            request.setAttribute(
                    "activeBooking",
                    activeBooking);

            request.getRequestDispatcher(
                    "/user/book-slot.jsp")
                    .forward(request, response);

        } catch (Exception ex) {

            ex.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    ex.getMessage());

            request.getRequestDispatcher(
                    "/user/book-slot.jsp")
                    .forward(request, response);

        }

    }

}