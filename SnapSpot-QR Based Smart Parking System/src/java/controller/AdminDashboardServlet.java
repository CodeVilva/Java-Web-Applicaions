package controller;

import constant.AppConstants;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Admin;

public class AdminDashboardServlet extends HttpServlet {

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

        request.setAttribute(
                "admin",
                admin);

        request.getRequestDispatcher(
                "/admin/dashboard.jsp")
                .forward(request, response);

    }

}