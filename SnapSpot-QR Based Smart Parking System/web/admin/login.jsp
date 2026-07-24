<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String error=(String)session.getAttribute("errorMessage");
String success=(String)session.getAttribute("successMessage");
if(error!=null) session.removeAttribute("errorMessage");
if(success!=null) session.removeAttribute("successMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Login | SNAPSPOT</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<style>
body{background:linear-gradient(135deg,#0d6efd,#212529);height:100vh;display:flex;align-items:center}
.card{max-width:430px;width:100%;margin:auto;border:none;border-radius:18px;box-shadow:0 12px 35px rgba(0,0,0,.25)}
.logo{font-size:56px;color:#0d6efd}
</style>
</head>
<body>
<!-- ═══════════════════════════  NAVBAR  ═══════════════════════════ -->
    <nav class="navbar navbar-expand-lg fixed-top" id="mainNav" style="background-color: #FFF;">
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
                        <a class="btn btn-primary" href="../user/user.jsp">
                            <i class="bi bi-person-circle me-1"></i>Users
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
<div class="container">
<div class="card">
<div class="card-body p-4">
<div class="text-center mb-4">
<div class="logo"><i class="bi bi-shield-lock-fill"></i></div>
<h3>SNAPSPOT</h3>
<p class="text-muted">Administrator Login</p>
</div>

<% if(success!=null){ %>
<div class="alert alert-success"><%=success%></div>
<% } %>

<% if(error!=null){ %>
<div class="alert alert-danger"><%=error%></div>
<% } %>

<form action="<%=request.getContextPath()%>/AdminLoginServlet" method="post">

<div class="mb-3">
<label class="form-label">Email Address</label>
<input type="email" name="email" class="form-control" required>
</div>

<div class="mb-3">
<label class="form-label">Password</label>
<div class="input-group">
<input type="password" name="password" id="password" class="form-control" required>
<button class="btn btn-outline-secondary" type="button" onclick="togglePassword()">
<i class="bi bi-eye" id="eyeIcon"></i>
</button>
</div>
</div>

<div class="d-grid">
<button class="btn btn-primary">
<i class="bi bi-box-arrow-in-right"></i>
Login
</button>
</div>

</form>

<hr>

<div class="text-center">
<a href="<%=request.getContextPath()%>/index.jsp" class="text-decoration-none">
<i class="bi bi-house"></i> Back to Home
</a>
</div>

</div>
</div>
</div>

<script>
function togglePassword(){
const p=document.getElementById("password");
const i=document.getElementById("eyeIcon");
if(p.type==="password"){
 p.type="text";
 i.className="bi bi-eye-slash";
}else{
 p.type="password";
 i.className="bi bi-eye";
}
}
</script>
</body>
</html>