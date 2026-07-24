<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%@ page import="java.sql.*,securevault.DBConnection" %>

<%
Integer userId = (Integer) session.getAttribute("userId");
String userName = (String) session.getAttribute("userName");
String userEmail = (String) session.getAttribute("userEmail");

if (userId == null) {
    response.sendRedirect("user-login.jsp?msg=sessionExpired");
    return;
}

String msg = request.getParameter("msg");

int sentCount = 0;
int receivedCount = 0;
try (Connection con = DBConnection.getConnection()) {
    PreparedStatement ps1 = con.prepareStatement("SELECT COUNT(*) FROM shared_files WHERE owner_id=?");
    ps1.setInt(1, userId);
    ResultSet rs1 = ps1.executeQuery();
    if (rs1.next()) sentCount = rs1.getInt(1);

    PreparedStatement ps2 = con.prepareStatement("SELECT COUNT(*) FROM shared_files WHERE target_user_id=?");
    ps2.setInt(1, userId);
    ResultSet rs2 = ps2.executeQuery();
    if (rs2.next()) receivedCount = rs2.getInt(1);
} catch (Exception e) { e.printStackTrace(); }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>User Dashboard | SecureVault</title>
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

<!-- Header -->
<section class="header-section">
  <% if ("welcome".equals(msg)) { %>
  <div class="alert alert-success">Welcome back, <b><%= userName %></b>!</div>
  <% } %>
  <h2>Hello, <%= userName %></h2>
  <p><i class="fa-solid fa-envelope"></i> <%= userEmail %></p>
  <p>Your SecureVault is ready. Encrypt, share and retrieve your files securely.</p>
</section>

<!-- Stats -->
<div class="stats-container">
  <div class="stat-card">
    <i class="fa-solid fa-paper-plane"></i>
    <h3><%= sentCount %></h3>
    <h5>Sent Files</h5>
  </div>
  <div class="stat-card">
    <i class="fa-solid fa-inbox"></i>
    <h3><%= receivedCount %></h3>
    <h5>Received Files</h5>
  </div>
</div>

<!-- Received Files Table -->
<div class="table-section">
  <div class="card-glass">
    <h4 class="mb-3"><i class="fa-solid fa-inbox"></i> Received Files</h4>
    <div class="table-responsive">
      <table class="table table-hover align-middle text-center">
        <thead>
          <tr>
            <th>#</th>
            <th>File Name</th>
            <th>Sender</th>
            <th>Date</th>
            <th>Status</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          <%
            int i = 0;
            try (Connection con = DBConnection.getConnection()) {
              PreparedStatement ps = con.prepareStatement(
                "SELECT sf.id, f.orig_filename, u.name AS sender, sf.shared_at, sf.status " +
                "FROM shared_files sf " +
                "JOIN files f ON sf.file_id=f.id " +
                "JOIN users u ON sf.owner_id=u.id " +
                "WHERE sf.target_user_id=? ORDER BY sf.shared_at DESC");
              ps.setInt(1, userId);
              ResultSet rs = ps.executeQuery();
              while (rs.next()) {
          %>
          <tr>
            <td><%= ++i %></td>
            <td><%= rs.getString("orig_filename") %></td>
            <td><%= rs.getString("sender") %></td>
            <td><%= rs.getTimestamp("shared_at") %></td>
            <td>
              <%
                String s = rs.getString("status");
                if ("ACCEPTED".equals(s)) {
              %><span class="badge bg-success">Accepted</span><%
                } else if ("REJECTED".equals(s)) {
              %><span class="badge bg-danger">Rejected</span><%
                } else {
              %><span class="badge bg-warning text-dark">Pending</span><%
                }
              %>
            </td>
            <td>
              <% if ("PENDING".equals(rs.getString("status"))) { %>
                <a href="UpdateShareStatusServlet?id=<%=rs.getInt("id")%>&status=ACCEPTED" class="btn btn-sm btn-success btn-action">
                  <i class="fa fa-check"></i> Accept
                </a>
                <a href="UpdateShareStatusServlet?id=<%=rs.getInt("id")%>&status=REJECTED" class="btn btn-sm btn-danger btn-action">
                  <i class="fa fa-times"></i> Reject
                </a>
              <% } else if ("ACCEPTED".equals(rs.getString("status"))) { %>
                <a href="DownloadStegoServlet?id=<%=rs.getInt("id")%>" class="btn btn-sm btn-info btn-action">
                  <i class="fa fa-image"></i> Download Stego
                </a>
                <a href="verify-stego-shared.jsp?fileId=<%=rs.getInt("id")%>" class="btn btn-sm btn-warning btn-action">
                  <i class="fa fa-lock-open"></i> Verify & Decrypt
                </a>
              <% } %>
            </td>
          </tr>
          <%
              }
              if (i == 0) {
          %>
          <tr><td colspan="6" class="text-light">No files received yet.</td></tr>
          <%
              }
            } catch (Exception e) {
              e.printStackTrace();
          %>
          <tr><td colspan="6" class="text-danger">Error loading received files.</td></tr>
          <%
            }
          %>
        </tbody>
      </table>
    </div>
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
<script src="bootstrap.bundle.min.js"></script>
</body>
</html>
