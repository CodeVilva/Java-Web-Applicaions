package controller;

import constant.AppConstants;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.TicketChecker;
import dao.TicketCheckerDAO;

import org.mindrot.jbcrypt.BCrypt;

public class TicketCheckerLoginServlet extends HttpServlet {

    private TicketCheckerDAO ticketCheckerDAO;

    @Override
    public void init() throws ServletException {

        ticketCheckerDAO = new TicketCheckerDAO();

    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String email =
                request.getParameter("email");

        String password =
                request.getParameter("password");

        try {

            TicketChecker checker =
                    ticketCheckerDAO.login(email);

            if (checker == null) {

                session.setAttribute(
                        "errorMessage",
                        "Invalid email or password.");

                response.sendRedirect(
                        request.getContextPath()
                        + "/ticket-checker/login.jsp");

                return;

            }

            boolean passwordMatched =
                    BCrypt.checkpw(
                            password,
                            checker.getPasswordHash());

            if (!passwordMatched) {

                session.setAttribute(
                        "errorMessage",
                        "Invalid email or password.");

                response.sendRedirect(
                        request.getContextPath()
                        + "/ticket-checker/login.jsp");

                return;

            }

            session.setAttribute(
                    AppConstants.SESSION_TICKET_CHECKER,
                    checker);

            session.setAttribute(
                    "successMessage",
                    "Welcome " + checker.getFullName());

            response.sendRedirect(
                    request.getContextPath()
                    + "/TicketCheckerDashboardServlet");

        }
        catch (Exception ex) {

            ex.printStackTrace();

            session.setAttribute(
                    "errorMessage",
                    "Unable to login. Please try again.");

            response.sendRedirect(
                    request.getContextPath()
                    + "/ticket-checker/login.jsp");

        }

    }

}