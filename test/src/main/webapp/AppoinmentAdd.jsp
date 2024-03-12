<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.logging.Level" %>
<%@ page import="java.util.logging.Logger" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Lab Appointment System - Appointment Booking</title>
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    
    <!-- Custom styles -->
    <style>
        body {
            background-size: cover;
            color: #000000;
            font-family: 'Arial', sans-serif;
            margin: 0; /* Remove default margin */
            padding: 0; /* Remove default padding */
        }

        .overlay {
            background-color: rgba(0, 0, 0, 0.6);
            height: 100%;
            width: 100%;
            top: 0;
            left: 0;
            z-index: -1;
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

        .appointment-container {
            margin-left: 250px;
            max-width: 80%;
        }
    </style>
</head>
<body>

<%@include file="Sidebar.jsp" %>
<%
    // Connection parameters for MySQL database
    String url = "jdbc:mysql://localhost:3306/lb?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
    String username = "root";
    String password = "";

    // JDBC variables
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        // Load JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Establish the connection
        conn = DriverManager.getConnection(url, username, password);

        // Check if the form is submitted
        if (request.getMethod().equalsIgnoreCase("POST")) {
            // Form data
            String patientId = request.getParameter("patientId");
            String appointmentDate = request.getParameter("appointmentDate");
            String appointmentTime = request.getParameter("appointmentTime");
            String doctorName = request.getParameter("doctorName");
            String appointmentPurpose = request.getParameter("appointmentPurpose");

            // SQL query to insert data into the 'appointments' table
            String sql = "INSERT INTO appointments (patient_id, appointment_date, appointment_time, doctor_name, appointment_purpose) VALUES (?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);

            // Set parameters for the SQL query
            stmt.setString(1, patientId);
            stmt.setString(2, appointmentDate);
            stmt.setString(3, appointmentTime);
            stmt.setString(4, doctorName);
            stmt.setString(5, appointmentPurpose);

            // Execute the query
            int rowsAffected = stmt.executeUpdate();

            // Display success message if data is inserted
            if (rowsAffected > 0) {
                out.println("<div class='container mt-3'><div class='alert alert-success' role='alert'>Appointment booked successfully!</div></div>");
            } else {
                out.println("<div class='container mt-3'><div class='alert alert-danger' role='alert'>Failed to book appointment. Please try again.</div></div>");
            }
        }

        // Fetch patient names and IDs for the dropdown
        String patientQuery = "SELECT id, CONCAT(firstName, ' ', lastName) AS fullName FROM patients";
        stmt = conn.prepareStatement(patientQuery);
        rs = stmt.executeQuery();
%>

<div class="container appointment-container">
    <div class="card mt-3">
        <div class="card-header">
            <h2 class="text-center">Appointment Booking</h2>
        </div>
        <div class="card-body">
            <!-- Appointment Booking Form -->
            <form method="post">
                <div class="mb-3">
                    <label for="patientId" class="form-label">Patient Name</label>
                    <select class="form-control" id="patientId" name="patientId" required>
                        <%
                            // Populate dropdown with patient names and IDs
                            while (rs.next()) {
                                String patientId = rs.getString("id");
                                String fullName = rs.getString("fullName");
                        %>
                                <option value="<%= patientId %>"><%= fullName %></option>
                        <%
                            }
                        %>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="appointmentDate" class="form-label">Appointment Date</label>
                    <input type="date" class="form-control" id="appointmentDate" name="appointmentDate" required>
                </div>

                <div class="mb-3">
                    <label for="appointmentTime" class="form-label">Appointment Time</label>
                    <input type="time" class="form-control" id="appointmentTime" name="appointmentTime" required>
                </div>

                <div class="mb-3">
                    <label for="doctorName" class="form-label">Doctor Name</label>
                    <input type="text" class="form-control" id="doctorName" name="doctorName" required>
                </div>

                <div class="mb-3">
                    <label for="appointmentPurpose" class="form-label">Appointment Purpose</label>
                    <textarea class="form-control" id="appointmentPurpose" name="appointmentPurpose" rows="3" required></textarea>
                </div>

                <button type="submit" class="btn btn-primary btn-block">Book Appointment</button>
                <a href="AppoinmentList.jsp" class="btn btn-info btn-block">Back</a>
            </form>
        </div>
    </div>
</div>

<%
    } catch (ClassNotFoundException | SQLException e) {
        // Handle exceptions
        Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Exception occurred during appointment booking", e);
        out.println("<div class='container mt-3'><div class='alert alert-danger' role='alert'>An error occurred during appointment booking. Please try again later. Error: " + e.getMessage() + "</div></div>");
    } finally {
        // Close JDBC resources
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<!-- Bootstrap JS and Popper.js (for Bootstrap's JavaScript components) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
