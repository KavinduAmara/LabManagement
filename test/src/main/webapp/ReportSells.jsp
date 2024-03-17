<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.itextpdf.text.Document" %>
<%@ page import="com.itextpdf.text.Element" %>
<%@ page import="com.itextpdf.text.Paragraph" %>
<%@ page import="com.itextpdf.text.pdf.PdfWriter" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Sales Report</title>
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    
    <!-- Custom styles -->
    <style>
        body {
            background-color: #f8f9fa;
        }
        .report-container {
            max-width: 800px;
            margin: auto;
            margin-top: 50px;
        }
        .card {
            margin-top: 20px;
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

    Map<String, Double> salesMap = new HashMap<>();

    try {
        // Load JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Establish the connection
        conn = DriverManager.getConnection(url, username, password);

        // Fetch sales data from the bill table
        String sql = "SELECT MONTH(appointment_date) AS month, YEAR(appointment_date) AS year, SUM(bill_amount) AS totalSales " +
                     "FROM bills " +
                     "GROUP BY YEAR(appointment_date), MONTH(appointment_date)";
        
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();

        // Populate the sales map
        while (rs.next()) {
            String monthYear = rs.getString("month") + "-" + rs.getString("year");
            double totalSales = rs.getDouble("totalSales");
            salesMap.put(monthYear, totalSales);
        }
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
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

<div class="container report-container">
    <div class="card">
        <div class="card-body">
            <h2 class="card-title text-center mb-4">Sales Report</h2>
            
            <!-- Display Sales Report -->
            <table class="table">
                <thead>
                    <tr>
                        <th scope="col">Month-Year</th>
                        <th scope="col">Total Sales</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        // Iterate over the sales map
                        for (Map.Entry<String, Double> entry : salesMap.entrySet()) {
                            String monthYear = entry.getKey();
                            double totalSales = entry.getValue();
                    %>
                        <tr>
                            <td><%= monthYear %></td>
                            <td><%= totalSales %></td>
                        </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>

            <!-- PDF Export Button -->
            <button class="btn btn-primary" onclick="exportToPDF()">Export to PDF</button>
        </div>
    </div>
</div>

<!-- Bootstrap JS and Popper.js (for Bootstrap's JavaScript components) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- jsPDF library -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.4.0/jspdf.umd.min.js"></script>

<!-- PDF Export Script -->
<script>
    function exportToPDF() {
        var doc = new jsPDF();
        doc.text("Sales Report", 20, 10);
        doc.autoTable({ html: 'table', startY: 20 });
        doc.save('sales_report.pdf');
    }
</script>

</body>
</html>
