<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Lab Appointment System - Dashboard</title>

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <!-- Custom styles -->
        <style>
        body {
            background-color: #f8f9fa;
        }
        .bill-container {
            max-width: 800px;
            margin: auto;
            margin-top: 50px;
        }
         .sidebar {
            height: 100%;
            width: 250px;
            position: fixed;
            z-index: 1;
            top: 0;
            left: 0;
            background-color: #343a40;
            padding-top: 20px;
            padding-right: 10px;
        }
        .sidebar a {
            padding: 10px 16px;
            text-decoration: none;
            font-size: 18px;
            color: white;
            display: block;
        }
        .sidebar a:hover {
            background-color: #212529;
        }
        .content {
            margin-left: 250px;
            padding: 16px;
        }
    </style>
</head>

<body>

    <div class="overlay"></div>

    <!-- Sidebar -->
    <%@include file="Sidebar.jsp" %>

    <!-- Page content -->
    <div class="content">
        <h2>Dashboard</h2>

        <div class="row">
            <!-- Appointments Card -->
            <div class="col-md-3">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Appointments</h5>
                        <p class="card-text">
                            <%
                                try {
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lb", "root", "");
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS appointmentCount FROM appointments");
                                    if (rs.next()) {
                                        out.println(rs.getInt("appointmentCount"));
                                    }
                                    rs.close();
                                    stmt.close();
                                    conn.close();
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                            %>
                        </p>
                        <a href="AppointmentList.jsp" class="btn btn-primary">View Details</a>
                    </div>
                </div>
            </div>

            
            <div class="col-md-3">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Bills</h5>
                        <p class="card-text">
                            <%
                                try {
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lb", "root", "");
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS billCount FROM bills");
                                    if (rs.next()) {
                                        out.println(rs.getInt("billCount"));
                                    }
                                    rs.close();
                                    stmt.close();
                                    conn.close();
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                            %>
                        </p>
                        <a href="BillList.jsp" class="btn btn-success">View Details</a>
                    </div>
                </div>
            </div>

            
            <div class="col-md-3">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Tests</h5>
                        <p class="card-text">
                            <%
                                try {
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lb", "root", "");
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS testCount FROM tests");
                                    if (rs.next()) {
                                        out.println(rs.getInt("testCount"));
                                    }
                                    rs.close();
                                    stmt.close();
                                    conn.close();
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                            %>
                        </p>
                        <a href="TestList.jsp" class="btn btn-info">View Details</a>
                    </div>
                </div>
            </div>

           
            <div class="col-md-3">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Patients</h5>
                        <p class="card-text">
                            <%
                                try {
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lb", "root", "");
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS patientCount FROM patients");
                                    if (rs.next()) {
                                        out.println(rs.getInt("patientCount"));
                                    }
                                    rs.close();
                                    stmt.close();
                                    conn.close();
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                            %>
                        </p>
                        <a href="PatientList.jsp" class="btn btn-warning">View Details</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS and Popper.js (for Bootstrap's JavaScript components) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>
