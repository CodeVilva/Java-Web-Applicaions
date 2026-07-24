<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("user-login.jsp?msg=sessionExpired");
        return;
    }

    String fileId = request.getParameter("fileId");
    if (fileId == null) {
        response.sendRedirect("user-dashboard.jsp?msg=invalidFile");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Verify & Decrypt Shared File | SecureVault</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

<style>
body {
    background: linear-gradient(135deg, #101d42 0%, #0f3460 50%, #16213e 100%);
    color: #fff;
    font-family: 'Poppins', sans-serif;
    min-height: 100vh;
}
nav {
    background: rgba(255,255,255,0.08);
    backdrop-filter: blur(10px);
    border-bottom: 1px solid rgba(255,255,255,0.1);
}
.navbar-brand {
    font-weight: 700;
    font-size: 1.6rem;
    color: #00e0ff !important;
}
.nav-link {
    color: #fff !important;
    font-weight: 500;
    border-radius: 10px;
}
.nav-link:hover {
    color: #00bcd4 !important;
    background: rgba(255,255,255,0.1);
}
section {
    padding: 80px 5%;
}
.card {
    background: rgba(255,255,255,0.07);
    border: 1px solid rgba(255,255,255,0.15);
    border-radius: 15px;
    backdrop-filter: blur(12px);
    box-shadow: 0 0 25px rgba(0,188,212,0.2);
    padding: 35px;
    max-width: 650px;
    margin: auto;
    text-align: center;
}
.card h3 {
    color: #00e0ff;
    margin-bottom: 15px;
}
.card p {
    color: #ccc;
}
.form-control {
    background: rgba(255,255,255,0.1);
    border: 1px solid rgba(255,255,255,0.2);
    color: #fff;
    border-radius: 10px;
}
.form-control:focus {
    background: rgba(255,255,255,0.15);
    border-color: #00bcd4;
    box-shadow: 0 0 5px rgba(0,188,212,0.5);
}
.btn-submit {
    background: #00bcd4;
    color: #000;
    border: none;
    font-weight: 600;
    border-radius: 25px;
    padding: 10px 25px;
    transition: all 0.3s ease;
}
.btn-submit:hover {
    background: #4CAF50;
    color: #fff;
    transform: scale(1.05);
}
footer {
    text-align: center;
    color: #aaa;
    font-size: 0.9rem;
    background: rgba(255,255,255,0.05);
    padding: 15px;
    border-top: 1px solid rgba(255,255,255,0.1);
    margin-top: 60px;
}
</style>
</head>

<body>
<!-- Navbar -->
<nav class="navbar navbar-expand-lg px-5">
  <div class="container-fluid">
    <a class="navbar-brand" href="user-dashboard.jsp"><i class="fa-solid fa-shield-halved"></i> SecureVault</a>
    <button class="navbar-toggler text-white border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
      <i class="fa-solid fa-bars"></i>
    </button>
    <div class="collapse navbar-collapse justify-content-end" id="navMenu">
      <ul class="navbar-nav mb-2 mb-lg-0">
    <li class="nav-item">
        <a href="user-dashboard.jsp" class="nav-link px-3 <%= request.getRequestURI().contains("user-dashboard.jsp") ? "text-info" : "" %>">
            <i class="fa fa-home"></i> Dashboard
        </a>
    </li>

    <li class="nav-item">
        <a href="user-upload.jsp" class="nav-link px-3 <%= request.getRequestURI().contains("user-upload.jsp") ? "text-info" : "" %>">
            <i class="fa fa-upload"></i> Upload
        </a>
    </li>

    <li class="nav-item">
        <a href="user-myfiles.jsp" class="nav-link px-3 <%= request.getRequestURI().contains("user-myfiles.jsp") ? "text-info" : "" %>">
            <i class="fa fa-folder"></i> My Files
        </a>
    </li>

    <li class="nav-item">
        <a href="user-sharefiles.jsp" class="nav-link px-3 <%= request.getRequestURI().contains("user-sharefiles.jsp") ? "text-info" : "" %>">
            <i class="fa fa-share-nodes"></i> Share Files
        </a>
    </li>

    <li class="nav-item">
        <a href="user-download-history.jsp" class="nav-link px-3 <%= request.getRequestURI().contains("user-download-history.jsp") ? "text-info" : "" %>">
            <i class="fa fa-clock-rotate-left"></i> History
        </a>
    </li>

    <li class="nav-item">
        <a href="logout.jsp" class="nav-link text-danger px-3">
            <i class="fa fa-sign-out-alt"></i> Logout
        </a>
    </li>
</ul>

    </div>
  </div>
</nav>

<section>
    <div class="card">
        <i class="fa-solid fa-image fa-3x mb-3" style="color:#00e0ff;"></i>
        <h3>Verify Stego Image & Decrypt File</h3>
        <p class="mb-4">Upload the stego image you downloaded to verify the hidden key and decrypt your shared file securely.</p>

        <form action="DecryptSharedServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="fileId" value="<%=fileId%>">
            <div class="mb-3">
                <input type="file" name="stegoImage" accept=".png,.jpg,.jpeg" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-submit">
                <i class="fa fa-lock-open"></i> Verify & Decrypt
            </button>
        </form>
    </div>
</section>

<footer class="text-center text-light py-2 fixed-bottom"
        style="background:rgba(255,255,255,0.05);
               border-top:1px solid rgba(255,255,255,0.1);
               backdrop-filter:blur(10px);
               box-shadow:0 -2px 15px rgba(0,0,0,0.4);">
  <div class="container">
    <small>© <%= java.time.Year.now() %> SecureVault | Hybrid Cryptography with Steganography Protection</small>
  </div>
</footer>
<script src="bootstrap.bundle.min.js"></script>
</body>
</html>
