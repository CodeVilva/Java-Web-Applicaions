package util;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;

public class QRCodeUtil {

    private static final int WIDTH = 300;
    private static final int HEIGHT = 300;

    public static String generateQRCode(
            int bookingId,
            String qrData)
            throws Exception {

        String fileName =
                "BOOKING_" + bookingId + ".png";

        String folder =
                "qr_codes/";

        File dir = new File(folder);

        if (!dir.exists()) {

            dir.mkdirs();

        }

        Path path =
                Paths.get(folder, fileName);

        BitMatrix matrix =
                new MultiFormatWriter()
                        .encode(
                                qrData,
                                BarcodeFormat.QR_CODE,
                                WIDTH,
                                HEIGHT);

        MatrixToImageWriter.writeToPath(
                matrix,
                "PNG",
                path);

        return "qr_codes/" + fileName;

    }

}