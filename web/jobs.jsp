<%@ page import="java.sql.*" %>
<%
    // Forces the browser to get a fresh copy from the server every time
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
%>
<%@ page import="com.careerconnect.utils.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vacancies | CareerConnect</title>
    <link rel="stylesheet" href="style.css">
    
    <style>
        .jobs-wrapper { max-width: 1000px; margin: 40px auto; padding: 0 20px; }
        .info-card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); margin-bottom: 25px; }
        .jobs-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .jobs-table th { background-color: #2c3e50; color: white; padding: 15px; text-align: left; }
        .jobs-table td { padding: 15px; border-bottom: 1px solid #eee; }
        .jobs-table tr:hover { background-color: #f9f9f9; }
    </style>
</head>
<body>

<header>
    <div class="logo">Career<span>Connect</span></div>
    <nav>
        <ul>
            <li><a href="index.jsp">Home</a></li>
            <li><a href="jobs.jsp" class="active">Vacancies</a></li>
            <li><a href="apply.jsp">ATS & Apply</a></li>
        </ul>
    </nav>
</header>

<div class="jobs-wrapper">
    
    <div class="info-card">
        <h2 style="text-align: center; color: #2c3e50; margin-bottom: 10px;">Live Job Board</h2>
        <p style="text-align: center; color: #666; margin-bottom: 20px;">Current Status: Recruitment Phase 1 - Live from Database</p>

        <div style="overflow-x: auto;">
            <table class="jobs-table">
                <thead>
                    <tr>
                        <th>Job ID</th>
                        <th>Role</th>
                        <th>Department</th>
                        <th>Seats</th>
                        <th>Live Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;

                    try {
                        conn = DBConnection.getConnection();
                        if (conn != null) {
                            stmt = conn.createStatement();
                            String query = "SELECT * FROM jobs";
                            rs = stmt.executeQuery(query);

                            while(rs.next()) {
                                String jobId = rs.getString("job_id");
                                String roleName = rs.getString("role_name");
                                String department = rs.getString("department");
                                int maxSeats = rs.getInt("max_seats");
                                int filledSeats = rs.getInt("filled_seats");
                                
                                String statusText = filledSeats + " / " + maxSeats + " Filled ";
                                String statusColor = "#28a745"; 
                                String openStatus = "(Open)";

                                if (filledSeats >= maxSeats) {
                                    openStatus = "(Closed)";
                                    statusColor = "#dc3545"; 
                                } else if (maxSeats - filledSeats <= 2) {
                                    openStatus = "(Urgent)";
                                    statusColor = "#fd7e14"; 
                                }
                %>
                                <tr>
                                    <td><b><%= jobId %></b></td>
                                    <td><%= roleName %></td>
                                    <td><%= department %></td>
                                    <td><%= maxSeats %></td>
                                    <td>
                                        <span style="color: <%= statusColor %>; font-weight: bold; background: #f8f9fa; padding: 4px 8px; border-radius: 4px; border: 1px solid <%= statusColor %>;">
                                            <%= statusText %> <%= openStatus %>
                                        </span>
                                    </td>
                                    <td>
                                        <% if (filledSeats < maxSeats) { %>
                                            <a href="apply.jsp?job_id=<%= jobId %>" style="text-decoration: none;">
                                                <button style="padding: 8px 18px; background-color: #3498db; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">Apply</button>
                                            </a>
                                        <% } else { %>
                                            <button disabled style="padding: 8px 18px; background: #ccc; color: #666; border: none; border-radius: 4px; cursor: not-allowed; font-weight: bold;">Full</button>
                                        <% } %>
                                    </td>
                                </tr>
                <%
                            } 
                        } else {
                            out.println("<tr><td colspan='6' style='color:red; text-align:center;'>Database connection failed. Check DBConnection.java</td></tr>");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<tr><td colspan='6' style='color:red; text-align:center;'>Error loading jobs: " + e.getMessage() + "</td></tr>");
                    } finally {
                        if(rs != null) try { rs.close(); } catch(SQLException e) {}
                        if(stmt != null) try { stmt.close(); } catch(SQLException e) {}
                        if(conn != null) try { conn.close(); } catch(SQLException e) {}
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

    <div class="info-card">
        <h3 style="color: #2c3e50; margin-bottom: 15px;">Why Join Us?</h3>
        <ul style="line-height: 2; color: #444; padding-left: 20px;">
            <li>100% Remote Work Options</li>
            <li>Comprehensive Health Insurance</li>
            <li>Annual Performance Bonus</li>
            <li>Professional Training Budget</li>
        </ul>
    </div>

</div>

<footer style="background-color: #2c3e50; color: white; text-align: center; padding: 20px; margin-top: auto;">
    <p>&copy; 2026 CareerConnect. Built for Excellence.</p>
</footer>

</body>
</html>