package securevault;

import javax.crypto.*;
import javax.crypto.spec.SecretKeySpec;
import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.security.MessageDigest;
import java.sql.*;
import java.util.Base64;

@MultipartConfig(maxFileSize = 1024L * 1024L * 100L)
public class DecryptServlet extends HttpServlet {

    private static final String ROOT_DIR = "E:/SecureVault/encrypted/";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        System.out.println("\n========== SecureVault DecryptServlet ==========");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("user-login.jsp?msg=sessionExpired");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        File userDir = new File(ROOT_DIR + userId);
        if (!userDir.exists()) userDir.mkdirs();

        Part part = req.getPart("stegoImage");
        if (part == null || part.getSize() == 0) {
            resp.sendRedirect("decrypt-fail.jsp?reason=invalidImage");
            return;
        }

        // Save uploaded stego image temporarily
        File stegoImg = new File(userDir, "uploaded_stego_" + System.currentTimeMillis() + ".png");
        try (InputStream in = part.getInputStream(); OutputStream out = new FileOutputStream(stegoImg)) {
            in.transferTo(out);
        }
        System.out.println("STEP 1: Image saved " + stegoImg.getAbsolutePath());

        try (Connection con = DBConnection.getConnection()) {

            // Step 2️⃣ Extract Base64 encoded key and decode
            String extracted = extractTextLSB(stegoImg);
            int terminator = extracted.indexOf('\0');
            if (terminator != -1) extracted = extracted.substring(0, terminator);
            String hiddenKey = new String(Base64.getDecoder().decode(extracted), "UTF-8");
            System.out.println("✅ Extracted key: [" + hiddenKey + "]");

            // Step 3️⃣ Locate encrypted parts
            File part1 = new File(userDir, "part1_AES.enc");
            File part2 = new File(userDir, "part2_3DES.enc");
            File part3 = new File(userDir, "part3_Blowfish.enc");
            if (!part1.exists() || !part2.exists() || !part3.exists()) {
                System.err.println("❌ Encrypted parts missing.");
                resp.sendRedirect("decrypt-fail.jsp?reason=missingParts");
                return;
            }

            // Step 4️⃣ Decrypt each part
            File dec1 = new File(userDir, "dec1.bin");
            File dec2 = new File(userDir, "dec2.bin");
            File dec3 = new File(userDir, "dec3.bin");
            decryptFile("AES", hiddenKey, part1, dec1);
            decryptFile("DESede", hiddenKey, part2, dec2);
            decryptFile("Blowfish", hiddenKey, part3, dec3);

            // Step 5️⃣ Get the original filename + file_id from DB
            String origName = "decrypted_file.bin";
            int fileId = -1;
            PreparedStatement psFile = con.prepareStatement(
                "SELECT id, orig_filename FROM files WHERE user_id=? ORDER BY id DESC LIMIT 1"
            );
            psFile.setInt(1, userId);
            ResultSet rs = psFile.executeQuery();
            if (rs.next()) {
                fileId = rs.getInt("id");
                origName = rs.getString("orig_filename");
            }
            rs.close();
            psFile.close();

            // Step 6️⃣ Merge parts into one file
            File finalFile = new File(userDir, "decrypted_" + System.currentTimeMillis() + "_" + origName);
            mergeFiles(new File[]{dec1, dec2, dec3}, finalFile);
            dec1.delete(); dec2.delete(); dec3.delete();

            // Step 7️⃣ Log self-download into same table (share_id NULL)
            try (PreparedStatement psLog = con.prepareStatement(
                "INSERT INTO download_history(user_id, file_id, share_id, file_name, size_bytes, sha256_hex, ip_address) VALUES(?,?,?,?,?,?,?)"
            )) {
                psLog.setInt(1, userId);
                psLog.setInt(2, fileId);
                psLog.setNull(3, java.sql.Types.INTEGER);
                psLog.setString(4, origName);
                psLog.setLong(5, finalFile.length());
                psLog.setString(6, computeSHA256(finalFile));
                psLog.setString(7, req.getRemoteAddr());
                psLog.executeUpdate();
                System.out.println("📜 Self-download logged successfully for user " + userId);
            } catch (Exception logEx) {
                logEx.printStackTrace();
            }

            // Step 8️⃣ Stream file to browser
            resp.setContentType("application/octet-stream");
            resp.setHeader("Content-Disposition", "attachment; filename=\"" + origName.replace(" ", "_") + "\"");
            resp.setContentLengthLong(finalFile.length());
            try (InputStream in = new FileInputStream(finalFile);
                 OutputStream out = resp.getOutputStream()) {
                in.transferTo(out);
            }

            System.out.println("✅ File decrypted and streamed: " + origName);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("decrypt-fail.jsp?reason=InvalidKey");
        } finally {
            stegoImg.delete();
        }
    }

    /* ---------- SHA256 Helper ---------- */
    private String computeSHA256(File file) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            try (InputStream is = new FileInputStream(file)) {
                byte[] buf = new byte[8192];
                int r;
                while ((r = is.read(buf)) != -1) md.update(buf, 0, r);
            }
            StringBuilder sb = new StringBuilder();
            for (byte b : md.digest()) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /* ---------- LSB Extraction ---------- */
    private String extractTextLSB(File imageFile) throws IOException {
        BufferedImage img = ImageIO.read(imageFile);
        if (img == null) throw new IOException("Bad image or format not supported");
        StringBuilder sb = new StringBuilder();
        int bitCount = 0;
        byte currentByte = 0;
        for (int y = 0; y < img.getHeight(); y++) {
            for (int x = 0; x < img.getWidth(); x++) {
                int blue = img.getRGB(x, y) & 0xff;
                int lsb = blue & 1;
                currentByte = (byte) ((currentByte << 1) | lsb);
                bitCount++;
                if (bitCount == 8) {
                    sb.append((char) currentByte);
                    bitCount = 0;
                    currentByte = 0;
                }
            }
        }
        return sb.toString();
    }

    /* ---------- Decrypt Helper ---------- */
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
            while ((r = cis.read(buf)) != -1)
                fos.write(buf, 0, r);
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
            for (File f : parts)
                try (BufferedInputStream bis = new BufferedInputStream(new FileInputStream(f))) {
                    int r;
                    while ((r = bis.read(buf)) != -1)
                        bos.write(buf, 0, r);
                }
        }
    }
}
