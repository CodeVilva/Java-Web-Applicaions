<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*, securevault.DBConnection" %>
<%@ page session="true" %>

<%
    String adminName = (String) session.getAttribute("adminName");
    if (adminName == null) {
        response.sendRedirect("admin-login.jsp?msg=sessionExpired");
        return;
    }

    int totalFiles = 0;
    long totalSize = 0;
    double avgSize = 0;
    int activeFiles = 0;
    int encryptedFiles = 0;
    int usersWithFiles = 0;

    LinkedHashMap<String,Integer> monthlyUploads = new LinkedHashMap<>();
    List<String> months = new ArrayList<>();
    List<Integer> counts = new ArrayList<>();

    try (Connection con = DBConnection.getConnection()) {
        Statement st = con.createStatement();

        ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM files");
        if (rs.next()) totalFiles = rs.getInt(1);
        rs.close();

        rs = st.executeQuery("SELECT SUM(size_bytes), AVG(size_bytes) FROM files");
        if (rs.next()) {
            totalSize = rs.getLong(1);
            avgSize = rs.getDouble(2);
        }
        rs.close();

        rs = st.executeQuery("SELECT COUNT(DISTINCT user_id) FROM files");
        if (rs.next()) usersWithFiles = rs.getInt(1);
        rs.close();

        rs = st.executeQuery("SELECT COUNT(*) FROM files WHERE status='ENCRYPTED'");
        if (rs.next()) encryptedFiles = rs.getInt(1);
        rs.close();

        rs = st.executeQuery("SELECT COUNT(*) FROM files WHERE status='ACTIVE'");
        if (rs.next()) activeFiles = rs.getInt(1);
        rs.close();

        rs = st.executeQuery("SELECT DATE_FORMAT(created_at, '%b %Y') m, COUNT(*) c FROM files GROUP BY m ORDER BY MIN(created_at) ASC LIMIT 6");
        while (rs.next()) {
            months.add(rs.getString("m"));
            counts.add(rs.getInt("c"));
        }
        rs.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin - Files | SecureVault</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<script src="chart.js"></script>
<style>
body {
  font-family:'Poppins',sans-serif;
  background:linear-gradient(135deg,#101d42 0%,#0f3460 50%,#16213e 100%);
  color:#fff;
  padding-top:80px;
}
.navbar {
  background:rgba(255,255,255,0.08);
  border-bottom:1px solid rgba(255,255,255,0.1);
  backdrop-filter:blur(10px);
}
.nav-link {
  color:#fff!important;
  border-radius:8px;
}
.nav-link:hover, .nav-link.active {
  background:rgba(255,255,255,0.1);
  color:#00e0ff!important;
}
.section {
  padding:50px 8%;
}
.card-glass {
  background:rgba(255,255,255,0.07);
  border:1px solid rgba(255,255,255,0.15);
  border-radius:20px;
  text-align:center;
  padding:30px;
  box-shadow:0 0 20px rgba(0,188,212,0.25);
  transition:0.3s;
}
.card-glass:hover {
  transform:translateY(-5px);
  box-shadow:0 0 30px rgba(0,224,255,0.4);
}
.card-glass i {
  font-size:2.4rem;
  color:#00e0ff;
  margin-bottom:10px;
}
footer {
  background:rgba(255,255,255,0.05);
  color:#aaa;
  text-align:center;
  padding:10px;
  border-top:1px solid rgba(255,255,255,0.1);
}
</style>
</head>

<body>
<nav class="navbar navbar-expand-lg fixed-top px-4">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold text-info" href="admin-dashboard.jsp">
      <i class="fa-solid fa-shield-halved"></i> SecureVault Admin
    </a>
    <button class="navbar-toggler text-white border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
      <i class="fa-solid fa-bars"></i>
    </button>
    <div class="collapse navbar-collapse justify-content-end" id="navMenu">
      <ul class="navbar-nav">
        <li class="nav-item"><a href="admin-dashboard.jsp" class="nav-link"><i class="fa fa-home"></i> Dashboard</a></li>
        <li class="nav-item"><a href="admin-users.jsp" class="nav-link"><i class="fa fa-users"></i> Users</a></li>
        <li class="nav-item"><a href="admin-files.jsp" class="nav-link active"><i class="fa fa-file-shield"></i> Files</a></li>
        <li class="nav-item"><a href="admin-shares.jsp" class="nav-link"><i class="fa fa-share-nodes"></i> Shares</a></li>
        <li class="nav-item"><a href="admin-downloads.jsp" class="nav-link"><i class="fa fa-download"></i> Downloads</a></li>
        <li class="nav-item"><a href="admin-reports.jsp" class="nav-link"><i class="fa fa-chart-pie"></i> Reports</a></li>
        <li class="nav-item"><a href="admin-login.jsp?msg=logout" class="nav-link text-danger"><i class="fa fa-sign-out-alt"></i> Logout</a></li>
      </ul>
    </div>
  </div>
</nav>

<section class="section">
  <h2 class="text-center text-info mb-4"><i class="fa-solid fa-file-shield"></i> File Analytics</h2>

  <div class="row text-center g-4 mb-5">
    <div class="col-md-3"><div class="card-glass"><i class="fa-solid fa-database"></i><h3><%= totalFiles %></h3><p>Total Files</p></div></div>
    <div class="col-md-3"><div class="card-glass"><i class="fa-solid fa-user"></i><h3><%= usersWithFiles %></h3><p>Users with Files</p></div></div>
    <div class="col-md-3"><div class="card-glass"><i class="fa-solid fa-lock"></i><h3><%= encryptedFiles %></h3><p>Encrypted Files</p></div></div>
    <div class="col-md-3"><div class="card-glass"><i class="fa-solid fa-chart-bar"></i><h3><%= activeFiles %></h3><p>Active Files</p></div></div>
  </div>

  <div class="row text-center g-4 mb-5">
    <div class="col-md-6"><div class="card-glass"><i class="fa-solid fa-weight-hanging"></i><h4><%= totalSize/1024 %> KB</h4><p>Total File Size</p></div></div>
    <div class="col-md-6"><div class="card-glass"><i class="fa-solid fa-calculator"></i><h4><%= String.format("%.2f", avgSize/1024) %> KB</h4><p>Average File Size</p></div></div>
  </div>

  

  <div class="card-glass">
    <h5 class="text-info"><i class="fa-solid fa-table"></i> File Distribution by Users</h5>
    <div class="table-responsive">
      <table class="table table-hover align-middle text-white">
        <thead>
          <tr>
            <th>#</th>
            <th>User ID</th>
            <th>Total Files</th>
            <th>Total Size (KB)</th>
            <th>Last Upload</th>
          </tr>
        </thead>
        <tbody>
          <%
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                   "SELECT user_id, COUNT(*) AS cnt, SUM(size_bytes)/1024 AS kb, MAX(created_at) AS last_date FROM files GROUP BY user_id ORDER BY last_date DESC");
                 ResultSet rs2 = ps.executeQuery()) {
                 int c = 1;
                 while (rs2.next()) {
          %>
          <tr>
            <td><%= c++ %></td>
            <td><%= rs2.getInt("user_id") %></td>
            <td><%= rs2.getInt("cnt") %></td>
            <td><%= rs2.getLong("kb") %></td>
            <td><%= rs2.getTimestamp("last_date") %></td>
          </tr>
          <% } } catch (Exception e) { e.printStackTrace(); } %>
        </tbody>
      </table>
    </div>
  </div>
</section>

<footer class="fixed-bottom">
  © <%= java.time.Year.now() %> SecureVault | Analytics Console
</footer>

<script src="bootstrap.bundle.min.js"></script>
<script>
const months = <%= months.toString() %>;
const counts = <%= counts.toString() %>;
new Chart(document.getElementById('uploadChart'), {
  type:'line',
  data:{labels:months,datasets:[{label:'Uploads',data:counts,borderColor:'#00e0ff',backgroundColor:'rgba(0,224,255,0.25)',fill:true,tension:0.4}]},
  options:{plugins:{legend:{display:false}},scales:{y:{beginAtZero:true}}}
});
</script>
</body>
</html>
