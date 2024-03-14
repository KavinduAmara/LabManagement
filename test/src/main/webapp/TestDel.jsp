<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.logging.Level" %>
<%@ page import="java.util.logging.Logger" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Lab Appointment System - Delete Test</title>
    
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

        // Check if the test ID is provided in the query parameter
        String testIdParam = request.getParameter("id");
        if (testIdParam == null || testIdParam.isEmpty()) {
            out.println("<div class='container mt-3'><div class='card'><div class='card-body'><div class='alert alert-danger' role='alert'>Invalid test ID. Please provide a valid ID.</div></div></div></div>");
        } else {
            int testId = Integer.parseInt(testIdParam);

            // Check if the form is submitted
            if (request.getMethod().equals("POST")) {
                // SQL query to delete the test
                String deleteSql = "DELETE FROM tests WHERE id=?";
                stmt = conn.prepareStatement(deleteSql);
                stmt.setInt(1, testId);

                // Execute the delete
                int rowsDeleted = stmt.executeUpdate();

                // Check if the delete was successful
                if (rowsDeleted > 0) {
                    out.println("<div class='container mt-3'><div class='card'><div class='card-body'><h2 class='card-title text-center mb-4'>Delete Test</h2><div class='alert alert-success' role='alert'>Test deleted successfully.</div><a href='TestList.jsp' class='btn btn-info btn-sm'>Back</a></div></div></div>");
                } else {
                    out.println("<div class='container mt-3'><div class='card'><div class='card-body'><h2 class='card-title text-center mb-4'>Delete Test</h2><div class='alert alert-danger' role='alert'>Failed to delete test. Please try again.</div><a href='TestList.jsp' class='btn btn-info btn-sm'>Back</a></div></div></div>");
                }
            }

            // Fetch the test details for display
            String sql = "SELECT * FROM tests WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, testId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                // Display test details
                String patientId = rs.getString("patient_id");
                String testName = rs.getString("test_name");
                String testDate = rs.getString("test_date");
                String testTime = rs.getString("test_time");
                String testResult = rs.getString("test_result");

                %>
                <div class="container">
                    <div class="card">
                        <div class="card-body">
                            <h2 class="card-title text-center mb-4">Delete Test</h2>
                            
                            <p><strong>Patient ID:</strong> <%= patientId %></p>
                            <p><strong>Test Name:</strong> <%= testName %></p>
                            <p><strong>Test Date:</strong> <%= testDate %></p>
                            <p><strong>Test Time:</strong> <%= testTime %></p>
                            <p><strong>Test Result:</strong> <%= testResult %></p>

                            <!-- Delete Test Form -->
                            <form method="post" class="mt-3">
                                <input type="hidden" name="id" value="<%= testId %>">
                                <button type="submit" class="btn btn-danger">Delete Test</button>
                                <a href="TestList.jsp" class="btn btn-info btn-block">Back</a>
                            </form>
                        </div>
                    </div>
                </div>
                <%
            } else {
                out.println("<div class='container mt-3'><div class='card'><div class='card-body'><h2 class='card-title text-center mb-4'>Delete Test</h2><div class='alert alert-danger' role='alert'>Test not found. Please provide a valid ID.</div><a href='TestList.jsp' class='btn btn-info btn-sm'>Back</a></div></div></div>");
            }
        }
    } catch (ClassNotFoundException | SQLException | NumberFormatException e) {
        // Handle exceptions
        Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Exception occurred during test deletion", e);
        out.println("<div class='container mt-3'><div class='card'><div class='card-body'><h2 class='card-title text-center mb-4'>Delete Test</h2><div class='alert alert-danger' role='alert'>An error occurred during test deletion. Please try again later. Error: " + e.getMessage() + "</div><a href='TestList.jsp' class='btn btn-info btn-sm'>Back</a></div></div></div>");
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
