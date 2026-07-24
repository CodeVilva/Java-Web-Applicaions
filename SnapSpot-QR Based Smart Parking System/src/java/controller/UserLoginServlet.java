package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import constant.AppConstants;
import model.User;
import service.ServiceResult;
import service.UserAuthenticationService;

/**
 * ============================================================
 * UserLoginServlet
 * ============================================================
 * Handles user login requests.
 *
 * NOTE:
 * Configure servlet mapping in web.xml.
 * ============================================================
 */
public class UserLoginServlet extends HttpServlet {

    private UserAuthenticationService authenticationService;

    @Override
    public void init() throws ServletException {

        authenticationService = new UserAuthenticationService();

    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        ServiceResult result =
                authenticationService.login(email, password);

        HttpSession session = request.getSession();

        if (result.isSuccess()) {

            User user = (User) result.getData();

            // Create User Session
            session.setAttribute(
                    AppConstants.SESSION_USER,
                    user
            );

            // Session Timeout (30 Minutes)
            session.setMaxInactiveInterval(
                    AppConstants.SESSION_TIMEOUT
            );
                         
            response.sendRedirect(
                    request.getContextPath()
                    + "/UserDashboardServlet"
            );

        } else {

            session.setAttribute(
                    "errorMessage",
                    result.getMessage()
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/user/user.jsp"
            );

        }

    }

}