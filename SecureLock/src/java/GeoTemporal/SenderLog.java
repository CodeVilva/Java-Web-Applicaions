/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package GeoTemporal;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;


public class SenderLog extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        PrintWriter out = response.getWriter();
        response.setContentType("text/html");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Get connection from your SQLconnection utility class
            con = SQLconnection.getconnection();

            // Check user credentials
            String sql = "SELECT * FROM data_sender WHERE email = ? AND pass = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                // ✅ Generate 5-digit OTP
                String otp = String.format("%05d", new Random().nextInt(100000));

                // ✅ Update OTP in database
                String updateOtp = "UPDATE data_sender SET otp = ? WHERE email = ?";
                ps = con.prepareStatement(updateOtp);
                ps.setString(1, otp);
                ps.setString(2, email);
                ps.executeUpdate();
                String sid =rs.getString("id");
                // ✅ Store email in session if needed
                HttpSession session = request.getSession();
                session.setAttribute("email", email);
                session.setAttribute("sid", sid);
                session.setAttribute("otp", otp); // Optional

                // ✅ Display or forward to OTP verification page
               // ✅ Send OTP to email
String subject = "OTP Verification";
String msg = "Dear user,\n\nYour login OTP is: " + otp + "\n\n";
SendMail.send(email, subject, msg);

// ✅ Redirect
out.println("<script>alert('OTP has been sent to your email.'); window.location='otp_verify.jsp';</script>");

                // Instead of alert, you can send OTP via email or SMS.
            } else {
                out.println("<script>alert('Invalid Email or Password!'); window.location='login.jsp';</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('Server Error: " + e.getMessage() + "');</script>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}
