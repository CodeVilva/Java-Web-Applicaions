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
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Share Files | SecureVault</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

<style>
body {
    background: linear-gradient(135deg,#101d42 0%,#0f3460 50%,#16213e 100%);
    color:#fff;
    font-family:'Poppins',sans-serif;
    min-height:100vh;
}
nav {
    background: rgba(255,255,255,0.08);
    backdrop-filter: blur(10px);
    border-bottom: 1px solid rgba(255,255,255,0.1);
}
.navbar-brand {
    font-weight:700;
    font-size:1.6rem;
    color:#00e0ff!important;
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
.section-content { padding:80px 8%; }
.card-glass {
    background: rgba(255,255,255,0.07);
    border:1px solid rgba(255,255,255,0.15);
    backdrop-filter: blur(12px);
    border-radius:15px;
    padding:25px;
    box-shadow:0 0 20px rgba(0,188,212,0.2);
}
h3,h4 { color:#00e0ff; }
.table thead { background:rgba(0,188,212,0.2); }
.table tbody tr:hover { background:rgba(255,255,255,0.05); }
.btn-sm { border-radius:20px; font-weight:500; }
footer {
    text-align:center;
    color:#aaa;
    font-size:0.9rem;
    background:rgba(255,255,255,0.05);
    padding:15px;
    border-top:1px solid rgba(255,255,255,0.1);
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

<!-- Share Section -->
<section class="section-content">
    <div class="card-glass mx-auto mb-5" style="max-width:700px;">
        <h3 class="mb-4"><i class="fa-solid fa-share-nodes"></i> Share Encrypted Files</h3>
        <form action="ShareFileServlet" method="post">
            <div class="mb-3">
                <label class="form-label text-info">Select File</label>
                <select class="form-select" name="fileId" required>
                    <option value="">-- Choose one of your files --</option>
                    <%
                        try (Connection con = DBConnection.getConnection()) {
                            PreparedStatement ps = con.prepareStatement("SELECT id, orig_filename FROM files WHERE user_id=? ORDER BY id DESC");
                            ps.setInt(1, userId);
                            ResultSet rs = ps.executeQuery();
                            while (rs.next()) {
                    %>
                    <option value="<%=rs.getInt("id")%>"><%=rs.getString("orig_filename")%></option>
                    <%
                            }
                        } catch (Exception e) { e.printStackTrace(); }
                    %>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label text-info">Share With</label>
                <select class="form-select" name="targetUserId" required>
                    <option value="">-- Select recipient user --</option>
                    <%
                        try (Connection con = DBConnection.getConnection()) {
                            PreparedStatement ps = con.prepareStatement("SELECT id, name, email FROM users WHERE id != ?");
                            ps.setInt(1, userId);
                            ResultSet rs = ps.executeQuery();
                            while (rs.next()) {
                    %>
                    <option value="<%=rs.getInt("id")%>">
                        <%=rs.getString("name")%> (<%=rs.getString("email")%>)
                    </option>
                    <%
                            }
                        } catch (Exception e) { e.printStackTrace(); }
                    %>
                </select>
            </div>

            <div class="text-center">
                <button type="submit" class="btn btn-info px-4 rounded-pill"><i class="fa fa-share"></i> Share File</button>
            </div>
        </form>
    </div>

    <!-- Shared History -->
    <div class="card-glass mx-auto" style="max-width:1000px;">
        <h4 class="mb-3"><i class="fa-solid fa-clock-rotate-left"></i> Shared History</h4>
        <div class="table-responsive">
            <table class="table table-hover align-middle text-center">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>File Name</th>
                        <th>Shared With</th>
                        <th>Date & Time</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    int count = 0;
                    try (Connection con = DBConnection.getConnection()) {
                        PreparedStatement ps = con.prepareStatement(
                            "SELECT sf.id, f.orig_filename, u.name AS targetName, sf.shared_at, sf.status " +
                            "FROM shared_files sf " +
                            "JOIN files f ON sf.file_id = f.id " +
                            "JOIN users u ON sf.target_user_id = u.id " +
                            "WHERE sf.owner_id = ? ORDER BY sf.shared_at DESC"
                        );
                        ps.setInt(1, userId);
                        ResultSet rs = ps.executeQuery();
                        while (rs.next()) {
                %>
                    <tr>
                        <td><%= ++count %></td>
                        <td><%= rs.getString("orig_filename") %></td>
                        <td><%= rs.getString("targetName") %></td>
                        <td><%= rs.getTimestamp("shared_at") %></td>
                        <td>
                            <%
                                String status = rs.getString("status");
                                if ("ACCEPTED".equals(status)) {
                            %><span class="badge bg-success">Accepted</span><%
                                } else if ("REJECTED".equals(status)) {
                            %><span class="badge bg-danger">Rejected</span><%
                                } else {
                            %><span class="badge bg-warning text-dark">Pending</span><%
                                }
                            %>
                        </td>
                    </tr>
                <%
                        }
                        if (count == 0) {
                %>
                    <tr><td colspan="5" class="text-light">No shared files yet.</td></tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                    <tr><td colspan="5" class="text-danger">Error loading shared history</td></tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
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
