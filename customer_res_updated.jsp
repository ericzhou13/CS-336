<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*,java.util.*"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Dashboard</title>
</head>
<body>
    <h1>Welcome to the Dashboard</h1>

    <%-- Database Connection --%>
    <%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

        try {
        	Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/TrainDatabase", "root", "7jk697azBb!");

            // Simulated Role Setup (Replace with session logic in production)
            String userRole = (String) session.getAttribute("Employee"); // "Customer", "Employee", or "Admin"
            if (userRole == null) {
                userRole = "Employee"; // Default role for testing
            }

            // Display content based on role
    %>

    <%-- Customer Features --%>
    <% if ("Customer".equals(userRole)) { %>
        <h2>Customer Features</h2>

        <%-- Browse Questions and Answers --%>
        <h3>Browse Questions and Answers</h3>
        <%
            String customerEmail = "hi@gmail.com"; // Replace with logged-in customer email
            String query = "SELECT issueDescription, response FROM CustomerIssues WHERE emailAddress = ?";
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, customerEmail);
                ResultSet k = stmt.executeQuery();

                out.println("<table border='1'><tr><th>Question</th><th>Answer</th></tr>");
                while (k.next()) {
                    out.println("<tr><td>" + k.getString("issueDescription") + "</td>");
                    out.println("<td>" + k.getString("response") + "</td></tr>");
                }
                out.println("</table>");
            }
        %>

        <%-- Send a Question to Customer Service --%>
        <h3>Send a Question</h3>
        <form method="post">
            <label>Question:</label>
            <textarea name="question" required></textarea>
            <br>
            <button type="submit" name="action" value="sendQuestion">Send</button>
        </form>
        <%
            if ("sendQuestion".equals(request.getParameter("action"))) {
                String question = request.getParameter("question");
                String insertSQL = "INSERT INTO CustomerIssues (emailAddress, issueDescription) VALUES (?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(insertSQL)) {
                    stmt.setString(1, customerEmail);
                    stmt.setString(2, question);
                    stmt.executeUpdate();
                    out.println("<p>Question submitted successfully!</p>");
                }
            }
        %>
    <% } %>

    <%-- Employee/Admin Features --%>
    <% if ("Employee".equals(userRole) || "Admin".equals(userRole)) { %>
        <h2>Employee/Admin Features</h2>

        <%-- Edit or Delete Train Schedules --%>
        <h3>Edit or Delete Train Schedules</h3>
        <form method="post">
            <label>Transit Line Name:</label>
            <input type="text" name="transitLineName" required>
            <br>
            <label>Train ID:</label>
            <input type="number" name="trainID" required>
            <br>
            <label>Origin:</label>
            <input type="text" name="origin">
            <br>
            <label>Destination:</label>
            <input type="text" name="destination">
            <br>
            <label>Depart Date:</label>
            <input type="datetime-local" name="departDate">
            <br>
            <label>Arrival Date:</label>
            <input type="datetime-local" name="arrivalDate">
            <br>
            <label>Fare:</label>
            <input type="number" step="0.01" name="fare">
            <br>
            <button type="submit" name="action" value="editSchedule">Edit</button>
            <button type="submit" name="action" value="deleteSchedule">Delete</button>
        </form>
        <%
            String action = request.getParameter("action");
            if ("editSchedule".equals(action)) {
                String transitLineName = request.getParameter("transitLineName");
                int trainID = Integer.parseInt(request.getParameter("trainID"));
                String origin = request.getParameter("origin");
                String destination = request.getParameter("destination");
                String departDate = request.getParameter("departDate");
                String arrivalDate = request.getParameter("arrivalDate");
                float fare = Float.parseFloat(request.getParameter("fare"));

                String updateSQL = "UPDATE TrainSchedule SET Origin = ?, Destination = ?, departDate = ?, arrivalDate = ?, fare = ? WHERE transitLineName = ? AND Train = ?";
                try (PreparedStatement stmt = conn.prepareStatement(updateSQL)) {
                    stmt.setString(1, origin);
                    stmt.setString(2, destination);
                    stmt.setString(3, departDate);
                    stmt.setString(4, arrivalDate);
                    stmt.setFloat(5, fare);
                    stmt.setString(6, transitLineName);
                    stmt.setInt(7, trainID);
                    stmt.executeUpdate();
                    out.println("<p>Schedule updated successfully!</p>");
                }
            } else if ("deleteSchedule".equals(action)) {
                String transitLineName = request.getParameter("transitLineName");
                int trainID = Integer.parseInt(request.getParameter("trainID"));

                String deleteSQL = "DELETE FROM TrainSchedule WHERE transitLineName = ? AND Train = ?";
                try (PreparedStatement stmt = conn.prepareStatement(deleteSQL)) {
                    stmt.setString(1, transitLineName);
                    stmt.setInt(2, trainID);
                    stmt.executeUpdate();
                    out.println("<p>Schedule deleted successfully!</p>");
                }
            }
        %>
    <% } %>
	<% if ("Employee".equals(userRole)) { %>
		<h3> List all customers who have reservations </h3>
		<form id="transitForm" method="post">
			<label for="transitLine">Transit Line:</label> 
			<input type="text" id="transitLine" name="transitLine"> 
			<label for="date">Date:</label> 
			<input type="date" id="date" name="date">
			<input type="submit" value="Submit" onclick="setFormAction('CustomerRepresentativeList.jsp')">
			<!-- <input type="submit" value="Last Page" onclick="this.form.action='index.jsp'"> -->
		</form>
		<%  
	
	    String transitline = request.getParameter("transitLine");
		String date = request.getParameter("date");
		
		if (transitline != null && !transitline.isEmpty() && date != null && !date.isEmpty()) { 
			
			String transitLineQuery = "SELECT emailAddress FROM Reservation WHERE departDate = ? AND transitLineName = ?;";
			pstmt = conn.prepareStatement(transitLineQuery);
			pstmt.setString(1, date); 
			pstmt.setString(2, transitline);
			rs = pstmt.executeQuery();
		%>
		<table>
		<thead> <tr> <th>Email Addresses: </th> </tr> </thead>
		<tbody>
			<% while (rs.next()) { %>
	            <tr><td><%= rs.getString("emailAddress") %></td></tr>
	        <%
	        	}
			}
		}
	       	%>
		</tbody>
		</table>
	<% if ("Employee".equals(userRole)) { %>
		<h3> List of Train Schedules for Station </h3>
		<form>

		<label for="station">Station:</label> 
		<input type="text" id="station" name="station"> 
		<input type="submit" value="Submit" onclick="setFormAction('test.jsp')">
		
		</form>
	<% 
		String station = request.getParameter("station");
		if (station != null && !station.isEmpty()) { 
			String transitLineQuery = "SELECT * FROM TrainSchedule WHERE origin = ? or destination = ?;";
			pstmt = conn.prepareStatement(transitLineQuery);
			pstmt.setString(1, station); 
			pstmt.setString(2, station);
			rs = pstmt.executeQuery();
		%>
		<table>
		<thead> <tr> <th>Train Schedules: </th> </tr> </thead>
		<tbody>
			<% while (rs.next()) { %>
	            <tr><td><%= rs.getString("transitLineName") %></td></tr>
	        <%
	        	}
	        rs.close();
	        pstmt.close();
			}
		}
	       	%>
		</tbody>
		</table>
    <%-- Close Database Connection --%>
    <%
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    out.println("<p>Error closing connection: " + e.getMessage() + "</p>");
                }
            }
        }
    %>
</body>
</html>