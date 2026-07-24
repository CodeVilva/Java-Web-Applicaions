/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package GeoTemporal;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.http.*;

public class Verifyotp extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userOtp = request.getParameter("otp");
        HttpSession session = request.getSession(false);
        String email = (session != null) ? (String) session.getAttribute("email") : null;

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        if (email == null) {
            out.println("<script>alert('Session expired. Please login again.'); window.location='login.jsp';</script>");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = SQLconnection.getconnection();

            String sql = "SELECT otp FROM data_sender WHERE email = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                String dbOtp = rs.getString("otp");

                if (dbOtp.equals(userOtp)) {
                    // OTP is correct
                    out.println("<script>alert('OTP Verified Successfully!'); window.location='Dsender.jsp';</script>");
                } else {
                    // Incorrect OTP
                    out.println("<script>alert('Incorrect OTP. Please try again.'); window.location='otp_verify.jsp';</script>");
                }
            } else {
                out.println("<script>alert('User not found.'); window.location='index.jsp';</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('Server error: " + e.getMessage() + "');</script>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}
