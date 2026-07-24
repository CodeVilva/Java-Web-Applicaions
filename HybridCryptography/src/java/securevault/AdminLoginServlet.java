package securevault;

import java.io.IOException;
import java.security.MessageDigest;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class AdminLoginServlet extends HttpServlet {

    // Default admin credentials
    private static final String DEFAULT_EMAIL = "admin@vault.com";
    private static final String DEFAULT_PASSWORD = "admin123"; // change if needed

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null || email.isEmpty() || password.isEmpty()) {
            response.sendRedirect("admin-login.jsp?msg=failed");
            return;
        }

        // Simple login check — case insensitive for email
        if (email.equalsIgnoreCase(DEFAULT_EMAIL) && password.equals(DEFAULT_PASSWORD)) {
            HttpSession session = request.getSession();
            session.setAttribute("adminId", 1);
            session.setAttribute("adminName", "Default Admin");
            session.setAttribute("adminEmail", DEFAULT_EMAIL);
            response.sendRedirect("admin-dashboard.jsp?msg=welcome");
        } else {
            response.sendRedirect("admin-login.jsp?msg=failed");
        }
    }

    // Optional SHA256 utility (for future secure login upgrades)
    private String sha256(String text) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = md.digest(text.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            return "";
        }
    }
}
