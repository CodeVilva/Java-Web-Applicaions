package controller;

import constant.AppConstants;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;
import model.Vehicle;
import service.ServiceResult;
import service.UserRegistrationService;

/**
 * ============================================================
 * RegisterServlet
 * ============================================================
 * Handles user registration requests.
 *
 * NOTE:
 * Configure this servlet in web.xml
 * ============================================================
 */
public class RegisterServlet extends HttpServlet {

    private UserRegistrationService registrationService;

    @Override
    public void init() throws ServletException {

        registrationService = new UserRegistrationService();

    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // ===============================
        // Read User Details
        // ===============================

        String fullName = request.getParameter("fullname");
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        String password = request.getParameter("password");

        // ===============================
        // Read Vehicle Details
        // ===============================

        String vehicleNumber = request.getParameter("vehicleNumber");
        String vehicleType = request.getParameter("vehicleType");

        // ===============================
        // Create Model Objects
        // ===============================

        User user = new User();

        user.setFullName(fullName);
        user.setEmail(email);
        user.setMobile(mobile);
        user.setPasswordHash(password);

        Vehicle vehicle = new Vehicle();

        vehicle.setVehicleNumber(vehicleNumber);
        vehicle.setVehicleType(vehicleType);

        // ===============================
        // Call Service
        // ===============================

        ServiceResult result =
                registrationService.registerUser(user, vehicle);

        HttpSession session = request.getSession();

        if (result.isSuccess()) {

            session.setAttribute(
                    "successMessage",
                    result.getMessage());

            response.sendRedirect(
                    request.getContextPath()
                    + "/user/login.jsp");

        } else {

            session.setAttribute(
                    "errorMessage",
                    result.getMessage());

            response.sendRedirect(
                    request.getContextPath()
                    + "/register.jsp");

        }

    }

}