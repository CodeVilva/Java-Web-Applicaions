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
 response.sendRedirect(request.getContextPath()+"/BookSlotPageServlet");
 return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dummy Payment | SNAPSPOT</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="../css/style.css">
<style>
body{background:#f5f7fb;}
.payment-card{max-width:850px;margin:120px auto 60px;background:#fff;border-radius:18px;padding:35px;box-shadow:0 10px 30px rgba(0,0,0,.12);}
.table td:first-child{font-weight:600;width:35%;}
</style>
</head>
<body>
<div class="container">
<div class="payment-card">
<h2 class="mb-4"><i class="bi bi-credit-card"></i> Dummy Payment</h2>
<table class="table table-bordered">
<tr><td>Booking ID</td><td><%=booking.getBookingId()%></td></tr>
<tr><td>Parking Area</td><td><%=area.getAreaName()%></td></tr>
<tr><td>Vehicle Number</td><td><%=vehicle.getVehicleNumber()%></td></tr>
<tr><td>Vehicle Type</td><td><%=vehicle.getVehicleType()%></td></tr>
<tr><td>Slot Code</td><td><%=slot.getSlotCode()%></td></tr>
<tr><td>Booking Date</td><td><%=booking.getBookingDate()%></td></tr>
<tr><td>Entry Time</td><td><%=booking.getEntryTime()%></td></tr>
<tr><td>Exit Time</td><td><%=booking.getExitTime()%></td></tr>
<tr><td>Total Amount</td><td><strong>₹ <%=booking.getTotalAmount()%></strong></td></tr>
</table>
<div class="alert alert-warning">
<strong>Demo Payment Gateway</strong><br>
This is a simulated payment page. Clicking <b>Pay Now</b> marks the booking as paid.
</div>
<form action="<%=request.getContextPath()%>/PaymentServlet" method="post">
<input type="hidden" name="bookingId" value="<%=booking.getBookingId()%>">
<button class="btn btn-success w-100">
<i class="bi bi-wallet2"></i> Pay Now
</button>
</form>
<div class="text-center mt-3">
<a href="../BookSlotPageServlet" class="btn btn-outline-secondary">Back</a>
</div>
</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
