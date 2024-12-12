<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page session="true"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Show list of TrainSchedules Page</title>
</head>
<script> 
function setFormAction(action) { 
	document.getElementById("transitForm").action = action; 
	document.getElementById("transitForm").submit(); 
	} 
</script>
<body>
<form id="transitForm" method="post">
<label for="transitLine">Transit Line:</label> 
<input type="text" id="transitLine" name="transitLine"> 
<label for="date">Date:</label> 
<input type="date" id="date" name="date">
<input type="submit" value="Submit" onclick="setFormAction('test.jsp')">
<input type="submit" value="Last Page" onclick="this.form.action='index.jsp'">
</form>
<%
	Connection conn = null;
	ApplicationDB db = new ApplicationDB();    
	conn = db.getConnection();
	PreparedStatement pstmt = null;
	ResultSet rs = null;

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
        rs.close();
        pstmt.close();
	}
       	%>
	</tbody>
	</table>
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
       	%>
	</tbody>
	</table>
</body>











