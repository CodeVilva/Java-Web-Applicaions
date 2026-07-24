<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("user-login.jsp?msg=sessionExpired");
        return;
    }
    String fileId = request.getParameter("fileId"); // Shared file ID for decrypt
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Stego Image Downloaded | SecureVault</title>
<link href="bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body {
  background: linear-gradient(135deg,#101d42 0%,#0f3460 50%,#16213e 100%);
  color: #fff;
  font-family: 'Poppins', sans-serif;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
}
.card {
  background: rgba(255,255,255,0.07);
  border: 1px solid rgba(255,255,255,0.15);
  border-radius: 15px;
  backdrop-filter: blur(12px);
  padding: 35px;
  text-align: center;
  box-shadow: 0 0 25px rgba(0,188,212,0.3);
  max-width: 600px;
}
.card i {
  color: #00e0ff;
  font-size: 3rem;
  margin-bottom: 15px;
}
.btn-next {
  background: #00bcd4;
  color: #000;
  font-weight: 600;
  border-radius: 25px;
  padding: 10px 25px;
  transition: all 0.3s ease;
  border: none;
}
.btn-next:hover {
  background: #4CAF50;
  color: #fff;
  transform: scale(1.05);
}
footer {
  position: absolute;
  bottom: 15px;
  width: 100%;
  text-align: center;
  color: #aaa;
  font-size: 0.9rem;
}
</style>
</head>
<body>
  <div class="card">
    <i class="fa-solid fa-circle-check"></i>
    <h3>Stego Image Downloaded Successfully</h3>
    <p class="mt-2">Your hidden-key image has been saved on your device.</p>
    <p>Now, upload the same image below to verify and decrypt the file securely.</p>

    <a href="verify-stego-shared.jsp?fileId=<%=fileId%>" class="btn btn-next mt-3">
      <i class="fa fa-lock-open"></i> Proceed to Verify & Decrypt
    </a>
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
