package GeoTemporal;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ReceiverReg extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String email = request.getParameter("email");
        String pass = request.getParameter("pass");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = SQLconnection.getconnection();

            // Insert receiver (email, pass)
            String sqlInsert = "INSERT INTO receivers (email, pass, otp) VALUES (?, ?, '0')";
            stmt = conn.prepareStatement(sqlInsert, PreparedStatement.RETURN_GENERATED_KEYS);
            stmt.setString(1, email);
            stmt.setString(2, pass);
            int rows = stmt.executeUpdate();

            if (rows > 0) {
                // Get generated receiver ID (auto_increment)
                rs = stmt.getGeneratedKeys();
                int receiverId = -1;
                if (rs.next()) {
                    receiverId = rs.getInt(1);
                }

                if (receiverId != -1) {
                    // Generate ECC key pair
                    KeyPairGenerator kpg = KeyPairGenerator.getInstance("EC");
                    kpg.initialize(256);
                    KeyPair keyPair = kpg.generateKeyPair();

                    // Save public key
                    Files.write(Paths.get("E:\\receiver_keys\\receiver_" + receiverId + "_pub.key"),
                            keyPair.getPublic().getEncoded());

                    // Save private key
                    Files.write(Paths.get("E:\\receiver_keys\\receiver_" + receiverId + "_priv.key"),
                            keyPair.getPrivate().getEncoded());

                    out.println("<script>alert('Registration Successful! Keys generated.'); window.location='DataReceivers.jsp?Success';</script>");
                } else {
                    out.println("<script>alert('Registration Successful but failed to get receiver ID!'); window.location='DataReceivers.jsp?Failed';</script>");
                }
            } else {
                out.println("<script>alert('Registration Failed!'); window.location='DataReceivers.jsp?Failed';</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('Error: " + e.getMessage() + "'); window.location='DataReceivers.jsp?Failed';</script>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}
