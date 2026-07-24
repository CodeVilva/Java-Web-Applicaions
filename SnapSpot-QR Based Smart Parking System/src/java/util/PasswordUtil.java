package util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * ============================================================
 * Password Utility
 * ============================================================
 * Provides password hashing and verification using BCrypt.
 *
 * BCrypt automatically:
 * - Generates a unique salt
 * - Hashes the password
 * - Stores the salt inside the hash
 * ============================================================
 */
public final class PasswordUtil {

    /**
     * BCrypt Work Factor
     *
     * Increase this value if stronger hashing is needed.
     */
    private static final int LOG_ROUNDS = 12;

    /**
     * Private Constructor
     */
    private PasswordUtil() {

    }

    /**
     * Hash Password
     *
     * @param plainPassword User entered password
     * @return BCrypt hashed password
     */
    public static String hashPassword(String plainPassword) {

        return BCrypt.hashpw(
                plainPassword,
                BCrypt.gensalt(LOG_ROUNDS)
        );

    }

    /**
     * Verify Password
     *
     * @param plainPassword User entered password
     * @param hashedPassword Password stored in database
     * @return true if password matches
     */
    public static boolean verifyPassword(String plainPassword,
                                         String hashedPassword) {

        if (plainPassword == null ||
                hashedPassword == null) {

            return false;

        }

        return BCrypt.checkpw(
                plainPassword,
                hashedPassword
        );

    }

}