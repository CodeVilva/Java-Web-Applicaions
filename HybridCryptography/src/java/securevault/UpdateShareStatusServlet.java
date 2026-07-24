package securevault;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;


public class UpdateShareStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");
        String status = req.getParameter("status");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("user-login.jsp?msg=sessionExpired");
            return;
        }

        if (idStr == null || status == null) {
            resp.sendRedirect("user-dashboard.jsp?msg=invalid");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "UPDATE shared_files SET status=?, action_at=NOW() WHERE id=?");
            ps.setString(1, status);
            ps.setInt(2, Integer.parseInt(idStr));
            ps.executeUpdate();

            System.out.println("✅ Shared file ID " + idStr + " marked as " + status);
            resp.sendRedirect("user-dashboard.jsp?msg=" + status.toLowerCase());
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("user-dashboard.jsp?msg=error");
        }
    }
}
