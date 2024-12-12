<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" 
    import="java.sql.*, java.util.*, com.cs336.pkg.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page session="true"%>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Representative Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; }
        table, th, td { border: 1px solid #ddd; padding: 8px; }
        .section { margin-bottom: 20px; }
    </style>
</head>
<body>
    <%
    // Database connection setup
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Establish database connection
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/TrainDatabase", "root", "12345678");

        // Check if user is logged in and has correct role
        String userRole = (String) session.getAttribute("role");
        if (userRole == null || !userRole.equals("Emplyee")) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 1. Edit and Delete Train Schedules
        if (request.getParameter("action") != null) {
            String action = request.getParameter("action");
            
            // Edit Train Schedule
            if (action.equals("editSchedule")) {
                String transitLineName = request.getParameter("transitLineName");
                String origin = request.getParameter("origin");
                String destination = request.getParameter("destination");
                String departDate = request.getParameter("departDate");
                
                pstmt = conn.prepareStatement(
                    "UPDATE TrainSchedule SET Origin=?, Destination=?, departDate=? WHERE transitLineName=?"
                );
                pstmt.setString(1, origin);
                pstmt.setString(2, destination);
                pstmt.setString(3, departDate);
                pstmt.setString(4, transitLineName);
                pstmt.executeUpdate();
            }
            
            // Delete Train Schedule
            if (action.equals("deleteSchedule")) {
                String transitLineName = request.getParameter("transitLineName");
                pstmt = conn.prepareStatement(
                    "DELETE FROM TrainSchedule WHERE transitLineName=?"
                );
                pstmt.setString(1, transitLineName);
                pstmt.executeUpdate();
            }
        }
    %>

    <div class="section">
        <h2>Train Schedule Management</h2>
        <!-- Train Schedule Edit Form -->
        <form method="post">
            <input type="hidden" name="action" value="editSchedule">
            Transit Line: <input type="text" name="transitLineName">
            Origin: <input type="text" name="origin">
            Destination: <input type="text" name="destination">
            Depart Date: <input type="datetime-local" name="departDate">
            <input type="submit" value="Edit Schedule">
        </form>
    </div>

    <%
        // 6. List Train Schedules for a Station
        String stationSearch = request.getParameter("stationSearch");
        if (stationSearch != null && !stationSearch.isEmpty()) {
            pstmt = conn.prepareStatement(
                "SELECT * FROM TrainSchedule " +
                "WHERE Origin = ? OR Destination = ?"
            );
            pstmt.setString(1, stationSearch);
            pstmt.setString(2, stationSearch);
            rs = pstmt.executeQuery();
    %>
        <div class="section">
            <h2>Train Schedules for <%= stationSearch %></h2>
            <table>
                <tr>
                    <th>Transit Line</th>
                    <th>Origin</th>
                    <th>Destination</th>
                    <th>Depart Date</th>
                </tr>
                <% while (rs.next()) { %>
                    <tr>
                        <td><%= rs.getString("transitLineName") %></td>
                        <td><%= rs.getString("Origin") %></td>
                        <td><%= rs.getString("Destination") %></td>
                        <td><%= rs.getString("departDate") %></td>
                    </tr>
                <% } %>
            </table>
        </div>
    <%
        }

        // 7. List Customers for Transit Line and Date
        String transitLineSearch = request.getParameter("transitLineSearch");
        String dateSearch = request.getParameter("dateSearch");
        if (transitLineSearch != null && dateSearch != null 
            && !transitLineSearch.isEmpty() && !dateSearch.isEmpty()) {
            pstmt = conn.prepareStatement(
                "SELECT DISTINCT c.* FROM Customer c " +
                "JOIN Reservation r ON c.emailAddress = r.emailAddress " +
                "WHERE r.transitLineName = ? AND r.departDate = ?"
            );
            pstmt.setString(1, transitLineSearch);
            pstmt.setString(2, dateSearch);
            rs = pstmt.executeQuery();
    %>
        <div class="section">
            <h2>Customers on <%= transitLineSearch %> on <%= dateSearch %></h2>
            <table>
                <tr>
                    <th>Email</th>
                    <th>Last Name</th>
                    <th>First Name</th>
                </tr>
                <% while (rs.next()) { %>
                    <tr>
                        <td><%= rs.getString("emailAddress") %></td>
                        <td><%= rs.getString("lastName") %></td>
                        <td><%= rs.getString("firstName") %></td>
                    </tr>
                <% } %>
            </table>
        </div>
    <%
        }

        // 2 & 3. Browse and Search Customer Questions
        String keyword = request.getParameter("keyword");
        if (keyword != null && !keyword.isEmpty()) {
            pstmt = conn.prepareStatement(
                "SELECT * FROM CustomerIssues " +
                "WHERE issueDescription LIKE ?"
            );
            pstmt.setString(1, "%" + keyword + "%");
            rs = pstmt.executeQuery();
    %>
        <div class="section">
            <h2>Customer Questions Matching: <%= keyword %></h2>
            <table>
                <tr>
                    <th>Customer Email</th>
                    <th>Issue</th>
                    <th>Response</th>
                </tr>
                <% while (rs.next()) { %>
                    <tr>
                        <td><%= rs.getString("emailAddress") %></td>
                        <td><%= rs.getString("issueDescription") %></td>
                        <td><%= rs.getString("response") %></td>
                    </tr>
                <% } %>
            </table>
        </div>
    <%
        }

        // 4 & 5. Send and Reply to Customer Questions
        if (request.getParameter("submitIssue") != null) {
            String email = request.getParameter("email");
            String issue = request.getParameter("issue");
            
            pstmt = conn.prepareStatement(
                "INSERT INTO CustomerIssues (emailAddress, issueDescription) VALUES (?, ?)"
            );
            pstmt.setString(1, email);
            pstmt.setString(2, issue);
            pstmt.executeUpdate();
        }

        // Rename 'response' to 'customerResponse' to avoid naming conflict
        if (request.getParameter("replyIssue") != null) {
            String email = request.getParameter("email");
            String customerResponse = request.getParameter("customerResponse");
            String salesRepSSN = (String) session.getAttribute("ssn");
            
            pstmt = conn.prepareStatement(
                "UPDATE CustomerIssues SET response = ?, salesRepSSN = ? " +
                "WHERE emailAddress = ? AND response IS NULL"
            );
            pstmt.setString(1, customerResponse);
            pstmt.setString(2, salesRepSSN);
            pstmt.setString(3, email);
            pstmt.executeUpdate();
        }
    %>

    <!-- Customer Question Submission Form -->
    <div class="section">
        <h2>Submit Customer Question</h2>
        <form method="post">
            Email: <input type="email" name="email" required>
            Issue: <textarea name="issue" required></textarea>
            <input type="submit" name="submitIssue" value="Submit Issue">
        </form>
    </div>

    <!-- Reply to Customer Question Form -->
    <div class="section">
        <h2>Reply to Customer Question</h2>
        <form method="post">
            Customer Email: <input type="email" name="email" required>
            Response: <textarea name="customerResponse" required></textarea>
            <input type="submit" name="replyIssue" value="Send Response">
        </form>
    </div>

    <!-- Station Search Form -->
    <div class="section">
        <h2>Search Train Schedules by Station</h2>
        <form method="post">
            Station Name: <input type="text" name="stationSearch">
            <input type="submit" value="Search Schedules">
        </form>
    </div>

    <!-- Transit Line Customer Search Form -->
    <div class="section">
        <h2>Search Customers by Transit Line and Date</h2>
        <form method="post">
            Transit Line: <input type="text" name="transitLineSearch">
            Date: <input type="date" name="dateSearch">
            <input type="submit" value="Search Customers">
        </form>
    </div>

    <%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // Close resources
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    %>
</body>
</html>