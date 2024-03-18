<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Lab Test System - Test Reports</title>
    
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
    <h2>Test Reports</h2>
    
    <!-- Table for Test List -->
    <div class="card">
        <div class="card-body">
            <table class="table">
                <thead>
                    <tr>
                        <th scope="col">#</th>
                        <th scope="col">Patient Name</th>
                        <th scope="col">Test Name</th>
                        <th scope="col">Test Date</th>
                        <th scope="col">Test Time</th>
                        <th scope="col">Test Result</th>
                        <th scope="col">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        // Java code to fetch test data from the database based on session log username
                        try {
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lb", "root", "");
                            Statement stmt = conn.createStatement();
                            
                            // Get the username from the session
                            HttpSession session1 = request.getSession();
                            String usernameFromSession = (String) session1.getAttribute("username");
                            
                            // Fetch patient_id based on the username
                            ResultSet patientIdResult = stmt.executeQuery("SELECT id FROM patients WHERE username = '" + usernameFromSession + "'");
                            if (patientIdResult.next()) {
                                int patientId = patientIdResult.getInt("id");
                                
                                // Fetch tests based on the patient_id
                                ResultSet rs = stmt.executeQuery("SELECT * FROM tests WHERE patient_id = " + patientId);
                                
                                // Loop through the result set and display test data
                                int count = 1;
                                while (rs.next()) {
                                    String patientName = getPatientName(rs.getInt("patient_id"));
                    %>
                                    <tr>
                                        <th scope="row"><%= count++ %></th>
                                        <td><%= patientName %></td>
                                        <td><%= rs.getString("test_name") %></td>
                                        <td><%= rs.getString("test_date") %></td>
                                        <td><%= rs.getString("test_time") %></td>
                                        <td><%= rs.getString("test_result") %></td>
                                        <td>
                                            <a href="TReport.jsp?id=<%= rs.getString("id") %>" class="btn btn-warning btn-sm">View Report</a>
                                        </td>
                                    </tr>
                    <%
                                }
                                rs.close();
                            }
                            patientIdResult.close();
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

    <!-- Add Test Modal -->
    <div class="modal fade" id="addTestModal" tabindex="-1" aria-labelledby="addTestModalLabel" aria-hidden="true">
        <!-- Modal content goes here -->
    </div>

    <!-- Edit Test Modal -->
    <div class="modal fade" id="editTestModal" tabindex="-1" aria-labelledby="editTestModalLabel" aria-hidden="true">
        <!-- Modal content goes here -->
    </div>

    <!-- Delete Test Modal -->
    <div class="modal fade" id="deleteTestModal" tabindex="-1" aria-labelledby="deleteTestModalLabel" aria-hidden="true">
        <!-- Modal content goes here -->
    </div>
</div>

<!-- Bootstrap JS and Popper.js (for Bootstrap's JavaScript components) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</div>
</body>
</html>
