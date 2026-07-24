<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Booking"%>

<%
    List<Booking> bookingList =
            (List<Booking>) request.getAttribute("bookingList");
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Booking History | SNAPSPOT</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

</head>

<body class="bg-light">

<div class="container mt-5">

    <div class="card shadow">

        <div class="card-header bg-primary text-white">

            <h3 class="mb-0">
                My Booking History
            </h3>

        </div>

        <div class="card-body">

            <%
                if (bookingList == null || bookingList.isEmpty()) {
            %>

            <div class="alert alert-info text-center">

                No bookings found.

            </div>

            <%
                } else {
            %>

            <div class="table-responsive">

                <table class="table table-bordered table-hover align-middle">

                    <thead class="table-dark">

                    <tr>

                        <th>Booking ID</th>
                        <th>Vehicle</th>
                        <th>Type</th>
                        <th>Slot</th>
                        <th>Date</th>
                        <th>Entry</th>
                        <th>Exit</th>
                        <th>Amount</th>
                        <th>Payment</th>
                        <th>Status</th>
                        <th>QR</th>

                    </tr>

                    </thead>

                    <tbody>

                    <%
                        for (Booking booking : bookingList) {
                    %>

                    <tr>

                        <td>

                            <%= booking.getBookingId() %>

                        </td>

                        <td>

                            <%= booking.getVehicleNumber() %>

                        </td>

                        <td>

                            <%= booking.getVehicleType() %>

                        </td>

                        <td>

                            <%= booking.getSlotCode() %>

                        </td>

                        <td>

                            <%= booking.getBookingDate() %>

                        </td>

                        <td>

                            <%= booking.getEntryTime() %>

                        </td>

                        <td>

                            <%= booking.getExitTime() %>

                        </td>

                        <td>

                            ₹ <%= booking.getTotalAmount() %>

                        </td>

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

                        <td>

                            <%
                                String status =
                                        booking.getBookingStatus();

                                String badge = "secondary";

                                if ("BOOKING_CONFIRMED".equalsIgnoreCase(status)) {

                                    badge = "primary";

                                } else if ("BOOKING_ACTIVE".equalsIgnoreCase(status)) {

                                    badge = "warning";

                                } else if ("BOOKING_COMPLETED".equalsIgnoreCase(status)) {

                                    badge = "success";

                                } else if ("BOOKING_CANCELLED".equalsIgnoreCase(status)) {

                                    badge = "danger";

                                }
                            %>

                            <span class="badge bg-<%=badge%>">

                                <%= status %>

                            </span>

                        </td>

                        <td>

                            <%
                                if (booking.getQrCode() != null
                                        && !booking.getQrCode().isEmpty()) {
                            %>

                            <a href="<%=request.getContextPath()%>/<%=booking.getQrCode()%>"
                               target="_blank"
                               class="btn btn-success btn-sm">

                                View QR

                            </a>

                            <%
                                } else {
                            %>

                            -

                            <%
                                }
                            %>

                        </td>

                    </tr>

                    <%
                        }
                    %>

                    </tbody>

                </table>

            </div>

            <%
                }
            %>

        </div>

    </div>

</div>

</body>

</html>