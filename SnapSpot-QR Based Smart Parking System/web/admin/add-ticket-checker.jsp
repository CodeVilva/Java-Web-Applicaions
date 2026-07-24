<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String error=(String)session.getAttribute("errorMessage");
String success=(String)session.getAttribute("successMessage");
if(error!=null) session.removeAttribute("errorMessage");
if(success!=null) session.removeAttribute("successMessage");
%>
<!DOCTYPE html>
<html><head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Add Ticket Checker</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<script>
function t(id,icon){const p=document.getElementById(id),i=document.getElementById(icon);if(p.type==="password"){p.type="text";i.className="bi bi-eye-slash";}else{p.type="password";i.className="bi bi-eye";}}
function v(){if(document.getElementById("password").value!==document.getElementById("confirmPassword").value){alert("Passwords do not match.");return false;}return true;}
</script>
<style>body{background:#f4f6f9}.card{max-width:700px;margin:40px auto;border:none;border-radius:16px;box-shadow:0 8px 24px rgba(0,0,0,.12)}</style>
</head><body>
<div class="container"><div class="card">
<div class="card-header bg-primary text-white"><h3>Add Ticket Checker</h3></div>
<div class="card-body">
<% if(success!=null){ %><div class="alert alert-success"><%=success%></div><% } %>
<% if(error!=null){ %><div class="alert alert-danger"><%=error%></div><% } %>
<form action="<%=request.getContextPath()%>/AddTicketCheckerServlet" method="post" onsubmit="return v();">
<div class="mb-3"><label>Full Name</label><input class="form-control" name="fullName" required></div>
<div class="mb-3"><label>Email</label><input type="email" class="form-control" name="email" required></div>
<div class="mb-3"><label>Password</label><div class="input-group"><input type="password" id="password" name="password" class="form-control" required><button type="button" class="btn btn-outline-secondary" onclick="t('password','e1')"><i id="e1" class="bi bi-eye"></i></button></div></div>
<div class="mb-4"><label>Confirm Password</label><div class="input-group"><input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required><button type="button" class="btn btn-outline-secondary" onclick="t('confirmPassword','e2')"><i id="e2" class="bi bi-eye"></i></button></div></div>
<div class="d-flex justify-content-between">
<a class="btn btn-secondary" href="<%=request.getContextPath()%>/TicketCheckerListServlet">Back</a>
<button class="btn btn-success" type="submit">Create Ticket Checker</button>
</div>
</form></div></div></div></body></html>