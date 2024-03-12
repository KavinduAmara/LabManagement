<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Lab Appointment System - Patient Management</title>
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    
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
        .content {
            margin-left: 250px;
            padding: 16px;
        }
        .card {
            margin-bottom: 20px;
        }
        .btn-action {
            margin-right: 5px;
        }
    </style>
</head>
<body>

<%@include file="Sidebar.jsp" %>
<!-- Page content -->
<div class="content">
    <h2>Patient Management</h2>
    
    <!-- CRUD Operations -->
    <div class="mb-3">
        <a href="Patient_PM.jsp" class="btn btn-primary">Add Patient</a>
    </div>
    
    <!-- Table for Patient List -->
    <div class="card">
        <div class="card-body">
            <table class="table">
                <thead>
                    <tr>
                        <th scope="col">#</th>
                        <th scope="col">First Name</th>
                        <th scope="col">Last Name</th>
                        <th scope="col">Email</th>
                        <th scope="col">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        // Java code to fetch patient data from the database
                        try {
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lb", "root", "");
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT * FROM patients");

                            // Loop through the result set and display patient data
                            int count = 1;
                            while (rs.next()) {
                    %>
                                <tr>
                                    <th scope="row"><%= count++ %></th>
                                    <td><%= rs.getString("firstName") %></td>
                                    <td><%= rs.getString("lastName") %></td>
                                    <td><%= rs.getString("email") %></td>
                                    <td>
                                        <a href="paitentEdit.jsp?id=<%= rs.getString("id") %>" class="btn btn-warning btn-action btn-sm">Edit</a>
                                        <a href="patDel.jsp?id=<%= rs.getString("id") %>" class="btn btn-danger btn-action btn-sm">Delete</a>
                                    </td>
                                </tr>
                    <%
                            }
                            rs.close();
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

</body>
</html>
