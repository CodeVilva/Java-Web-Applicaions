<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SecureVault - Hybrid Cryptography File Storage</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap & Icons -->
 <link href="bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Poppins', sans-serif;
            background: radial-gradient(circle at top left, #101d42, #16213e, #0f3460);
            color: #fff;
            overflow-x: hidden;
            min-height: 100vh;
        }

        nav {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.6rem;
            color: #fff !important;
        }

        .nav-link {
            color: #fff !important;
            font-weight: 500;
            transition: 0.3s;
        }

        .nav-link:hover {
            color: #00bcd4 !important;
        }

        header {
            text-align: center;
            padding: 120px 20px 80px;
        }

        header h1 {
            font-size: 2.8rem;
            font-weight: 700;
            letter-spacing: 1px;
            margin-bottom: 10px;
            background: linear-gradient(90deg,#00bcd4,#4CAF50);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
           
        }

        header p {
            color: #bbb;
            font-size: 1.1rem;
            max-width: 700px;
            margin: auto;
        }

        .btn-glow {
            background: linear-gradient(90deg,#00bcd4,#4CAF50);
            color: #fff;
            border: none;
            border-radius: 30px;
            padding: 12px 30px;
            margin-top: 30px;
            transition: all 0.3s ease;
            box-shadow: 0 0 10px rgba(0,188,212,0.5);
        }

        .btn-glow:hover {
            transform: translateY(-3px);
            box-shadow: 0 0 20px rgba(0,188,212,0.8);
        }

        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit,minmax(250px,1fr));
            gap: 25px;
            padding: 60px 10%;
        }

        .card {
            background: rgba(255,255,255,0.06);
            border: none;
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            transition: 0.4s;
             
        }
        h5{
             background: linear-gradient(90deg,#00bcd4,#4CAF50);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        p{
            color: white;
        }

        .card:hover {
            transform: translateY(-8px);
            background: rgba(255,255,255,0.12);
        }

        .card i {
            font-size: 2.5rem;
            margin-bottom: 15px;
            color: #00bcd4;
        }

        footer {
            text-align: center;
            padding: 30px 10px;
            font-size: 0.9rem;
            color: #aaa;
            background: rgba(255,255,255,0.05);
            border-top: 1px solid rgba(255,255,255,0.1);
        }

        /* subtle animated particles */
        .particles span {
            position: absolute;
            width: 4px; height: 4px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            animation: move 10s linear infinite;
        }

        @keyframes move {
            0% { transform: translateY(0) scale(1); opacity: 1; }
            100% { transform: translateY(-100vh) scale(0.5); opacity: 0; }
        }
    </style>
</head>

<body>
    <nav class="navbar navbar-expand-lg px-5">
        <a class="navbar-brand" href="#">SecureVault</a>
        <div class="ms-auto">
            <a href="index.jsp" class="nav-link d-inline px-3">Home</a>
            <a href="user-login.jsp" class="nav-link d-inline px-3">User Login</a>
            <a href="user-register.jsp" class="nav-link d-inline px-3">Register</a>
            <a href="admin-login.jsp" class="nav-link d-inline px-3">Admin</a>
        </div>
    </nav>

    <header>
        <h1>Hybrid Cryptography File Storage System</h1>
        <p>
            SecureVault protects your sensitive files using multi-layered encryption and image-based key hiding. 
            Upload, encrypt, share, and decrypt with total privacy control — powered by AES, 3DES, and Blowfish.
        </p>
        <a href="user-register.jsp" class="btn btn-glow">Get Started</a>
    </header>

    <section class="features">
        <div class="card">
            <i class="fa-solid fa-user-shield"></i>
            <h5>User Registration</h5>
            <p>Each user gets a unique encrypted identity with a secure login to manage file uploads and shares.</p>
        </div>

        <div class="card">
            <i class="fa-solid fa-lock"></i>
            <h5>Triple Encryption</h5>
            <p>Files are divided into three blocks and protected using AES, 3DES, and Blowfish algorithms.</p>
        </div>

        <div class="card">
            <i class="fa-solid fa-image"></i>
            <h5>Steganography Protection</h5>
            <p>The decryption key is hidden securely inside an image file using advanced LSB steganography.</p>
        </div>

        <div class="card">
            <i class="fa-solid fa-share-nodes"></i>
            <h5>Controlled Sharing</h5>
            <p>Files can be shared securely — only users with the correct hidden image can decrypt and view data.</p>
        </div>

        <div class="card">
            <i class="fa-solid fa-cloud-download-alt"></i>
            <h5>Easy Recovery</h5>
            <p>Upload your stego-image and retrieve decrypted files in one click with full integrity verification.</p>
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
    <div class="particles">
        <% for(int i=0;i<25;i++){ %>
            <span style="top:<%= (int)(Math.random()*100) %>%; left:<%= (int)(Math.random()*100) %>%;
            animation-delay:<%= String.format("%.1f", Math.random()*5) %>s;"></span>
        <% } %>
    </div>

    <script src="bootstrap.bundle.min.js"></script>
</body>
</html>
