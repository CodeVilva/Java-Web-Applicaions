<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*, java.time.*, java.time.format.DateTimeFormatter, securevault.DBConnection" %>
<%@ page session="true" %>
<%
    // ---- Auth guard ----
    String adminName = (String) session.getAttribute("adminName");
    if (adminName == null) {
        response.sendRedirect("admin-login.jsp?msg=sessionExpired");
        return;
    }

    // ---- Top-level KPIs ----
    int totalUsers = 0, totalFiles = 0, totalShares = 0, totalDownloads = 0;
    long totalFileSize = 0;
    double avgFileSize = 0;
    int selfDecrypts = 0, sharedDecrypts = 0;

    // ---- Build last 6 month buckets (labels + zero values) ----
    DateTimeFormatter keyFmt = DateTimeFormatter.ofPattern("yyyy-MM");     // map key
    DateTimeFormatter niceFmt = DateTimeFormatter.ofPattern("MMM yyyy");   // label shown
    LinkedHashMap<String,String> monthKeyToLabel = new LinkedHashMap<>();  // key -> "MMM yyyy"
    LinkedHashMap<String,Integer> uploadsByMonth   = new LinkedHashMap<>();
    LinkedHashMap<String,Integer> sharesByMonth    = new LinkedHashMap<>();
    LinkedHashMap<String,Integer> downloadsByMonth = new LinkedHashMap<>();

    YearMonth nowYM = YearMonth.now();
    for (int i = 5; i >= 0; i--) {
        YearMonth ym = nowYM.minusMonths(i);
        String key   = ym.format(keyFmt);     // e.g., 2025-05
        String label = ym.atDay(1).format(niceFmt); // e.g., May 2025
        monthKeyToLabel.put(key, label);
        uploadsByMonth.put(key, 0);
        sharesByMonth.put(key, 0);
        downloadsByMonth.put(key, 0);
    }

    // ---- Query DB and fill metrics ----
    try (Connection con = DBConnection.getConnection();
         Statement st = con.createStatement()) {

        // KPIs
        try (ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM users")) { if (rs.next()) totalUsers = rs.getInt(1); }
        try (ResultSet rs = st.executeQuery("SELECT COUNT(*), IFNULL(SUM(size_bytes),0), IFNULL(AVG(size_bytes),0) FROM files")) {
            if (rs.next()) { totalFiles = rs.getInt(1); totalFileSize = rs.getLong(2); avgFileSize = rs.getDouble(3); }
        }
        try (ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM shared_files")) { if (rs.next()) totalShares = rs.getInt(1); }
        try (ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM download_history")) { if (rs.next()) totalDownloads = rs.getInt(1); }
        try (ResultSet rs = st.executeQuery(
            "SELECT " +
            "SUM(CASE WHEN share_id IS NULL THEN 1 ELSE 0 END) AS selfD, " +
            "SUM(CASE WHEN share_id IS NOT NULL THEN 1 ELSE 0 END) AS sharedD " +
            "FROM download_history")) {
            if (rs.next()) { selfDecrypts = rs.getInt("selfD"); sharedDecrypts = rs.getInt("sharedD"); }
        }

        // Uploads grouped by month (last 6 months)
        try (PreparedStatement ps = con.prepareStatement(
            "SELECT DATE_FORMAT(created_at, '%Y-%m') ym, COUNT(*) cnt " +
            "FROM files " +
            "WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) " +
            "GROUP BY ym ORDER BY ym")) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String ym = rs.getString("ym");
                    if (uploadsByMonth.containsKey(ym)) uploadsByMonth.put(ym, rs.getInt("cnt"));
                }
            }
        }

        // Shares grouped by month (last 6 months)
        try (PreparedStatement ps = con.prepareStatement(
            "SELECT DATE_FORMAT(action_at, '%Y-%m') ym, COUNT(*) cnt " +
            "FROM shared_files " +
            "WHERE action_at >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) " +
            "GROUP BY ym ORDER BY ym")) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String ym = rs.getString("ym");
                    if (sharesByMonth.containsKey(ym)) sharesByMonth.put(ym, rs.getInt("cnt"));
                }
            }
        }

        // Downloads grouped by month (last 6 months)
        try (PreparedStatement ps = con.prepareStatement(
            "SELECT DATE_FORMAT(downloaded_at, '%Y-%m') ym, COUNT(*) cnt " +
            "FROM download_history " +
            "WHERE downloaded_at >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) " +
            "GROUP BY ym ORDER BY ym"))
            
            {
            System.out.println("className.methodName() Check1");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String ym = rs.getString("ym");
                    if (downloadsByMonth.containsKey(ym)) downloadsByMonth.put(ym, rs.getInt("cnt"));
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    // ---- Prepare JS arrays (labels & data) ----
    StringBuilder labelsJs = new StringBuilder("[");
    StringBuilder uploadsJs = new StringBuilder("[");
    StringBuilder sharesJs  = new StringBuilder("[");
    StringBuilder dloadsJs  = new StringBuilder("[");

    int idx = 0, size = monthKeyToLabel.size();
    for (Map.Entry<String,String> e : monthKeyToLabel.entrySet()) {
        String key = e.getKey();
        String lbl = e.getValue();
        labelsJs.append("'").append(lbl).append("'");
        uploadsJs.append(uploadsByMonth.get(key));
        sharesJs.append(sharesByMonth.get(key));
        dloadsJs.append(downloadsByMonth.get(key));
        if (++idx < size) { labelsJs.append(","); uploadsJs.append(","); sharesJs.append(","); dloadsJs.append(","); }
    }
    labelsJs.append("]"); uploadsJs.append("]"); sharesJs.append("]"); dloadsJs.append("]");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin Dashboard | SecureVault</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<script src="chart.js"></script>

<style>
body {
  font-family:'Poppins',sans-serif;
  background:linear-gradient(135deg,#101d42 0%,#0f3460 50%,#16213e 100%);
  color:#fff; padding-top:80px; padding-bottom:90px;
}
.navbar{background:rgba(255,255,255,0.08);border-bottom:1px solid rgba(255,255,255,0.1);backdrop-filter:blur(10px);}
.navbar-brand{font-weight:700;color:#00e0ff!important;}
.nav-link{color:#fff!important;border-radius:10px;margin:0 6px;}
.nav-link:hover,.nav-link.active{background:rgba(255,255,255,0.1);color:#00bcd4!important;}
.section{padding:50px 8%;}
.card-glass{background:rgba(255,255,255,0.07);border:1px solid rgba(255,255,255,0.15);border-radius:20px;text-align:center;padding:28px;box-shadow:0 0 20px rgba(0,188,212,0.25);transition:0.3s;}
.card-glass:hover{transform:translateY(-5px);box-shadow:0 0 30px rgba(0,224,255,0.4);}
.card-glass i{font-size:2.3rem;color:#00e0ff;margin-bottom:10px;}
footer{background:rgba(255,255,255,0.05);color:#aaa;text-align:center;padding:10px;border-top:1px solid rgba(255,255,255,0.1);}
.small-muted{color:#cfd8dc;font-size:.9rem;}
</style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg fixed-top px-4">
  <div class="container-fluid">
    <a class="navbar-brand" href="admin-dashboard.jsp"><i class="fa-solid fa-shield-halved"></i> SecureVault Admin</a>
    <button class="navbar-toggler text-white border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
      <i class="fa-solid fa-bars"></i>
    </button>
    <div class="collapse navbar-collapse justify-content-end" id="navMenu">
      <ul class="navbar-nav">
        <li class="nav-item"><a href="admin-dashboard.jsp" class="nav-link active"><i class="fa fa-home"></i> Dashboard</a></li>
        <li class="nav-item"><a href="admin-users.jsp" class="nav-link"><i class="fa fa-users"></i> Users</a></li>
        <li class="nav-item"><a href="admin-files.jsp" class="nav-link"><i class="fa fa-file-shield"></i> Files</a></li>
        <li class="nav-item"><a href="admin-shares.jsp" class="nav-link"><i class="fa fa-share-nodes"></i> Shares</a></li>
        <li class="nav-item"><a href="admin-downloads.jsp" class="nav-link"><i class="fa fa-download"></i> Downloads</a></li>
        <li class="nav-item"><a href="admin-reports.jsp" class="nav-link"><i class="fa fa-chart-pie"></i> Reports</a></li>
        <li class="nav-item"><a href="admin-login.jsp?msg=logout" class="nav-link text-danger"><i class="fa fa-sign-out-alt"></i> Logout</a></li>
      </ul>
    </div>
  </div>
</nav>

<!-- DASHBOARD -->
<section class="section">
  <h2 class="text-center text-info mb-4"><i class="fa-solid fa-chart-line"></i> Analytics Overview</h2>

  <!-- KPI Row -->
  <div class="row text-center g-4">
    <div class="col-md-3"><div class="card-glass">
      <i class="fa-solid fa-users"></i><h3><%= totalUsers %></h3><p>Total Users</p>
    </div></div>
    <div class="col-md-3"><div class="card-glass">
      <i class="fa-solid fa-file-shield"></i><h3><%= totalFiles %></h3><p>Encrypted Files</p>
    </div></div>
    <div class="col-md-3"><div class="card-glass">
      <i class="fa-solid fa-share-nodes"></i><h3><%= totalShares %></h3><p>Shared Files</p>
    </div></div>
    <div class="col-md-3"><div class="card-glass">
      <i class="fa-solid fa-download"></i><h3><%= totalDownloads %></h3><p>Total Downloads</p>
    </div></div>
  </div>

  <!-- Secondary Stats -->
  <div class="row mt-4 text-center g-4">
    <div class="col-md-4"><div class="card-glass">
      <i class="fa-solid fa-database"></i><h4><%= totalFileSize/1024 %> KB</h4><p>Total File Size</p>
      <div class="small-muted">Sum of encrypted file sizes</div>
    </div></div>
    <div class="col-md-4"><div class="card-glass">
      <i class="fa-solid fa-calculator"></i><h4><%= String.format("%.2f", avgFileSize/1024) %> KB</h4><p>Average File Size</p>
      <div class="small-muted">Average size of encrypted files</div>
    </div></div>
    <div class="col-md-4"><div class="card-glass">
      <i class="fa-solid fa-unlock"></i><h4><%= selfDecrypts %> / <%= sharedDecrypts %></h4><p>Self vs Shared Decrypts</p>
      <div class="small-muted">Download history split</div>
    </div></div>
  </div>

  <!-- Charts -->
  <div class="row mt-5 g-4">
    <div class="col-md-6">
      <div class="card-glass">
        <h5>📈 Uploads (Last 6 Months)</h5>
        <canvas id="uploadChart" height="120"></canvas>
      </div>
    </div>
    <div class="col-md-6">
      <div class="card-glass">
        <h5>📊 Shares vs Downloads (Last 6 Months)</h5>
        <canvas id="shareChart" height="120"></canvas>
      </div>
    </div>
  </div>
</section>

<!-- FOOTER -->
<footer class="fixed-bottom">
  © <%= java.time.Year.now() %> SecureVault | Analytics Console
</footer>

<script src="bootstrap.bundle.min.js"></script>

<script>
/* Data embedded from JSP (option 1) */
const labels   = <%= labelsJs.toString() %>;
const uploads  = <%= uploadsJs.toString() %>;
const shares   = <%= sharesJs.toString() %>;
const downloads= <%= dloadsJs.toString() %>;

/* Guard: avoid empty datasets */
const fallback = (arr) => (arr && arr.length ? arr : [0,0,0,0,0,0]);

/* Upload chart */
new Chart(document.getElementById('uploadChart').getContext('2d'), {
  type: 'line',
  data: {
    labels: labels.length ? labels : ['','','','','',''],
    datasets: [{
      label: 'Uploads',
      data: fallback(uploads),
      borderColor: '#00e0ff',
      backgroundColor: 'rgba(0,224,255,0.2)',
      tension: 0.35,
      fill: true,
      pointRadius: 3
    }]
  },
  options: { responsive: true, scales: { y: { beginAtZero: true } }, plugins: { legend: { display: false } } }
});

/* Shares vs Downloads */
new Chart(document.getElementById('shareChart').getContext('2d'), {
  type: 'bar',
  data: {
    labels: labels.length ? labels : ['','','','','',''],
    datasets: [
      { label: 'Shares',    data: fallback(shares),    backgroundColor: 'rgba(0,188,212,0.7)' },
      { label: 'Downloads', data: fallback(downloads), backgroundColor: 'rgba(76,175,80,0.7)' }
    ]
  },
  options: { responsive: true, scales: { y: { beginAtZero: true } } }
});
</script>
</body>
</html>
