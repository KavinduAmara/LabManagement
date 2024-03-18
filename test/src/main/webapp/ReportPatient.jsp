<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.logging.Level" %>
<%@ page import="java.util.logging.Logger" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Lab Appointment System - Patient History</title>
    
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
        .patient-container {
            margin-left: 250px;
            padding: 16px;
            max-width:80%;
        }
        .card {
            margin-top: 20px;
        }

        /* Print Styles */
        @media print {
            body {
                background-color: white;
            }
            .print-hidden {
                display: none;
            }
            .print-visible {
                display: block !important;
            }
        }
    </style>
</head>
<body>
<%@include file="Sidebar2.jsp" %>
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

        // Check if the patient ID is provided in the query parameter
        String patientIdParam = request.getParameter("reportId");
        out.println(patientIdParam);
        if (patientIdParam == null || patientIdParam.isEmpty()) {
            out.println("<div class='container mt-3'><div class='card'><div class='card-body'><div class='alert alert-danger' role='alert'>Invalid patient ID. Please provide a valid ID.</div></div></div></div>");
        } else {
            int patientId = Integer.parseInt(patientIdParam);

            // Fetch the patient details
            String patientSql = "SELECT * FROM patients WHERE id = ?";
            stmt = conn.prepareStatement(patientSql);
            stmt.setInt(1, patientId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                // Patient data
                String patientName = rs.getString("firstName") + " " + rs.getString("lastName");
                String dob = rs.getString("dateOfBirth");
                String gender = rs.getString("email");
                String contactNumber = rs.getString("phoneNumber");
                String address = rs.getString("medicalHistory");

                %>
                <div class="container patient-container">
                    <div class="card">
                        <div class="card-body">
                            <h2 class="card-title text-center mb-4">View Patient History</h2>
                            
                            <!-- View Patient History -->
                            <div class="mb-3">
                                <label for="patientName" class="form-label">Patient Name</label>
                                <input type="text" class="form-control" id="patientName" name="patientName" value="<%= patientName %>" readonly>
                            </div>

                            <div class="mb-3">
                                <label for="dob" class="form-label">Date of Birth</label>
                                <input type="text" class="form-control" id="dob" name="dob" value="<%= dob %>" readonly>
                            </div>

                            <div class="mb-3">
                                <label for="gender" class="form-label">Email</label>
                                <input type="text" class="form-control" id="gender" name="gender" value="<%= gender %>" readonly>
                            </div>

                            <div class="mb-3">
                                <label for="contactNumber" class="form-label">Contact Number</label>
                                <input type="text" class="form-control" id="contactNumber" name="contactNumber" value="<%= contactNumber %>" readonly>
                            </div>

                            <div class="mb-3">
                                <label for="address" class="form-label">Medical History</label>
                                <textarea class="form-control" id="address" name="address" rows="3" readonly><%= address %></textarea>
                            </div>

                            <!-- Add more fields as needed -->

                            <div class="print-hidden">
                                <!-- Edit Patient Form -->
                                <form method="post">
                                    <!-- Your existing form fields -->
                                    <a href="ReportPaiHs.jsp" class="btn btn-info btn-block">Back</a><br><br>
                                </form>
                            </div>
                            
                            <!-- Print Button -->
                            <div class="mb-3">
                                <button class="btn btn-success btn-block print-visible" onclick="printPatientHistory()">Print Patient History</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Print Script -->
                <script>
                    function printPatientHistory() {
                        window.print();
                    }
                </script>
                <%
            } else {
                out.println("<div class='container mt-3'><div class='card'><div class='card-body'><h2 class='card-title text-center mb-4'>View Patient History</h2><div class='alert alert-danger' role='alert'>Patient not found. Please provide a valid ID.</div><a href='PatientList.jsp' class='btn btn-info btn-sm'>Back</a></div></div></div>");
            }
        }
    } catch (ClassNotFoundException | SQLException | NumberFormatException e) {
        Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Exception occurred during patient history viewing", e);
        out.println("<div class='container mt-3'><div class='card'><div class='card-body'><h2 class='card-title text-center mb-4'>View Patient History</h2><div class='alert alert-danger' role='alert'>An error occurred during patient history viewing. Please try again later. Error: " + e.getMessage() + "</div><a href='PatientList.jsp' class='btn btn-info btn-sm'>Back</a></div></div></div>");
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