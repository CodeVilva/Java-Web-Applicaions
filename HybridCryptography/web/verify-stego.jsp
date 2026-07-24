<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,securevault.DBConnection" %>
<%@ page session="true" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");

    if (userId == null) {
        response.sendRedirect("user-login.jsp?msg=sessionExpired");
        return;
    }
    String fileId = request.getParameter("fileId");
    Connection con = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>My Files | SecureVault</title>
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
            .myfiles-section {
                padding: 80px 8%;
            }
            .card-glass {
                background: rgba(255,255,255,0.07);
                border: 1px solid rgba(255,255,255,0.15);
                backdrop-filter: blur(12px);
                border-radius: 15px;
                padding: 25px;
                box-shadow: 0 0 20px rgba(0,188,212,0.2);
            }
            .verify-card {
                background: rgba(255,255,255,0.07);
                backdrop-filter: blur(12px);
                border-radius: 20px;
                padding: 50px;
                margin: 100px auto;
                max-width: 600px;
                box-shadow: 0 0 25px rgba(0,188,212,0.15);
                text-align: center;
            }
            .btn-glow {
                background: linear-gradient(90deg,#00bcd4,#4CAF50);
                color: #fff;
                border: none;
                border-radius: 30px;
                padding: 12px 40px;
                box-shadow: 0 0 15px rgba(0,188,212,0.4);
                transition: all 0.3s;
            }
            .btn-glow:hover {
                transform: translateY(-3px);
                box-shadow: 0 0 25px rgba(0,188,212,0.8);
            }
            table {
                color: #fff;
            }
            thead {
                background: rgba(0,188,212,0.2);
            }
            tr:hover {
                background: rgba(255,255,255,0.05);
            }
            .btn-sm {
                border-radius: 20px;
                font-weight: 500;
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
        <!-- Navbar -->
        <nav class="navbar navbar-expand-lg px-5">
            <div class="container-fluid">
                <a class="navbar-brand" href="user-dashboard.jsp"><i class="fa-solid fa-shield-halved"></i> SecureVault</a>
                <button class="navbar-toggler text-white border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
                    <i class="fa-solid fa-bars"></i>
                </button>
                <div class="collapse navbar-collapse justify-content-end" id="navMenu">
                    <ul class="navbar-nav mb-2 mb-lg-0">
                        <li class="nav-item"><a href="user-dashboard.jsp" class="nav-link px-3"><i class="fa fa-home"></i> Dashboard</a></li>
                        <li class="nav-item"><a href="user-upload.jsp" class="nav-link px-3"><i class="fa fa-upload"></i> Upload</a></li>
                        <li class="nav-item"><a href="user-myfiles.jsp" class="nav-link px-3 text-info"><i class="fa fa-folder"></i> My Files</a></li>
                        <li class="nav-item"><a href="user-sharefiles.jsp" class="nav-link px-3"><i class="fa fa-share-nodes"></i> Share Files</a></li>
                        <li class="nav-item"><a href="logout.jsp" class="nav-link text-danger px-3"><i class="fa fa-sign-out-alt"></i> Logout</a></li>
                    </ul>
                </div>
            </div>
        </nav>
        <div class="verify-card">
            <h3><i class="fa-solid fa-image"></i> Verify Stego Image</h3>
            <p>Upload the steganography image used during encryption to unlock and download your file.</p>

            <form action="DecryptServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="fileId" value="<%= fileId%>">
                <div class="mb-3 text-start">
                    <label class="form-label">Select Stego Image</label>
                    <input type="file" name="stegoImage" class="form-control" accept="image/png,image/jpeg" required>
                </div>
                <button type="submit" class="btn-glow"><i class="fa-solid fa-key"></i> Verify & Download</button>
            </form>
        </div>
        <footer class="text-center text-light py-2 fixed-bottom"
                style="background:rgba(255,255,255,0.05);
                border-top:1px solid rgba(255,255,255,0.1);
                backdrop-filter:blur(10px);
                box-shadow:0 -2px 15px rgba(0,0,0,0.4);">
            <div class="container">
                <small>© <%= java.time.Year.now()%> SecureVault | Hybrid Cryptography with Steganography Protection</small>
            </div>
        </footer>
    </body>
</html>
