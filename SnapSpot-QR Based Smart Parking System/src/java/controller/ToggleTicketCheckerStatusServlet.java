package controller;

import constant.AppConstants;
import dao.TicketCheckerDAO;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Admin;
import model.TicketChecker;

public class ToggleTicketCheckerStatusServlet extends HttpServlet {

    private TicketCheckerDAO ticketCheckerDAO;

    @Override
    public void init() throws ServletException {

        ticketCheckerDAO = new TicketCheckerDAO();

    }

    @Override
    protected void doPost(HttpServletRequest request,
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

            int checkerId =
                    Integer.parseInt(
                            request.getParameter("checkerId"));

            TicketChecker checker =
                    ticketCheckerDAO.getTicketCheckerById(
                            checkerId);

            if (checker == null) {

                session.setAttribute(
                        "errorMessage",
                        "Ticket Checker not found.");

                response.sendRedirect(
                        request.getContextPath()
                        + "/TicketCheckerListServlet");

                return;

            }

            String newStatus;

            if ("ACTIVE".equalsIgnoreCase(
                    checker.getStatus())) {

                newStatus = "BLOCKED";

            } else {

                newStatus = "ACTIVE";

            }

            boolean success =
                    ticketCheckerDAO.updateStatus(
                            checkerId,
                            newStatus);

            if (success) {

                session.setAttribute(
                        "successMessage",
                        "Ticket Checker status updated successfully.");

            } else {

                session.setAttribute(
                        "errorMessage",
                        "Unable to update Ticket Checker status.");

            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/TicketCheckerListServlet");

        }
        catch (Exception ex) {

            ex.printStackTrace();

            session.setAttribute(
                    "errorMessage",
                    "Something went wrong.");

            response.sendRedirect(
                    request.getContextPath()
                    + "/TicketCheckerListServlet");

        }

    }

}