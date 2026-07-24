<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Login | SecureVault</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap + Icons -->
   <link href="bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background: radial-gradient(circle at top left, #101d42, #16213e, #0f3460);
            font-family: 'Poppins', sans-serif;
            color: #fff;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        nav {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(10px);
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            color: #fff !important;
        }

        .container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-box {
            background: rgba(255,255,255,0.08);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0,188,212,0.2);
            width: 100%;
            max-width: 400px;
        }

        .login-box h2 {
            text-align: center;
            background: linear-gradient(90deg,#00bcd4,#4CAF50);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-weight: 700;
            margin-bottom: 30px;
        }

        .form-control {
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            color: #fff;
        }

        .form-control:focus {
            background: rgba(255,255,255,0.15);
            border-color: #00bcd4;
            box-shadow: 0 0 10px rgba(0,188,212,0.3);
        }

        .btn-glow {
            background: linear-gradient(90deg,#00bcd4,#4CAF50);
            color: #fff;
            border: none;
            border-radius: 30px;
            padding: 12px 30px;
            width: 100%;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 0 10px rgba(0,188,212,0.5);
        }

        .btn-glow:hover {
            transform: translateY(-3px);
            box-shadow: 0 0 20px rgba(0,188,212,0.8);
        }

        .form-text a {
            color: #00bcd4;
            text-decoration: none;
        }

        footer {
            text-align: center;
            padding: 20px;
            font-size: 0.9rem;
            color: #aaa;
            background: rgba(255,255,255,0.05);
            border-top: 1px solid rgba(255,255,255,0.1);
        }
.login-box {
    background: rgba(255,255,255,0.08);
    border: 1px solid rgba(255,255,255,0.15);
    border-radius: 20px;
    backdrop-filter: blur(12px);
    padding: 40px 50px;
    width: 400px;
    box-shadow: 0 0 25px rgba(0,188,212,0.25);
}
.login-box h3 {
    color: #00e0ff;
    font-weight: 700;
    text-align: center;
    margin-bottom: 25px;
}
.form-control {
    background: rgba(255,255,255,0.1);
    border: none;
    color: #fff;
    border-radius: 10px;
}
.form-control:focus {
    background: rgba(255,255,255,0.15);
    box-shadow: 0 0 0 0.2rem rgba(0,224,255,0.25);
}
.btn-login {
    width: 100%;
    background: linear-gradient(90deg,#00bcd4,#4CAF50);
    border: none;
    border-radius: 30px;
    font-weight: 600;
    color: #fff;
    transition: all 0.3s;
}
.btn-login:hover {
    transform: translateY(-2px);
    box-shadow: 0 0 20px rgba(0,224,255,0.4);
}
.alert {
    border-radius: 12px;
    text-align: center;
}
    </style>
</head>
<%
    String msg = request.getParameter("msg");
%>
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
    <div class="container">
<div class="login-box">
    <h3><i class="fa-solid fa-user-shield"></i> Admin Login</h3>

    <% if ("failed".equals(msg)) { %>
        <div class="alert alert-danger py-2">Invalid username or password!</div>
    <% } else if ("logout".equals(msg)) { %>
        <div class="alert alert-success py-2">You have been logged out successfully.</div>
    <% } %>

    <form action="AdminLoginServlet" method="post">
        <div class="mb-3">
            <label class="form-label text-light">Admin Email</label>
            <input type="email" name="email" class="form-control" placeholder="Enter admin email" required>
        </div>
        <div class="mb-3">
            <label class="form-label text-light">Password</label>
            <input type="password" name="password" class="form-control" placeholder="Enter password" required>
        </div>
        <button type="submit" class="btn btn-login mt-3">
            <i class="fa fa-sign-in-alt"></i> Login
        </button>
    </form>
</div>
    </div>
<footer class="text-center text-light py-2 fixed-bottom">
  <div class="container">
    <small>© <%= java.time.Year.now() %> SecureVault | All Rights Reserved</small>
  </div>
</footer>

<script src="bootstrap.bundle.min.js"></script>
</body>
</html>
