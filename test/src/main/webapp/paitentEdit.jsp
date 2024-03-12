<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.logging.Level, java.util.logging.Logger"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Lab Appointment System - Edit Patient</title>
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    
    <!-- Custom styles -->
    <style>
        body {
            background-color: #f8f9fa;
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
        .edit-container {
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
    // Database connection parameters
    String url = "jdbc:mysql://localhost:3306/lb";
    String username = "root";
    String password = "";

    // Patient ID obtained from the URL parameter
    String patientIdString = request.getParameter("id");

    // JDBC variables
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        // Load JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Establish the connection
        conn = DriverManager.getConnection(url, username, password);

        // SQL query to retrieve patient details based on ID
        String sql = "SELECT * FROM patients WHERE id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, patientIdString);

        // Execute the query
        rs = stmt.executeQuery();

        // Check if a record is found
        if (rs.next()) {
            // Retrieve values from the result set
            String firstName = rs.getString("firstName");
            String lastName = rs.getString("lastName");
            String email = rs.getString("email");
            String phoneNumber = rs.getString("phoneNumber");
            String dateOfBirth = rs.getString("dateOfBirth");
            String address = rs.getString("address");
            String medicalHistory = rs.getString("medicalHistory");
%>

<div class="edit-container">
    <div class="card">
        <div class="card-body">
            <h2 class="card-title text-center mb-4">Edit Patient</h2>
            
            <!-- Edit Patient Form -->
            <form>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="firstName" class="form-label">First Name</label>
                        <input type="text" class="form-control" id="firstName" name="firstName" value="<%= firstName %>" required>
                    </div>
                    <div class="col-md-6">
                        <label for="lastName" class="form-label">Last Name</label>
                        <input type="text" class="form-control" id="lastName" name="lastName" value="<%= lastName %>" required>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" id="email" name="email" value="<%= email %>" required>
                </div>
                
                <div class="mb-3">
                    <label for="phoneNumber" class="form-label">Phone Number</label>
                    <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" value="<%= phoneNumber %>" required>
                </div>
                
                <div class="mb-3">
                    <label for="dateOfBirth" class="form-label">Date of Birth</label>
                    <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" value="<%= dateOfBirth %>" required>
                </div>
                
                <div class="mb-3">
                    <label for="address" class="form-label">Address</label>
                    <textarea class="form-control" id="address" name="address" rows="3" required><%= address %></textarea>
                </div>
                
                <div class="mb-3">
                    <label for="medicalHistory" class="form-label">Medical History</label>
                    <textarea class="form-control" id="medicalHistory" name="medicalHistory" rows="3"><%= medicalHistory %></textarea>
                </div>
                
                <button type="submit" class="btn btn-primary btn-block">Save Changes</button>
                <a href="paitentMg.jsp" class="btn btn-info btn-block">Back</a>
            </form>
        </div>
    </div>
</div>

<%
        } else {
            // No record found for the given patient ID
            out.println("<div class='container mt-3'><div class='alert alert-danger' role='alert'>Patient not found. Please check the patient ID.</div></div>");
        }
    } catch (ClassNotFoundException | SQLException e) {
        // Handle exceptions
        Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Exception occurred during patient data retrieval", e);
        out.println("<div class='container mt-3'><div class='alert alert-danger' role='alert'>An error occurred. Please try again later.</div></div>");
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
