<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ticket Checker Login | SNAPSPOT</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="../css/style.css">
<style>
body{background:linear-gradient(135deg,#1d1f23,#2d3436);min-height:100vh}
.login-card{max-width:520px;margin:80px auto;background:#fff;padding:35px;border-radius:18px;box-shadow:0 15px 40px rgba(0,0,0,.25)}
</style>
</head>
<body>
<!-- ═══════════════════════════  NAVBAR  ═══════════════════════════ -->
<nav class="navbar navbar-expand-lg fixed-top" id="mainNav">
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
<br><br><br>
<div class="container">
<div class="login-card">
<h2 class="mb-4">Ticket Checker Login</h2>
<%
String error=(String)session.getAttribute("errorMessage");
if(error!=null){
%>
<div class="alert alert-danger"><%=error%></div>
<%
session.removeAttribute("errorMessage");
}
%>
<form action="<%=request.getContextPath()%>/TicketCheckerLoginServlet" method="post">
<div class="mb-3">
<label>Email</label>
<input type="email" name="email" class="form-control" required>
</div>
<div class="mb-4">
<label>Password</label>
<div class="input-group">
<input type="password" id="password" name="password" class="form-control" required>
<button type="button" class="btn btn-outline-secondary" onclick="togglePassword()"><i id="eye" class="bi bi-eye"></i></button>
</div>
</div>
<button class="btn btn-nav-cta w-100"><i class="bi bi-box-arrow-in-right"></i> Login</button>
</form>
</div>
</div>
<script>
function togglePassword(){
const p=document.getElementById('password');
const e=document.getElementById('eye');
if(p.type==='password'){p.type='text';e.className='bi bi-eye-slash';}
else{p.type='password';e.className='bi bi-eye';}
}
</script>
</body>
</html>
