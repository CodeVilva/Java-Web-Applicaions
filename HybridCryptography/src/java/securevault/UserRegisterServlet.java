package securevault;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UserRegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        try (PrintWriter out = response.getWriter()) {
            Connection con = DBConnection.getConnection();

            // generate 16-byte random salt
            SecureRandom sr = new SecureRandom();
            byte[] salt = new byte[16];
            sr.nextBytes(salt);

            // hash password + salt
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] hashed = md.digest(password.getBytes("UTF-8"));
            String hashedHex = bytesToHex(hashed);
            String saltHex = bytesToHex(salt);

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO users(name,email,phone,password_hash,salt) VALUES(?,?,?,?,UNHEX(?))"
            );
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, hashedHex);
            ps.setString(5, saltHex);

            int x = ps.executeUpdate();
            if (x > 0) {
                response.sendRedirect("user-login.jsp?msg=registered");
            } else {
                out.println("<script>alert('Registration failed!');window.location='user-register.jsp';</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("user-register.jsp?msg=error");
        }
    }

    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) sb.append(String.format("%02x", b));
        return sb.toString();
    }
}
