/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.careerconnect.servlet;

import com.careerconnect.utils.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AddJobServlet")
public class AddJobServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String jobId = request.getParameter("job_id");
        String role = request.getParameter("role");
        String dept = request.getParameter("dept");
        int max = Integer.parseInt(request.getParameter("max"));

        try (Connection conn = DBConnection.getConnection()) {
            // INSERT Operation: Adding a new row to the jobs table
            String sql = "INSERT INTO jobs (job_id, role_name, department, max_seats, filled_seats) VALUES (?, ?, ?, ?, 0)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, jobId);
            pstmt.setString(2, role);
            pstmt.setString(3, dept);
            pstmt.setInt(4, max);
            
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        // Redirect back to see the new job in the list
        response.sendRedirect("admin_dashboard.jsp");
    }
}