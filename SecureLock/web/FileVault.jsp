<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Secure Lock | Secure File Download</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta content="QR Secure File System" name="keywords" />
    <meta content="Secure file download with QR and location validation" name="description" />

    <!-- Favicon -->
    <link href="img/favicon.ico" rel="icon" />

    <!-- Bootstrap + Fonts -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- QR + Map -->
    <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>
    <link rel="stylesheet" href="map/leaflet.css" />
    <script src="map/leaflet.js" defer></script>

    <!-- Custom Theme -->
    <link href="css/style.css" rel="stylesheet">

    <style>
        #map {
            height: 300px;
            width: 100%;
            margin-bottom: 15px;
        }

        /* --- QR Scanner Styling --- */
        #qr-reader {
            width: 320px;
            height: 320px;
            margin: 0 auto;
            border: 3px solid var(--secondary);
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.3);
            overflow: hidden;
        }

        #qr-reader__dashboard_section_csr button {
            background-color: var(--secondary) !important;
            color: white !important;
            font-weight: bold;
            border-radius: 5px;
        }

        #qr-reader video {
            object-fit: cover;
            width: 100% !important;
            height: 100% !important;
            transform: none !important;
        }

        @media (min-width: 768px) {
            #qr-reader {
                width: 400px;
                height: 400px;
            }
        }

   
    </style>
</head>

<body>

<!-- Navbar -->
<div class="navbar-sticky-wrap">
    <nav class="navbar navbar-expand-lg">
        <div class="nav-shell">
            <a href="index.jsp" class="brand">
                <span class="brand-icon"><i class="fa fa-lock"></i></span>
                Secure Lock
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarCollapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a href="index.jsp" class="nav-link">Home</a></li>
                    <li class="nav-item"><a href="DataSender.jsp" class="nav-link">Data Sender</a></li>
                    <li class="nav-item"><a href="DataReceivers.jsp" class="nav-link">Data Receivers</a></li>
                    <li class="nav-item"><a href="FileVault.jsp" class="nav-link active">File Vault</a></li>
                </ul>
            </div>
        </div>
    </nav>
</div>

<!-- Hero -->
<section class="hero">
    <div class="hero-icon"><i class="fa fa-qrcode"></i></div>
    <h1 class="display-5 fw-bold">Secure File Download with QR Verification</h1>
    <p class="lead">Scan your authorized QR, verify your location, and securely access your encrypted file.</p>
</section>

<!-- Download Card -->
<div class="section">
    <div class="panel-narrow card p-4">
        <h3 class="text-center mb-4" style="color:var(--primary-dark);"><i class="fa fa-qrcode me-2"></i>Scan QR to Download</h3>

        <div class="text-center mb-4">
            <div id="qr-reader"></div>
        </div>

        <form id="downloadForm" class="text-center" method="post" enctype="multipart/form-data">
            <div class="mb-3">
                <label>Passcode (auto-filled):</label>
                <input type="text" id="passcode" name="passcode" class="form-control text-center" readonly required>
            </div>

            <label>Select / Auto Detect Location:</label>
            <div id="map" class="mb-3"></div>
            <input type="hidden" id="latitude" name="latitude">
            <input type="hidden" id="longitude" name="longitude">

            <button type="button" class="btn btn-primary px-4" id="downloadBtn">
                <i class="fa fa-download me-2"></i>Download File
            </button>
        </form>
    </div>
</div>

<!-- Footer -->
<div class="footer-bar">
    <p class="mb-0">© 2025 Secure-Lock Secure File System</p>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
document.addEventListener("DOMContentLoaded", function () {
    // ===== Leaflet Map =====
    const map = L.map('map').setView([11.0168, 76.9558], 10);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap contributors'
    }).addTo(map);

    let marker = null;
    map.on('click', e => {
        document.getElementById('latitude').value = e.latlng.lat;
        document.getElementById('longitude').value = e.latlng.lng;
        if (marker) marker.setLatLng(e.latlng);
        else marker = L.marker(e.latlng).addTo(map);
    });

    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(pos => {
            let lat = pos.coords.latitude, lng = pos.coords.longitude;
            document.getElementById('latitude').value = lat;
            document.getElementById('longitude').value = lng;
            map.setView([lat, lng], 15);
            marker = L.marker([lat, lng]).addTo(map);
        });
    }

    // ===== QR Scanner =====
    const qrScanner = new Html5Qrcode("qr-reader");
    const config = { fps: 10, qrbox: { width: 250, height: 250 }, aspectRatio: 1.0, disableFlip: true };

    Html5Qrcode.getCameras().then(devices => {
        if (devices && devices.length) {
            let cameraId = devices[0].id;
            qrScanner.start(
                { facingMode: "environment" },
                config,
                decodedText => {
                    document.getElementById("passcode").value = decodedText;
                    alert("QR Scanned: " + decodedText);
                    qrScanner.stop().then(() => console.log("[QR] Scanner stopped after successful scan."));
                },
                errorMessage => {
                    // Minimal console noise
                    console.log("[QR] Scanning...");
                }
            ).catch(err => console.error("[QR] Start error:", err));
        } else {
            alert("No camera found. Please allow camera access.");
        }
    }).catch(err => console.error("[QR] Device error:", err));

    // ===== File Download Action =====
    document.getElementById("downloadBtn").addEventListener("click", function () {
        const passcode = document.getElementById("passcode").value.trim();
        const lat = document.getElementById("latitude").value;
        const lng = document.getElementById("longitude").value;

        if (!passcode) { alert("Scan QR first!"); return; }
        if (!lat || !lng) { alert("Please select your location!"); return; }

        const formData = new FormData();
        formData.append("passcode", passcode);
        formData.append("latitude", lat);
        formData.append("longitude", lng);

        fetch("DownloadFile", { method: "POST", body: formData })
            .then(resp => {
                if (!resp.ok) throw new Error("Download failed");
                const cd = resp.headers.get("Content-Disposition");
                let fname = "downloaded_file";
                if (cd && cd.indexOf("filename=") !== -1)
                    fname = cd.split("filename=")[1].replace(/"/g, "");
                return resp.blob().then(b => ({ b, fname }));
            })
            .then(({ b, fname }) => {
                const url = URL.createObjectURL(b);
                const a = document.createElement("a");
                a.href = url;
                a.download = fname;
                document.body.appendChild(a);
                a.click();
                a.remove();
                URL.revokeObjectURL(url);
                console.log("[DOWNLOAD] File downloaded successfully:", fname);
            })
            .catch(err => alert("Error: " + err.message));
    });
});
</script>

</body>
</html>
