<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.logging.Level" %>
<%@ page import="java.util.logging.Logger" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Lab Appointment System - Edit Appointment</title>
    
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
        .appointment-container {
            margin-left: 250px;
            padding: 16px;
            max-width: 80%;
        }
        .card {
            margin-top: 20px;
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

        // Check if the appointment ID is provided in the query parameter
        String appointmentIdParam = request.getParameter("id");
        if (appointmentIdParam == null || appointmentIdParam.isEmpty()) {
            out.println("<div class='container mt-3'><div class='alert alert-danger' role='alert'>Invalid appointment ID. Please provide a valid ID.</div></div>");
        } else {
            int appointmentId = Integer.parseInt(appointmentIdParam);

            // Check if the form is submitted
            if (request.getMethod().equals("POST")) {
                // Retrieve form data
                String updatedDate = request.getParameter("appointmentDate");
                String updatedTime = request.getParameter("appointmentTime");
                String updatedDoctorName = request.getParameter("doctorName");
                String updatedAppointmentPurpose = request.getParameter("appointmentPurpose");

                // SQL query to update appointment details
                String updateSql = "UPDATE appointments SET appointment_date=?, appointment_time=?, doctor_name=?, appointment_purpose=? WHERE id=?";
                stmt = conn.prepareStatement(updateSql);
                stmt.setString(1, updatedDate);
                stmt.setString(2, updatedTime);
                stmt.setString(3, updatedDoctorName);
                stmt.setString(4, updatedAppointmentPurpose);
                stmt.setInt(5, appointmentId);

                // Execute the update
                int rowsUpdated = stmt.executeUpdate();

                // Check if the update was successful
                if (rowsUpdated > 0) {
                    out.println("<div class='container mt-3'><div class='alert alert-success' role='alert'>Appointment details updated successfully.</div></div>");
                } else {
                    out.println("<div class='container mt-3'><div class='alert alert-danger' role='alert'>Failed to update appointment details. Please try again.</div></div>");
                }
            }

            // Fetch the updated appointment details
            String sql = "SELECT * FROM appointments WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, appointmentId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                // Appointment data
                String patientId = rs.getString("patient_id");
                String appointmentDate = rs.getString("appointment_date");
                String appointmentTime = rs.getString("appointment_time");
                String doctorName = rs.getString("doctor_name");
                String appointmentPurpose = rs.getString("appointment_purpose");

                %>
                <div class="container appointment-container">
                    <div class="card">
                        <div class="card-header">
                            <h2 class="text-center mb-4">Edit Appointment</h2>
                        </div>
                        <div class="card-body">
                            <!-- Edit Appointment Form -->
                            <form method="post">
                                <div class="mb-3">
                                    <label for="patientId" class="form-label">Patient ID</label>
                                    <input type="text" class="form-control" id="patientId" name="patientId" value="<%= patientId %>" readonly>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="appointmentDate" class="form-label">Appointment Date</label>
                                    <input type="date" class="form-control" id="appointmentDate" name="appointmentDate" value="<%= appointmentDate %>" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="appointmentTime" class="form-label">Appointment Time</label>
                                    <input type="time" class="form-control" id="appointmentTime" name="appointmentTime" value="<%= appointmentTime %>" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="doctorName" class="form-label">Doctor Name</label>
                                    <input type="text" class="form-control" id="doctorName" name="doctorName" value="<%= doctorName %>" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="appointmentPurpose" class="form-label">Appointment Purpose</label>
                                    <textarea class="form-control" id="appointmentPurpose" name="appointmentPurpose" rows="3" required><%= appointmentPurpose %></textarea>
                                </div>
                                
                                <button type="submit" class="btn btn-primary btn-block">Save Changes</button>
                                <a href="AppoinmentList.jsp" class="btn btn-info btn-block">Back</a>
                            </form>
                        </div>
                    </div>
                </div>
                <%
            } else {
                out.println("<div class='container mt-3'><div class='alert alert-danger' role='alert'>Appointment not found. Please provide a valid ID.</div></div>");
            }
        }
    } catch (ClassNotFoundException | SQLException | NumberFormatException e) {
        // Handle exceptions
        Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Exception occurred during appointment editing", e);
        out.println("<div class='container mt-3'><div class='alert alert-danger' role='alert'>An error occurred during appointment editing. Please try again later. Error: " + e.getMessage() + "</div></div>");
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
