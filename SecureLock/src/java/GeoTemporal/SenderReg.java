package GeoTemporal;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class SenderReg extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set response content type
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String email = request.getParameter("email");
        String pass = request.getParameter("pass");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Connect to database
            conn = SQLconnection.getconnection();

            // SQL insert
            String sql = "INSERT INTO data_sender (email, pass, otp) VALUES (?, ?, '0')";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, email);
            stmt.setString(2, pass);

            int rows = stmt.executeUpdate();

            if (rows > 0) {
                // Get generated sender ID (auto_increment)
                rs = stmt.getGeneratedKeys();
                int senderId = -1;
                if (rs.next()) {
                    senderId = rs.getInt(1);
                }

                if (senderId != -1) {
                    // Generate ECC key pair
                    KeyPairGenerator kpg = KeyPairGenerator.getInstance("EC");
                    kpg.initialize(256);
                    KeyPair keyPair = kpg.generateKeyPair();

                    // Define key file paths
                    Path pubKeyPath = Paths.get("E:\\sender_keys\\sender_" + senderId + "_pub.key");
                    Path privKeyPath = Paths.get("E:\\sender_keys\\sender_" + senderId + "_priv.key");

                    // Ensure keys do not already exist before writing
                    if (!Files.exists(pubKeyPath)) {
                        Files.write(pubKeyPath, keyPair.getPublic().getEncoded());
                    }
                    if (!Files.exists(privKeyPath)) {
                        Files.write(privKeyPath, keyPair.getPrivate().getEncoded());
                    }

                    out.println("<script>alert('Registration Successful! Keys generated.'); window.location='DataSender.jsp?Success';</script>");
                } else {
                    out.println("<script>alert('Registration Successful but failed to retrieve sender ID!'); window.location='DataSender.jsp?Failed';</script>");
                }
            } else {
                out.println("<script>alert('Registration Failed!'); window.location='DataSender.jsp?Failed';</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('Error: " + e.getMessage() + "'); window.location='DataSender.jsp?Failed';</script>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}
