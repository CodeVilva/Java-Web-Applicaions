<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.TicketChecker"%>

<%
List<TicketChecker> ticketCheckerList =
(List<TicketChecker>)request.getAttribute("ticketCheckerList");

String success=(String)session.getAttribute("successMessage");
String error=(String)session.getAttribute("errorMessage");

if(success!=null) session.removeAttribute("successMessage");
if(error!=null) session.removeAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Ticket Checkers | SNAPSPOT</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>
body{background:#f4f6f9}
.card{border:none;border-radius:16px;box-shadow:0 8px 24px rgba(0,0,0,.08)}
.table th{background:#0d6efd;color:#fff}
</style>

<script>
function searchTable(){
 let input=document.getElementById("search").value.toLowerCase();
 let rows=document.getElementById("checkerTable").getElementsByTagName("tr");
 for(let i=1;i<rows.length;i++){
   let txt=rows[i].innerText.toLowerCase();
   rows[i].style.display=txt.indexOf(input)>-1?"":"none";
 }
}
</script>
</head>

<body>

<div class="container py-4">

<div class="d-flex justify-content-between align-items-center mb-4">
<h2>Manage Ticket Checkers</h2>

<div>
<a href="<%=request.getContextPath()%>/admin/add-ticket-checker.jsp"
class="btn btn-success">
<i class="bi bi-person-plus-fill"></i> Add Ticket Checker
</a>

<a href="<%=request.getContextPath()%>/AdminDashboardServlet"
class="btn btn-secondary">
Dashboard
</a>
</div>
</div>

<% if(success!=null){ %>
<div class="alert alert-success"><%=success%></div>
<% } %>

<% if(error!=null){ %>
<div class="alert alert-danger"><%=error%></div>
<% } %>

<div class="card">

<div class="card-body">

<div class="row mb-3">
<div class="col-md-4 ms-auto">
<input
type="text"
id="search"
class="form-control"
placeholder="Search..."
onkeyup="searchTable()">
</div>
</div>

<div class="table-responsive">

<table class="table table-bordered table-hover align-middle"
id="checkerTable">

<thead>
<tr>
<th>#</th>
<th>Full Name</th>
<th>Email</th>
<th>Status</th>
<th>Created</th>
<th width="220">Actions</th>
</tr>
</thead>

<tbody>

<%
int count=1;

if(ticketCheckerList!=null){

for(TicketChecker checker : ticketCheckerList){
%>

<tr>

<td><%=count++%></td>

<td><%=checker.getFullName()%></td>

<td><%=checker.getEmail()%></td>

<td>

<%
if("ACTIVE".equalsIgnoreCase(checker.getStatus())){
%>

<span class="badge bg-success">ACTIVE</span>

<%
}else{
%>

<span class="badge bg-danger">BLOCKED</span>

<%
}
%>

</td>

<td><%=checker.getCreatedAt()%></td>

<td>

<form action="<%=request.getContextPath()%>/FetchTicketCheckerServlet"
      method="get"
      style="display:inline;">

<input
type="hidden"
name="checkerId"
value="<%=checker.getCheckerId()%>">

<button class="btn btn-primary btn-sm">
    <i class="bi bi-pencil-square"></i> Edit
</button>

</form>



<form
action="<%=request.getContextPath()%>/ToggleTicketCheckerStatusServlet"
method="post"
style="display:inline;">

<input
type="hidden"
name="checkerId"
value="<%=checker.getCheckerId()%>">

<button
class="btn btn-warning btn-sm">

<%
if("ACTIVE".equalsIgnoreCase(checker.getStatus())){
%>

Block

<%
}else{
%>

Activate

<%
}
%>

</button>

</form>

</td>

</tr>

<%
}
}
%>

</tbody>

</table>

</div>

</div>

</div>

</div>

</body>
</html>
