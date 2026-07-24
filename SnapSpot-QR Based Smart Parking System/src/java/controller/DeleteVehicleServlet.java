package controller;

import dao.VehicleDAO;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.*;

public class DeleteVehicleServlet extends HttpServlet {

    private final VehicleDAO vehicleDAO = new VehicleDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("loggedInUser") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp");

            return;
        }

        int vehicleId =
                Integer.parseInt(request.getParameter("id"));

        try {

            vehicleDAO.deleteVehicle(vehicleId);

        } catch (SQLException ex) {

            ex.printStackTrace();

        }

        response.sendRedirect(
                request.getContextPath()
                + "/MyVehiclesServlet");

    }

}