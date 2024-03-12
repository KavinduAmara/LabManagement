<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Lab Appointment System - Bill Management</title>
    
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
         margin-left: 250px;
         padding: 16px;
         }
         .card-header {
         background-color: #343a40;
         color: white;
         }
         .card-body {
         background-color: #f8f9fa;
         }
      </style>
</head>
<body>

<!-- Sidebar -->
<%@include file="Sidebar.jsp" %>

<!-- Page content -->
<div class="content">
    <h2>Bill Management</h2>
    
    <!-- CRUD Operations -->
    <div class="mb-3">
        <a href="BillAdd.jsp" class="btn btn-primary">Add Bill</a>
    </div>
    
    <%! 
    // Declaration of the method outside the scriptlet
    String getPatientName(int patientId) {
        String fullName = "";
        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lb", "root", "");
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT CONCAT(firstName, ' ', lastName) AS fullName FROM patients WHERE id = " + patientId)) {
            if (rs.next()) {
                fullName = rs.getString("fullName");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return fullName;
    }
	%>
    
    <!-- Bill List Card -->
    <div class="bill-container">
        <div class="card bill-card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th scope="col">#</th>
                                <th scope="col">Patient Name</th>
                                <th scope="col">Test Name</th>
                                <th scope="col">Date</th>
                                <th scope="col">Time</th>
                                <th scope="col">Doctor</th>
                                <th scope="col">Bill Amount</th>
                                <th scope="col">Payment Status</th>
                                <th scope="col">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                // Java code to fetch bill data from the database
                                try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lb", "root", "");
                                     Statement stmt = conn.createStatement();
                                     ResultSet rs = stmt.executeQuery("SELECT * FROM bills")) {

                                    // Loop through the result set and display bill data
                                    int count = 1;
                                    while (rs.next()) {
                                        // Get patient name using patient_id from bills table
                                        String patientName = getPatientName(rs.getInt("patient_id"));
                            %>
                                        <tr>
                                            <th scope="row"><%= count++ %></th>
                                            <td><%= patientName %></td>
                                            <td><%= rs.getString("test_name") %></td>
                                            <td><%= rs.getString("appointment_date") %></td>
                                            <td><%= rs.getString("appointment_time") %></td>
                                            <td><%= rs.getString("doctor_name") %></td>
                                            <td><%= rs.getString("bill_amount") %></td>
                                            <td><%= rs.getString("payment_status") %></td>
                                            <td>
                                                <a href="BillEdit.jsp?id=<%= rs.getString("id") %>" class="btn btn-warning btn-sm">Edit</a>
                                                <a href="BillDel.jsp?id=<%= rs.getString("id") %>" class="btn btn-danger btn-sm">Delete</a>
                                                <a href="BillSent.jsp?id=<%= rs.getString("id") %>" class="btn btn-info btn-sm">Send Email</a>
                                            </td>
                                        </tr>
                            <%
                                    }
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Bill Modal -->
    <div class="modal fade" id="addBillModal" tabindex="-1" aria-labelledby="addBillModalLabel" aria-hidden="true">
        <!-- Modal content goes here -->
    </div>

    <!-- Edit Bill Modal -->
    <div class="modal fade" id="editBillModal" tabindex="-1" aria-labelledby="editBillModalLabel" aria-hidden="true">
        <!-- Modal content goes here -->
    </div>

    <!-- Delete Bill Modal -->
    <div class="modal fade" id="deleteBillModal" tabindex="-1" aria-labelledby="deleteBillModalLabel" aria-hidden="true">
        <!-- Modal content goes here -->
    </div>

    <script>
        // JavaScript function to handle sending email
        function sendEmail(patientId) {
            // Implement your logic to send email here
            alert("Email sent to patient with ID: " + patientId);
        }
    </script>
</div>

<!-- Bootstrap JS and Popper.js (for Bootstrap's JavaScript components) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
