package service;

import constant.AppConstants;
import dao.UserDAO;
import dao.VehicleDAO;
import model.User;
import model.Vehicle;
import util.PasswordUtil;

/**
 * ============================================================
 * UserRegistrationService
 * ============================================================
 * Handles business logic related to user registration.
 * ============================================================
 */
public class UserRegistrationService {

    private final UserDAO userDAO;
    private final VehicleDAO vehicleDAO;

    /**
     * Constructor
     */
    public UserRegistrationService() {

        userDAO = new UserDAO();
        vehicleDAO = new VehicleDAO();

    }

    /**
     * Register New User
     *
     * @param user User Details
     * @param vehicle Vehicle Details
     * @return ServiceResult
     */
    public ServiceResult registerUser(User user,
                                      Vehicle vehicle) {

        try {

            /*
             * Validate Email
             */
            if (userDAO.emailExists(user.getEmail())) {

                return ServiceResult.failure(
                        "Email already registered.");

            }

            /*
             * Validate Mobile
             */
            if (userDAO.mobileExists(user.getMobile())) {

                return ServiceResult.failure(
                        "Mobile number already registered.");

            }

            /*
             * Encrypt Password
             */
            String hashedPassword =
                    PasswordUtil.hashPassword(
                            user.getPasswordHash());

            user.setPasswordHash(hashedPassword);

            /*
             * Set Default Status
             */
            user.setStatus(AppConstants.STATUS_ACTIVE);

            /*
             * Save User
             */
            boolean userSaved =
                    userDAO.registerUser(user);

            if (!userSaved) {

                return ServiceResult.failure(
                        "Unable to register user.");

            }

            /*
             * Retrieve Generated User
             */
            User registeredUser =
                    userDAO.getUserByEmail(
                            user.getEmail());

            if (registeredUser == null) {

                return ServiceResult.failure(
                        "Unable to retrieve registered user.");

            }

            /*
             * Assign User ID
             */
            vehicle.setUserId(
                    registeredUser.getUserId());

            vehicle.setDefaultVehicle(true);

            /*
             * Save Vehicle
             */
            boolean vehicleSaved =
                    vehicleDAO.addVehicle(vehicle);

            if (!vehicleSaved) {

                return ServiceResult.failure(
                        "Vehicle registration failed.");

            }

            /*
             * Registration Successful
             */
            return ServiceResult.success(
                    "Registration completed successfully.");

        }
        catch (Exception ex) {

            ex.printStackTrace();

            return ServiceResult.failure(
                    "Something went wrong. Please try again.");

        }

    }

}