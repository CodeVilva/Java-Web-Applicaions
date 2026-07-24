
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
                    <a href="Dsender.jsp" class="brand">
                        <span class="brand-icon"><i class="fa fa-lock"></i></span>
                        Secure Lock
                    </a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarCollapse">
                        <div class="navbar-nav ms-auto">
                            <a href="Dsender.jsp" class="nav-item nav-link active">Home</a>
                            <a href="FileUpload.jsp" class="nav-item nav-link">File Upload</a>
                            <a href="Fstatus.jsp" class="nav-item nav-link">Status</a>
                            <a href="logout.jsp" class="nav-item nav-link">Logout</a>
                        </div>
                    </div>
                </div>
            </nav>
        </div>
        <!-- Navbar End -->

        <!-- Hero Start -->
        <div class="hero">
            <div class="hero-icon"><i class="fa fa-paper-plane"></i></div>
            <h1 class="display-4">Sender Home</h1>
            <p class="lead">Welcome back. Upload new files or check the status of files you've sent.</p>
        </div>
        <!-- Hero End -->

        <!-- Services Start -->
        <div class="avatar-panel card">
            <img src="img/user.jpg">
            <h5>Sender Account</h5>
            <p>Manage your uploads and view delivery status from the menu above.</p>
        </div>
        <!-- Services End -->

        <!-- Footer Start -->
        <div class="footer-bar">
            <p class="mb-0"><a href="#">Secure File Locking System using QR and Location Validation</a></p>
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
