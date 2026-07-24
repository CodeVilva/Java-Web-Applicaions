package GeoTemporal;

import java.io.*;
import java.sql.*;
import javax.crypto.*;
import javax.crypto.spec.*;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;

@MultipartConfig(maxFileSize = 1024 * 1024 * 10)
public class DownloadFile extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String passcode = getStringFromPart(request.getPart("passcode"));
            String latStr = getStringFromPart(request.getPart("latitude"));
            String lngStr = getStringFromPart(request.getPart("longitude"));

            if (passcode == null || latStr == null || lngStr == null ||
                passcode.isEmpty() || latStr.isEmpty() || lngStr.isEmpty()) {
                sendHtmlAlert(response, "Missing fields. Please rescan the QR and select your location.");
                return;
            }

            double userLat = Double.parseDouble(latStr);
            double userLng = Double.parseDouble(lngStr);

            try (Connection conn = SQLconnection.getconnection()) {
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM uploads WHERE passcode=?");
                ps.setString(1, passcode);
                ResultSet rs = ps.executeQuery();

                if (!rs.next()) {
                    sendHtmlAlert(response, "Invalid QR or passcode not found.");
                    return;
                }

                Timestamp now = new Timestamp(System.currentTimeMillis());
                Timestamp fromTime = rs.getTimestamp("from_time");
                Timestamp toTime = rs.getTimestamp("to_time");

                if (now.before(fromTime) || now.after(toTime)) {
                    deleteFileRecord(conn, passcode);
                    sendHtmlAlert(response, "Access denied: Time window expired.");
                    return;
                }

                double fileLat = Double.parseDouble(rs.getString("latitude"));
                double fileLng = Double.parseDouble(rs.getString("longitude"));
                if (distanceInKm(userLat, userLng, fileLat, fileLng) > 1.0) {
                    sendHtmlAlert(response, "Access denied: Out of location range.");
                    return;
                }

                byte[] encrypted = rs.getBytes("filedata");
                byte[] keyBytes = rs.getBytes("aes_key");
                byte[] ivBytes = rs.getBytes("iv");

                SecretKey aesKey = new SecretKeySpec(keyBytes, "AES");
                IvParameterSpec ivSpec = new IvParameterSpec(ivBytes);

                Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
                cipher.init(Cipher.DECRYPT_MODE, aesKey, ivSpec);
                byte[] decrypted = cipher.doFinal(encrypted);

                deleteFileRecord(conn, passcode);

                response.setContentType("application/octet-stream");
                response.setHeader("Content-Disposition",
                        "attachment; filename=\"" + rs.getString("filename") + "\"");

                try (OutputStream out = response.getOutputStream()) {
                    out.write(decrypted);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            sendHtmlAlert(response, "Error: " + e.getMessage());
        }
    }

    private void deleteFileRecord(Connection conn, String passcode) throws SQLException {
        PreparedStatement ps = conn.prepareStatement("DELETE FROM uploads WHERE passcode=?");
        ps.setString(1, passcode);
        ps.executeUpdate();
    }

    private double distanceInKm(double lat1, double lng1, double lat2, double lng2) {
        final int R = 6371;
        double dLat = Math.toRadians(lat2 - lat1);
        double dLng = Math.toRadians(lng2 - lng1);
        double a = Math.sin(dLat/2)*Math.sin(dLat/2)
                 + Math.cos(Math.toRadians(lat1))*Math.cos(Math.toRadians(lat2))
                 * Math.sin(dLng/2)*Math.sin(dLng/2);
        return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    }

    private String getStringFromPart(Part part) throws IOException {
        if (part == null) return null;
        try (BufferedReader r = new BufferedReader(new InputStreamReader(part.getInputStream(), "UTF-8"))) {
            StringBuilder sb = new StringBuilder(); String line;
            while ((line = r.readLine()) != null) sb.append(line);
            return sb.toString().trim();
        }
    }

    private void sendHtmlAlert(HttpServletResponse response, String msg) throws IOException {
        response.setContentType("text/html");
        try (PrintWriter out = response.getWriter()) {
            out.println("<html><body style='background:#0e2742;color:#00d4ff;font-family:Roboto;text-align:center;padding:50px;'>");
            out.println("<h2>Geo-Lock Secure Access</h2>");
            out.println("<p style='color:#ff5252;font-weight:bold;'>" + msg + "</p>");
            out.println("<a href='GeoDownload.jsp' style='color:#00d4ff;'>← Back to Download Page</a>");
            out.println("</body></html>");
        }
    }
}