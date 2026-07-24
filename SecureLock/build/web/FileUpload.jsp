<%@page import="GeoTemporal.SQLconnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>Secure File Locking System using QR and Location Validation</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="Free HTML Templates" name="keywords">
        <meta content="Free HTML Templates" name="description">

        <!-- Favicon -->
        <link href="img/favicon.ico" rel="icon">

        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=Roboto+Condensed:wght@400;700&family=Roboto:wght@400;700&display=swap" rel="stylesheet">  

        <!-- Icon Font Stylesheet -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
        <!-- Libraries Stylesheet -->
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
        <!-- Customized Bootstrap Stylesheet -->
        <link href="css/bootstrap.min.css" rel="stylesheet">

        <!-- Template Stylesheet -->
        <link href="css/style.css" rel="stylesheet">
    </head>
    <link rel="stylesheet" href="map/leaflet.css"/>
    <script src="map/leaflet.js"></script>

    <style>
        #map {
            height: 300px;
            border-radius: 12px;
            border: 1px solid #ccc;
        }
    </style>
    
<%
                    if (request.getParameter("Success") != null) {%>
        <script>alert('File Uploaded To The Cloud');</script>  
        <%}
        %>

    <body >
        <!-- Navbar Start -->
        <div class="navbar-sticky-wrap">
            <nav class="navbar navbar-expand-lg">
                <div class="nav-shell">
                    <a href="Dsender.jsp" class="brand">
                        <span class="brand-icon"><i class="fa fa-lock"></i></span>
                        Secure Lock
                    </a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarCollapse">
                        <div class="navbar-nav ms-auto">
                            <a href="Dsender.jsp" class="nav-item nav-link">Home</a>
                            <a href="FileUpload.jsp" class="nav-item nav-link active">File Upload</a>
                            <a href="Fstatus.jsp" class="nav-item nav-link">Status</a>
                            <a href="logout.jsp" class="nav-item nav-link">Logout</a>
                        </div>
                    </div>
                </div>
            </nav>
        </div>
        <!-- Navbar End -->
<%

String sid=session.getAttribute("sid").toString();
String email=session.getAttribute("email").toString();
%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = SQLconnection.getconnection(); // Your DB connection class
        String query = "SELECT id, email FROM receivers";
        ps = con.prepareStatement(query);
        rs = ps.executeQuery();
%>

        <!-- Hero Start -->
        <div class="hero">
            <div class="hero-icon"><i class="fa fa-cloud-upload-alt"></i></div>
            <h1 class="display-4">Upload File with Location &amp; Time</h1>
            <p class="lead">Choose a receiver, attach your file, then lock it to a time window and a map location.</p>
        </div>
 <!-- Hero End -->
        <div class="section">
    <div class="panel-narrow card">

            <form method="post" action="Upload" enctype="multipart/form-data">
                <div class="mb-3">
                    <label class="form-label">Select Receiver</label>
                    <select class="form-control" name="rid" required>
    <option value="">-- Select Receiver --</option>
    <%
        while (rs.next()) {
            int id = rs.getInt("id");
            String email1 = rs.getString("email");
    %>
      <option value="<%=id%>|<%=email1%>"><%=email1%></option> 
    <%
        }
    %>
</select>
<%
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }
%>


                </div>
                <div class="mb-3">
                    <label for="upfile" class="form-label">Choose File</label>
                    <input type="file" class="form-control" name="upfile" required>
                </div>

                <div class="mb-3">
                    <label for="fromTime" class="form-label">From Time</label>
                    <input type="datetime-local" class="form-control" name="fromTime" required>
                </div>

                <div class="mb-3">
                    <label for="toTime" class="form-label">To Time</label>
                    <input type="datetime-local" class="form-control" name="toTime" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Click on the map to select location:</label>
                    <div id="map"></div>
                    <small class="form-text text-muted">Your selected location will be saved automatically.</small>
                </div>

                <!-- Hidden inputs for lat/lng -->
                <input type="hidden" id="latitude" name="latitude" required>
                <input type="hidden" id="longitude" name="longitude" required>
                <input type="hidden" value="<%=sid%>" name="sid" required>
                <input type="hidden" value="<%=email%>" name="semail" required>
               

                <div class="mb-3">
                    <button class="btn btn-primary w-100" type="submit">Upload</button>
                </div>
            </form>
    </div>
</div>

<!-- Leaflet map script -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const map = L.map('map').setView([12.9716, 77.5946], 8); // Default center: Bangalore

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors'
        }).addTo(map);

        let marker;

        map.on('click', function (e) {
            const lat = e.latlng.lat;
            const lng = e.latlng.lng;

            document.getElementById('latitude').value = lat;
            document.getElementById('longitude').value = lng;

            if (marker) {
                map.removeLayer(marker);
            }

            marker = L.marker([lat, lng]).addTo(map);
        });
    });
</script>
        <!-- Services End -->
        <!-- Footer Start -->
        <div class="footer-bar">
            <p class="mb-0">Copyright &copy; <a href="#">Cloud Computing</a>. All Rights Reserved.</p>
        </div>
        <!-- Footer End -->


        <!-- Back to Top -->
        <a href="#" class="btn btn-lg btn-secondary btn-lg-square rounded-circle back-to-top"><i class="bi bi-arrow-up"></i></a>


        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/waypoints/waypoints.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>

        <!-- Template Javascript -->
        <script src="js/main.js"></script>
    </body>
</html>
