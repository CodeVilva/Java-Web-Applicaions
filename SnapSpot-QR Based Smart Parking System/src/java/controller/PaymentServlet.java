package controller;

import constant.AppConstants;
import dao.BookingDAO;
import dao.PaymentDAO;
import model.Booking;
import model.Payment;
import model.User;
import util.QRCodeUtil;

import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class PaymentServlet extends HttpServlet {

    private BookingDAO bookingDAO;
    private PaymentDAO paymentDAO;

    @Override
    public void init() throws ServletException {

        bookingDAO = new BookingDAO();
        paymentDAO = new PaymentDAO();

    }

    @Override
    protected void doPost(HttpServletRequest request,
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

            int bookingId =
                    Integer.parseInt(
                            request.getParameter("bookingId"));

            Booking booking =
                    bookingDAO.getBookingById(
                            bookingId);

            if (booking == null) {

                session.setAttribute(
                        "errorMessage",
                        "Booking not found.");

                response.sendRedirect(
                        request.getContextPath()
                        + "/BookSlotPageServlet");

                return;

            }

            /*----------------------------------------
                Create Dummy Payment
            ----------------------------------------*/

            Payment payment = new Payment();

            payment.setBookingId(
                    booking.getBookingId());

            payment.setAmount(
                    booking.getTotalAmount());

            payment.setPaymentMethod(
                    "Dummy Payment");

            payment.setGateway(
                    "SNAPSPOT Demo Gateway");

            payment.setPaymentStatus(
                    AppConstants.PAYMENT_SUCCESS);

            payment.setTransactionId(
                    UUID.randomUUID()
                            .toString()
                            .replace("-", "")
                            .substring(0, 16));

            boolean paymentSaved =
                    paymentDAO.createPayment(
                            payment);

            if (!paymentSaved) {

                session.setAttribute(
                        "errorMessage",
                        "Unable to process payment.");

                response.sendRedirect(
                        request.getContextPath()
                        + "/PaymentPageServlet");

                return;

            }

            /*----------------------------------------
                Update Booking
            ----------------------------------------*/

            bookingDAO.updatePaymentStatus(
                    bookingId,
                    AppConstants.PAYMENT_SUCCESS);

            bookingDAO.updateBookingStatus(
                    bookingId,
                    AppConstants.BOOKING_CONFIRMED);

            /*----------------------------------------
                Store QR Code
            ----------------------------------------*/
            String qrData =
                        "BOOKING_ID=" + bookingId;

            String qrPath =
                        QRCodeUtil.generateQRCode(
                        bookingId,
                        qrData);
            
            System.out.println("QR Path in DB = " + qrPath);
            System.out.println("Real Path = " + getServletContext().getRealPath("/qr_codes"));

            bookingDAO.updateQRCode(
                        bookingId,
                        qrPath);
            /*----------------------------------------
                Store Booking Id
            ----------------------------------------*/

            session.setAttribute(
                    "bookingId",
                    bookingId);

            response.sendRedirect(
                    request.getContextPath()
                    + "/TicketServlet");

        }
        catch (NumberFormatException ex) {

            session.setAttribute(
                    "errorMessage",
                    "Invalid booking.");

            response.sendRedirect(
                    request.getContextPath()
                    + "/BookSlotPageServlet");

        }
        catch (SQLException ex) {

            ex.printStackTrace();

            session.setAttribute(
                    "errorMessage",
                    "Database error while processing payment.");

            response.sendRedirect(
                    request.getContextPath()
                    + "/PaymentPageServlet");

        }
        catch (Exception ex) {

            ex.printStackTrace();

            session.setAttribute(
                    "errorMessage",
                    "Unable to complete payment.");

            response.sendRedirect(
                    request.getContextPath()
                    + "/PaymentPageServlet");

        }

    }

}