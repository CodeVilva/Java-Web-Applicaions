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

import org.mindrot.jbcrypt.BCrypt;

public class AddTicketCheckerServlet extends HttpServlet {

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

            String fullName =
                    request.getParameter("fullName");

            String email =
                    request.getParameter("email");

            String password =
                    request.getParameter("password");

            String confirmPassword =
                    request.getParameter("confirmPassword");

            if (!password.equals(confirmPassword)) {

                session.setAttribute(
                        "errorMessage",
                        "Passwords do not match.");

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/add-ticket-checker.jsp");

                return;

            }

            if (ticketCheckerDAO.emailExists(email)) {

                session.setAttribute(
                        "errorMessage",
                        "Email already exists.");

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/add-ticket-checker.jsp");

                return;

            }

            TicketChecker checker =
                    new TicketChecker();

            checker.setFullName(fullName);
            checker.setEmail(email);

            checker.setPasswordHash(
                    BCrypt.hashpw(
                            password,
                            BCrypt.gensalt()));

            checker.setStatus("ACTIVE");

            boolean success =
                    ticketCheckerDAO.addTicketChecker(
                            checker);

            if (success) {

                session.setAttribute(
                        "successMessage",
                        "Ticket Checker added successfully.");

                response.sendRedirect(
                        request.getContextPath()
                        + "/TicketCheckerListServlet");

            } else {

                session.setAttribute(
                        "errorMessage",
                        "Unable to add Ticket Checker.");

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/add-ticket-checker.jsp");

            }

        }
        catch (Exception ex) {

            ex.printStackTrace();

            session.setAttribute(
                    "errorMessage",
                    "Something went wrong.");

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/add-ticket-checker.jsp");

        }

    }

}