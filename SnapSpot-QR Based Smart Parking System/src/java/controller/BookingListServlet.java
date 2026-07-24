package controller;

import dao.BookingDAO;
import model.Admin;
import model.Booking;

import constant.AppConstants;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class BookingListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }

        Admin admin = (Admin) session.getAttribute(AppConstants.SESSION_ADMIN);

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }

        try {

            BookingDAO bookingDAO = new BookingDAO();

            List<Booking> bookingList = bookingDAO.getAllBookings();

            request.setAttribute("admin", admin);
            request.setAttribute("bookingList", bookingList);

            request.getRequestDispatcher("/admin/booking-list.jsp")
                   .forward(request, response);

        } catch (SQLException e) {

            e.printStackTrace();

            request.setAttribute("errorMessage",
                    "Unable to load booking records.");

            request.getRequestDispatcher("/admin/booking-list.jsp")
                   .forward(request, response);

        }

    }

}