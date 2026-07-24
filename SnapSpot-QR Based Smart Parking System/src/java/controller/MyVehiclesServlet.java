package controller;

import dao.VehicleDAO;
import model.User;
import model.Vehicle;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class MyVehiclesServlet extends HttpServlet {

    private final VehicleDAO vehicleDAO =
            new VehicleDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
                session.getAttribute("loggedInUser") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp");

            return;
        }

        User user =
                (User) session.getAttribute("loggedInUser");

        try {

            List<Vehicle> vehicleList =
                    vehicleDAO.getVehiclesByUserId(
                            user.getUserId());

            request.setAttribute(
                    "vehicleList",
                    vehicleList);

            request.getRequestDispatcher(
                    "/user/my-vehicles.jsp")
                    .forward(
                            request,
                            response);

        } catch (SQLException ex) {

            ex.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to load vehicles.");

            request.getRequestDispatcher(
                    "/user/my-vehicles.jsp")
                    .forward(
                            request,
                            response);

        }

    }

}