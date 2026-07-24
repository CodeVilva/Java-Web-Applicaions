package GeoTemporal;

import java.io.*;
import java.security.*;
import java.sql.*;
import javax.crypto.*;
import javax.crypto.spec.*;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;

import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;
import javax.mail.util.ByteArrayDataSource;

import com.google.zxing.*;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.util.*;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB memory threshold
        maxFileSize = 1024 * 1024 * 2, // 2 MB max
        maxRequestSize = 1024 * 1024 * 3 // 3 MB total
)
public class Upload extends HttpServlet {

    private static final String PASSCODE_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    private static final int PASSCODE_LENGTH = 8;

    // Gmail credentials
    private static final String SENDER_EMAIL = "sakthiprojact@gmail.com";
    private static final String SENDER_PASS = "bvbe mdrx vite zxxn"; // Gmail App Password

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== [GeoTemporal.Upload] File upload request received ===");

        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {

            // ---- Retrieve parameters ----
            String[] receiverData = request.getParameter("rid").split("\\|");
            int rid = Integer.parseInt(receiverData[0]);
            String remail = receiverData[1];
            int sid = Integer.parseInt(request.getParameter("sid"));

            String semail = request.getParameter("semail");
            String fromTime = request.getParameter("fromTime");
            String toTime = request.getParameter("toTime");
            String latitude = request.getParameter("latitude");
            String longitude = request.getParameter("longitude");

            System.out.println("[INFO] Parameters => rid=" + rid + ", sid=" + sid + ", sender=" + semail + ", receiver=" + remail);
            System.out.println("[INFO] Time window: " + fromTime + " to " + toTime);
            System.out.println("[INFO] Location: lat=" + latitude + ", lon=" + longitude);

            // ---- File upload ----
            javax.servlet.http.Part filePart = request.getPart("upfile");
            String originalFileName = filePart.getSubmittedFileName();
            long fileSize = filePart.getSize();
            System.out.println("[INFO] Upload received: " + originalFileName + " (" + fileSize + " bytes)");

            if (fileSize > (2 * 1024 * 1024)) {
                System.out.println("[ERROR] File exceeds 2 MB limit.");
                out.println("<script>alert('File exceeds 2 MB limit.'); window.location='FileUpload.jsp';</script>");
                return;
            }

            byte[] fileBytes;
            try (InputStream is = filePart.getInputStream()) {
                fileBytes = is.readAllBytes();
            }
            System.out.println("[OK] File read successfully (" + fileBytes.length + " bytes)");

            // ---- AES Encryption ----
            System.out.println("[STEP] Generating AES key...");
            KeyGenerator keyGen = KeyGenerator.getInstance("AES");
            keyGen.init(128);
            SecretKey aesKey = keyGen.generateKey();
            byte[] aesKeyBytes = aesKey.getEncoded();

            byte[] ivBytes = new byte[16];
            SecureRandom random = new SecureRandom();
            random.nextBytes(ivBytes);
            IvParameterSpec ivSpec = new IvParameterSpec(ivBytes);

            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, aesKey, ivSpec);
            byte[] encryptedFile = cipher.doFinal(fileBytes);
            System.out.println("[OK] File encrypted successfully (" + encryptedFile.length + " bytes)");

            // ---- Passcode generation ----
            String passcode = generatePasscode();
            System.out.println("[STEP] Generated passcode: " + passcode);

            // ---- Database insert ----
            System.out.println("[STEP] Saving encrypted file to database...");
            try (Connection con = SQLconnection.getconnection()) {
                String sql = "INSERT INTO uploads(sid, rid, semail, filename, filedata, aes_key, iv, "
                        + "from_time, to_time, latitude, longitude, passcode, accessed) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, sid);
                ps.setInt(2, rid);
                ps.setString(3, semail);
                ps.setString(4, originalFileName);
                ps.setBytes(5, encryptedFile);
                ps.setBytes(6, aesKeyBytes);
                ps.setBytes(7, ivBytes);
                ps.setString(8, fromTime);
                ps.setString(9, toTime);
                ps.setString(10, latitude);
                ps.setString(11, longitude);
                ps.setString(12, passcode);
                ps.setString(13, "0");
                ps.executeUpdate();
                System.out.println("[OK] File record inserted into DB successfully.");
            } catch (Exception ex) {
                System.out.println("[DB ERROR] " + ex.getMessage());
                ex.printStackTrace();
                throw ex;
            }

            // ---- Generate QR ----
            System.out.println("[STEP] Generating QR image...");
            byte[] qrBytes = generateQrPng(passcode, 300, 300);
            System.out.println("[OK] QR generated (" + qrBytes.length + " bytes)");

            // ---- Send Email ----
            if (remail != null && !remail.isBlank()) {
                System.out.println("[STEP] Sending email with QR to " + remail + "...");
                sendEmailWithQr(remail, passcode, qrBytes, semail, originalFileName);
                System.out.println("[OK] Email sent successfully to " + remail);
            } else {
                System.out.println("[WARN] Receiver email not provided. Skipping mail send.");
            }

            out.println("<script>alert('File uploaded successfully (max 2 MB). QR sent.'); window.location='FileUpload.jsp';</script>");
            System.out.println("=== [GeoTemporal.Upload] Completed successfully ===");

        } catch (Exception e) {
            System.out.println("[FATAL ERROR] " + e.getMessage());
            e.printStackTrace();
            response.getWriter().println("<script>alert('Upload failed: "
                    + e.getMessage().replace("'", "\\'")
                    + "'); window.location='FileUpload.jsp';</script>");
        }
    }

    // ---- Generate random passcode ----
    private String generatePasscode() {
        SecureRandom r = new SecureRandom();
        StringBuilder sb = new StringBuilder(PASSCODE_LENGTH);
        for (int i = 0; i < PASSCODE_LENGTH; i++) {
            sb.append(PASSCODE_CHARS.charAt(r.nextInt(PASSCODE_CHARS.length())));
        }
        return sb.toString();
    }

    // ---- Generate QR image ----
    private byte[] generateQrPng(String text, int w, int h) throws Exception {
        Map<EncodeHintType, Object> hints = new HashMap<>();
        hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.M);
        hints.put(EncodeHintType.MARGIN, 1);
        BitMatrix m = new MultiFormatWriter().encode(text, BarcodeFormat.QR_CODE, w, h, hints);
        BufferedImage img = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
        for (int x = 0; x < w; x++) {
            for (int y = 0; y < h; y++) {
                img.setRGB(x, y, m.get(x, y) ? 0x000000 : 0xFFFFFF);
            }
        }
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(img, "png", baos);
        return baos.toByteArray();
    }

    // ---- Email sender with full console logs ----
    private void sendEmailWithQr(String to, String passcode, byte[] qr, String sender, String fileName) throws Exception {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        System.out.println("[MAIL] Preparing mail session...");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                System.out.println("[MAIL] Authenticating as " + SENDER_EMAIL);
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASS);
            }
        });
        session.setDebug(true); // Print all mail protocol logs

        MimeMessage msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(SENDER_EMAIL, "Secure File Server"));
        msg.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
        msg.setSubject("Secure File Access QR (Passcode Enclosed)");

        String html = "<p>Hello,</p>"
                + "<p>You received a secure upload from <b>" + sender + "</b>.</p>"
                + "<p>File: <b>" + fileName + "</b><br>Passcode: <b>" + passcode + "</b></p>"
                + "<p>Scan the attached QR to verify and access your file.</p>";

        MimeBodyPart htmlPart = new MimeBodyPart();
        htmlPart.setContent(html, "text/html; charset=utf-8");

        MimeBodyPart qrPart = new MimeBodyPart();
        qrPart.setDataHandler(new DataHandler(new ByteArrayDataSource(qr, "image/png")));
        qrPart.setFileName("passcode-qr.png");

        Multipart mp = new MimeMultipart();
        mp.addBodyPart(htmlPart);
        mp.addBodyPart(qrPart);
        msg.setContent(mp);

        System.out.println("[MAIL] Sending message to " + to + " ...");
        Transport.send(msg);
        System.out.println("[MAIL] Message successfully sent to " + to);
    }
}
