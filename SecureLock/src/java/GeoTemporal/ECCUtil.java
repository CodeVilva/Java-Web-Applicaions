/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package GeoTemporal;

/**
 *
 * @author NARESH
 */
import java.security.*;
import javax.crypto.KeyAgreement;

public class ECCUtil {
    public static KeyPair generateECCKeyPair() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("EC");
        kpg.initialize(256);
        return kpg.generateKeyPair();
    }

    public static byte[] deriveSharedSecret(PrivateKey privKey, PublicKey pubKey) throws Exception {
        KeyAgreement ka = KeyAgreement.getInstance("ECDH");
        ka.init(privKey);
        ka.doPhase(pubKey, true);
        return ka.generateSecret();
    }
}

