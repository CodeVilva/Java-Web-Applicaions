<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*, securevault.DBConnection" %>
<%@ page session="true" %>

<%
String adminName = (String) session.getAttribute("adminName");
if (adminName == null) {
    response.sendRedirect("admin-login.jsp?msg=sessionExpired");
    return;
}

int totalDownloads = 0, selfDownloads = 0, sharedDownloads = 0, uniqueUsers = 0;
List<String> months = new ArrayList<>();
List<Integer> totalCounts = new ArrayList<>();
List<Integer> selfCounts = new ArrayList<>();
List<Integer> sharedCounts = new ArrayList<>();

try (Connection con = DBConnection.getConnection()) {
    Statement st = con.createStatement();

    // Totals
    ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM download_history");
    if (rs.next()) totalDownloads = rs.getInt(1); rs.close();

    rs = st.executeQuery("SELECT COUNT(*) FROM download_history WHERE share_id IS NULL");
    if (rs.next()) selfDownloads = rs.getInt(1); rs.close();

    rs = st.executeQuery("SELECT COUNT(*) FROM download_history WHERE share_id IS NOT NULL");
    if (rs.next()) sharedDownloads = rs.getInt(1); rs.close();

    rs = st.executeQuery("SELECT COUNT(DISTINCT user_id) FROM download_history");
    if (rs.next()) uniqueUsers = rs.getInt(1); rs.close();

    // 6-month trend comparison (total, self, shared)
    rs = st.executeQuery(
        "SELECT DATE_FORMAT(downloaded_at, '%b %Y') AS m, " +
        "COUNT(*) AS total, " +
        "SUM(CASE WHEN share_id IS NULL THEN 1 ELSE 0 END) AS self_d, " +
        "SUM(CASE WHEN share_id IS NOT NULL THEN 1 ELSE 0 END) AS shared_d " +
        "FROM download_history WHERE downloaded_at IS NOT NULL " +
        "GROUP BY m ORDER BY MIN(downloaded_at) ASC LIMIT 6");

    while (rs.next()) {
        months.add(rs.getString("m"));
        totalCounts.add(rs.getInt("total"));
        selfCounts.add(rs.getInt("self_d"));
        sharedCounts.add(rs.getInt("shared_d"));
    }
    rs.close();
} catch (Exception e) { e.printStackTrace(); }

// Convert lists to JSON-style arrays
StringBuilder monthJS = new StringBuilder("[");
for (int i = 0; i < months.size(); i++) {
    monthJS.append("\"").append(months.get(i)).append("\"");
    if (i < months.size() - 1) monthJS.append(",");
}
monthJS.append("]");

StringBuilder totalJS = new StringBuilder("[");
StringBuilder selfJS = new StringBuilder("[");
StringBuilder sharedJS = new StringBuilder("[");
for (int i = 0; i < totalCounts.size(); i++) {
    totalJS.append(totalCounts.get(i));
    selfJS.append(selfCounts.get(i));
    sharedJS.append(sharedCounts.get(i));
    if (i < totalCounts.size() - 1) { totalJS.append(","); selfJS.append(","); sharedJS.append(","); }
}
totalJS.append("]");
selfJS.append("]");
sharedJS.append("]");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin - Downloads | SecureVault</title>
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
  color:#fff!important;border-radius:8px;
}
.nav-link:hover,.nav-link.active {
  background:rgba(255,255,255,0.1);color:#00e0ff!important;
}
.section { padding:50px 8%; }
.card-glass {
  background:rgba(255,255,255,0.07);
  border:1px solid rgba(255,255,255,0.15);
  border-radius:20px;text-align:center;
  padding:30px;box-shadow:0 0 20px rgba(0,188,212,0.25);
  transition:0.3s;
}
.card-glass:hover { transform:translateY(-5px);box-shadow:0 0 30px rgba(0,224,255,0.4); }
.card-glass i { font-size:2.4rem;color:#00e0ff;margin-bottom:10px; }
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
        <li class="nav-item"><a href="admin-files.jsp" class="nav-link"><i class="fa fa-file-shield"></i> Files</a></li>
        <li class="nav-item"><a href="admin-shares.jsp" class="nav-link"><i class="fa fa-share-nodes"></i> Shares</a></li>
        <li class="nav-item"><a href="admin-downloads.jsp" class="nav-link active"><i class="fa fa-download"></i> Downloads</a></li>
        <li class="nav-item"><a href="admin-reports.jsp" class="nav-link"><i class="fa fa-chart-pie"></i> Reports</a></li>
        <li class="nav-item"><a href="admin-login.jsp?msg=logout" class="nav-link text-danger"><i class="fa fa-sign-out-alt"></i> Logout</a></li>
      </ul>
    </div>
  </div>
</nav>

<section class="section">
  <h2 class="text-center text-info mb-4"><i class="fa-solid fa-download"></i> Download Analytics</h2>

  <div class="row text-center g-4 mb-5">
    <div class="col-md-3"><div class="card-glass"><i class="fa-solid fa-cloud-arrow-down"></i><h3><%= totalDownloads %></h3><p>Total Downloads</p></div></div>
    <div class="col-md-3"><div class="card-glass"><i class="fa-solid fa-user-lock text-success"></i><h3><%= selfDownloads %></h3><p>Self Decryptions</p></div></div>
    <div class="col-md-3"><div class="card-glass"><i class="fa-solid fa-share text-warning"></i><h3><%= sharedDownloads %></h3><p>Shared Downloads</p></div></div>
    <div class="col-md-3"><div class="card-glass"><i class="fa-solid fa-users text-info"></i><h3><%= uniqueUsers %></h3><p>Unique Users</p></div></div>
  </div>

  <div class="card-glass mb-5">
    <h5 class="text-info"><i class="fa-solid fa-chart-line"></i> Total Downloads Over the Last 6 Months</h5>
    <canvas id="totalChart" height="120"></canvas>
  </div>

  <div class="card-glass mb-5">
    <h5 class="text-info"><i class="fa-solid fa-chart-area"></i> Self vs Shared Download Trends</h5>
    <canvas id="compareChart" height="120"></canvas>
  </div>

  <div class="card-glass">
    <h5 class="text-info"><i class="fa-solid fa-table"></i> Top Downloaders</h5>
    <div class="table-responsive">
      <table class="table table-hover align-middle text-white">
        <thead>
          <tr><th>#</th><th>User ID</th><th>Total</th><th>Self</th><th>Shared</th><th>Last IP</th></tr>
        </thead>
        <tbody>
          <%
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                   "SELECT user_id, COUNT(*) AS total, " +
                   "SUM(CASE WHEN share_id IS NULL THEN 1 ELSE 0 END) AS self_d, " +
                   "SUM(CASE WHEN share_id IS NOT NULL THEN 1 ELSE 0 END) AS shared_d, " +
                   "MAX(ip_address) AS last_ip " +
                   "FROM download_history GROUP BY user_id ORDER BY total DESC LIMIT 10");
                 ResultSet rs = ps.executeQuery()) {
                 int i = 1;
                 while (rs.next()) {
          %>
          <tr>
            <td><%= i++ %></td>
            <td><%= rs.getInt("user_id") %></td>
            <td><%= rs.getInt("total") %></td>
            <td><%= rs.getInt("self_d") %></td>
            <td><%= rs.getInt("shared_d") %></td>
            <td><%= rs.getString("last_ip") %></td>
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
const totals = <%= totalJS.toString() %>;
const selfData = <%= selfJS.toString() %>;
const sharedData = <%= sharedJS.toString() %>;

// Chart 1: Total Downloads
new Chart(document.getElementById('totalChart'), {
  type:'bar',
  data:{
    labels:months,
    datasets:[{
      label:'Total Downloads',
      data:totals,
      backgroundColor:'rgba(0,224,255,0.4)',
      borderColor:'#00e0ff',
      borderWidth:2
    }]
  },
  options:{scales:{y:{beginAtZero:true,ticks:{color:'#fff'}},x:{ticks:{color:'#fff'}}},plugins:{legend:{labels:{color:'#fff'}}}}
});

// Chart 2: Self vs Shared Comparison
new Chart(document.getElementById('compareChart'), {
  type:'line',
  data:{
    labels:months,
    datasets:[
      {label:'Self Decryptions',data:selfData,borderColor:'#4CAF50',backgroundColor:'rgba(76,175,80,0.2)',fill:true,tension:0.4},
      {label:'Shared Downloads',data:sharedData,borderColor:'#FFC107',backgroundColor:'rgba(255,193,7,0.2)',fill:true,tension:0.4}
    ]
  },
  options:{scales:{y:{beginAtZero:true,ticks:{color:'#fff'}},x:{ticks:{color:'#fff'}}},plugins:{legend:{labels:{color:'#fff'}}}}
});
</script>
</body>
</html>
