<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.logging.Level" %>
<%@ page import="java.util.logging.Logger" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Lab Appointment System - Delete Bill</title>
    
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
        .content {
            margin-left: 250px;
            padding: 16px;
        }
        .bill-card {
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

        // Check if the bill ID is provided in the query parameter
        String billIdParam = request.getParameter("id");
        if (billIdParam == null || billIdParam.isEmpty()) {
            out.println("<div class='container mt-3'><div class='alert alert-danger' role='alert'>Invalid bill ID. Please provide a valid ID.</div></div>");
        } else {
            int billId = Integer.parseInt(billIdParam);

            // Check if the form is submitted
            if (request.getMethod().equals("POST")) {
                // SQL query to delete the bill
                String deleteSql = "DELETE FROM bills WHERE id=?";
                stmt = conn.prepareStatement(deleteSql);
                stmt.setInt(1, billId);

                // Execute the delete
                int rowsDeleted = stmt.executeUpdate();

                // Check if the delete was successful
                if (rowsDeleted > 0) {
                    out.println("<div class='container mt-3'><div class='alert alert-success' role='alert'>Bill deleted successfully.</div></div>");
                } else {
                    out.println("<div class='container mt-3'><div class='alert alert-danger' role='alert'>Failed to delete bill. Please try again.</div></div>");
                }
            }

            // Fetch the bill details for display
            String sql = "SELECT * FROM bills WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, billId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                // Display bill details
                String patientId = rs.getString("patient_id");
                String testName = rs.getString("test_name");
                String appointmentDate = rs.getString("appointment_date");
                String appointmentTime = rs.getString("appointment_time");
                String doctorName = rs.getString("doctor_name");
                String billAmount = rs.getString("bill_amount");
                String paymentStatus = rs.getString("payment_status");

                %>
                <div class="container bill-container">
                    <div class="card bill-card">
                        <div class="card-body">
                            <h2 class="card-title text-center mb-4">Delete Bill</h2>
                            <!-- Bill Details -->
                            <p><strong>Patient ID:</strong> <%= patientId %></p>
                            <p><strong>Test Name:</strong> <%= testName %></p>
                            <p><strong>Appointment Date:</strong> <%= appointmentDate %></p>
                            <p><strong>Appointment Time:</strong> <%= appointmentTime %></p>
                            <p><strong>Doctor Name:</strong> <%= doctorName %></p>
                            <p><strong>Bill Amount:</strong> <%= billAmount %></p>
                            <p><strong>Payment Status:</strong> <%= paymentStatus %></p>

                            <!-- Delete Bill Form -->
                            <form method="post" class="mt-3">
                                <input type="hidden" name="id" value="<%= billId %>">
                                <button type="submit" class="btn btn-danger">Delete Bill</button>
                                <a href="BillList.jsp" class="btn btn-info btn-block">Back</a>
                            </form>
                        </div>
                    </div>
                </div>
                <%
            } else {
                out.println("<div class='container mt-3'><div class='alert alert-danger' role='alert'>Bill not found. Please provide a valid ID.</div></div>");
            }
        }
    } catch (ClassNotFoundException | SQLException | NumberFormatException e) {
        // Handle exceptions
        Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Exception occurred during bill deletion", e);
        out.println("<div class='container mt-3'><div class='alert alert-danger' role='alert'>An error occurred during bill deletion. Please try again later. Error: " + e.getMessage() + "</div></div>");
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
