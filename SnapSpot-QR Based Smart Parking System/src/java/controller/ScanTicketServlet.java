package controller;

import constant.AppConstants;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.TicketChecker;

public class ScanTicketServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/ticket-checker/login.jsp");

            return;

        }

        TicketChecker checker =
                (TicketChecker) session.getAttribute(
                        AppConstants.SESSION_TICKET_CHECKER);

        if (checker == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/ticket-checker/login.jsp");

            return;

        }

        request.setAttribute(
                "ticketChecker",
                checker);

        request.getRequestDispatcher(
                "/ticket-checker/scan-ticket.jsp")
                .forward(request, response);

    }

}