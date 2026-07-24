<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | SNAPSPOT</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&family=Space+Grotesk:wght@500;600;700&display=swap" rel="stylesheet">

    <!-- Existing Project CSS -->
    <link rel="stylesheet" href="css/style.css">

    <style>
        .auth-section{
            min-height:100vh;
            padding-top:120px;
            padding-bottom:60px;
            background:linear-gradient(135deg,#1A1A1A,#252525);
        }

        .auth-card{
            background:#fff;
            border-radius:20px;
            padding:40px;
            box-shadow:0 20px 50px rgba(0,0,0,.25);
        }

        .auth-title{
            font-family:'Space Grotesk',sans-serif;
            font-weight:700;
        }

        .form-control,.form-select{
            min-height:52px;
            border-radius:12px;
        }

        .btn-register{
            width:100%;
        }

        .left-info h1{
            color:#fff;
            font-family:'Space Grotesk',sans-serif;
            font-weight:700;
        }

        .left-info p{
            color:#d7d7d7;
            line-height:1.8;
        }
    </style>
</head>

<body>

<!-- Navbar -->
<nav id="mainNav" class="navbar navbar-expand-lg navbar-dark fixed-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="index.jsp">
            <div class="brand-icon"><i class="bi bi-qr-code"></i></div>
            <span class="brand-text">SNAP<span class="brand-accent">SPOT</span></span>
        </a>

        <button class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#navMenu">
            <span class="toggler-bar"></span>
            <span class="toggler-bar"></span>
            <span class="toggler-bar"></span>
        </button>

        <div class="collapse navbar-collapse" id="navMenu">
            <ul class="navbar-nav ms-auto align-items-lg-center">
                <li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link active" href="register.jsp">Register</a></li>
                <li class="nav-item"><a class="nav-link btn-nav-cta ms-lg-2" href="user/user.jsp">Login</a></li>
            </ul>
        </div>
    </div>
</nav>

<section class="auth-section">
<div class="container">

<div class="row align-items-center g-5">

<div class="col-lg-5 reveal-up left-info">

<span class="eyebrow-tag">
<i class="bi bi-shield-lock"></i>
SECURE REGISTRATION
</span>

<h1>Create your SNAPSPOT account</h1>

<p>
Register once to reserve parking slots, receive QR-based tickets,
manage your vehicles and track all bookings from a single dashboard.
</p>

<div class="mt-4">
<div class="feat-pill mb-3">
<div class="feat-icon"><i class="bi bi-qr-code"></i></div>
<div>
<strong>QR Based Ticket</strong>
<span>Instant QR generated after booking.</span>
</div>
</div>

<div class="feat-pill mb-3">
<div class="feat-icon"><i class="bi bi-car-front"></i></div>
<div>
<strong>Smart Parking</strong>
<span>Reserve parking slots before arriving.</span>
</div>
</div>

<div class="feat-pill">
<div class="feat-icon"><i class="bi bi-shield-check"></i></div>
<div>
<strong>Secure Platform</strong>
<span>Industry-standard authentication architecture.</span>
</div>
</div>

</div>

</div>

<div class="col-lg-7 reveal-right">

<div class="auth-card">

<h2 class="auth-title mb-4">Create Account</h2>

<form action="RegisterServlet" method="post">

<div class="row">

<div class="col-md-6 mb-3">
<label class="form-label">Full Name</label>
<input type="text" name="fullname" class="form-control" required>
</div>

<div class="col-md-6 mb-3">
<label class="form-label">Email Address</label>
<input type="email" name="email" class="form-control" required>
</div>

<div class="col-md-6 mb-3">
<label class="form-label">Mobile Number</label>
<input type="text" name="mobile" class="form-control" maxlength="10" required>
</div>

<div class="col-md-6 mb-3">
<label class="form-label">Vehicle Type</label>
<select name="vehicleType" class="form-select" required>
<option value="">Select</option>
<option>Bike</option>
<option>Car</option>
<option>SUV</option>
<option>EV</option>
</select>
</div>

<div class="col-12 mb-3">
<label class="form-label">Vehicle Number</label>
<input type="text" name="vehicleNumber" class="form-control"
placeholder="TN09AB1234" required>
</div>

<div class="col-md-6 mb-3">
<label class="form-label">Password</label>
<input type="password" name="password" class="form-control" required>
</div>

<div class="col-md-6 mb-4">
<label class="form-label">Confirm Password</label>
<input type="password" name="confirmPassword" class="form-control" required>
</div>

<div class="col-12">
<button class="btn btn-primary-snap btn-register">
<i class="bi bi-person-plus-fill"></i>
Create Account
</button>
</div>

<div class="col-12 text-center mt-4">
Already have an account?
<a href="login.jsp">Login</a>
</div>

</div>

</form>

</div>

</div>

</div>

</div>
</section>

<footer class="site-footer">
<div class="container text-center">
<p class="footer-copy">© 2026 SNAPSPOT. All Rights Reserved.</p>
</div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/animations.js"></script>

</body>
</html>
