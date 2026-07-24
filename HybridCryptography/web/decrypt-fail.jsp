<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String reason = request.getParameter("reason");
    String message;

    if ("invalidImage".equals(reason)) {
        message = "Invalid or unreadable steganography image. Please upload the correct image file.";
    } else if ("missingParts".equals(reason)) {
        message = "Decryption failed — one or more encrypted parts are missing.";
    } else if ("InvalidKey".equals(reason)) {
        message = "Decryption failed due to incorrect or corrupted key data.";
    } else if ("corruptFile".equals(reason)) {
        message = "The reconstructed file appears to be corrupted. Try re-uploading.";
    } else if ("sessionExpired".equals(reason)) {
        message = "Your session has expired. Please log in again.";
    } else {
        message = "An unexpected error occurred during decryption.";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Decryption Failed | SecureVault</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body {
    font-family: 'Poppins', sans-serif;
    background: linear-gradient(135deg,#101d42 0%,#0f3460 50%,#16213e 100%);
    color: #fff;
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
}
.container {
    background: rgba(255,255,255,0.08);
    border: 1px solid rgba(255,255,255,0.15);
    border-radius: 20px;
    backdrop-filter: blur(12px);
    padding: 40px 50px;
    max-width: 600px;
    text-align: center;
    box-shadow: 0 0 25px rgba(0,188,212,0.25);
}
h2 {
    color: #ff6b6b;
    font-weight: 700;
    margin-bottom: 15px;
}
p {
    color: #ddd;
    margin-bottom: 25px;
}
.btn {
    border-radius: 30px;
    font-weight: 500;
    transition: all 0.3s;
}
.btn:hover {
    transform: translateY(-3px);
}
footer {
    position: absolute;
    bottom: 10px;
    width: 100%;
    text-align: center;
    color: #aaa;
    font-size: 0.9rem;
}
</style>
</head>
<body>
<div class="container">
    <i class="fa-solid fa-triangle-exclamation fa-4x text-danger mb-3"></i>
    <h2>Decryption Failed</h2>
    <p><%= message %></p>

    <div class="d-flex justify-content-center gap-3">
        <a href="user-dashboard.jsp" class="btn btn-outline-info px-4">
            <i class="fa fa-home"></i> Dashboard
        </a>
        <a href="user-myfiles.jsp" class="btn btn-outline-light px-4">
            <i class="fa fa-upload"></i> Try Again
        </a>
    </div>
</div>
   <footer class="text-center text-light py-2 fixed-bottom"
        style="background:rgba(255,255,255,0.05);
               border-top:1px solid rgba(255,255,255,0.1);
               backdrop-filter:blur(10px);
               box-shadow:0 -2px 15px rgba(0,0,0,0.4);">
  <div class="container">
    <small>© <%= java.time.Year.now() %> SecureVault | Hybrid Cryptography with Steganography Protection</small>
  </div>
</footer>
</body>
</html>
