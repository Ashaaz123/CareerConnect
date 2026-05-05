package com.careerconnect.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.careerconnect.utils.DBConnection;

@WebServlet("/UpdateJobServlet") 
public class UpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect("admin_login.jsp");
            return;
        }

        String jobId = request.getParameter("job_id");
        String newMaxStr = request.getParameter("new_max");

        try (Connection conn = DBConnection.getConnection()) {
            int newMax = Integer.parseInt(newMaxStr);
            String sql = "UPDATE jobs SET max_seats = ? WHERE job_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, newMax);
            pstmt.setString(2, jobId);
            
            pstmt.executeUpdate();
            response.sendRedirect("admin_dashboard.jsp?status=success");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin_dashboard.jsp?status=error");
        }
    }
}