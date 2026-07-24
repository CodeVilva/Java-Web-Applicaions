<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.TicketChecker"%>

<%
// Reads the full object forwarded from the Servlet above
TicketChecker checker = (TicketChecker) request.getAttribute("checker");

if (checker == null) {
    response.sendRedirect(request.getContextPath() + "/TicketCheckerListServlet");
    return;
}
String error = (String) session.getAttribute("errorMessage");
String success = (String) session.getAttribute("successMessage");
if (error != null) session.removeAttribute("errorMessage");
if (success != null) session.removeAttribute("successMessage");
%>


<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Edit Ticket Checker | SNAPSPOT</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<style>
body{background:#f4f6f9}
.card{max-width:720px;margin:40px auto;border:none;border-radius:16px;box-shadow:0 8px 24px rgba(0,0,0,.1)}
</style>
</head>
<body>
<div class="container">
<div class="card">
<div class="card-header bg-primary text-white">
<h3 class="mb-0"><i class="bi bi-pencil-square"></i> Edit Ticket Checker</h3>
</div>
<div class="card-body">

<% if(success!=null){ %><div class="alert alert-success"><%=success%></div><% } %>
<% if(error!=null){ %><div class="alert alert-danger"><%=error%></div><% } %>

<form action="<%=request.getContextPath()%>/EditTicketCheckerServlet" method="post">

<input type="hidden" name="checkerId" value="<%=checker.getCheckerId()%>">

<div class="mb-3">
<label class="form-label">Full Name</label>
<input type="text" class="form-control" name="fullName"
value="<%=checker.getFullName()%>" required>
</div>

<div class="mb-4">
<label class="form-label">Email Address</label>
<input type="email" class="form-control" name="email"
value="<%=checker.getEmail()%>" required>
</div>

<div class="alert alert-info">
Password is not modified on this page.
</div>

<div class="d-flex justify-content-between">
<a href="<%=request.getContextPath()%>/TicketCheckerListServlet"
class="btn btn-secondary">
<i class="bi bi-arrow-left"></i> Back
</a>

<button type="submit" class="btn btn-primary">
<i class="bi bi-save"></i> Update Ticket Checker
</button>
</div>

</form>

</div>
</div>
</div>
</body>
</html>