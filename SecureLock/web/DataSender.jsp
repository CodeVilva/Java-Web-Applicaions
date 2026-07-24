
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
        if (request.getParameter("success") != null) {%>
    <script>alert('Registration Success');</script>  
    <%}
    %>
    <%
        if (request.getParameter("mailid") != null) {%>
    <script>alert('You are already registered');</script>  
    <%}
    %>
    <%
        if (request.getParameter("not") != null) {%>
    <script>alert('Your Account not yet approved. please try again later');</script>  
    <%}
    %>
    <body>
        <!-- Navbar Start -->
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
                        <div class="navbar-nav ms-auto">
                            <a href="index.jsp" class="nav-item nav-link">Home</a>
                            <a href="DataSender.jsp" class="nav-item nav-link active">Data Sender</a>
                            <a href="DataReceivers.jsp" class="nav-item nav-link">Data Receivers</a>
                            <a href="FileVault.jsp" class="nav-item nav-link">File Vault</a>
                        </div>
                    </div>
                </div>
            </nav>
        </div>
        <!-- Navbar End -->

        <!-- Hero Start -->
        <div class="hero">
            <div class="hero-icon"><i class="fa fa-user-lock"></i></div>
            <h1 class="display-4">Data Sender</h1>
            <p class="lead">Sign in to upload and manage your encrypted, geo-locked files.</p>
        </div>
        <!-- Hero End -->

        <div class="section">
            <div class="panel-narrow card">
                <h1 class="mb-4 text-center" style="font-size:1.6rem;">Authentication</h1>
                <form method="post" action="SenderLog">
                    <div class="row g-3">
                        <div class="col-12">
                            <input type="email" class="form-control" required="" name="email" placeholder="Email" style="height: 55px;">
                        </div>
                        <div class="col-12">
                            <input type="password" class="form-control" required="" name="password" placeholder="Password" style="height: 55px;">
                        </div>
                        <div class="col-12">
                            <button class="btn btn-primary w-100 py-3" type="submit">Login</button>
                        </div>
                    </div>
                </form>
                <div class="pt-4 text-center">
                    <a href="SenderReg.jsp" style="color: var(--primary-dark); font-weight:600;">Click here for sign up</a>
                </div>
            </div>
        </div>

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