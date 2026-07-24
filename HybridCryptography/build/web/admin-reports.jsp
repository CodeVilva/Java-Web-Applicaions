<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*, securevault.DBConnection" %>
<%@ page session="true" %>

<%
String adminName = (String) session.getAttribute("adminName");
if (adminName == null) {
    response.sendRedirect("admin-login.jsp?msg=sessionExpired");
    return;
}

int totalFiles = 0, totalShares = 0, totalDownloads = 0, totalUsers = 0;
List<String> months = new ArrayList<>();
List<Integer> fileCounts = new ArrayList<>();
List<Integer> shareCounts = new ArrayList<>();
List<Integer> downloadCounts = new ArrayList<>();

try (Connection con = DBConnection.getConnection()) {
    Statement st = con.createStatement();

    ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM users");
    if (rs.next()) totalUsers = rs.getInt(1);
    rs.close();

    rs = st.executeQuery("SELECT COUNT(*) FROM files");
    if (rs.next()) totalFiles = rs.getInt(1);
    rs.close();

    rs = st.executeQuery("SELECT COUNT(*) FROM shared_files");
    if (rs.next()) totalShares = rs.getInt(1);
    rs.close();

    rs = st.executeQuery("SELECT COUNT(*) FROM download_history");
    if (rs.next()) totalDownloads = rs.getInt(1);
    rs.close();

    // File upload trend (6 months)
    rs = st.executeQuery(
        "SELECT DATE_FORMAT(created_at, '%b %Y') m, COUNT(*) c " +
        "FROM files GROUP BY m ORDER BY MIN(created_at) ASC LIMIT 6");
    while (rs.next()) {
        months.add(rs.getString("m"));
        fileCounts.add(rs.getInt("c"));
    }
    rs.close();

    // Share trend
    rs = st.executeQuery(
        "SELECT DATE_FORMAT(shared_at, '%b %Y') m, COUNT(*) c " +
        "FROM shared_files GROUP BY m ORDER BY MIN(shared_at) ASC LIMIT 6");
    while (rs.next()) shareCounts.add(rs.getInt("c"));
    rs.close();

    // Download trend
    rs = st.executeQuery(
        "SELECT DATE_FORMAT(downloaded_at, '%b %Y') m, COUNT(*) c " +
        "FROM download_history GROUP BY m ORDER BY MIN(downloaded_at) ASC LIMIT 6");
    while (rs.next()) downloadCounts.add(rs.getInt("c"));
    rs.close();
} catch (Exception e) {
    e.printStackTrace();
}

// Prepare JavaScript-safe arrays
StringBuilder jsMonths = new StringBuilder("[");
for (int i = 0; i < months.size(); i++) {
    jsMonths.append("\"").append(months.get(i)).append("\"");
    if (i < months.size() - 1) jsMonths.append(",");
}
jsMonths.append("]");

StringBuilder jsFiles = new StringBuilder("[");
for (int i = 0; i < fileCounts.size(); i++) {
    jsFiles.append(fileCounts.get(i));
    if (i < fileCounts.size() - 1) jsFiles.append(",");
}
jsFiles.append("]");

StringBuilder jsShares = new StringBuilder("[");
for (int i = 0; i < shareCounts.size(); i++) {
    jsShares.append(shareCounts.get(i));
    if (i < shareCounts.size() - 1) jsShares.append(",");
}
jsShares.append("]");

StringBuilder jsDownloads = new StringBuilder("[");
for (int i = 0; i < downloadCounts.size(); i++) {
    jsDownloads.append(downloadCounts.get(i));
    if (i < downloadCounts.size() - 1) jsDownloads.append(",");
}
jsDownloads.append("]");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin Reports | SecureVault</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<script src="chart.js"></script>
<style>
body { font-family:'Poppins',sans-serif;background:linear-gradient(135deg,#101d42 0%,#0f3460 50%,#16213e 100%);color:#fff;padding-top:80px; }
.navbar { background:rgba(255,255,255,0.08);border-bottom:1px solid rgba(255,255,255,0.1);backdrop-filter:blur(10px); }
.nav-link { color:#fff!important;border-radius:8px; }
.nav-link:hover,.nav-link.active { background:rgba(255,255,255,0.1);color:#00e0ff!important; }
.section { padding:50px 8%; }
.card-glass { background:rgba(255,255,255,0.07);border:1px solid rgba(255,255,255,0.15);border-radius:20px;text-align:center;padding:30px;box-shadow:0 0 20px rgba(0,188,212,0.25);transition:0.3s; }
.card-glass:hover { transform:translateY(-5px);box-shadow:0 0 30px rgba(0,224,255,0.4); }
.card-glass i { font-size:2.4rem;color:#00e0ff;margin-bottom:10px; }
footer { background:rgba(255,255,255,0.05);color:#aaa;text-align:center;padding:10px;border-top:1px solid rgba(255,255,255,0.1); }
canvas { background:rgba(255,255,255,0.03);border-radius:10px;padding:10px; }
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
        <li class="nav-item"><a href="admin-shares.jsp" class="nav-link"><i class="fa fa-share-nodes"></i> Shares</a></li>
        <li class="nav-item"><a href="admin-downloads.jsp" class="nav-link"><i class="fa fa-download"></i> Downloads</a></li>
        <li class="nav-item"><a href="admin-reports.jsp" class="nav-link active"><i class="fa fa-chart-pie"></i> Reports</a></li>
        <li class="nav-item"><a href="admin-login.jsp?msg=logout" class="nav-link text-danger"><i class="fa fa-sign-out-alt"></i> Logout</a></li>
      </ul>
    </div>
  </div>
</nav>

<section class="section">
  <h2 class="text-center text-info mb-4"><i class="fa-solid fa-chart-pie"></i> System Analytics Overview</h2>

  <!-- Summary Cards -->
  <div class="row text-center g-4 mb-5">
    <div class="col-md-3"><div class="card-glass"><i class="fa-solid fa-users"></i><h3><%= totalUsers %></h3><p>Total Users</p></div></div>
    <div class="col-md-3"><div class="card-glass"><i class="fa-solid fa-file-shield"></i><h3><%= totalFiles %></h3><p>Encrypted Files</p></div></div>
    <div class="col-md-3"><div class="card-glass"><i class="fa-solid fa-share-nodes"></i><h3><%= totalShares %></h3><p>Files Shared</p></div></div>
    <div class="col-md-3"><div class="card-glass"><i class="fa-solid fa-download"></i><h3><%= totalDownloads %></h3><p>Total Downloads</p></div></div>
  </div>

  <!-- Main Trend Chart -->
  <div class="card-glass mb-5">
    <h5 class="text-info"><i class="fa-solid fa-chart-line"></i> 6-Month Trend Comparison</h5>
    <canvas id="trendChart" height="150"></canvas>
  </div>

  <!-- Additional Charts -->
  <div class="row g-4 mb-5">
    <div class="col-md-6">
      <div class="card-glass">
        <h5 class="text-info"><i class="fa-solid fa-chart-pie"></i> Data Distribution</h5>
        <canvas id="pieChart" height="260"></canvas>
      </div>
    </div>
    <div class="col-md-6">
      <div class="card-glass">
        <h5 class="text-info"><i class="fa-solid fa-chart-radar"></i> Activity Balance Radar</h5>
        <canvas id="radarChart" height="260"></canvas>
      </div>
    </div>
  </div>

  <div class="card-glass mb-5">
    <h5 class="text-info"><i class="fa-solid fa-chart-bar"></i> Total Operation Comparison</h5>
    <canvas id="barChart" height="160"></canvas>
  </div>

  <!-- Table -->
  <div class="card-glass">
    <h5 class="text-info"><i class="fa-solid fa-table"></i> Monthly Activity Summary</h5>
    <table class="table table-hover text-white align-middle">
      <thead>
        <tr><th>Month</th><th>Files</th><th>Shares</th><th>Downloads</th></tr>
      </thead>
      <tbody>
      <% for (int i = 0; i < months.size(); i++) { %>
        <tr>
          <td><%= months.get(i) %></td>
          <td><%= i < fileCounts.size() ? fileCounts.get(i) : 0 %></td>
          <td><%= i < shareCounts.size() ? shareCounts.get(i) : 0 %></td>
          <td><%= i < downloadCounts.size() ? downloadCounts.get(i) : 0 %></td>
        </tr>
      <% } %>
      </tbody>
    </table>
  </div>
</section>

<footer class="fixed-bottom">
  © <%= java.time.Year.now() %> SecureVault | Analytics Console
</footer>

<script src="bootstrap.bundle.min.js"></script>
<script>
const months = <%= jsMonths.toString() %>;
const files = <%= jsFiles.toString() %>;
const shares = <%= jsShares.toString() %>;
const downloads = <%= jsDownloads.toString() %>;

/* ---- Mixed Trend Chart ---- */
new Chart(document.getElementById('trendChart'), {
  data: {
    labels: months,
    datasets: [
      { type:'bar', label:'Files Uploaded', data:files, backgroundColor:'rgba(0,224,255,0.4)', borderColor:'#00e0ff', borderWidth:2, borderRadius:6 },
      { type:'line', label:'Files Shared', data:shares, borderColor:'#4CAF50', backgroundColor:'rgba(76,175,80,0.15)', tension:0.4, fill:true },
      { type:'line', label:'Downloads', data:downloads, borderColor:'#FFC107', borderDash:[6,6], backgroundColor:'rgba(255,193,7,0.15)', tension:0.4, fill:true }
    ]
  },
  options:{ scales:{y:{beginAtZero:true,ticks:{color:'#fff'}}}, plugins:{legend:{labels:{color:'#fff'}}}}
});

/* ---- Pie Chart ---- */
new Chart(document.getElementById('pieChart'), {
  type:'pie',
  data:{
    labels:['Users','Files','Shares','Downloads'],
    datasets:[{
      data:[<%= totalUsers %>,<%= totalFiles %>,<%= totalShares %>,<%= totalDownloads %>],
      backgroundColor:['#00e0ff','#4CAF50','#FFC107','#E91E63']
    }]
  },
  options:{ plugins:{legend:{labels:{color:'#fff'}}}}
});

/* ---- Radar Chart ---- */
new Chart(document.getElementById('radarChart'), {
  type:'radar',
  data:{
    labels:['Files','Shares','Downloads','Users'],
    datasets:[{
      label:'Activity Index',
      data:[<%= totalFiles %>,<%= totalShares %>,<%= totalDownloads %>,<%= totalUsers %>],
      fill:true,
      backgroundColor:'rgba(0,224,255,0.2)',
      borderColor:'#00e0ff',
      pointBackgroundColor:'#4CAF50'
    }]
  },
  options:{
    scales:{r:{angleLines:{color:'rgba(255,255,255,0.1)'},grid:{color:'rgba(255,255,255,0.2)'},pointLabels:{color:'#fff'}}},
    plugins:{legend:{labels:{color:'#fff'}}}
  }
});

/* ---- Horizontal Bar Chart ---- */
new Chart(document.getElementById('barChart'), {
  type:'bar',
  data:{
    labels:['Files','Shares','Downloads','Users'],
    datasets:[{
      label:'Total Counts',
      data:[<%= totalFiles %>,<%= totalShares %>,<%= totalDownloads %>,<%= totalUsers %>],
      backgroundColor:['rgba(0,224,255,0.6)','rgba(76,175,80,0.6)','rgba(255,193,7,0.6)','rgba(233,30,99,0.6)']
    }]
  },
  options:{
    indexAxis:'y',
    scales:{x:{ticks:{color:'#fff'}},y:{ticks:{color:'#fff'}}},
    plugins:{legend:{labels:{color:'#fff'}}}
  }
});
</script>
</body>
</html>
