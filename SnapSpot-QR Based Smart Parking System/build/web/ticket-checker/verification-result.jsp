<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Booking"%>
<%
String status=(String)request.getAttribute("status");
String message=(String)request.getAttribute("message");
Booking booking=(Booking)request.getAttribute("booking");

if(status==null) status="FAILED";
if(message==null) message="Unknown Result";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Verification Result | SNAPSPOT</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>
body{background:#f4f6f9;}
.result-card{
max-width:800px;
margin:60px auto;
background:#fff;
padding:35px;
border-radius:18px;
box-shadow:0 10px 30px rgba(0,0,0,.12);
}
.icon{
font-size:70px;
}
</style>
</head>
<body>

<div class="container">

<div class="result-card text-center">

<%
if("ENTRY".equals(status)){
%>
<div class="text-success">
<i class="bi bi-check-circle-fill icon"></i>
<h2 class="mt-3">Vehicle Entry Allowed</h2>
</div>
<%
}else if("EXIT".equals(status)){
%>
<div class="text-primary">
<i class="bi bi-box-arrow-right icon"></i>
<h2 class="mt-3">Vehicle Exit Completed</h2>
</div>
<%
}else{
%>
<div class="text-danger">
<i class="bi bi-x-circle-fill icon"></i>
<h2 class="mt-3">Verification Failed</h2>
</div>
<%
}
%>

<p class="lead mt-3"><%=message%></p>

<%
if(booking!=null){
%>

<table class="table table-bordered mt-4">

<tr>
<td><strong>Booking ID</strong></td>
<td><%=booking.getBookingId()%></td>
</tr>

<tr>
<td><strong>Booking Date</strong></td>
<td><%=booking.getBookingDate()%></td>
</tr>

<tr>
<td><strong>Entry Time</strong></td>
<td><%=booking.getEntryTime()%></td>
</tr>

<tr>
<td><strong>Exit Time</strong></td>
<td><%=booking.getExitTime()%></td>
</tr>

<tr>
<td><strong>Booking Status</strong></td>
<td><%=booking.getBookingStatus()%></td>
</tr>

<tr>
<td><strong>Payment Status</strong></td>
<td><%=booking.getPaymentStatus()%></td>
</tr>

</table>

<%
}
%>

<div class="mt-4">

<a href="<%=request.getContextPath()%>/ScanTicketServlet"
class="btn btn-primary">

<i class="bi bi-qr-code-scan"></i>
Scan Next Ticket

</a>

<a href="<%=request.getContextPath()%>/TicketCheckerDashboardServlet"
class="btn btn-secondary">

Dashboard

</a>

</div>

</div>

</div>

</body>
</html>
