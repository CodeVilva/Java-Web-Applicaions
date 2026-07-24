package securevault;

import javax.crypto.*;
import javax.crypto.spec.SecretKeySpec;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.*;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Base64;


@MultipartConfig(maxFileSize = 1024L * 1024L * 100L) // 100 MB
public class UploadEncryptServlet extends HttpServlet {

    private static final String ROOT_DIR = "E:/SecureVault/encrypted/";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("user-login.jsp?msg=sessionExpired");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        File userDir = new File(ROOT_DIR + userId);
        if (!userDir.exists()) userDir.mkdirs();

        Part dataPart = req.getPart("dataFile");
        Part imgPart  = req.getPart("coverImage");
        String keyText = req.getParameter("secretKey");

        if (dataPart == null || imgPart == null || keyText == null || keyText.isEmpty()) {
            resp.sendRedirect("user-upload.jsp?msg=missingData");
            return;
        }

        // Save uploaded data file
        File dataFile = new File(userDir, dataPart.getSubmittedFileName());
        try (InputStream in = dataPart.getInputStream();
             OutputStream out = new FileOutputStream(dataFile)) {
            in.transferTo(out);
        }

        // Split file into 3 parts
        File[] parts = splitFile(dataFile, 3);

        // Encrypt each part
        File enc1 = new File(userDir, "part1_AES.enc");
        File enc2 = new File(userDir, "part2_3DES.enc");
        File enc3 = new File(userDir, "part3_Blowfish.enc");

       try {
    encryptFile("AES", keyText, parts[0], enc1);
    encryptFile("DESede", keyText, parts[1], enc2);
    encryptFile("Blowfish", keyText, parts[2], enc3);
} catch (Exception e) {
    e.printStackTrace();
    resp.sendRedirect("user-upload.jsp?msg=encryptionFailed");
    return;
}


        // Hide encoded key inside image (PNG only)
        BufferedImage img = ImageIO.read(imgPart.getInputStream());
        String encodedKey = Base64.getEncoder().encodeToString(keyText.getBytes("UTF-8"));
        BufferedImage stego = hideTextLSB(img, encodedKey + "\0"); // \0 as terminator
        File stegoFile = new File(userDir, "stego_" + System.currentTimeMillis() + ".png");
        ImageIO.write(stego, "png", stegoFile);
        System.out.println("✅ Stego image created: " + stegoFile.getAbsolutePath());

        // Compute SHA-256 hash of original file
        String hash = computeSHA256(dataFile);
        System.out.println("✅ SHA-256: " + hash);

        // Insert record into database
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO files(user_id, orig_filename, size_bytes, sha256_hex, status) VALUES(?,?,?,?,?)");
            ps.setInt(1, userId);
            ps.setString(2, dataFile.getName());
            ps.setLong(3, dataFile.length());
            ps.setString(4, hash);
            ps.setString(5, "ENCRYPTED");
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Clean up split parts
        for (File f : parts) if (f.exists()) f.delete();

        resp.sendRedirect("user-upload.jsp?msg=success");
    }

    /* ---------- Helpers ---------- */

    private File[] splitFile(File input, int parts) throws IOException {
        File[] files = new File[parts];
        long len = input.length(), partSize = len / parts;
        try (BufferedInputStream bis = new BufferedInputStream(new FileInputStream(input))) {
            for (int i = 0; i < parts; i++) {
                files[i] = new File(input.getParent(), "split_" + (i + 1) + ".bin");
                try (BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(files[i]))) {
                    long bytesToWrite = (i == parts - 1) ? len - partSize * i : partSize;
                    byte[] buf = new byte[8192];
                    while (bytesToWrite > 0) {
                        int r = bis.read(buf, 0, (int)Math.min(buf.length, bytesToWrite));
                        if (r == -1) break;
                        bos.write(buf, 0, r);
                        bytesToWrite -= r;
                    }
                }
            }
        }
        return files;
    }

    private void encryptFile(String algo, String keyText, File in, File out) throws Exception {
        byte[] keyBytes = keyText.getBytes("UTF-8");
        SecretKeySpec key;
        switch (algo) {
            case "AES": key = new SecretKeySpec(normalizeKey(keyBytes,16), "AES"); break;
            case "DESede": key = new SecretKeySpec(normalizeKey(keyBytes,24), "DESede"); break;
            default: key = new SecretKeySpec(normalizeKey(keyBytes,16), "Blowfish");
        }
        Cipher cipher = Cipher.getInstance(algo + "/ECB/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, key);
        try (FileInputStream fis = new FileInputStream(in);
             CipherOutputStream cos = new CipherOutputStream(new FileOutputStream(out), cipher)) {
            fis.transferTo(cos);
        }
    }

    private byte[] normalizeKey(byte[] src, int len) {
        byte[] key = new byte[len];
        for (int i = 0; i < len; i++) key[i] = src[i % src.length];
        return key;
    }

    private String computeSHA256(File file) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            try (InputStream is = new FileInputStream(file)) {
                byte[] buf = new byte[8192];
                int r;
                while ((r = is.read(buf)) != -1)
                    md.update(buf, 0, r);
            }
            StringBuilder sb = new StringBuilder();
            for (byte b : md.digest())
                sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    private BufferedImage hideTextLSB(BufferedImage src, String text) {
        byte[] data = text.getBytes();
        int w = src.getWidth(), h = src.getHeight();
        BufferedImage img = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);
        int bitPos = 7, bytePos = 0;
        for (int y = 0; y < h; y++)
            for (int x = 0; x < w; x++) {
                int rgb = src.getRGB(x, y);
                int r = (rgb >> 16) & 0xff, g = (rgb >> 8) & 0xff, b = rgb & 0xff;
                if (bytePos < data.length) {
                    int bit = (data[bytePos] >> bitPos) & 1;
                    b = (b & 0xFE) | bit;
                    bitPos--; if (bitPos < 0) { bitPos = 7; bytePos++; }
                }
                img.setRGB(x, y, (0xFF << 24) | (r << 16) | (g << 8) | b);
            }
        return img;
    }
}
