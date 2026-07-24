<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, securevault.DBConnection" %>
<%@ page session="true" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");

    if (userId == null) {
        response.sendRedirect("user-login.jsp?msg=sessionExpired");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Download History | SecureVault</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

<style>
body {
    font-family: 'Poppins', sans-serif;
    background: linear-gradient(135deg, #101d42 0%, #0f3460 50%, #16213e 100%);
    color: #fff;
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
    padding: 70px 6%;
}
.card {
    background: rgba(255,255,255,0.07);
    border: 1px solid rgba(255,255,255,0.15);
    border-radius: 15px;
    backdrop-filter: blur(12px);
    box-shadow: 0 0 25px rgba(0,188,212,0.2);
    padding: 25px;
}
h3 {
    color: #00e0ff;
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
.badge {
    font-weight: 600;
}
footer {
    text-align: center;
    color: #aaa;
    font-size: 0.9rem;
    background: rgba(255,255,255,0.05);
    padding: 15px;
    border-top: 1px solid rgba(255,255,255,0.1);
    margin-top: 40px;
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
        <h3 class="mb-4"><i class="fa-solid fa-clock-rotate-left"></i> Download History</h3>

        <table class="table table-hover align-middle">
            <thead>
                <tr>
                    <th>#</th>
                    <th>File Name</th>
                    <th>Downloaded By</th>
                    <th>Downloaded At</th>
                    <th>Size (KB)</th>
                    <th>IP Address</th>
                    <th>Type</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try (Connection con = DBConnection.getConnection()) {
                        PreparedStatement ps = con.prepareStatement(
                            "SELECT d.id, f.orig_filename, u.name AS downloaded_by, d.downloaded_at, " +
                            "d.size_bytes, d.ip_address, IFNULL(d.share_id, 'SELF') AS source " +
                            "FROM download_history d " +
                            "JOIN files f ON d.file_id = f.id " +
                            "JOIN users u ON d.user_id = u.id " +
                            "WHERE f.user_id = ? ORDER BY d.downloaded_at DESC"
                        );
                        ps.setInt(1, userId);
                        ResultSet rs = ps.executeQuery();
                        int i = 1;
                        boolean hasData = false;
                        while (rs.next()) {
                            hasData = true;
                %>
                <tr>
                    <td><%= i++ %></td>
                    <td><i class="fa fa-file"></i> <%= rs.getString("orig_filename") %></td>
                    <td><i class="fa fa-user"></i> <%= rs.getString("downloaded_by") %></td>
                    <td><%= rs.getTimestamp("downloaded_at") %></td>
                    <td><%= rs.getLong("size_bytes") / 1024 %> KB</td>
                    <td><%= rs.getString("ip_address") %></td>
                    <td>
                        <% if("SELF".equals(rs.getString("source"))) { %>
                            <span class="badge bg-secondary">Self</span>
                        <% } else { %>
                            <span class="badge bg-success">Shared</span>
                        <% } %>
                    </td>
                </tr>
                <%
                        }
                        if (!hasData) {
                            out.println("<tr><td colspan='7' class='text-center text-muted'>No downloads recorded yet.</td></tr>");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<tr><td colspan='7' class='text-center text-danger'>Error loading history.</td></tr>");
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
    <small>© <%= java.time.Year.now() %> SecureVault | Hybrid Cryptography with Steganography Protection</small>
  </div>
</footer>
<script src="bootstrap.bundle.min.js"></script>
</body>
</html>
