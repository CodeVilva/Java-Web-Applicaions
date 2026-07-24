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
    border-top: 1px solid rgba(255,255,255,0.1);
    padding: 10px 0;
    margin-top: auto; /* ensures footer sticks to bottom */
    width: 100%;
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

    <!-- My Files Section -->
    <section class="myfiles-section">
        <div class="card-glass">
            <h3 class="mb-4"><i class="fa-solid fa-folder-open"></i> My Encrypted Files</h3>

            <table class="table table-hover align-middle">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>File Name</th>
                        <th>Size (KB)</th>
                        <th>Uploaded On</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    try {
                        con = DBConnection.getConnection();
                        PreparedStatement ps = con.prepareStatement(
                            "SELECT id, orig_filename, size_bytes, created_at, status FROM files WHERE user_id=? ORDER BY created_at DESC"
                        );
                        ps.setInt(1, userId);
                        rs = ps.executeQuery();
                        int i = 1;
                        while (rs.next()) {
                            long kb = rs.getLong("size_bytes") / 1024;
                %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><%= rs.getString("orig_filename") %></td>
                        <td><%= kb %> KB</td>
                        <td><%= rs.getTimestamp("created_at") %></td>
                        <td><span class="badge bg-success"><%= rs.getString("status") %></span></td>
                        <td>
                           <a href="verify-stego.jsp?fileId=<%= rs.getInt("id") %>" class="btn btn-sm btn-outline-info">
    <i class="fa fa-lock-open"></i> Decrypt & Download
</a>

                            <a href="user-sharefiles.jsp?fileId=<%= rs.getInt("id") %>" class="btn btn-sm btn-outline-warning">
                                <i class="fa fa-share"></i> Share
                            </a>
                        </td>
                    </tr>
                <%
                        }
                        rs.close(); ps.close();
                    } catch (Exception e) {
                        out.println("<tr><td colspan='6' class='text-center text-danger'>Error loading files</td></tr>");
                        e.printStackTrace();
                    } finally {
                        try { if (con != null) con.close(); } catch (Exception ex) {}
                    }
                %>
                </tbody>
            </table>
        </div>
    </section>

   <footer class="text-center text-light py-2 fixed-bottom"
        style="background:rgba(255,255,255,0.05);
               border-top:1px solid rgba(255,255,255,0.1);
               backdrop-filter:blur(10px);
               box-shadow:0 -2px 15px rgba(0,0,0,0.4);">
  <div class="container">
    <small>© <%= java.time.Year.now() %> SecureVault | All Rights Reserved</small>
  </div>
</footer>



    <script src="bootstrap.bundle.min.js"></script>
</body>
</html>
