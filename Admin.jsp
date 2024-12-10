<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page session="true"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Advanced Admin Reporting</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 1200px; margin: 0 auto; padding: 20px; }
        table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
        table, th, td { border: 1px solid #ddd; padding: 8px; }
        th { background-color: #f2f2f2; text-align: left; }
        h1, h2 { color: #333; }
    </style>
</head>
<body>
    <h1>Comprehensive Reservation and Revenue Reporting</h1>

    <%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Establish database connection
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/TrainDatabase", "root", "12345678");

        // 1. Reservations by Transit Line
        %>
        <h2>Detailed Reservations by Transit Line</h2>
        <table>
            <tr>
                <th>Transit Line</th>
                <th>Total Reservations</th>
            </tr>
            <%
            String transitLineQuery = "SELECT transitLineName, COUNT(*) AS ReservationCount " +
                                      "FROM Reservation " +
                                      "GROUP BY transitLineName " +
                                      "ORDER BY ReservationCount DESC";
            pstmt = conn.prepareStatement(transitLineQuery);
            rs = pstmt.executeQuery();

            while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("transitLineName") %></td>
                <td><%= rs.getInt("ReservationCount") %></td>
            </tr>
            <%
            }
            rs.close();
            pstmt.close();
            %>
        </table>

        <%
        // 2. Reservations by Customer Name
        %>
        <h2>Detailed Reservations by Customer</h2>
        <table>
            <tr>
                <th>Customer Name</th>
                <th>Email</th>
                <th>Total Reservations</th>
            </tr>
            <%
            String customerReservationQuery = "SELECT c.firstName, c.lastName, c.emailAddress, COUNT(*) AS ReservationCount " +
                                              "FROM Customer c " +
                                              "JOIN Reservation r ON c.emailAddress = r.emailAddress " +
                                              "GROUP BY c.emailAddress, c.firstName, c.lastName " +
                                              "ORDER BY ReservationCount DESC";
            pstmt = conn.prepareStatement(customerReservationQuery);
            rs = pstmt.executeQuery();

            while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("firstName") + " " + rs.getString("lastName") %></td>
                <td><%= rs.getString("emailAddress") %></td>
                <td><%= rs.getInt("ReservationCount") %></td>
            </tr>
            <%
            }
            rs.close();
            pstmt.close();
            %>
        </table>

        <%
        // 3. Revenue by Transit Line
        %>
        <h2>Detailed Revenue by Transit Line</h2>
        <table>
            <tr>
                <th>Transit Line</th>
                <th>Total Reservations</th>
                <th>Total Revenue</th>
                <th>Average Fare</th>
            </tr>
            <%
            String transitLineRevenueQuery = "SELECT transitLineName, " +
                                             "COUNT(*) AS ReservationCount, " +
                                             "SUM(totalFare) AS TotalRevenue, " +
                                             "AVG(totalFare) AS AverageFare " +
                                             "FROM Reservation " +
                                             "GROUP BY transitLineName " +
                                             "ORDER BY TotalRevenue DESC";
            pstmt = conn.prepareStatement(transitLineRevenueQuery);
            rs = pstmt.executeQuery();

            while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("transitLineName") %></td>
                <td><%= rs.getInt("ReservationCount") %></td>
                <td>$<%= String.format("%.2f", rs.getDouble("TotalRevenue")) %></td>
                <td>$<%= String.format("%.2f", rs.getDouble("AverageFare")) %></td>
            </tr>
            <%
            }
            rs.close();
            pstmt.close();
            %>
        </table>

        <%
        // 4. Revenue by Customer
        %>
        <h2>Detailed Revenue by Customer</h2>
        <table>
            <tr>
                <th>Customer Name</th>
                <th>Email</th>
                <th>Total Reservations</th>
                <th>Total Revenue</th>
                <th>Average Fare</th>
            </tr>
            <%
            String customerRevenueQuery = "SELECT c.firstName, c.lastName, c.emailAddress, " +
                                          "COUNT(*) AS ReservationCount, " +
                                          "SUM(r.totalFare) AS TotalRevenue, " +
                                          "AVG(r.totalFare) AS AverageFare " +
                                          "FROM Customer c " +
                                          "JOIN Reservation r ON c.emailAddress = r.emailAddress " +
                                          "GROUP BY c.emailAddress, c.firstName, c.lastName " +
                                          "ORDER BY TotalRevenue DESC";
            pstmt = conn.prepareStatement(customerRevenueQuery);
            rs = pstmt.executeQuery();

            while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("firstName") + " " + rs.getString("lastName") %></td>
                <td><%= rs.getString("emailAddress") %></td>
                <td><%= rs.getInt("ReservationCount") %></td>
                <td>$<%= String.format("%.2f", rs.getDouble("TotalRevenue")) %></td>
                <td>$<%= String.format("%.2f", rs.getDouble("AverageFare")) %></td>
            </tr>
            <%
            }
            rs.close();
            pstmt.close();
            %>
        </table>

        <%
        // 5. Best 5 Most Active Transit Lines
        %>
        <h2>Top 5 Most Active Transit Lines</h2>
        <table>
            <tr>
                <th>Rank</th>
                <th>Transit Line</th>
                <th>Total Reservations</th>
                <th>Total Revenue</th>
            </tr>
            <%
            String topTransitLinesQuery = "SELECT transitLineName, " +
                                          "COUNT(*) AS ReservationCount, " +
                                          "SUM(totalFare) AS TotalRevenue " +
                                          "FROM Reservation " +
                                          "GROUP BY transitLineName " +
                                          "ORDER BY ReservationCount DESC, TotalRevenue DESC " +
                                          "LIMIT 5";
            pstmt = conn.prepareStatement(topTransitLinesQuery);
            rs = pstmt.executeQuery();
            
            int rank = 1;
            while (rs.next()) {
            %>
            <tr>
                <td><%= rank++ %></td>
                <td><%= rs.getString("transitLineName") %></td>
                <td><%= rs.getInt("ReservationCount") %></td>
                <td>$<%= String.format("%.2f", rs.getDouble("TotalRevenue")) %></td>
            </tr>
            <%
            }
            %>
        </table>

    <%
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        // Close resources
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            out.println("<p>Error closing database resources: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    }
    %>
</body>
</html>