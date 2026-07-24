<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Add Vehicle | SNAPSPOT</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

</head>

<body class="bg-light">

<div class="container mt-5">

    <div class="row justify-content-center">

        <div class="col-md-6">

            <div class="card shadow">

                <div class="card-header bg-success text-white">

                    <h3 class="mb-0">
                        Register New Vehicle
                    </h3>

                </div>

                <div class="card-body">

                    <%
                        String error =
                                (String) request.getAttribute("error");

                        if(error != null){
                    %>

                    <div class="alert alert-danger">

                        <%= error %>

                    </div>

                    <%
                        }
                    %>

                    <form action="<%=request.getContextPath()%>/AddVehicleServlet"
                          method="post">

                        <div class="mb-3">

                            <label class="form-label">

                                Vehicle Number

                            </label>

                            <input
                                type="text"
                                name="vehicleNumber"
                                class="form-control"
                                placeholder="TN01AB1234"
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

                                <option value="">Select Vehicle Type</option>

                                <option value="Bike">Bike</option>

                                <option value="Car">Car</option>

                                <option value="SUV">SUV</option>

                                <option value="Van">Van</option>

                                <option value="Bus">Bus</option>

                                <option value="Truck">Truck</option>

                            </select>

                        </div>

                        <button
                            type="submit"
                            class="btn btn-success w-100">

                            Register Vehicle

                        </button>

                    </form>

                </div>

                <div class="card-footer text-center">

                    <a href="<%=request.getContextPath()%>/MyVehiclesServlet"
                       class="btn btn-secondary">

                        Back to My Vehicles

                    </a>

                </div>

            </div>

        </div>

    </div>

</div>

</body>

</html>