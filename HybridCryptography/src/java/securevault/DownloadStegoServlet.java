package securevault;

import java.io.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;


public class DownloadStegoServlet extends HttpServlet {

    private static final String ROOT_DIR = "E:/SecureVault/encrypted/";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        System.out.println("\n========== SecureVault DownloadStegoServlet ==========");

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            resp.sendRedirect("user-dashboard.jsp?msg=invalidId");
            return;
        }

        int shareId = Integer.parseInt(idStr);

        try (Connection con = DBConnection.getConnection()) {

            // ✅ Step 1: Fetch stego path and recipient user
            PreparedStatement ps = con.prepareStatement(
                "SELECT stego_path, target_user_id FROM shared_files WHERE id=?");
            ps.setInt(1, shareId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                resp.sendRedirect("user-dashboard.jsp?msg=notFound");
                return;
            }

            String stegoPath = rs.getString("stego_path");
            int targetUserId = rs.getInt("target_user_id");

            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                resp.sendRedirect("user-login.jsp?msg=sessionExpired");
                return;
            }

            int currentUserId = (int) session.getAttribute("userId");
            if (currentUserId != targetUserId) {
                System.err.println("❌ Unauthorized attempt: user " + currentUserId + " tried to download another user's file.");
                resp.sendRedirect("user-dashboard.jsp?msg=unauthorized");
                return;
            }

            File stegoFile = new File(stegoPath);
            if (!stegoFile.exists() || !stegoFile.isFile()) {
                System.err.println("❌ Stego file not found at " + stegoPath);
                resp.sendRedirect("user-dashboard.jsp?msg=fileNotFound");
                return;
            }

            System.out.println("✅ Streaming stego image: " + stegoFile.getAbsolutePath());

            // ✅ Step 2: Stream to browser
            resp.setContentType("image/png");
            resp.setHeader("Content-Disposition", "attachment; filename=\"" + stegoFile.getName() + "\"");
            resp.setContentLengthLong(stegoFile.length());

            try (BufferedInputStream bis = new BufferedInputStream(new FileInputStream(stegoFile));
                 BufferedOutputStream bos = new BufferedOutputStream(resp.getOutputStream())) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = bis.read(buffer)) != -1) {
                    bos.write(buffer, 0, bytesRead);
                }
                bos.flush();
                resp.sendRedirect("stego-download-success.jsp?fileId=" + shareId);
            }

            System.out.println("✅ Stego download completed successfully for user " + currentUserId);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("user-dashboard.jsp?msg=error");
        }
    }
}
