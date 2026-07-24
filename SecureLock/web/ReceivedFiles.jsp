<%@ page import="java.sql.*" %>
<%@page import="GeoTemporal.SQLconnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>
      <meta charset="utf-8">
        <title>Geo-Temporal Encrypted File Vault with Secure Access Control and Self-Destruction</title>
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
        <link href="css/table.css" rel="stylesheet">
    </head>

    <%
        if (request.getParameter("Success") != null) {%>
    <script>alert('Login Success');</script>  
    <%}
    %>

    <body>
        <!-- Navbar Start -->
        <div class="navbar-sticky-wrap">
            <nav class="navbar navbar-expand-lg">
                <div class="nav-shell">
                    <a href="Receiver.jsp" class="brand">
                        <span class="brand-icon"><i class="fa fa-lock"></i></span>
                        Secure Lock
                    </a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarCollapse">
                        <div class="navbar-nav ms-auto">
                            <a href="Dsender.jsp" class="nav-item nav-link active">Home</a>
                            <a href="ReceivedFiles.jsp" class="nav-item nav-link">Received Files</a>
                            <a href="logout.jsp" class="nav-item nav-link">Logout</a>
                        </div>
                    </div>
                </div>
            </nav>
        </div>
        <!-- Navbar End -->

        <!-- Hero Start -->
        <div class="hero">
            <div class="hero-icon"><i class="fa fa-file-shield"></i></div>
            <h1 class="display-4">File Sent Details</h1>
            <p class="lead">See every file that has been securely shared with you, and its access status.</p>
        </div>
        <!-- Hero End -->

        <!-- Services Start -->
        <div class="table-wrap card">
<%
    String ridParam = session.getAttribute("rid").toString();

    if (ridParam == null || ridParam.trim().isEmpty()) {
%>
    <p style="color:red; text-align:center;">Receiver ID is missing in the request.</p>
<%
    } else {
        try {
            int rid = Integer.parseInt(ridParam);

           
            Connection conn = SQLconnection.getconnection();

            String selectSql = "SELECT id, sid, semail, passcode, upload_time, latitude, longitude, accessed " +
                               "FROM uploads WHERE rid = ?";
            PreparedStatement ps = conn.prepareStatement(selectSql);
            ps.setInt(1, rid);
            ResultSet rs = ps.executeQuery();
%>
<table id="naresh">
        <caption>Uploaded Files for Receiver ID: <%= rid %></caption>
        <tr>
           
           
            <th>Sender Id</th>
            <th>Passcode</th>
            <th>Upload Time</th>
            <th>Latitude</th>
            <th>Longitude</th>
            <th>Accessed</th>
        </tr>
<%
        boolean hasData = false;

        while (rs.next()) {
            hasData = true;

            int id = rs.getInt("id");
            String accessed = rs.getString("accessed");

            // Update accessed = '1' if not already marked
            if ("0".equals(accessed)) {
                PreparedStatement updatePs = conn.prepareStatement("UPDATE uploads SET accessed = '1' WHERE id = ?");
                updatePs.setInt(1, id);
                updatePs.executeUpdate();
                updatePs.close();
            }
%>
        <tr>
            
            <td><%= rs.getString("sid") %></td>
            <td><%= rs.getString("passcode") %></td>
            <td><%= rs.getTimestamp("upload_time") %></td>
            <td><%= rs.getString("latitude") %></td>
            <td><%= rs.getString("longitude") %></td>
            <td><%= "1".equals(accessed) ? "Yes" : "Marked Now" %></td>
        </tr>
<%
        }

        if (!hasData) {
%>
        <tr>
            <td colspan="7" style="color:gray;">No files found for this receiver.</td>
        </tr>
<%
        }

        rs.close();
        ps.close();
        conn.close();

        } catch (Exception e) {
%>
    <p style="color:red; text-align:center;">Error: <%= e.getMessage() %></p>
<%
        }
    }
%>
</table>
        </div>
        <!-- Services End -->
        <!-- Footer Start -->
        <div class="footer-bar">
            <p class="mb-0"><a href="#">Geo-Temporal Encrypted File Vault with Secure Access Control and Self-Destruction</a></p>
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
