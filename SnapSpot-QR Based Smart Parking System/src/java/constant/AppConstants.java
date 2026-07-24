package constant;

/**
 * SNAPSPOT Application Constants
 *
 * This class contains all reusable constants used
 * throughout the application.
 */
public final class AppConstants {

    private AppConstants() {
        // Prevent instantiation
    }

    /* =====================================================
     * Application Information
     * ===================================================== */

    public static final String APP_NAME = "SNAPSPOT";
    public static final String APP_VERSION = "1.0";

    /* =====================================================
     * User Status
     * ===================================================== */

    public static final String STATUS_ACTIVE = "ACTIVE";
    public static final String STATUS_BLOCKED = "BLOCKED";
    public static final String STATUS_INACTIVE = "INACTIVE";

    /* =====================================================
     * Booking Status
     * ===================================================== */

    public static final String BOOKING_PENDING = "PENDING";
    public static final String BOOKING_CONFIRMED = "CONFIRMED";
    public static final String BOOKING_ACTIVE = "ACTIVE";
    public static final String BOOKING_CANCELLED = "CANCELLED";
    public static final String BOOKING_COMPLETED = "COMPLETED";

    /* =====================================================
     * Parking Slot Status
     * ===================================================== */

    public static final String SLOT_AVAILABLE = "AVAILABLE";
    public static final String SLOT_RESERVED = "RESERVED";
    public static final String SLOT_OCCUPIED = "OCCUPIED";
    public static final String SLOT_DISABLED = "DISABLED";

    /* =====================================================
     * Payment Status
     * ===================================================== */

    public static final String PAYMENT_PENDING = "PENDING";
    public static final String PAYMENT_SUCCESS = "SUCCESS";
    public static final String PAYMENT_FAILED = "FAILED";

    /* =====================================================
     * QR Ticket Status
     * ===================================================== */

    public static final String QR_ACTIVE = "ACTIVE";
    public static final String QR_USED = "USED";
    public static final String QR_EXPIRED = "EXPIRED";

    /* =====================================================
     * Session Keys
     * ===================================================== */

    public static final String SESSION_USER = "loggedInUser";

    public static final String SESSION_ADMIN = "loggedInAdmin";

    public static final String SESSION_CHECKER = "loggedInChecker";

    /* =====================================================
     * Default Configuration
     * ===================================================== */

    public static final int SESSION_TIMEOUT = 30 * 60; // 30 Minutes
    
    public static final String SESSION_TICKET_CHECKER = "loggedInTicketChecker";
    
    public static final int ENTRY_WINDOW_MINUTES = 30;
}