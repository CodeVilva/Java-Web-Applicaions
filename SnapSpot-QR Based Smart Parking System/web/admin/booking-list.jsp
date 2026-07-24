<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Admin"%>
<%@page import="model.Booking"%>

<%
Admin admin = (Admin) request.getAttribute("admin");

if(admin == null){
    response.sendRedirect(request.getContextPath()+"/admin/login.jsp");
    return;
}

List<Booking> bookingList =
        (List<Booking>) request.getAttribute("bookingList");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Booking Management | SNAPSPOT</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>

body{
    background:#f5f6fa;
}

.header{
    background:#212529;
    color:white;
    padding:20px;
}

.card{
    border:none;
    border-radius:15px;
    box-shadow:0 5px 15px rgba(0,0,0,.08);
}

.table td,
.table th{
    vertical-align:middle;
}

.badge{
    font-size:.85rem;
}

</style>

</head>

<body>

<div class="header">

<div class="container d-flex justify-content-between align-items-center">

<div>

<h3>
<i class="bi bi-car-front-fill"></i>
Booking Management
</h3>

<p class="mb-0">
Welcome,
<strong><%=admin.getFullName()%></strong>
</p>

</div>

<a href="<%=request.getContextPath()%>/AdminDashboardServlet"
class="btn btn-light">

<i class="bi bi-arrow-left"></i>

Dashboard

</a>

</div>

</div>

<div class="container py-4">

<div class="card">

<div class="card-header bg-primary text-white">

<h5 class="mb-0">

All Bookings

</h5>

</div>

<div class="card-body">

<div class="table-responsive">

<table class="table table-hover table-bordered align-middle">

<thead class="table-dark">

<tr>

<th>ID</th>

<th>Vehicle</th>

<th>Type</th>

<th>Slot</th>

<th>Booking Date</th>

<th>Entry</th>

<th>Exit</th>

<th>Amount</th>

<th>Booking</th>

<th>Payment</th>

</tr>

</thead>

<tbody>

<%
if(bookingList != null && !bookingList.isEmpty()){

for(Booking booking : bookingList){
%>

<tr>

<td>

<%=booking.getBookingId()%>

</td>

<td>

<%=booking.getVehicleNumber()%>

</td>

<td>

<%=booking.getVehicleType()%>

</td>

<td>

<%=booking.getSlotCode()%>

</td>

<td>

<%=booking.getBookingDate()%>

</td>

<td>

<%=booking.getEntryTime()%>

</td>

<td>

<%=booking.getExitTime()%>

</td>

<td>

₹<%=booking.getTotalAmount()%>

</td>

<td>

<%
String bookingStatus = booking.getBookingStatus();

if("BOOKED".equalsIgnoreCase(bookingStatus)){
%>

<span class="badge bg-primary">

BOOKED

</span>

<%
}
else if("ACTIVE".equalsIgnoreCase(bookingStatus)){
%>

<span class="badge bg-success">

ACTIVE

</span>

<%
}
else if("COMPLETED".equalsIgnoreCase(bookingStatus)){
%>

<span class="badge bg-secondary">

COMPLETED

</span>

<%
}
else if("CANCELLED".equalsIgnoreCase(bookingStatus)){
%>

<span class="badge bg-danger">

CANCELLED

</span>

<%
}
else{
%>

<span class="badge bg-dark">

<%=bookingStatus%>

</span>

<%
}
%>

</td>

<td>

<%
String paymentStatus = booking.getPaymentStatus();

if("SUCCESS".equalsIgnoreCase(paymentStatus)){
%>

<span class="badge bg-success">

SUCCESS

</span>

<%
}
else if("FAILED".equalsIgnoreCase(paymentStatus)){
%>

<span class="badge bg-danger">

FAILED

</span>

<%
}
else{
%>

<span class="badge bg-warning text-dark">

PENDING

</span>

<%
}
%>

</td>
</tr>

<%
}

}else{
%>

<tr>

<td colspan="11" class="text-center text-muted">

No Bookings Found

</td>

</tr>

<%
}
%>

</tbody>

</table>

</div>

</div>

</div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>