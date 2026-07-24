package controller;

import dao.VehicleDAO;
import model.User;
import model.Vehicle;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.*;

public class EditVehicleServlet extends HttpServlet {

    private final VehicleDAO vehicleDAO = new VehicleDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int vehicleId = Integer.parseInt(request.getParameter("id"));

        try {

            Vehicle vehicle = vehicleDAO.getVehicleById(vehicleId);

            request.setAttribute("vehicle", vehicle);

            request.getRequestDispatcher("/user/edit-vehicle.jsp")
                   .forward(request, response);

        } catch (SQLException ex) {

            ex.printStackTrace();

            response.sendRedirect(request.getContextPath()
                    + "/MyVehiclesServlet");

        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");

        Vehicle vehicle = new Vehicle();

        vehicle.setVehicleId(
                Integer.parseInt(request.getParameter("vehicleId")));

        vehicle.setUserId(user.getUserId());

        vehicle.setVehicleNumber(
                request.getParameter("vehicleNumber"));

        vehicle.setVehicleType(
                request.getParameter("vehicleType"));

        try {

            boolean success = vehicleDAO.updateVehicle(vehicle);

            if (success) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/MyVehiclesServlet");

            } else {

                request.setAttribute("error",
                        "Unable to update vehicle.");

                request.setAttribute("vehicle", vehicle);

                request.getRequestDispatcher("/user/edit-vehicle.jsp")
                       .forward(request, response);

            }

        } catch (SQLException ex) {

            ex.printStackTrace();

            request.setAttribute("error",
                    "Database error occurred.");

            request.setAttribute("vehicle", vehicle);

            request.getRequestDispatcher("/user/edit-vehicle.jsp")
                   .forward(request, response);

        }

    }

}