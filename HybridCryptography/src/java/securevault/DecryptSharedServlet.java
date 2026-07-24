package securevault;

import com.oreilly.servlet.MultipartRequest;
import javax.crypto.*;
import javax.crypto.spec.SecretKeySpec;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.io.*;
import java.security.MessageDigest;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.util.Base64;


public class DecryptSharedServlet extends HttpServlet {

    private static final String ROOT_DIR = "E:/SecureVault/encrypted/";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        System.out.println("\n========== SecureVault DecryptSharedServlet ==========");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("user-login.jsp?msg=sessionExpired");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        // temp dir for output
        File userDir = new File(ROOT_DIR + userId + "/temp");
        if (!userDir.exists()) userDir.mkdirs();

        MultipartRequest m = new MultipartRequest(req, userDir.getAbsolutePath(), 50 * 1024 * 1024);
        String fileIdStr = m.getParameter("fileId");
        File stegoImg = m.getFile("stegoImage");

        if (fileIdStr == null || stegoImg == null || !stegoImg.exists()) {
            resp.sendRedirect("user-dashboard.jsp?msg=invalidUpload");
            return;
        }

        int shareId = Integer.parseInt(fileIdStr);

        try (Connection con = DBConnection.getConnection()) {

            // Step 1️⃣ Fetch share info
            PreparedStatement ps = con.prepareStatement(
                "SELECT sf.file_id, sf.owner_id, f.orig_filename " +
                "FROM shared_files sf JOIN files f ON sf.file_id=f.id WHERE sf.id=?");
            ps.setInt(1, shareId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                resp.sendRedirect("user-dashboard.jsp?msg=notFound");
                return;
            }

            int ownerId = rs.getInt("owner_id");
            String origFilename = rs.getString("orig_filename");
            System.out.println("📂 Owner ID: " + ownerId + " | File: " + origFilename);

            // Step 2️⃣ Extract hidden Base64 key
            String extracted = extractTextLSB(stegoImg);
            if (extracted == null || extracted.trim().isEmpty()) {
                System.err.println("❌ No data extracted from stego image.");
                resp.sendRedirect("user-dashboard.jsp?msg=invalidStego");
                return;
            }

            // cut at terminator '\0' and decode Base64
            int t = extracted.indexOf('\0');
            if (t != -1) extracted = extracted.substring(0, t);
            String hiddenKey = new String(Base64.getDecoder().decode(extracted), "UTF-8").trim();

            System.out.println("🔑 Extracted key: [" + hiddenKey + "] len=" + hiddenKey.length());

            // Step 3️⃣ Locate sender's encrypted files
            File senderDir = new File(ROOT_DIR + ownerId);
            File part1 = new File(senderDir, "part1_AES.enc");
            File part2 = new File(senderDir, "part2_3DES.enc");
            File part3 = new File(senderDir, "part3_Blowfish.enc");

            if (!part1.exists() || !part2.exists() || !part3.exists()) {
                System.err.println("❌ Missing encrypted parts in sender directory!");
                resp.sendRedirect("user-dashboard.jsp?msg=missingParts");
                return;
            }

            // Step 4️⃣ Decrypt each part
            File dec1 = new File(userDir, "dec1.bin");
            File dec2 = new File(userDir, "dec2.bin");
            File dec3 = new File(userDir, "dec3.bin");

            decryptFile("AES", hiddenKey, part1, dec1);
            decryptFile("DESede", hiddenKey, part2, dec2);
            decryptFile("Blowfish", hiddenKey, part3, dec3);

            // Step 5️⃣ Merge into one file
            File finalFile = new File(userDir, "decrypted_" + origFilename);
            mergeFiles(new File[]{dec1, dec2, dec3}, finalFile);

            if (!finalFile.exists() || finalFile.length() == 0) {
                resp.sendRedirect("user-dashboard.jsp?msg=decryptFailed");
                return;
            }
            // Step 5️⃣.5 Log download in history
try (PreparedStatement psLog = con.prepareStatement(
    "INSERT INTO download_history(user_id, file_id, share_id, file_name, size_bytes, sha256_hex, ip_address) VALUES(?,?,?,?,?,?,?)"
)) {
    psLog.setInt(1, userId);
    psLog.setInt(2, rs.getInt("file_id"));
    psLog.setInt(3, shareId);
    psLog.setString(4, origFilename);
    psLog.setLong(5, finalFile.length());
    psLog.setString(6, computeSHA256(finalFile)); // helper below
    psLog.setString(7, req.getRemoteAddr());
    psLog.executeUpdate();
    System.out.println("📜 Download logged for user " + userId + " (" + req.getRemoteAddr() + ")");
} catch (Exception logEx) {
    logEx.printStackTrace();
}

            // Step 6️⃣ Stream to browser
            resp.setContentType("application/octet-stream");
            resp.setHeader("Content-Disposition", "attachment; filename=\"" + finalFile.getName().replace(" ", "_") + "\"");
            resp.setContentLengthLong(finalFile.length());

            try (BufferedInputStream bis = new BufferedInputStream(new FileInputStream(finalFile));
                 BufferedOutputStream bos = new BufferedOutputStream(resp.getOutputStream())) {
                byte[] buf = new byte[8192];
                int r;
                while ((r = bis.read(buf)) != -1) bos.write(buf, 0, r);
                bos.flush();
            }

            System.out.println("✅ File decrypted successfully for user " + userId);

            // cleanup
            dec1.delete(); dec2.delete(); dec3.delete(); finalFile.delete();

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("user-dashboard.jsp?msg=error");
        }
    }

    /* ---------- Helper Functions ---------- */
private String computeSHA256(File file) {
    try {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        try (InputStream is = new FileInputStream(file)) {
            byte[] buf = new byte[8192];
            int r;
            while ((r = is.read(buf)) != -1) {
                md.update(buf, 0, r);
            }
        }
        StringBuilder sb = new StringBuilder();
        for (byte b : md.digest()) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    } catch (Exception e) {
        e.printStackTrace();
        return null;
    }
}

    private String extractTextLSB(File imageFile) throws IOException {
        BufferedImage img;
        try (InputStream in = new BufferedInputStream(new FileInputStream(imageFile))) {
            img = ImageIO.read(in);
        }
        if (img == null) throw new IOException("Unsupported or corrupted image format");

        StringBuilder sb = new StringBuilder();
        int bitCount = 0;
        byte currentByte = 0;
        for (int y = 0; y < img.getHeight(); y++) {
            for (int x = 0; x < img.getWidth(); x++) {
                int rgb = img.getRGB(x, y);
                int blue = rgb & 0xff;
                int lsb = blue & 1;
                currentByte = (byte) ((currentByte << 1) | lsb);
                bitCount++;
                if (bitCount == 8) {
                    sb.append((char) (currentByte & 0xFF));
                    bitCount = 0;
                    currentByte = 0;
                }
            }
        }
        return sb.toString();
    }

    private void decryptFile(String algo, String keyText, File in, File out) throws Exception {
        byte[] keyBytes = keyText.getBytes("UTF-8");
        SecretKeySpec key;
        switch (algo) {
            case "AES": key = new SecretKeySpec(normalizeKey(keyBytes, 16), "AES"); break;
            case "DESede": key = new SecretKeySpec(normalizeKey(keyBytes, 24), "DESede"); break;
            default: key = new SecretKeySpec(normalizeKey(keyBytes, 16), "Blowfish");
        }

        Cipher cipher = Cipher.getInstance(algo + "/ECB/PKCS5Padding");
        cipher.init(Cipher.DECRYPT_MODE, key);

        try (CipherInputStream cis = new CipherInputStream(new FileInputStream(in), cipher);
             FileOutputStream fos = new FileOutputStream(out)) {
            byte[] buf = new byte[8192];
            int r;
            while ((r = cis.read(buf)) != -1) fos.write(buf, 0, r);
        }
    }

    private byte[] normalizeKey(byte[] src, int len) {
        byte[] key = new byte[len];
        for (int i = 0; i < len; i++) key[i] = src[i % src.length];
        return key;
    }

    private void mergeFiles(File[] parts, File output) throws IOException {
        try (BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(output))) {
            byte[] buf = new byte[8192];
            for (File f : parts) {
                try (BufferedInputStream bis = new BufferedInputStream(new FileInputStream(f))) {
                    int r;
                    while ((r = bis.read(buf)) != -1) bos.write(buf, 0, r);
                }
            }
        }
    }
}
