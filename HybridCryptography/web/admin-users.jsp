<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*, java.time.*, java.time.format.DateTimeFormatter, securevault.DBConnection" %>
<%@ page session="true" %>

<%
    String adminName = (String) session.getAttribute("adminName");
    if (adminName == null) {
        response.sendRedirect("admin-login.jsp?msg=sessionExpired");
        return;
    }

    int totalUsers = 0;
    int newUsers = 0;
    LinkedHashMap<String,Integer> usersByMonth = new LinkedHashMap<>();

    DateTimeFormatter keyFmt = DateTimeFormatter.ofPattern("yyyy-MM");
    DateTimeFormatter niceFmt = DateTimeFormatter.ofPattern("MMM yyyy");
    LinkedHashMap<String,String> monthKeyToLabel = new LinkedHashMap<>();

    YearMonth nowYM = YearMonth.now();
    for (int i=5;i>=0;i--) {
        YearMonth ym = nowYM.minusMonths(i);
        String key = ym.format(keyFmt);
        monthKeyToLabel.put(key, ym.atDay(1).format(niceFmt));
        usersByMonth.put(key, 0);
    }

    ResultSet rs = null;
    try (Connection con = DBConnection.getConnection()) {
        // total count
        PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM users");
        rs = ps.executeQuery();
        if (rs.next()) totalUsers = rs.getInt(1);
        rs.close(); ps.close();

        // new users (last 30 days)
        ps = con.prepareStatement("SELECT COUNT(*) FROM users WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)");
        
        rs = ps.executeQuery();
        if (rs.next()) newUsers = rs.getInt(1);
        rs.close(); ps.close();

        // monthly registrations
        ps = con.prepareStatement("SELECT DATE_FORMAT(created_at, '%Y-%m') ym, COUNT(*) cnt FROM users WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) GROUP BY ym ORDER BY ym");
        rs = ps.executeQuery();
        while (rs.next()) {
            String ym = rs.getString("ym");
            if (usersByMonth.containsKey(ym)) usersByMonth.put(ym, rs.getInt("cnt"));
        }
        rs.close(); ps.close();
    } catch (Exception e) { e.printStackTrace(); }

    // prep chart JS arrays
    StringBuilder labelsJs = new StringBuilder("[");
    StringBuilder valuesJs = new StringBuilder("[");
    int i=0,size=monthKeyToLabel.size();
    for (Map.Entry<String,String> e: monthKeyToLabel.entrySet()) {
        labelsJs.append("'").append(e.getValue()).append("'");
        valuesJs.append(usersByMonth.get(e.getKey()));
        if (++i < size) { labelsJs.append(","); valuesJs.append(","); }
    }
    labelsJs.append("]"); valuesJs.append("]");

%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin - Users | SecureVault</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<script src="chart.js"></script>
<style>
body {font-family:'Poppins',sans-serif;background:linear-gradient(135deg,#101d42 0%,#0f3460 50%,#16213e 100%);color:#fff;padding-top:80px;}
.navbar{background:rgba(255,255,255,0.08);border-bottom:1px solid rgba(255,255,255,0.1);backdrop-filter:blur(10px);}
.nav-link{color:#fff!important;margin:0 5px;border-radius:8px;}
.nav-link:hover,.nav-link.active{background:rgba(255,255,255,0.1);color:#00e0ff!important;}
.section{padding:50px 8%;}
.card-glass{background:rgba(255,255,255,0.07);border:1px solid rgba(255,255,255,0.15);border-radius:20px;text-align:center;padding:28px;box-shadow:0 0 20px rgba(0,188,212,0.25);}
.card-glass i{font-size:2.3rem;color:#00e0ff;margin-bottom:10px;}
.table thead{background:rgba(0,188,212,0.2);}
.table-hover tbody tr:hover{background:rgba(255,255,255,0.05);}
footer{background:rgba(255,255,255,0.05);color:#aaa;text-align:center;padding:10px;border-top:1px solid rgba(255,255,255,0.1);}
</style>
</head>

<body>

<nav class="navbar navbar-expand-lg fixed-top px-4">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold text-info" href="admin-dashboard.jsp"><i class="fa-solid fa-shield-halved"></i> SecureVault Admin</a>
    <button class="navbar-toggler text-white border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
      <i class="fa-solid fa-bars"></i>
    </button>
    <div class="collapse navbar-collapse justify-content-end" id="navMenu">
      <ul class="navbar-nav">
        <li class="nav-item"><a href="admin-dashboard.jsp" class="nav-link"><i class="fa fa-home"></i> Dashboard</a></li>
        <li class="nav-item"><a href="admin-users.jsp" class="nav-link active"><i class="fa fa-users"></i> Users</a></li>
        <li class="nav-item"><a href="admin-files.jsp" class="nav-link"><i class="fa fa-file-shield"></i> Files</a></li>
        <li class="nav-item"><a href="admin-shares.jsp" class="nav-link"><i class="fa fa-share-nodes"></i> Shares</a></li>
        <li class="nav-item"><a href="admin-downloads.jsp" class="nav-link"><i class="fa fa-download"></i> Downloads</a></li>
        <li class="nav-item"><a href="admin-reports.jsp" class="nav-link"><i class="fa fa-chart-pie"></i> Reports</a></li>
        <li class="nav-item"><a href="admin-login.jsp?msg=logout" class="nav-link text-danger"><i class="fa fa-sign-out-alt"></i> Logout</a></li>
      </ul>
    </div>
  </div>
</nav>

<section class="section">
  <h2 class="text-center text-info mb-4"><i class="fa fa-users"></i> Registered Users</h2>

  <div class="row text-center g-4 mb-5">
    <div class="col-md-6"><div class="card-glass">
      <i class="fa-solid fa-user-group"></i><h3><%= totalUsers %></h3><p>Total Registered Users</p>
    </div></div>
    <div class="col-md-6"><div class="card-glass">
      <i class="fa-solid fa-user-plus"></i><h3><%= newUsers %></h3><p>New Users (Last 30 Days)</p>
    </div></div>
  </div>

  <!-- Chart -->
  <div class="card-glass mb-5">
    <h5 class="text-info"><i class="fa fa-chart-line"></i> Registrations in Last 6 Months</h5>
    <canvas id="userChart" height="120"></canvas>
  </div>

  <!-- Table -->
  <div class="card-glass">
    <h5 class="text-info mb-3"><i class="fa fa-table"></i> User Details</h5>
    <div class="table-responsive">
      <table class="table table-hover align-middle text-white">
        <thead>
          <tr>
            <th>#</th>
            <th>Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Registered On</th>
          </tr>
        </thead>
        <tbody>
          <%
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement("SELECT id,name,email,phone,created_at FROM users ORDER BY created_at DESC");
                 ResultSet rs2 = ps.executeQuery()) {
                 int count=1;
                 while (rs2.next()) {
          %>
          <tr>
            <td><%= count++ %></td>
            <td><%= rs2.getString("name") %></td>
            <td><%= rs2.getString("email") %></td>
            <td><%= rs2.getString("phone") %></td>
            <td><%= rs2.getTimestamp("created_at") %></td>
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
const labels = <%= labelsJs.toString() %>;
const data = <%= valuesJs.toString() %>;
new Chart(document.getElementById('userChart'), {
  type:'bar',
  data:{labels:labels,datasets:[{label:'User Registrations',data:data,backgroundColor:'rgba(0,224,255,0.5)',borderColor:'#00e0ff',borderWidth:2}]},
  options:{responsive:true,scales:{y:{beginAtZero:true}}}
});
</script>
</body>
</html>
