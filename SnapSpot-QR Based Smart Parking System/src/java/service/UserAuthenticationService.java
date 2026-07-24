package service;

import constant.AppConstants;
import dao.UserDAO;
import model.User;
import util.PasswordUtil;

/**
 * ============================================================
 * UserAuthenticationService
 * ============================================================
 * Handles user authentication.
 * ============================================================
 */
public class UserAuthenticationService {

    private final UserDAO userDAO;

    public UserAuthenticationService() {
        userDAO = new UserDAO();
    }

    /**
     * Authenticate User
     *
     * @param email User email
     * @param password Plain text password
     * @return ServiceResult
     */
    public ServiceResult login(String email,
                               String password) {

        try {

            /*
             * Find User
             */
            User user = userDAO.getUserByEmail(email);

            if (user == null) {

                return ServiceResult.failure(
                        "Invalid email or password.");

            }

            /*
             * Check Account Status
             */
            if (!AppConstants.STATUS_ACTIVE.equals(user.getStatus())) {

                return ServiceResult.failure(
                        "Your account is inactive. Please contact support.");

            }

            /*
             * Verify Password
             */
            boolean valid =
                    PasswordUtil.verifyPassword(
                            password,
                            user.getPasswordHash());

            if (!valid) {

                return ServiceResult.failure(
                        "Invalid email or password.");

            }

            /*
             * Login Successful
             */
            return ServiceResult.success(
                    "Login successful.",
                    user);

        }
        catch (Exception ex) {

            ex.printStackTrace();

            return ServiceResult.failure(
                    "Unable to login. Please try again later.");

        }

    }

}