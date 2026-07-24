<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Admin"%>
<%
Admin admin=(Admin)request.getAttribute("admin");
if(admin==null){
    response.sendRedirect(request.getContextPath()+"/admin/login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard | SNAPSPOT</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<style>
body{background:#f4f6f9}
.header{background:#212529;color:#fff;padding:20px 0}
.menu-card{border:none;border-radius:16px;box-shadow:0 6px 18px rgba(0,0,0,.08);transition:.25s;height:100%}
.menu-card:hover{transform:translateY(-5px)}
.icon{font-size:42px;color:#0d6efd}
</style>
</head>
<body>

<div class="header">
<div class="container d-flex justify-content-between align-items-center">
<div>
<h3>SNAPSPOT Admin Dashboard</h3>
<p class="mb-0">Welcome, <strong><%=admin.getFullName()%></strong></p>
</div>
<a class="btn btn-light" href="<%=request.getContextPath()%>/LogoutServlet">
<i class="bi bi-box-arrow-right"></i> Logout
</a>
</div>
</div>

<div class="container py-5">
<div class="row g-4">
<div class="col-md-4">
<div class="card menu-card">
<div class="card-body text-center">
<div class="icon"><i class="bi bi-person-badge-fill"></i></div>
<h5>Ticket Checkers</h5>
<p>Create and manage ticket checkers.</p>
<a class="btn btn-primary" href="<%=request.getContextPath()%>/TicketCheckerListServlet">Open</a>
</div></div></div>

<div class="col-md-4">
<div class="card menu-card">
<div class="card-body text-center">
<div class="icon"><i class="bi bi-car-front-fill"></i></div>
<h5>Bookings</h5>
<p>View all bookings.</p>
<a class="btn btn-primary" href="<%=request.getContextPath()%>/BookingListServlet">Open</a>
</div></div></div>
</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
