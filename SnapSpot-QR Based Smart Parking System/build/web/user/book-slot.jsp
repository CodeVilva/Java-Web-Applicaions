<%@page import="model.Vehicle"%>
<%@page import="model.User"%>
<%@page import="constant.AppConstants"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Vehicle"%>
<%@page import="model.ParkingSlot"%>
<%@page import="model.ParkingRate"%>
<%@page import="model.Booking"%>
<%@page import="model.ParkingArea"%>

<%
List<ParkingArea> areaList =
(List<ParkingArea>)request.getAttribute("areaList");
System.out.println("area List OK");

List<Vehicle> vehicleList =
(List<Vehicle>)request.getAttribute("vehicleList");
System.out.println("Vehicle List OK");

List<ParkingSlot> slotList =
(List<ParkingSlot>)request.getAttribute("slotList");
System.out.println("slot List OK");

List<ParkingRate> rateList =
(List<ParkingRate>)request.getAttribute("rateList");
System.out.println("rate List OK");

Booking activeBooking =
(Booking)request.getAttribute("activeBooking");

%>
<%
    User user = (User) session.getAttribute(AppConstants.SESSION_USER);

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Book Parking Slot | SNAPSPOT</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&family=Space+Grotesk:wght@500;600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="../css/style.css">

    <style>

        body{
            background:#F4F6F9;
            font-family:'Inter',sans-serif;
        }

        .page-section{
            padding-top:110px;
            padding-bottom:70px;
        }

        .booking-card{
            background:#ffffff;
            border-radius:20px;
            padding:35px;
            box-shadow:0 15px 40px rgba(0,0,0,.08);
        }

        .booking-title{
            font-family:'Space Grotesk',sans-serif;
            font-weight:700;
        }

        .form-control,
        .form-select{

            min-height:52px;
            border-radius:12px;

        }

        .summary-card{

            background:#0d6efd;
            color:#fff;
            border-radius:20px;
            padding:30px;
            height:100%;

        }

        .summary-card h5{

            font-weight:600;

        }

        .summary-item{

            margin-bottom:18px;

        }

        .summary-item small{

            color:#d8e6ff;

        }

        .btn-book{

            width:100%;
            min-height:52px;

        }

    </style>

</head>

<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">

<div class="container">

<a class="navbar-brand"
href="<%=request.getContextPath()%>/UserDashboardServlet">

<i class="bi bi-qr-code"></i>

SNAP<span class="text-primary">SPOT</span>

</a>

<div class="ms-auto">

<a href="<%=request.getContextPath()%>/UserDashboardServlet"
class="btn btn-outline-light">

<i class="bi bi-house-door-fill"></i>

Dashboard

</a>

</div>

</div>

</nav>

<section class="page-section">

<div class="container">

<div class="row">

<div class="col-lg-8">

<div class="booking-card">

<h2 class="booking-title mb-4">

<i class="bi bi-p-square-fill text-primary"></i>

Book Parking Slot

</h2>

<form action="BookSlotServlet" method="post">

<div class="row">

<div class="col-md-6 mb-3">

<label class="form-label">

Booking Date

</label>

<input
type="date"
name="bookingDate"
class="form-control"
required>

</div>

<div class="col-md-6 mb-3">

<label class="form-label">

Parking Area

</label>

<select
name="areaId"
class="form-select"
required>

<option value="">Select Parking Area</option>

<%
if(areaList != null){

    for(ParkingArea area : areaList){
%>

<option value="<%=area.getAreaId()%>">

<%=area.getAreaName()%>

</option>

<%
    }
}
%>

</select>
</div>

<div class="col-md-6 mb-3">

<label class="form-label">

Entry Time

</label>

<input
type="time"
name="entryTime"
class="form-control"
required>

</div>

<div class="col-md-6 mb-3">

<label class="form-label">

Exit Time

</label>

<input
type="time"
name="exitTime"
class="form-control"
required>

</div>

<div class="col-md-6 mb-3">

<label class="form-label">

Vehicle

</label>

<select
class="form-select"
name="vehicleId"
required>

<option value="">Select Vehicle</option>

<%

if(!vehicleList.isEmpty()){

    for(Vehicle vehicle : vehicleList){

%>

<option value="<%=vehicle.getVehicleId()%>">

<%=vehicle.getVehicleNumber()%>
(
<%=vehicle.getVehicleType()%>
)

</option>

<%
}
}else{

%>

<option disabled>

No vehicles registered

</option>

<%

}

%>

</select>

</div>

<div class="col-md-6 mb-3">

<label class="form-label">

Slot

</label>

<select name="slotId" class="form-select">

<option value="">Select Slot</option>

<%
for(ParkingSlot slot : slotList){
%>

<option value="<%=slot.getSlotId()%>">

<%=slot.getSlotCode()%>

</option>

<%
}
%>

</select>

</div>

<div class="col-12">

<button
type="submit"
class="btn btn-primary btn-book">

<i class="bi bi-search"></i>

Find Available Slots

</button>

</div>

</div>

</form>

</div>

</div>

<div class="col-lg-4">

<div class="summary-card">

<h4>

Booking Summary

</h4>

<hr>

<div class="summary-item">

<small>

User

</small>

<h5>

<%=user.getFullName()%>

</h5>

</div>

<div class="summary-item">

<small>

Email

</small>

<h6>

<%=user.getEmail()%>

</h6>

</div>

<div class="summary-item">

<small>

Mobile

</small>

<h6>

<%=user.getMobile()%>

</h6>

</div>
<div class="summary-item">

<small>

Booking Status

</small>

<h6>

Ready for Booking

</h6>

</div>

<div class="summary-item">

<small>

Payment

</small>

<h6>

Dummy Payment Gateway

</h6>

</div>

<div class="summary-item">

<small>

QR Ticket

</small>

<h6>

Generated After Payment

</h6>

</div>

</div>

</div>

</div>


<!-- =======================================
     Parking Charges
======================================= -->

<div class="row mt-4">

<div class="col-lg-8">

<div class="booking-card">

<h4 class="mb-4">

<i class="bi bi-cash-stack text-success"></i>

Parking Charges

</h4>

<table class="table table-bordered align-middle">

<thead class="table-dark">

<tr>

<th>

Vehicle Type

</th>

<th>

Hourly Charge

</th>

<th>

Availability

</th>

</tr>

</thead>

<tbody>

<%
for(ParkingRate rate : rateList){
%>

<tr>

<td>

<%=rate.getVehicleType()%>

</td>

<td>

₹<%=rate.getHourlyRate()%>/Hour

</td>

<td>

<span class="badge bg-success">

Available

</span>

</td>

</tr>

<%
}
%>

</tbody>

</table>

</div>

</div>


<!-- =======================================
     Parking Slot Legend
======================================= -->

<div class="col-lg-4">

<div class="booking-card">

<h4 class="mb-4">

<i class="bi bi-grid-fill text-primary"></i>

Slot Status

</h4>

<div class="d-flex align-items-center mb-3">

<span class="badge bg-success me-3">

&nbsp;

</span>

Available

</div>

<div class="d-flex align-items-center mb-3">

<span class="badge bg-warning text-dark me-3">

&nbsp;

</span>

Reserved

</div>

<div class="d-flex align-items-center mb-3">

<span class="badge bg-danger me-3">

&nbsp;

</span>

Occupied

</div>

<div class="d-flex align-items-center">

<span class="badge bg-secondary me-3">

&nbsp;

</span>

Disabled

</div>

</div>

</div>

</div>


<!-- =======================================
     Booking Guidelines
======================================= -->

<div class="booking-card mt-4">

<h4 class="mb-4">

<i class="bi bi-info-circle-fill text-primary"></i>

Booking Guidelines

</h4>

<div class="row">

<div class="col-md-6">

<ul class="list-group list-group-flush">

<li class="list-group-item">

Book your slot before arriving.

</li>

<li class="list-group-item">

Carry your QR Ticket.

</li>

<li class="list-group-item">

Reach before your entry time.

</li>

</ul>

</div>

<div class="col-md-6">

<ul class="list-group list-group-flush">

<li class="list-group-item">

Follow parking instructions.

</li>

<li class="list-group-item">

Late exit may incur additional charges.

</li>

<li class="list-group-item">

Contact support for booking issues.

</li>

</ul>

</div>

</div>

</div>
<!-- =======================================
     Help Section
======================================= -->

<div class="booking-card mt-4">

    <h4 class="mb-4">

        <i class="bi bi-headset text-primary"></i>

        Need Help?

    </h4>

    <div class="row">

        <div class="col-md-4">

            <div class="text-center">

                <i class="bi bi-question-circle display-5 text-primary"></i>

                <h5 class="mt-3">

                    FAQ

                </h5>

                <p>

                    Frequently asked questions regarding parking.

                </p>

            </div>

        </div>

        <div class="col-md-4">

            <div class="text-center">

                <i class="bi bi-envelope-fill display-5 text-danger"></i>

                <h5 class="mt-3">

                    Email Support

                </h5>

                <p>

                    support@snapspot.com

                </p>

            </div>

        </div>

        <div class="col-md-4">

            <div class="text-center">

                <i class="bi bi-telephone-fill display-5 text-success"></i>

                <h5 class="mt-3">

                    Contact

                </h5>

                <p>

                    +91 98765 43210

                </p>

            </div>

        </div>

    </div>

</div>


<footer class="text-center mt-5">

    <hr>

    <p class="text-muted">

        © 2026 SNAPSPOT - QR Based Parking System

    </p>

</footer>

</div>

</section>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>

document.addEventListener("DOMContentLoaded", function(){

    const today = new Date();

    today.setHours(0,0,0,0);

    const yyyy = today.getFullYear();
    const mm = String(today.getMonth()+1).padStart(2,'0');
    const dd = String(today.getDate()).padStart(2,'0');

    document.getElementsByName("bookingDate")[0].min =
            yyyy + "-" + mm + "-" + dd;

});

</script>

</body>

</html>