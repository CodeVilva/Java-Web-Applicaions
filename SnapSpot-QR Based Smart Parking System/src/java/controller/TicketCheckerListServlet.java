package controller;

import constant.AppConstants;
import dao.TicketCheckerDAO;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Admin;
import model.TicketChecker;

public class TicketCheckerListServlet extends HttpServlet {

    private TicketCheckerDAO ticketCheckerDAO;

    @Override
    public void init() throws ServletException {

        ticketCheckerDAO = new TicketCheckerDAO();

    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/login.jsp");

            return;

        }

        Admin admin =
                (Admin) session.getAttribute(
                        AppConstants.SESSION_ADMIN);

        if (admin == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/login.jsp");

            return;

        }

        try {

            List<TicketChecker> ticketCheckerList =
                    ticketCheckerDAO.getAllTicketCheckers();

            request.setAttribute(
                    "ticketCheckerList",
                    ticketCheckerList);

            request.getRequestDispatcher(
                    "/admin/ticket-checkers.jsp")
                    .forward(request, response);

        } catch (Exception ex) {

            ex.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    "Unable to load Ticket Checkers.");

            request.getRequestDispatcher(
                    "/admin/ticket-checkers.jsp")
                    .forward(request, response);

        }

    }

}