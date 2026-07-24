<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Vehicle"%>

<%
    Vehicle vehicle = (Vehicle) request.getAttribute("vehicle");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Edit Vehicle | SNAPSPOT</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

</head>

<body class="bg-light">

<div class="container mt-5">

    <div class="row justify-content-center">

        <div class="col-md-6">

            <div class="card shadow">

                <div class="card-header bg-warning text-dark">

                    <h3 class="mb-0">

                        Edit Vehicle

                    </h3>

                </div>

                <div class="card-body">

                    <% if(error != null){ %>

                        <div class="alert alert-danger">

                            <%= error %>

                        </div>

                    <% } %>

                    <% if(vehicle != null){ %>

                    <form action="<%=request.getContextPath()%>/EditVehicleServlet"
                          method="post">

                        <input
                            type="hidden"
                            name="vehicleId"
                            value="<%=vehicle.getVehicleId()%>">

                        <div class="mb-3">

                            <label class="form-label">

                                Vehicle Number

                            </label>

                            <input
                                type="text"
                                name="vehicleNumber"
                                class="form-control"
                                value="<%=vehicle.getVehicleNumber()%>"
                                required>

                        </div>

                        <div class="mb-3">

                            <label class="form-label">

                                Vehicle Type

                            </label>

                            <select
                                name="vehicleType"
                                class="form-select"
                                required>

                                <option value="Bike"
                                    <%= "Bike".equalsIgnoreCase(vehicle.getVehicleType()) ? "selected" : "" %>>
                                    Bike
                                </option>

                                <option value="Car"
                                    <%= "Car".equalsIgnoreCase(vehicle.getVehicleType()) ? "selected" : "" %>>
                                    Car
                                </option>

                                <option value="SUV"
                                    <%= "SUV".equalsIgnoreCase(vehicle.getVehicleType()) ? "selected" : "" %>>
                                    SUV
                                </option>

                                <option value="Van"
                                    <%= "Van".equalsIgnoreCase(vehicle.getVehicleType()) ? "selected" : "" %>>
                                    Van
                                </option>

                                <option value="Bus"
                                    <%= "Bus".equalsIgnoreCase(vehicle.getVehicleType()) ? "selected" : "" %>>
                                    Bus
                                </option>

                                <option value="Truck"
                                    <%= "Truck".equalsIgnoreCase(vehicle.getVehicleType()) ? "selected" : "" %>>
                                    Truck
                                </option>

                            </select>

                        </div>

                        <div class="d-grid gap-2">

                            <button
                                type="submit"
                                class="btn btn-warning">

                                Update Vehicle

                            </button>

                            <a href="<%=request.getContextPath()%>/MyVehiclesServlet"
                               class="btn btn-secondary">

                                Cancel

                            </a>

                        </div>

                    </form>

                    <% } else { %>

                        <div class="alert alert-warning text-center">

                            Vehicle details not found.

                        </div>

                        <div class="text-center">

                            <a href="<%=request.getContextPath()%>/MyVehiclesServlet"
                               class="btn btn-secondary">

                                Back

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