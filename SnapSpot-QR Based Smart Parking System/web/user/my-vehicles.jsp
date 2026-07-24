<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Vehicle"%>

<%
    List<Vehicle> vehicleList =
            (List<Vehicle>) request.getAttribute("vehicleList");

    String error =
            (String) request.getAttribute("error");
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>My Vehicles | SNAPSPOT</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

</head>

<body class="bg-light">

<div class="container mt-5">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <h2>My Vehicles</h2>

        <a href="<%=request.getContextPath()%>/user/add-vehicle.jsp"
           class="btn btn-success">
            + Register Vehicle
        </a>

    </div>

    <% if(error != null){ %>

        <div class="alert alert-danger">

            <%= error %>

        </div>

    <% } %>

    <% if(vehicleList == null || vehicleList.isEmpty()){ %>

        <div class="alert alert-warning text-center">

            <h5>No Vehicles Registered</h5>

            <p class="mb-3">
                Register your first vehicle to start booking parking slots.
            </p>

            <a href="<%=request.getContextPath()%>/AddVehicleServlet"
               class="btn btn-primary">
                Register Vehicle
            </a>

        </div>

    <% } else { %>

    <div class="card shadow">

        <div class="card-body">

            <table class="table table-bordered table-hover align-middle">

                <thead class="table-dark">

                <tr>

                    <th>S.No</th>

                    <th>Vehicle Number</th>

                    <th>Vehicle Type</th>

                    <th>Actions</th>

                </tr>

                </thead>

                <tbody>

                <%

                    int count = 1;

                    for(Vehicle vehicle : vehicleList){

                %>

                <tr>

                    <td><%= count++ %></td>

                    <td><%= vehicle.getVehicleNumber() %></td>

                    <td><%= vehicle.getVehicleType() %></td>
                    
                    <td>

                        <a href="<%=request.getContextPath()%>/EditVehicleServlet?id=<%=vehicle.getVehicleId()%>"
                           class="btn btn-warning btn-sm">

                            Edit

                        </a>

                        <a href="<%=request.getContextPath()%>/DeleteVehicleServlet?id=<%=vehicle.getVehicleId()%>"
                           class="btn btn-danger btn-sm"
                           onclick="return confirm('Are you sure you want to delete this vehicle?');">

                            Delete

                        </a>

                    </td>

                </tr>

                <%

                    }

                %>

                </tbody>

            </table>

        </div>

    </div>

    <% } %>

    <div class="text-center mt-4">

        <a href="<%=request.getContextPath()%>/UserDashboardServlet"
           class="btn btn-secondary">

            Back to Dashboard

        </a>

    </div>

</div>

</body>

</html>