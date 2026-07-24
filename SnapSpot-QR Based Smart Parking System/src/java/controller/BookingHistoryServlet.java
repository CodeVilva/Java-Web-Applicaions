package controller;

import dao.BookingDAO;
import model.Booking;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

import java.sql.SQLException;

import java.util.List;

public class BookingHistoryServlet extends HttpServlet {

    private final BookingDAO bookingDAO =
            new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null
                || session.getAttribute("loggedInUser") == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login.jsp");

            return;

        }

        User user =
                (User) session.getAttribute("loggedInUser");

        try {

            List<Booking> bookingList =
                    bookingDAO.getBookingsByUserId(
                            user.getUserId());

            request.setAttribute(
                    "bookingList",
                    bookingList);

            request.getRequestDispatcher(
                    "/user/booking-history.jsp")
                    .forward(
                            request,
                            response);

        } catch (SQLException ex) {

            ex.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to load booking history.");

            request.getRequestDispatcher(
                    "/user/booking-history.jsp")
                    .forward(
                            request,
                            response);

        }

    }

}