<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Lab Appointment System - Login</title>
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    
    <!-- Custom styles -->
    <style>
        body {
            background: url('Images/04.jpg') center center fixed;
            background-size: cover;
        }
        .overlay {
            background-color: rgba(248, 249, 250, 0.8); /* Adjust the alpha value for the overlay */
            height: 100%;
            width: 100%;
            position: fixed;
            top: 0;
            left: 0;
            z-index: -1;
        }
        .login-container {
            max-width: 400px;
            margin: auto;
            margin-top: 100px;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            background-color: #eee;
        }
        .login-container h2 {
            color: #007bff;
        }
        .form-check-label {
            color: #555;
        }
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }
        .content {
            margin-left: 250px;
            padding: 16px;
        }
    </style>
</head>
<body>

<div class="overlay"></div>

<%
	Class.forName("com.mysql.jdbc.Driver");
    if (request.getMethod().equalsIgnoreCase("post")) {
        String userType = request.getParameter("userType");
        
        if (userType != null && !userType.isEmpty()) {
        	
            String tableName = "";
            if (userType.equals("admin")) {
                tableName = "admin"; // Replace with your actual admin table name
            } else if (userType.equals("patient")) {
                tableName = "patients"; // Replace with your actual patient table name
            }
            

            String username = request.getParameter("username");
            String password = request.getParameter("password");

            try {
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lb", "root", "");
                out.println(userType);
                out.println(password);
                Statement stmt = conn.createStatement();
                String query = "SELECT * FROM " + tableName + " WHERE username = '" + username + "' AND password = '" + password + "'";
                ResultSet rs = stmt.executeQuery(query);
                

                if (rs.next()) {
                    // User is valid, perform redirection or other actions
                    HttpSession sessionObj = request.getSession(true);

                    // Store user information in the session
                    sessionObj.setAttribute("userType", userType);
                    sessionObj.setAttribute("username", username);
                    
					if(userType.equals("admin")){
						 response.sendRedirect("dashboard.jsp");
					}
					else{
						response.sendRedirect("ReportList.jsp");
					}
						
                } else {
                    // User is not valid, display an error message or take appropriate action
                    out.println("<p style='color: red;'>Invalid username or password</p>");
                }

                rs.close();
                stmt.close();
                conn.close();
            } catch (SQLException e) {
                out.println(e);
                e.printStackTrace();
            }
        }
    }
%>



<div class="container login-container">
    <h2 class="text-center mb-4">ABC Lab Appointment System</h2>
    
    <!-- Login Form -->
    <form action="index.jsp" method="post">
        <!-- Add a hidden field to pass the userType to the server -->
        
        <div class="mb-3">
            <label for="username" class="form-label">Username</label>
            <input type="text" class="form-control" id="username" name="username" required>
        </div>
        
        <div class="mb-3">
            <label for="password" class="form-label">Password</label>
            <input type="password" class="form-control" id="password" name="password" required>
        </div>
        
        <div class="mb-3">
            <label for="userType" class="form-label">User Type</label>
            <select class="form-select" id="userType" name="userType" required>
                <option value="admin">Admin</option>
                <option value="patient">Patient</option>
            </select>
        </div>
        
        <div class="mb-3 form-check">
            <input type="checkbox" class="form-check-input" id="rememberMe">
            <label class="form-check-label" for="rememberMe">Remember me</label>
        </div>
        
        <center><button type="submit" class="btn btn-primary btn-block">Login</button></center>
    </form>

    <!-- Forgot Password Link -->
    <div class="mt-3 text-center">
        <a href="#" style="color: #007bff;">Forgot Password?</a>
    </div>
</div>

<!-- Bootstrap JS and Popper.js (for Bootstrap's JavaScript components) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
