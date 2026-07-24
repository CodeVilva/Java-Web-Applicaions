<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*, securevault.DBConnection" %>
<%@ page session="true" %>

<%
String adminName = (String) session.getAttribute("adminName");
if (adminName == null) {
    response.sendRedirect("admin-login.jsp?msg=sessionExpired");
    return;
}

int totalShares = 0, accepted = 0, pending = 0, declined = 0, uniqueSenders = 0;
List<String> months = new ArrayList<>();
List<Integer> shareCounts = new ArrayList<>();

try (Connection con = DBConnection.getConnection()) {
    Statement st = con.createStatement();

    ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM shared_files");
    if (rs.next()) totalShares = rs.getInt(1); rs.close();

    rs = st.executeQuery("SELECT COUNT(*) FROM shared_files WHERE status='ACCEPTED'");
    if (rs.next()) accepted = rs.getInt(1); rs.close();

    rs = st.executeQuery("SELECT COUNT(*) FROM shared_files WHERE status='PENDING'");
    if (rs.next()) pending = rs.getInt(1); rs.close();

    rs = st.executeQuery("SELECT COUNT(*) FROM shared_files WHERE status='DECLINED'");
    if (rs.next()) declined = rs.getInt(1); rs.close();

    rs = st.executeQuery("SELECT COUNT(DISTINCT owner_id) FROM shared_files");
    if (rs.next()) uniqueSenders = rs.getInt(1); rs.close();

    // ✅ Monthly data (use shared_at safely)
    rs = st.executeQuery(
        "SELECT DATE_FORMAT(shared_at, '%b %Y') AS m, COUNT(*) AS c " +
        "FROM shared_files WHERE shared_at IS NOT NULL " +
        "GROUP BY m ORDER BY MIN(shared_at) ASC LIMIT 6");
    while (rs.next()) {
        months.add(rs.getString("m"));
        shareCounts.add(rs.getInt("c"));
    }
    rs.close();
} catch (Exception e) { e.printStackTrace(); }

// Convert to JS-safe arrays
StringBuilder monthJS = new StringBuilder("[");
for (int i = 0; i < months.size(); i++) {
    monthJS.append("\"").append(months.get(i)).append("\"");
    if (i < months.size() - 1) monthJS.append(",");
}
monthJS.append("]");

StringBuilder shareJS = new StringBuilder("[");
for (int i = 0; i < shareCounts.size(); i++) {
    shareJS.append(shareCounts.get(i));
    if (i < shareCounts.size() - 1) shareJS.append(",");
}
shareJS.append("]");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin - Shares | SecureVault</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<script src="chart.js"></script>
<style>
body{font-family:'Poppins',sans-serif;background:linear-gradient(135deg,#101d42 0%,#0f3460 50%,#16213e 100%);color:#fff;padding-top:80px;}
.navbar{background:rgba(255,255,255,0.08);border-bottom:1px solid rgba(255,255,255,0.1);backdrop-filter:blur(10px);}
.nav-link{color:#fff!important;border-radius:8px;}
.nav-link:hover,.nav-link.active{background:rgba(255,255,255,0.1);color:#00e0ff!important;}
.section{padding:50px 8%;}
.card-glass{background:rgba(255,255,255,0.07);border:1px solid rgba(255,255,255,0.15);border-radius:20px;text-align:center;padding:30px;
box-shadow:0 0 20px rgba(0,188,212,0.25);transition:0.3s;}
.card-glass:hover{transform:translateY(-5px);box-shadow:0 0 30px rgba(0,224,255,0.4);}
.card-glass i{font-size:2.4rem;color:#00e0ff;margin-bottom:10px;}
footer{background:rgba(255,255,255,0.05);color:#aaa;text-align:center;padding:10px;border-top:1px solid rgba(255,255,255,0.1);}
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
        <li class="nav-item"><a href="admin-files.jsp" class="nav-link"><i class="fa fa-file-shield"></i> Files</a></li>
        <li class="nav-item"><a href="admin-shares.jsp" class="nav-link active"><i class="fa fa-share-nodes"></i> Shares</a></li>
        <li class="nav-item"><a href="admin-downloads.jsp" class="nav-link"><i class="fa fa-download"></i> Downloads</a></li>
        <li class="nav-item"><a href="admin-reports.jsp" class="nav-link"><i class="fa fa-chart-pie"></i> Reports</a></li>
        <li class="nav-item"><a href="admin-login.jsp?msg=logout" class="nav-link text-danger"><i class="fa fa-sign-out-alt"></i> Logout</a></li>
      </ul>
    </div>
  </div>
</nav>

<section class="section">
  <h2 class="text-center text-info mb-4"><i class="fa-solid fa-share-nodes"></i> File Share Analytics</h2>

  <div class="row text-center g-4 mb-5">
    <div class="col-md-3"><div class="card-glass"><i class="fa-solid fa-share"></i><h3><%= totalShares %></h3><p>Total Shares</p></div></div>
    <div class="col-md-3"><div class="card-glass"><i class="fa-solid fa-circle-check text-success"></i><h3><%= accepted %></h3><p>Accepted</p></div></div>
    <div class="col-md-3"><div class="card-glass"><i class="fa-solid fa-hourglass-half text-warning"></i><h3><%= pending %></h3><p>Pending</p></div></div>
    <div class="col-md-3"><div class="card-glass"><i class="fa-solid fa-circle-xmark text-danger"></i><h3><%= declined %></h3><p>Declined</p></div></div>
  </div>

  <div class="card-glass mb-5">
    <h5 class="text-info"><i class="fa-solid fa-chart-line"></i> Shares Over the Last 6 Months</h5>
    <canvas id="sharesChart" height="120"></canvas>
  </div>

  <div class="card-glass">
    <h5 class="text-info"><i class="fa-solid fa-table"></i> Share Distribution by Sender</h5>
    <div class="table-responsive">
      <table class="table table-hover align-middle text-white">
        <thead>
          <tr><th>#</th><th>Sender ID</th><th>Total</th><th>Accepted</th><th>Pending</th><th>Declined</th></tr>
        </thead>
        <tbody>
          <%
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                   "SELECT owner_id, COUNT(*) AS total, " +
                   "SUM(CASE WHEN status='ACCEPTED' THEN 1 ELSE 0 END) AS acc, " +
                   "SUM(CASE WHEN status='PENDING' THEN 1 ELSE 0 END) AS pen, " +
                   "SUM(CASE WHEN status='DECLINED' THEN 1 ELSE 0 END) AS declined " +
                   "FROM shared_files GROUP BY owner_id ORDER BY total DESC");
                 ResultSet rs2 = ps.executeQuery()) {
                 int c=1;
                 while (rs2.next()) {
          %>
          <tr>
            <td><%= c++ %></td>
            <td><%= rs2.getInt("owner_id") %></td>
            <td><%= rs2.getInt("total") %></td>
            <td><%= rs2.getInt("acc") %></td>
            <td><%= rs2.getInt("pen") %></td>
            <td><%= rs2.getInt("declined") %></td>
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
const months = <%= monthJS.toString() %>;
const shares = <%= shareJS.toString() %>;
if (months.length > 0) {
  new Chart(document.getElementById('sharesChart'), {
    type:'bar',
    data:{
      labels: months,
      datasets:[{
        label:'Shares',
        data: shares,
        backgroundColor:'rgba(0,224,255,0.4)',
        borderColor:'#00e0ff',
        borderWidth:2
      }]
    },
    options:{
      scales:{y:{beginAtZero:true}},
      plugins:{legend:{labels:{color:'#fff'}}}
    }
  });
}
</script>
</body>
</html>
