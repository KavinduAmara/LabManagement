<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Lab Appointment System - Report List</title>
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
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
<%@include file="Sidebar2.jsp" %>
<div class="container text-center">
    <h2>Report List</h2>

    <!-- Bootstrap Buttons to Link to Different Reports -->
    <div class="mt-4">
        <a href="TestReport.jsp" class="btn btn-success btn-lg">Test Reports</a>
        <a href="ReportPaiHs.jsp" class="btn btn-info btn-lg">Patient Reports</a>
    </div>
</div>

<!-- Bootstrap JS and Popper.js (for Bootstrap's JavaScript components) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
