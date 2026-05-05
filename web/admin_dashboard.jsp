<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.careerconnect.utils.DBConnection" %>
<%
    // Security Check: If no admin session exists, kick them back to login
    if (session.getAttribute("adminUser") == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | CareerConnect</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .admin-container { max-width: 1200px; margin: 30px auto; padding: 20px; }
        .data-table { width: 100%; border-collapse: collapse; background: white; margin-bottom: 40px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); border-radius: 8px; overflow: hidden; }
        .data-table th { background: #2c3e50; color: white; padding: 15px; text-align: left; }
        .data-table td { padding: 12px; border-bottom: 1px solid #eee; font-size: 14px; }
        .action-btn { padding: 8px 14px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; font-size: 13px; display: inline-block; }
        .delete-btn { background: #e74c3c; color: white; transition: 0.3s; }
        .delete-btn:hover { background: #c0392b; }
        .update-btn { background: #f39c12; color: white; font-weight: bold; }
        .update-btn:hover { background: #d35400; }
        .view-link-btn { background: #3498db; color: white; font-weight: bold; }
        .view-link-btn:hover { background: #2980b9; }
        .info-card { background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 30px; }
        .badge { background: #ecf0f1; padding: 4px 8px; border-radius: 4px; color: #2c3e50; font-weight: 600; font-size: 12px; }
        .update-input { width: 60px; padding: 5px; border: 1px solid #ddd; border-radius: 4px; text-align: center; }
    </style>
</head>
<body style="background: #f4f7f6; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">

    <header>
        <div class="logo">Career<span>Connect</span> Admin</div>
        <nav>
            <ul>
                <li style="color: white; margin-right: 20px;">User: <strong><%= session.getAttribute("adminUser") %></strong></li>
                <li><a href="LogoutServlet" style="background: #e74c3c; padding: 8px 15px; border-radius: 4px;">Logout</a></li>
            </ul>
        </nav>
    </header>

    <div class="admin-container">
        <h2>Dashboard Overview</h2>
        
        <% if(request.getParameter("status") != null) { %>
            <div style="padding: 15px; background: #d4edda; color: #155724; border-radius: 5px; margin-bottom: 20px;">
                Operation successful! Changes reflected in real-time.
            </div>
        <% } %>

        <hr style="border: 0; height: 1px; background: #ddd; margin-bottom: 30px;">

        <h3>1. Recent Applications (Retrieve Operation)</h3>
        <table class="data-table">
            <thead>
                <tr>
                    <th>App ID</th>
                    <th>Candidate Name</th>
                    <th>Email</th>
                    <th>Role Applied</th>
                    <th>Resume / Drive Link</th>
                    <th>Applied Date</th>
                    <th>Action</th> 
                </tr>
            </thead>
            <tbody>
                <%
                    try (Connection conn = DBConnection.getConnection()) {
                        String sql = "SELECT a.app_id, a.full_name, a.email, j.role_name, a.resume_link, a.applied_at " +
                                     "FROM applications a JOIN jobs j ON a.job_id = j.job_id ORDER BY a.applied_at DESC";
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(sql);
                        while (rs.next()) {
                %>
                    <tr>
                        <td>#<%= rs.getInt("app_id") %></td>
                        <td><strong><%= rs.getString("full_name") %></strong></td>
                        <td><%= rs.getString("email") %></td>
                        <td><span class="badge"><%= rs.getString("role_name") %></span></td>
                        <td>
                            <% if(rs.getString("resume_link") != null && !rs.getString("resume_link").isEmpty()) { %>
                                <a href="<%= rs.getString("resume_link") %>" target="_blank" class="action-btn view-link-btn">View Resume 🔗</a>
                            <% } else { %>
                                <span style="color: #999;">No Link Provided</span>
                            <% } %>
                        </td>
                        <td style="color: #7f8c8d;"><%= rs.getTimestamp("applied_at") %></td>
                        <td>
                            <a href="DeleteApplicationServlet?id=<%= rs.getInt("app_id") %>" 
                               class="action-btn delete-btn" 
                               onclick="return confirm('Are you sure you want to remove this applicant?')">Remove</a>
                        </td>
                    </tr>
                <% 
                        }
                    } catch (Exception e) { 
                        out.println("<tr><td colspan='7' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>

        <div class="info-card" style="border-left: 5px solid #27ae60;">
            <h3>2. Post a New Vacancy (Insert Operation)</h3>
            <form action="AddJobServlet" method="POST" style="display: flex; gap: 10px; flex-wrap: wrap; margin-top: 15px;">
                <input type="text" name="job_id" placeholder="Job ID (QA-05)" required style="flex: 1; padding: 12px; border: 1px solid #ddd; border-radius: 4px;">
                <input type="text" name="role" placeholder="Role Name" required style="flex: 2; padding: 12px; border: 1px solid #ddd; border-radius: 4px;">
                <input type="text" name="dept" placeholder="Department" required style="flex: 1; padding: 12px; border: 1px solid #ddd; border-radius: 4px;">
                <input type="number" name="max" placeholder="Max Seats" required style="width: 100px; padding: 12px; border: 1px solid #ddd; border-radius: 4px;">
                <button type="submit" class="action-btn" style="background: #27ae60; color: white; border: none; font-weight: bold;">Add Vacancy</button>
            </form>
        </div>

        <h3>3. Active Vacancies (Update & Delete Operations)</h3>
        <table class="data-table">
            <thead>
                <tr>
                    <th>Job ID</th>
                    <th>Role</th>
                    <th>Dept</th>
                    <th>Filled / Max</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try (Connection conn = DBConnection.getConnection()) {
                        String sql = "SELECT * FROM jobs";
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(sql);
                        while (rs.next()) {
                %>
                    <tr>
                        <td><strong><%= rs.getString("job_id") %></strong></td>
                        <td><%= rs.getString("role_name") %></td>
                        <td><%= rs.getString("department") %></td>
                        <td>
                            <div style="font-weight: bold; color: <%= (rs.getInt("filled_seats") >= rs.getInt("max_seats")) ? "red" : "#2c3e50" %>;">
                                <%= rs.getInt("filled_seats") %> / 
                                <form action="UpdateJobServlet" method="POST" style="display: inline-block;">
                                    <input type="hidden" name="job_id" value="<%= rs.getString("job_id") %>">
                                    <input type="number" name="new_max" value="<%= rs.getInt("max_seats") %>" class="update-input">
                                    <button type="submit" class="action-btn update-btn" style="padding: 4px 8px; margin-left: 5px;">Update</button>
                                </form>
                            </div>
                        </td>
                        <td>
                            <a href="DeleteJobServlet?id=<%= rs.getString("job_id") %>" 
                               class="action-btn delete-btn" 
                               onclick="return confirm('Are you sure you want to delete this vacancy?')">Delete</a>
                        </td>
                    </tr>
                <% 
                        }
                    } catch (Exception e) { e.printStackTrace(); }
                %>
            </tbody>
        </table>
    </div>

</body>
</html>