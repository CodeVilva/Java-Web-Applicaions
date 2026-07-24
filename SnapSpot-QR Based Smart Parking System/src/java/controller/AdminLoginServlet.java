package controller;

import constant.AppConstants;
import dao.AdminDAO;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Admin;

import org.mindrot.jbcrypt.BCrypt;

public class AdminLoginServlet extends HttpServlet {

    private AdminDAO adminDAO;

    @Override
    public void init() throws ServletException {

        adminDAO = new AdminDAO();

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

            Admin admin =
                    adminDAO.login(email);

            if (admin == null) {

                session.setAttribute(
                        "errorMessage",
                        "Invalid email or password.");

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/login.jsp");

                return;

            }

            boolean passwordMatched =
                    BCrypt.checkpw(
                            password,
                            admin.getPasswordHash());

            if (!passwordMatched) {

                session.setAttribute(
                        "errorMessage",
                        "Invalid email or password.");

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/login.jsp");

                return;

            }

            session.setAttribute(
                    AppConstants.SESSION_ADMIN,
                    admin);

            session.setAttribute(
                    "successMessage",
                    "Welcome " + admin.getFullName());

            response.sendRedirect(
                    request.getContextPath()
                    + "/AdminDashboardServlet");

        }
        catch (Exception ex) {

            ex.printStackTrace();

            session.setAttribute(
                    "errorMessage",
                    "Unable to login. Please try again.");

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/login.jsp");

        }

    }

}