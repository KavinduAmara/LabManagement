<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Lab Test System - Patient History Reports</title>
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    
    <!-- Custom styles -->
    <style>
        body {
            background-size: cover;
            color: #000000;
            font-family: 'Arial', sans-serif;
        }

        .overlay {
            background-color: rgba(0, 0, 0, 0.6);
            height: 100%;
            width: 100%;
            position: fixed;
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
        .content {
            margin-left: 200px;
            padding:16px;
        }
        .card {
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div class="container fluid">
<%! 
    // Declaration of the method outside the scriptlet
    String getPatientName(int patientId) {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lb", "root", "");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT CONCAT(firstName, ' ', lastName) AS fullName FROM patients WHERE id = " + patientId);
            if (rs.next()) {
                return rs.getString("fullName");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }
%>

<%@include file="Sidebar2.jsp" %>

<!-- Page content -->
<div class="content">
    <h2>Patient History Reports</h2>
    
    <!-- Table for Patient History Reports -->
    <div class="card">
        <div class="card-body">
            <table class="table">
                <thead>
                    <tr>
                        <th scope="col">#</th>
                        <th scope="col">Name</th>
                        <th scope="col">Medical History</th>
                        <th scope="col">Contact Number</th>
                        <th scope="col">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        // Java code to fetch patient data from the database
                        try {
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lb", "root", "");
                            Statement stmt = conn.createStatement();
                            
                            // Get the username from the session
                            HttpSession session1 = request.getSession();
                            String usernameFromSession = (String) session1.getAttribute("username");


                            // Fetch patient data based on the username
                            ResultSet patientResult = stmt.executeQuery("SELECT * FROM patients WHERE username = '" + usernameFromSession + "'");
                            if (patientResult.next()) {
                                int patientId = patientResult.getInt("id");
                                // Fetch reports based on the patient_id
                                ResultSet rs = stmt.executeQuery("SELECT * FROM patients WHERE id = " + patientId);
                                // Loop through the result set and display report data
                                int count = 1;
                                while (rs.next()) {
                    %>
                                    <tr>
                                        <th scope="row"><%= count++ %></th>
                                        <td><%= getPatientName(patientId) %></td>
                                        <td><%= rs.getString("medicalHistory") %></td>
                                        <td><%= rs.getString("phoneNumber") %></td>
                                        <td>
                                            <a href="ReportPatient.jsp?reportId=<%= rs.getInt("id") %>" class="btn btn-warning btn-sm">View Report</a>
                                        </td>
                                    </tr>
                    <%
                                }
                                rs.close();
                            }
                            patientResult.close();
                            stmt.close();
                            conn.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Add Patient Modal -->
    <div class="modal fade" id="addPatientModal" tabindex="-1" aria-labelledby="addPatientModalLabel" aria-hidden="true">
        <!-- Modal content goes here -->
    </div>

    <!-- Edit Patient Modal -->
    <div class="modal fade" id="editPatientModal" tabindex="-1" aria-labelledby="editPatientModalLabel" aria-hidden="true">
        <!-- Modal content goes here -->
    </div>

    <!-- Delete Patient Modal -->
    <div class="modal fade" id="deletePatientModal" tabindex="-1" aria-labelledby="deletePatientModalLabel" aria-hidden="true">
        <!-- Modal content goes here -->
    </div>
</div>

<!-- Bootstrap JS and Popper.js (for Bootstrap's JavaScript components) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</div>
</body>
</html>
