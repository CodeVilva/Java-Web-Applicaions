package controller;

import constant.AppConstants;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        String redirectUrl =
                request.getContextPath() + "/index.jsp";

        if (session != null) {

            if (session.getAttribute(
                    AppConstants.SESSION_ADMIN) != null) {

                redirectUrl =
                        request.getContextPath()
                        + "/admin/login.jsp";

            }
            else if (session.getAttribute(
                    AppConstants.SESSION_TICKET_CHECKER) != null) {

                redirectUrl =
                        request.getContextPath()
                        + "/ticket-checker/login.jsp";

            }
            else if (session.getAttribute(
                    AppConstants.SESSION_USER) != null) {

                redirectUrl =
                        request.getContextPath()
                        + "/user/user.jsp";

            }

            session.invalidate();

        }

        response.sendRedirect(redirectUrl);

    }

}