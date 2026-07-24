<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("user-login.jsp?msg=sessionExpired");
        return;
    }
    String msg = request.getParameter("msg");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Encrypt & Upload | SecureVault</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

   <link href="bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body {
  font-family:'Poppins',sans-serif;
  background:linear-gradient(135deg,#101d42 0%,#0f3460 50%,#16213e 100%);
  color:#fff;
  min-height:100vh;
}
nav {
  background:rgba(255,255,255,0.08);
  backdrop-filter:blur(10px);
  border-bottom:1px solid rgba(255,255,255,0.1);
}
.navbar-brand {
  font-weight:700;
  font-size:1.6rem;
  color:#00e0ff!important;
  letter-spacing:1px;
}
.nav-link {
  color:#fff!important;
  font-weight:500;
  border-radius:10px;
}
.nav-link:hover {
  color:#00bcd4!important;
  background:rgba(255,255,255,0.1);
}
.header-section {
  text-align:center;
  padding-top:80px;
}
.header-section h2 {
  font-weight:700;
  font-size:2.2rem;
  background:linear-gradient(90deg,#00bcd4,#4CAF50);
  -webkit-background-clip:text;
  -webkit-text-fill-color:transparent;
}
.stats-container {
  display:flex;
  justify-content:center;
  flex-wrap:wrap;
  gap:30px;
  padding:60px 10%;
}
.stat-card {
  width:260px;
  height:160px;
  background:rgba(255,255,255,0.06);
  border:1px solid rgba(255,255,255,0.1);
  border-radius:20px;
  text-align:center;
  padding:30px 20px;
  backdrop-filter:blur(12px);
  transition:all 0.4s ease;
  box-shadow:0 0 20px rgba(0,188,212,0.2);
}
.stat-card:hover {
  transform:translateY(-8px);
  box-shadow:0 0 30px rgba(0,188,212,0.4);
}
.stat-card i { font-size:2.8rem; color:#00e0ff; margin-bottom:10px; }
.stat-card h3 { font-size:2.4rem; color:#4CAF50; font-weight:700; }
.stat-card h5 { color:#ccc; margin-top:8px; }

.table-section {
  padding:40px 8%;
}
.card-glass {
  background:rgba(255,255,255,0.07);
  border:1px solid rgba(255,255,255,0.15);
  backdrop-filter:blur(12px);
  border-radius:15px;
  padding:25px;
  box-shadow:0 0 20px rgba(0,188,212,0.2);
}
.table thead { background:rgba(0,188,212,0.2); }
.table tbody tr:hover { background:rgba(255,255,255,0.05); }

footer {
  text-align:center;
  color:#aaa;
  font-size:0.9rem;
  background:rgba(255,255,255,0.05);
  padding:15px;
  border-top:1px solid rgba(255,255,255,0.1);
}
.btn-action { border-radius:20px; font-weight:500; }
.alert { border-radius:12px; text-align:center; max-width:500px; margin:20px auto; }

        .upload-card {
            background: rgba(255,255,255,0.07);
            backdrop-filter: blur(12px);
            border-radius: 20px;
            padding: 40px;
            margin: 100px auto;
            max-width: 600px;
            box-shadow: 0 0 25px rgba(0,188,212,0.15);
        }
        .btn-glow {
            background: linear-gradient(90deg,#00bcd4,#4CAF50);
            border: none;
            color: #fff;
            border-radius: 30px;
            padding: 12px 40px;
            box-shadow: 0 0 15px rgba(0,188,212,0.4);
            transition: all 0.3s;
        }
        .btn-glow:hover {
            transform: translateY(-3px);
            box-shadow: 0 0 25px rgba(0,188,212,0.8);
        }
        footer {
            text-align: center;
            color: #aaa;
            font-size: 0.9rem;
            background: rgba(255,255,255,0.05);
            padding: 15px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }
    </style>
</head>

<body>
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

    <% if ("success".equals(msg)) { %>
        <div class="alert alert-success text-center mt-3">File encrypted & uploaded successfully!</div>
    <% } else if ("error".equals(msg)) { %>
        <div class="alert alert-danger text-center mt-3">Encryption failed. Try again.</div>
    <% } %>

    <div class="upload-card text-center">
        <h3><i class="fa-solid fa-lock"></i> Encrypt & Upload File</h3>
        <p>Upload a file, enter your encryption key, and choose an image to hide the key securely.</p>

        <form action="UploadEncryptServlet" method="post" enctype="multipart/form-data">
            <div class="mb-3 text-start">
                <label class="form-label">Select File to Encrypt</label>
                <input type="file" name="dataFile" class="form-control" required>
            </div>

            <div class="mb-3 text-start">
                <label class="form-label">Enter Secret Key</label>
                <input type="password" name="secretKey" class="form-control" placeholder="Enter encryption key" required>
            </div>

            <div class="mb-4 text-start">
                <label class="form-label">Choose Image to Hide Key</label>
                <input type="file" name="coverImage" class="form-control" accept="image/png,image/jpeg" required>
            </div>

            <button type="submit" class="btn-glow"><i class="fa-solid fa-shield-halved"></i> Encrypt & Upload</button>
        </form>
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
  <script src="bootstrap.bundle.min.js"></script>
</body>
</html>
