package controller;

import dao.VehicleDAO;
import model.User;
import model.Vehicle;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AddVehicleServlet extends HttpServlet {

    private final VehicleDAO vehicleDAO = new VehicleDAO();

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

        String vehicleNumber = request.getParameter("vehicleNumber");
        String vehicleType = request.getParameter("vehicleType");

        Vehicle vehicle = new Vehicle();
        vehicle.setUserId(user.getUserId());
        vehicle.setVehicleNumber(vehicleNumber);
        vehicle.setVehicleType(vehicleType);

        try {

            boolean success = vehicleDAO.addVehicle(vehicle);

            if (success) {

                response.sendRedirect(request.getContextPath()
                        + "/MyVehiclesServlet");

            } else {

                request.setAttribute("error",
                        "Unable to register vehicle.");

                request.getRequestDispatcher("/user/add-vehicle.jsp")
                        .forward(request, response);

            }

        } catch (SQLException ex) {

            ex.printStackTrace();

            request.setAttribute("error",
                    "Database error occurred.");

            request.getRequestDispatcher("/user/add-vehicle.jsp")
                    .forward(request, response);

        }

    }
}