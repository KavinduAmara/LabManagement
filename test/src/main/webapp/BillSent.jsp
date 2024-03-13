<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Lab Appointment System - Email Sent</title>
    
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
        .container {
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

<%! 
    // Declaration of the method to get patient email
    String getPatientEmail(int patientId) {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lb", "root", "");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT email FROM patients WHERE id = " + patientId);
            if (rs.next()) {
                return rs.getString("email");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }

    // Declaration of the method to get patient name
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

<!-- Page content -->
<div class="container">
    <div class="card">
        <div class="card-body">
            <h2 class="card-title">Email Sent</h2>

            <% 
                // Get the bill ID from the request parameter
                String billIdParam = request.getParameter("id");
                if (billIdParam != null && !billIdParam.isEmpty()) {
                    int billId = Integer.parseInt(billIdParam);

                    // Fetch bill details from the database
                    try {
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lb", "root", "");
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT * FROM bills WHERE id = " + billId);

                        if (rs.next()) {
                            // Get patient name, email, and other details using patient_id from bills table
                            String patientName = getPatientName(rs.getInt("patient_id"));
                            String patientEmail = getPatientEmail(rs.getInt("patient_id"));
            %>

                            <p class="card-text">Email has been sent to <%= patientName %> (<%= patientEmail %>) with the following bill details:</p>
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item">Test Name: <%= rs.getString("test_name") %></li>
                                <li class="list-group-item">Date: <%= rs.getString("appointment_date") %></li>
                                <li class="list-group-item">Time: <%= rs.getString("appointment_time") %></li>
                                <li class="list-group-item">Doctor: <%= rs.getString("doctor_name") %></li>
                                <li class="list-group-item">Bill Amount: <%= rs.getString("bill_amount") %></li>
                                <li class="list-group-item">Payment Status: <%= rs.getString("payment_status") %></li>
                            </ul>

            <%
                            // Include the button for sending email
                        } else {
            %>
                            <p class="card-text">Bill not found.</p>
            <%
                        }

                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
            %>
                        <p class="card-text">An error occurred while fetching bill details.</p>
            <%
                    }
                } else {
            %>
                    <p class="card-text">Invalid bill ID. Please provide a valid ID.</p>
            <%
                }
            %>
			<button id="sendEmailBtn" class="btn btn-success btn-block">Send Email</button>
            <a href="BillList.jsp" class="btn btn-primary btn-block">Back to Bill Management</a>
        </div>
    </div>
</div>

<script>
document.getElementById('sendEmailBtn').addEventListener('click', function() {
    // Get the bill ID from the request parameter
    var billIdParam = '<%= request.getParameter("id") %>';
    
    if (billIdParam && billIdParam !== '') {
        var billId = parseInt(billIdParam);

        // Make an AJAX request to the server-side script for sending email
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4) {
                if (xhr.status == 200) {
                    alert('Email sent successfully!');
                } else {
                    alert('Failed to send email. Please try again.');
                }
            }
        };

        // Replace 'SendEmailServlet' with the actual servlet or server-side script
        xhr.open('GET', 'SendEmailServlet?billId=' + billId, true);
        xhr.send();
    } else {
        alert('Invalid bill ID. Please provide a valid ID.');
    }
});
</script>

<!-- Bootstrap JS and Popper.js (for Bootstrap's JavaScript components) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
