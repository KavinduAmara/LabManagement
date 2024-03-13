<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.logging.Level" %>
<%@ page import="java.util.logging.Logger" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Lab Appointment System - Edit Bill</title>
    
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
        .bill-container {
                margin-left: 250px;
                padding: 16px;
                max-width:80%;
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
                // Retrieve form data
                String updatedTestName = request.getParameter("testName");
                String updatedAppointmentDate = request.getParameter("appointmentDate");
                String updatedAppointmentTime = request.getParameter("appointmentTime");
                String updatedDoctorName = request.getParameter("doctorName");
                String updatedBillAmount = request.getParameter("billAmount");
                String updatedPaymentStatus = request.getParameter("paymentStatus");

                // SQL query to update bill details
                String updateSql = "UPDATE bills SET test_name=?, appointment_date=?, appointment_time=?, doctor_name=?, bill_amount=?, payment_status=? WHERE id=?";
                stmt = conn.prepareStatement(updateSql);
                stmt.setString(1, updatedTestName);
                stmt.setString(2, updatedAppointmentDate);
                stmt.setString(3, updatedAppointmentTime);
                stmt.setString(4, updatedDoctorName);
                stmt.setString(5, updatedBillAmount);
                stmt.setString(6, updatedPaymentStatus);
                stmt.setInt(7, billId);

                // Execute the update
                int rowsUpdated = stmt.executeUpdate();

                // Check if the update was successful
                if (rowsUpdated > 0) {
                    out.println("<div class='container mt-3'><div class='alert alert-success' role='alert'>Bill details updated successfully.</div></div>");
                } else {
                    out.println("<div class='container mt-3'><div class='alert alert-danger' role='alert'>Failed to update bill details. Please try again.</div></div>");
                }
            }

            // Fetch the updated bill details
            String sql = "SELECT * FROM bills WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, billId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                // Bill data
                String patientId = rs.getString("patient_id");
                String testName = rs.getString("test_name");
                String appointmentDate = rs.getString("appointment_date");
                String appointmentTime = rs.getString("appointment_time");
                String doctorName = rs.getString("doctor_name");
                String billAmount = rs.getString("bill_amount");
                String paymentStatus = rs.getString("payment_status");

                %>
                <div class="container bill-container">
                    <h2 class="text-center mb-4">Edit Bill</h2>
                    
                    <!-- Edit Bill Form -->
                    <form method="post">
                        <div class="mb-3">
                            <label for="patientId" class="form-label">Patient ID</label>
                            <input type="text" class="form-control" id="patientId" name="patientId" value="<%= patientId %>" readonly>
                        </div>

                        <div class="mb-3">
                            <label for="testName" class="form-label">Test Name</label>
                            <input type="text" class="form-control" id="testName" name="testName" value="<%= testName %>" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="appointmentDate" class="form-label">Appointment Date</label>
                            <input type="date" class="form-control" id="appointmentDate" name="appointmentDate" value="<%= appointmentDate %>" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="appointmentTime" class="form-label">Appointment Time</label>
                            <input type="time" class="form-control" id="appointmentTime" name="appointmentTime" value="<%= appointmentTime %>" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="doctorName" class="form-label">Doctor Name</label>
                            <input type="text" class="form-control" id="doctorName" name="doctorName" value="<%= doctorName %>" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="billAmount" class="form-label">Bill Amount</label>
                            <input type="text" class="form-control" id="billAmount" name="billAmount" value="<%= billAmount %>" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="paymentStatus" class="form-label">Payment Status</label>
                            <select class="form-control" id="paymentStatus" name="paymentStatus" required>
                                <option value="Paid" <%= paymentStatus.equals("Paid") ? "selected" : "" %>>Paid</option>
                                <option value="Unpaid" <%= paymentStatus.equals("Unpaid") ? "selected" : "" %>>Unpaid</option>
                            </select>
                        </div>
                        
                        <button type="submit" class="btn btn-primary btn-block">Save Changes</button>
                        <a href="BillList.jsp" class="btn btn-info btn-block">Back</a>
                    </form>
                </div>
                <%
            } else {
                out.println("<div class='container mt-3'><div class='alert alert-danger' role='alert'>Bill not found. Please provide a valid ID.</div></div>");
            }
        }
    } catch (ClassNotFoundException | SQLException | NumberFormatException e) {
        // Handle exceptions
        Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Exception occurred during bill editing", e);
        out.println("<div class='container mt-3'><div class='alert alert-danger' role='alert'>An error occurred during bill editing. Please try again later. Error: " + e.getMessage() + "</div></div>");
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
