<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Booking"%>

<%
    Booking booking =
            (Booking) request.getAttribute("activeBooking");

    String error =
            (String) request.getAttribute("error");
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Active Booking | SNAPSPOT</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

</head>

<body class="bg-light">

<div class="container mt-5">

    <div class="row justify-content-center">

        <div class="col-lg-8">

            <div class="card shadow">

                <div class="card-header bg-primary text-white">

                    <h3 class="mb-0">
                        Active Booking
                    </h3>

                </div>

                <div class="card-body">

                    <% if (error != null) { %>

                        <div class="alert alert-danger">

                            <%= error %>

                        </div>

                    <% } %>

                    <% if (booking == null) { %>

                        <div class="alert alert-warning text-center">

                            <h5>No Active Booking Found</h5>

                            <p class="mb-0">
                                You currently do not have any active booking.
                            </p>

                        </div>

                    <% } else { %>

                    <table class="table table-bordered">

                        <tr>
                            <th width="35%">Booking ID</th>
                            <td><%= booking.getBookingId() %></td>
                        </tr>

                        <tr>
                            <th>Vehicle Number</th>
                            <td><%= booking.getVehicleNumber() %></td>
                        </tr>

                        <tr>
                            <th>Vehicle Type</th>
                            <td><%= booking.getVehicleType() %></td>
                        </tr>

                        <tr>
                            <th>Parking Slot</th>
                            <td><%= booking.getSlotCode() %></td>
                        </tr>

                        <tr>
                            <th>Booking Date</th>
                            <td><%= booking.getBookingDate() %></td>
                        </tr>

                        <tr>
                            <th>Entry Time</th>
                            <td><%= booking.getEntryTime() %></td>
                        </tr>

                        <tr>
                            <th>Exit Time</th>
                            <td><%= booking.getExitTime() %></td>
                        </tr>

                        <tr>
                            <th>Total Amount</th>
                            <td>
                                ₹ <%= booking.getTotalAmount() %>
                            </td>
                        </tr>

                        <tr>
                            <th>Payment Status</th>

                            <td>

                                <%
                                    if ("SUCCESS".equalsIgnoreCase(
                                            booking.getPaymentStatus())) {
                                %>

                                    <span class="badge bg-success">
                                        Paid
                                    </span>

                                <%
                                    } else {
                                %>

                                    <span class="badge bg-danger">
                                        Pending
                                    </span>

                                <%
                                    }
                                %>

                            </td>

                        </tr>

                        <tr>

                            <th>Booking Status</th>

                            <td>

                                <%
                                    String badge = "secondary";

                                    if ("BOOKING_CONFIRMED".equalsIgnoreCase(
                                            booking.getBookingStatus())) {

                                        badge = "primary";

                                    } else if ("BOOKING_ACTIVE".equalsIgnoreCase(
                                            booking.getBookingStatus())) {

                                        badge = "warning";

                                    } else if ("BOOKING_COMPLETED".equalsIgnoreCase(
                                            booking.getBookingStatus())) {

                                        badge = "success";

                                    }
                                %>

                                <span class="badge bg-<%= badge %>">

                                    <%= booking.getBookingStatus() %>

                                </span>

                            </td>

                        </tr>

                        <tr>

                            <th>QR Code</th>

                            <td>

                                <% if (booking.getQrCode() != null &&
                                       !booking.getQrCode().isEmpty()) { %>

                                    <img
                                        src="<%=request.getContextPath()%>/<%=booking.getQrCode()%>"
                                        class="img-thumbnail"
                                        width="220"
                                        alt="QR Code">

                                <% } else { %>

                                    QR Code Not Available

                                <% } %>

                            </td>

                        </tr>

                    </table>

                    <div class="text-center mt-4">

                        <a href="<%=request.getContextPath()%>/user/dashboard.jsp"
                           class="btn btn-secondary">

                            Back to Dashboard

                        </a>

                    </div>

                    <% } %>

                </div>

            </div>

        </div>

    </div>

</div>

</body>

</html>