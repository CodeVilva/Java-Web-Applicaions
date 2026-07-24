<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.TicketChecker"%>
<%
TicketChecker checker=(TicketChecker)request.getAttribute("ticketChecker");
if(checker==null){
response.sendRedirect(request.getContextPath()+"/ticket-checker/login.jsp");
return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ticket Checker Dashboard | SNAPSPOT</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="../css/style.css">
<style>
body{background:#f4f6f9}
.header{background:#0d6efd;color:#fff;padding:20px 0}
.card-action,.stat-card{border:none;border-radius:16px;box-shadow:0 6px 20px rgba(0,0,0,.08)}
.card-action:hover{transform:translateY(-4px);transition:.25s}
.icon-box{width:70px;height:70px;border-radius:50%;background:#e9f2ff;display:flex;align-items:center;justify-content:center;font-size:32px;color:#0d6efd;margin:0 auto 15px}
</style>
</head>
<body>
<div class="header">
<div class="container d-flex justify-content-between align-items-center">
<div>
<h3>SNAPSPOT Ticket Checker</h3>
<p>Welcome, <strong><%=checker.getFullName()%></strong></p>
</div>
<a href="LogoutServlet" class="btn btn-light">Logout</a>
</div>
</div>
<div class="container py-5">
<div class="row g-4">
<div class="col-md-6">
<div class="card card-action h-100"><div class="card-body text-center">
<div class="icon-box"><i class="bi bi-qr-code-scan"></i></div>
<h4>Scan QR Ticket</h4>
<p>Scan customer QR codes to validate entry or exit.</p>
<a href="ScanTicketServlet" class="btn btn-primary">Start Scanning</a>
</div></div></div>
<div class="col-md-6">
<div class="card card-action h-100"><div class="card-body text-center">
<div class="icon-box"><i class="bi bi-search"></i></div>
<h4>Manual Verification</h4>
<form action="../VerifyTicketServlet" method="get">
<div class="input-group">
<input type="number" name="bookingId" class="form-control" placeholder="Booking ID" required>
<button class="btn btn-success">Verify</button>
</div>
</form>
</div></div></div>
</div>
<div class="row g-4 mt-2">

    <div class="col-md-4">
        <div class="card stat-card">
            <div class="card-body text-center">
                <h5>Today's Entries</h5>
                <h2><%=request.getAttribute("todayEntries")%></h2>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="card stat-card">
            <div class="card-body text-center">
                <h5>Today's Exits</h5>
                <h2><%=request.getAttribute("todayExits")%></h2>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="card stat-card">
            <div class="card-body text-center">
                <h5>Active Vehicles</h5>
                <h2><%=request.getAttribute("activeVehicles")%></h2>
            </div>
        </div>
    </div>

</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body></html>