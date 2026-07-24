<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>User Login | SNAPSPOT</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&family=Space+Grotesk:wght@500;600;700&display=swap" rel="stylesheet">

    <!-- Project CSS -->
    <link rel="stylesheet" href="../css/style.css">

    <style>

        body{

            background:linear-gradient(135deg,#1A1A1A,#252525);
            min-height:100vh;

        }

        .login-section{

            padding-top:120px;
            padding-bottom:70px;

        }

        .login-card{

            background:#fff;
            border-radius:20px;
            padding:40px;
            box-shadow:0 20px 50px rgba(0,0,0,.25);

        }

        .login-title{

            font-family:'Space Grotesk',sans-serif;
            font-weight:700;

        }

        .form-control{

            min-height:52px;
            border-radius:12px;

        }

        .btn-login{

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

<!-- ═══════════════════════════  NAVBAR  ═══════════════════════════ -->
    <nav class="navbar navbar-expand-lg fixed-top" id="mainNav" >
        <div class="container-xl">

            <!-- Brand -->
            <a class="navbar-brand d-flex align-items-center gap-2" href="../index.jsp">
                <div class="brand-icon">
                    <i class="bi bi-qr-code-scan"></i>
                </div>
                <span class="brand-text">SNAP<span class="brand-accent">SPOT</span></span>
            </a>

            <!-- Toggler -->
            <button class="navbar-toggler" type="button"
                    data-bs-toggle="collapse" data-bs-target="#navbarNav"
                    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="toggler-bar"></span>
                <span class="toggler-bar"></span>
                <span class="toggler-bar"></span>
            </button>

            <!-- Nav Links -->
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-1">
                    <li class="nav-item">
                        <a class="nav-link active" href="../index.jsp">
                            <i class="bi bi-house me-1"></i>Home
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="../admin/dashboard.jsp">
                            <i class="bi bi-shield-lock me-1"></i>Administrator
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="../ticket-checker/login.jsp">
                            <i class="bi bi-upc-scan me-1"></i>Ticket Checker
                        </a>
                    </li>
                    <li class="nav-item ms-lg-2">
                        <a class="nav-link btn-nav-cta" href="../user/user.jsp">
                            <i class="bi bi-person-circle me-1"></i>Users
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

<section class="login-section text-secondary">

<div class="container">

<div class="row align-items-center g-5">

<!-- Left -->

<div class="col-lg-5">

<h1>

Welcome Back

</h1>

<p>

Login to reserve parking slots, manage your vehicles,
download QR tickets and view your booking history.

</p>

</div>

<!-- Right -->

<div class="col-lg-7">

<div class="login-card">

<h2 class="login-title mb-4">

User Login

</h2>

<%

String errorMessage =
(String)session.getAttribute("errorMessage");

String successMessage =
(String)session.getAttribute("successMessage");

if(successMessage!=null){

%>

<div class="alert alert-success">

<%=successMessage%>

</div>

<%

session.removeAttribute("successMessage");

}

if(errorMessage!=null){

%>

<div class="alert alert-danger">

<%=errorMessage%>

</div>

<%

session.removeAttribute("errorMessage");

}

%>

<form action="../UserLoginServlet" method="post">

<div class="mb-3">

<label class="form-label">

Email Address

</label>

<input
type="email"
name="email"
class="form-control"
autocomplete="email"
required>

</div>

<div class="mb-4">

<label class="form-label">

Password

</label>

<div class="input-group">

<input
type="password"
id="password"
name="password"
class="form-control"
autocomplete="current-password"
required>

<button
class="btn btn-outline-secondary"
type="button"
onclick="togglePassword()">

<i id="eyeIcon"
class="bi bi-eye">

</i>

</button>

</div>

</div>

<button
class="btn btn-primary-snap btn-login">

<i class="bi bi-box-arrow-in-right"></i>

Login

</button>

<div class="text-center mt-4">

Don't have an account?

<a href="../register.jsp">

Register Here

</a>

</div>

</form>

</div>

</div>

</div>

</div>

</section>

<script>

function togglePassword(){

const password =
document.getElementById("password");

const eye =
document.getElementById("eyeIcon");

if(password.type==="password"){

password.type="text";

eye.className="bi bi-eye-slash";

}
else{

password.type="password";

eye.className="bi bi-eye";

}

}

</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>