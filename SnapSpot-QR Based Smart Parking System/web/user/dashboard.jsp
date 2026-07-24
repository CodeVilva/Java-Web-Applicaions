<%@page import="model.User"%>
<%@page import="model.Vehicle"%>
<%@page import="constant.AppConstants"%>
<%@page import="dao.VehicleDAO" %>
<%@page import="dao.ParkingRateDAO" %>
<%@page import="dao.BookingDAO" %>
<%@page import="java.util.List"%>
<%@page import="model.Booking"%>
<%@page import="model.ParkingRate"%>
<%@page import="dao.ParkingRateDAO" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
User user=(User)session.getAttribute(AppConstants.SESSION_USER);

if(user==null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport"
content="width=device-width, initial-scale=1.0">

<title>User Dashboard | SNAPSPOT</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&family=Space+Grotesk:wght@500;600;700&display=swap" rel="stylesheet">

<link rel="stylesheet" href="../css/style.css">

<style>

body{

background:#F5F7FA;

font-family:'Inter',sans-serif;

}

.dashboard-section{

padding-top:110px;

padding-bottom:60px;

}

.welcome-card{

background:linear-gradient(135deg,#0d6efd,#2d8cff);

border-radius:20px;

padding:35px;

color:#fff;

box-shadow:0 15px 35px rgba(0,0,0,.15);

}

.welcome-card h2{

font-family:'Space Grotesk',sans-serif;

font-weight:700;

}

.action-card{

background:#fff;

border-radius:18px;

padding:30px;

transition:.3s;

cursor:pointer;

box-shadow:0 10px 25px rgba(0,0,0,.08);

height:100%;

}

.action-card:hover{

transform:translateY(-8px);

}

.action-icon{

width:70px;

height:70px;

border-radius:18px;

display:flex;

align-items:center;

justify-content:center;

background:#0d6efd;

color:#fff;

font-size:28px;

margin-bottom:20px;

}

.summary-card{

background:#fff;

border-radius:18px;

padding:30px;

box-shadow:0 10px 25px rgba(0,0,0,.08);

margin-top:30px;

}

.table td{

vertical-align:middle;

}

.price-box{

background:#fff;

border-radius:18px;

padding:30px;

box-shadow:0 10px 25px rgba(0,0,0,.08);

margin-top:30px;

}

.logout-btn{

border-radius:50px;

}

</style>

</head>

<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">

<div class="container">

<a class="navbar-brand"
href="../index.jsp">

<i class="bi bi-qr-code"></i>

SNAP<span class="text-primary">SPOT</span>

</a>

<div class="ms-auto">

<a href="<%=request.getContextPath()%>/LogoutServlet"

class="btn btn-outline-light logout-btn">

<i class="bi bi-box-arrow-right"></i>

Logout

</a>

</div>

</div>

</nav>

<section class="dashboard-section">

<div class="container">

<div class="welcome-card">

<div class="row align-items-center">

<div class="col-md-8">

<h2>

Welcome,

<%=user.getFullName()%>

👋

</h2>

<p class="mb-1">

Manage your parking bookings,

vehicles and QR tickets from here.

</p>

</div>

<div class="col-md-4 text-md-end">

<h5>

<%=user.getEmail()%>

</h5>

<p>

<%=user.getMobile()%>

</p>

</div>

</div>

</div>

<div class="row mt-5 g-4">

<div class="col-lg-3">

<a href="<%=request.getContextPath()%>/BookSlotPageServlet"

class="text-decoration-none text-dark">

<div class="action-card">

<div class="action-icon">

<i class="bi bi-p-square"></i>

</div>

<h5>

Book Slot

</h5>

<p>

Reserve a parking slot instantly.

</p>

</div>

</a>

</div>

<div class="col-lg-3">

<a href="<%=request.getContextPath()%>/ActiveBookingServlet"

class="text-decoration-none text-dark">

<div class="action-card">

<div class="action-icon">

<i class="bi bi-clock-history"></i>

</div>

<h5>

Active Booking

</h5>

<p>

View your current parking.

</p>

</div>

</a>

</div>

<div class="col-lg-3">

<a href="<%=request.getContextPath()%>/BookingHistoryServlet"

class="text-decoration-none text-dark">

<div class="action-card">

<div class="action-icon">

<i class="bi bi-card-checklist"></i>

</div>

<h5>

Booking History

</h5>

<p>

View all completed bookings.

</p>

</div>

</a>

</div>

<div class="col-lg-3">

<a href="<%=request.getContextPath()%>/MyVehiclesServlet"

class="text-decoration-none text-dark">

<div class="action-card">

<div class="action-icon">

<i class="bi bi-car-front-fill"></i>

</div>

<h5>

My Vehicles

</h5>

<p>

Manage your registered vehicles.

</p>

</div>

</a>

</div>

</div>
<!-- ============================
     Active Booking Summary
============================= -->

<div class="summary-card">

<div class="d-flex justify-content-between align-items-center mb-4">

<h4>

<i class="bi bi-ticket-perforated-fill text-primary"></i>

Active Booking

</h4>

<a href="<%=request.getContextPath()%>/ActiveBookingServlet"
class="btn btn-primary btn-sm">

View All

</a>

</div>

<table class="table table-hover">

<thead>

<tr>

<th>Booking ID</th>

<th>Vehicle</th>

<th>Slot</th>

<th>Status</th>

<th>Action</th>

</tr>
</thead>
<%
List<Booking> activeBookings =
        (List<Booking>)request.getAttribute("activeBookings");
%>
<tbody>
<% if(activeBookings==null || activeBookings.isEmpty()){ %>
<tr>
    <td colspan="5" class="text-center">
        No Active Booking Available
    </td>
</tr>
<% }else{

for(Booking booking:activeBookings){

%>
<tr>

<td><%=booking.getBookingId()%></td>

<td><%=booking.getVehicleNumber()%></td>

<td><%=booking.getSlotCode()%></td>

<td>
<span class="badge bg-success">
<%=booking.getBookingStatus()%>
</span>
</td>

<td>

<a href="<%=request.getContextPath()%>/ActiveBookingServlet?id=<%=booking.getBookingId()%>"
class="btn btn-sm btn-primary">

View

</a>

</td>

</tr>

<%
}
}
%>

</tbody>

</table>

</div>


<!-- ============================
     Parking Charges
============================= -->

<div class="price-box">

<h4 class="mb-4">

<i class="bi bi-cash-stack text-success"></i>

Parking Charges

</h4>

<div class="table-responsive">

<table class="table table-bordered align-middle">

<thead class="table-dark">

<tr>

<th>Vehicle Type</th>

<th>Hourly Charge</th>

<th>Status</th>

</tr>

</thead>

<tbody>

<%
List<ParkingRate> parkingRates =
(List<ParkingRate>)request.getAttribute("parkingRates");
%>

<% for(ParkingRate rate:parkingRates){ %>

<tr>

<td>

<%=rate.getVehicleType()%>

</td>

<td>

₹<%=rate.getHourlyRate()%> / Hour

</td>

<td>

<span class="badge bg-success">

Available

</span>

</td>

</tr>

<% } %>

</tbody>

</table>

</div>

</div>


<!-- ============================
     Statistics Cards
============================= -->

<div class="row mt-4">

<div class="col-lg-4 mb-4">

<div class="summary-card text-center">

<i class="bi bi-car-front-fill
display-5 text-primary"></i>

<h3 class="mt-3">
<%=request.getAttribute("vehicleCount")%>
</h3>

<p>

Registered Vehicles

</p>

</div>

</div>

<div class="col-lg-4 mb-4">

<div class="summary-card text-center">

<i class="bi bi-calendar-check-fill
display-5 text-success"></i>

<h3 class="mt-3">

<%=request.getAttribute("bookingCount")%>

</h3>

<p>

Total Bookings

</p>

</div>

</div>

<div class="col-lg-4 mb-4">

<div class="summary-card text-center">

<i class="bi bi-qr-code-scan
display-5 text-danger"></i>

<h3 class="mt-3">

<%=request.getAttribute("qrTicketCount")%>

</h3>

<p>

QR Tickets

</p>

</div>

</div>

</div>


<!-- ============================
     Notifications
============================= -->

<div class="summary-card">

<h4 class="mb-4">

<i class="bi bi-bell-fill text-warning"></i>

Notifications

</h4>

<div class="alert alert-info">

Welcome to SNAPSPOT.

Your account has been created successfully.

</div>

<div class="alert alert-warning">

Book your parking slot before arriving
to avoid congestion.

</div>

<div class="alert alert-success">

QR Tickets will appear here after
successful booking.

</div>

</div>
<!-- ============================
     Recent Activities
============================= -->

<div class="summary-card">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <h4>
            <i class="bi bi-clock-history text-primary"></i>
            Recent Activities
        </h4>

    </div>

    <ul class="list-group list-group-flush">

        <li class="list-group-item">
            <i class="bi bi-person-check-fill text-success"></i>
            Account registered successfully.
        </li>

        <li class="list-group-item">
            <i class="bi bi-car-front-fill text-primary"></i>
            Vehicle registered successfully.
        </li>

        <li class="list-group-item">
            <i class="bi bi-info-circle-fill text-warning"></i>
            No parking slot booked yet.
        </li>

    </ul>

</div>


<!-- ============================
     Help & Support
============================= -->

<div class="summary-card mt-4">

    <h4 class="mb-4">

        <i class="bi bi-headset text-success"></i>

        Help & Support

    </h4>

    <div class="row">

        <div class="col-md-4 mb-3">

            <div class="card border-0 shadow-sm">

                <div class="card-body text-center">

                    <i class="bi bi-question-circle display-5 text-primary"></i>

                    <h5 class="mt-3">

                        FAQ

                    </h5>

                    <p>

                        Find answers to common questions.

                    </p>

                </div>

            </div>

        </div>

        <div class="col-md-4 mb-3">

            <div class="card border-0 shadow-sm">

                <div class="card-body text-center">

                    <i class="bi bi-envelope-fill display-5 text-danger"></i>

                    <h5 class="mt-3">

                        Contact

                    </h5>

                    <p>

                        Reach our support team anytime.

                    </p>

                </div>

            </div>

        </div>

        <div class="col-md-4 mb-3">

            <div class="card border-0 shadow-sm">

                <div class="card-body text-center">

                    <i class="bi bi-shield-check display-5 text-success"></i>

                    <h5 class="mt-3">

                        Security

                    </h5>

                    <p>

                        Your account is protected using secure authentication.

                    </p>

                </div>

            </div>

        </div>

    </div>

</div>


<!-- ============================
     Footer
============================= -->

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

    const cards = document.querySelectorAll(".action-card");

    cards.forEach(function(card){

        card.addEventListener("mouseenter", function(){

            card.style.transition = ".3s";

        });

    });

});

</script>

</body>

</html>