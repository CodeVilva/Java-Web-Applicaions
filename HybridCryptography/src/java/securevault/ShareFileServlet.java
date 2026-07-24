package securevault;

import java.io.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;


public class ShareFileServlet extends HttpServlet {

    private static final String ROOT_DIR = "E:/SecureVault/encrypted/";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("user-login.jsp?msg=sessionExpired");
            return;
        }

        int ownerId = (int) session.getAttribute("userId");
        String fileIdStr = req.getParameter("fileId");
        String targetUserIdStr = req.getParameter("targetUserId");

        if (fileIdStr == null || targetUserIdStr == null) {
            resp.sendRedirect("user-sharefiles.jsp?msg=invalidInput");
            return;
        }

        int fileId = Integer.parseInt(fileIdStr);
        int targetUserId = Integer.parseInt(targetUserIdStr);

        try (Connection con = DBConnection.getConnection()) {

            // ✅ Step 1: Locate the latest stego image from sender's folder
            File senderDir = new File(ROOT_DIR + ownerId);
            File[] stegoFiles = senderDir.listFiles((dir, name) -> name.startsWith("stego_") && name.endsWith(".png"));

            if (stegoFiles == null || stegoFiles.length == 0) {
                System.err.println("❌ No stego image found for user " + ownerId);
                resp.sendRedirect("user-sharefiles.jsp?msg=noStego");
                return;
            }

            // find the newest one
            File latestStego = stegoFiles[0];
            for (File f : stegoFiles) {
                if (f.lastModified() > latestStego.lastModified()) {
                    latestStego = f;
                }
            }

            // ✅ Step 2: Create recipient subfolder
            File recipientDir = new File(ROOT_DIR + targetUserId + "/shared_from_" + ownerId);
            if (!recipientDir.exists()) {
                recipientDir.mkdirs();
                System.out.println("📁 Created new folder: " + recipientDir.getAbsolutePath());
            }

            // ✅ Step 3: Copy stego image into recipient’s shared folder
            String newStegoFileName = "stego_shared_" + System.currentTimeMillis() + ".png";
            File recipientStego = new File(recipientDir, newStegoFileName);

            try (InputStream in = new FileInputStream(latestStego);
                 OutputStream out = new FileOutputStream(recipientStego)) {
                byte[] buf = new byte[8192];
                int r;
                while ((r = in.read(buf)) != -1)
                    out.write(buf, 0, r);
            }

            System.out.println("✅ Copied stego image to: " + recipientStego.getAbsolutePath());

            // ✅ Step 4: Insert into shared_files table
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO shared_files(file_id, stego_path, owner_id, target_user_id, shared_at, status) " +
                "VALUES(?,?,?,?,NOW(),'PENDING')");
            ps.setInt(1, fileId);
            ps.setString(2, recipientStego.getAbsolutePath());
            ps.setInt(3, ownerId);
            ps.setInt(4, targetUserId);
            ps.executeUpdate();

            System.out.println("✅ File shared from user " + ownerId + " to user " + targetUserId);
            resp.sendRedirect("user-sharefiles.jsp?msg=success");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("user-sharefiles.jsp?msg=error");
        }
    }
}
