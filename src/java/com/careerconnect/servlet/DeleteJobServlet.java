/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.careerconnect.servlet;

import com.careerconnect.utils.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DeleteJobServlet")
public class DeleteJobServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get the Job ID from the URL (e.g., DeleteJobServlet?id=DEV-01)
        String jobId = request.getParameter("id");

        if (jobId != null) {
            try (Connection conn = DBConnection.getConnection()) {
                // 2. DELETE Operation: Remove the job from the 'jobs' table
                // Note: Because of our "ON DELETE CASCADE" in SQL, 
                // this will also remove any applications linked to this job!
                String sql = "DELETE FROM jobs WHERE job_id = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, jobId);
                
                pstmt.executeUpdate();
                System.out.println("Job " + jobId + " deleted successfully.");
                
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // 3. Redirect back to the admin dashboard to see the updated list
        response.sendRedirect("admin_dashboard.jsp");
    }
}