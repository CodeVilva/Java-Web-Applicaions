<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Booking"%>
<%@page import="model.Vehicle"%>
<%@page import="model.ParkingSlot"%>
<%@page import="model.ParkingArea"%>
<%
Booking booking=(Booking)request.getAttribute("booking");
Vehicle vehicle=(Vehicle)request.getAttribute("vehicle");
ParkingSlot slot=(ParkingSlot)request.getAttribute("slot");
ParkingArea area=(ParkingArea)request.getAttribute("area");
if(booking==null||vehicle==null||slot==null||area==null){
response.sendRedirect(request.getContextPath()+"/user/dashboard.jsp");
return;
}
%>
<!DOCTYPE html>
<html><head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>SNAPSPOT Ticket</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="../css/style.css">
<style>
body{background:#eef2f7}
.ticket-card{max-width:900px;margin:60px auto;background:#fff;border-radius:20px;padding:30px;box-shadow:0 15px 40px rgba(0,0,0,.15)}
.table td:first-child{font-weight:600;width:35%}
.qr{text-align:center}
.qr img{width:220px;height:220px}
</style>
</head><body>
<div class="container">
<div class="ticket-card">
<h2 class="mb-4"><i class="bi bi-ticket-perforated-fill"></i> SNAPSPOT Parking Ticket</h2>
<div class="row">
<div class="col-lg-8">
<table class="table table-bordered">
<tr><td>Booking ID</td><td><%=booking.getBookingId()%></td></tr>
<tr><td>Vehicle Number</td><td><%=vehicle.getVehicleNumber()%></td></tr>
<tr><td>Vehicle Type</td><td><%=vehicle.getVehicleType()%></td></tr>
<tr><td>Parking Area</td><td><%=area.getAreaName()%></td></tr>
<tr><td>Slot Code</td><td><%=slot.getSlotCode()%></td></tr>
<tr><td>Booking Date</td><td><%=booking.getBookingDate()%></td></tr>
<tr><td>Entry Time</td><td><%=booking.getEntryTime()%></td></tr>
<tr><td>Exit Time</td><td><%=booking.getExitTime()%></td></tr>
<tr><td>Total Amount</td><td>₹ <%=booking.getTotalAmount()%></td></tr>
<tr><td>Payment Status</td><td><span class="badge bg-success"><%=booking.getPaymentStatus()%></span></td></tr>
<tr><td>Booking Status</td><td><span class="badge bg-primary"><%=booking.getBookingStatus()%></span></td></tr>
</table>
<button class="btn btn-primary" onclick="window.print()"><i class="bi bi-printer"></i> Print Ticket</button>
<a href="<%=request.getContextPath()%>/UserDashboardServlet" class="btn btn-outline-secondary">Dashboard</a>
</div>
<div class="col-lg-4 qr">
<h5>QR Ticket</h5>
<img src="<%=request.getContextPath()%>/<%=booking.getQrCode()%>" alt="QR Code">
<p class="mt-3">Scan this QR at the parking entrance.</p>
</div>
</div>
</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
