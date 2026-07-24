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

public class EditTicketCheckerServlet extends HttpServlet {

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
                            request.getParameter(
                                    "checkerId"));

            String fullName =
                    request.getParameter(
                            "fullName");

            String email =
                    request.getParameter(
                            "email");

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

            checker.setFullName(fullName);
            checker.setEmail(email);

            boolean success =
                    ticketCheckerDAO.updateTicketChecker(
                            checker);

            if (success) {

                session.setAttribute(
                        "successMessage",
                        "Ticket Checker updated successfully.");

            } else {

                session.setAttribute(
                        "errorMessage",
                        "Unable to update Ticket Checker.");

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