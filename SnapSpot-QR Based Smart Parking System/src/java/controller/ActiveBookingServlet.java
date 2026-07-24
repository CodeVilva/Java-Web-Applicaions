package controller;

import dao.BookingDAO;
import model.Booking;
import model.User;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ActiveBookingServlet extends HttpServlet {

    private final BookingDAO bookingDAO =
            new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
                session.getAttribute("loggedInUser") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp");

            return;
        }

        User user =
                (User) session.getAttribute("loggedInUser");

        try {

            Booking booking =
                    bookingDAO.getActiveBooking(
                            user.getUserId());

            request.setAttribute(
                    "activeBooking",
                    booking);

            request.getRequestDispatcher(
                    "/user/active-booking.jsp")
                    .forward(
                            request,
                            response);

        } catch (SQLException ex) {

            ex.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to load active booking.");

            request.getRequestDispatcher(
                    "/user/active-booking.jsp")
                    .forward(
                            request,
                            response);

        }

    }

}