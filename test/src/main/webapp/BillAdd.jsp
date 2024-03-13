<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.logging.Level" %>
<%@ page import="java.util.logging.Logger" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Lab Appointment System - Add Bill</title>
    
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

        // Check if the form is submitted
        if (request.getMethod().equalsIgnoreCase("POST")) {
            // Form data
            String patientId = request.getParameter("patientId");
            String testName = request.getParameter("testName");
            String appointmentDate = request.getParameter("appointmentDate");
            String appointmentTime = request.getParameter("appointmentTime");
            String doctorName = request.getParameter("doctorName");
            String billAmount = request.getParameter("billAmount");
            String paymentStatus = request.getParameter("paymentStatus");

            // SQL query to insert data into the 'bills' table
            String sql = "INSERT INTO bills (patient_id, test_name, appointment_date, appointment_time, doctor_name, bill_amount, payment_status) VALUES (?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);

            // Set parameters for the SQL query
            stmt.setString(1, patientId);
            stmt.setString(2, testName);
            stmt.setString(3, appointmentDate);
            stmt.setString(4, appointmentTime);
            stmt.setString(5, doctorName);
            stmt.setString(6, billAmount);
            stmt.setString(7, paymentStatus);

            // Execute the query
            int rowsAffected = stmt.executeUpdate();

            // Display success message if data is inserted
            if (rowsAffected > 0) {
                out.println("<div class='container mt-3'><div class='alert alert-success' role='alert'>Bill added successfully!</div></div>");
            } else {
                out.println("<div class='container mt-3'><div class='alert alert-danger' role='alert'>Failed to add bill. Please try again.</div></div>");
            }
        }
        
        // Fetch patient names and IDs for the dropdown
        String patientQuery = "SELECT id, CONCAT(firstName, ' ', lastName) AS fullName FROM patients";
        stmt = conn.prepareStatement(patientQuery);
        rs = stmt.executeQuery();

        // Display the bill addition form
    %>
    <div class="container bill-container">
        <div class="card bill-card">
            <div class="card-header">
                <h2 class="text-center mb-4">Add Bill</h2>
            </div>
            <div class="card-body">
                <!-- Bill Addition Form -->
                <form method="post">
                    <div class="mb-3">
                        <label for="patientId" class="form-label">Patient Name</label>
                        <select class="form-control" id="patientId" name="patientId" required>
                            <%
                                // Populate dropdown with patient names and IDs
                                while (rs.next()) {
                                    String patientId = rs.getString("id");
                                    String fullName = rs.getString("fullName");
                            %>
                                    <option value="<%= patientId %>"><%= fullName %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="testName" class="form-label">Test Name</label>
                        <input type="text" class="form-control" id="testName" name="testName" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="appointmentDate" class="form-label">Appointment Date</label>
                        <input type="date" class="form-control" id="appointmentDate" name="appointmentDate" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="appointmentTime" class="form-label">Appointment Time</label>
                        <input type="time" class="form-control" id="appointmentTime" name="appointmentTime" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="doctorName" class="form-label">Doctor Name</label>
                        <input type="text" class="form-control" id="doctorName" name="doctorName" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="billAmount" class="form-label">Bill Amount</label>
                        <input type="text" class="form-control" id="billAmount" name="billAmount" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="paymentStatus" class="form-label">Payment Status</label>
                        <select class="form-control" id="paymentStatus" name="paymentStatus" required>
                            <option value="Paid">Paid</option>
                            <option value="Unpaid">Unpaid</option>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-block">Add Bill</button>
                    <a href="BillList.jsp" class="btn btn-info btn-block">Back</a>
                </form>
            </div>
        </div>
    </div>
    <%
    } catch (ClassNotFoundException | SQLException e) {
        // Handle exceptions
        Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Exception occurred during bill addition", e);
        out.println("<div class='container mt-3'><div class='alert alert-danger' role='alert'>An error occurred during bill addition. Please try again later. Error: " + e.getMessage() + "</div></div>");
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
