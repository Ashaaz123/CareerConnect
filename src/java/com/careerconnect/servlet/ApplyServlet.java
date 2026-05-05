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

@WebServlet("/ApplyServlet")
public class ApplyServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get form data from apply.jsp
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String jobId = request.getParameter("jobId");
        String resumeLink = request.getParameter("resumeLink"); 

        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                // Start Transaction: Both actions must succeed together
                conn.setAutoCommit(false);

                try {
                    // ACTION A: Insert the Application details
                    String sqlApp = "INSERT INTO applications (full_name, email, job_id, resume_link) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement pstmtApp = conn.prepareStatement(sqlApp)) {
                        pstmtApp.setString(1, fullName);
                        pstmtApp.setString(2, email);
                        pstmtApp.setString(3, jobId);
                        pstmtApp.setString(4, resumeLink);
                        pstmtApp.executeUpdate();
                    }

                    // ACTION B: Increment the filled_seats in the jobs table
                    // The "AND filled_seats < max_seats" prevents over-booking
                    String sqlJob = "UPDATE jobs SET filled_seats = filled_seats + 1 WHERE job_id = ? AND filled_seats < max_seats";
                    try (PreparedStatement pstmtJob = conn.prepareStatement(sqlJob)) {
                        pstmtJob.setString(1, jobId);
                        int rowsUpdated = pstmtJob.executeUpdate();

                        if (rowsUpdated > 0) {
                            // Both succeeded! Permanently save to database
                            conn.commit();
                        } else {
                            // Job might be full! Undo the application insert
                            conn.rollback();
                            System.out.println("Application failed: Job " + jobId + " is full.");
                        }
                    }
                } catch (Exception innerEx) {
                    conn.rollback(); // Undo everything if any error occurs
                    innerEx.printStackTrace();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Redirect back to the jobs board to see the updated count
        response.sendRedirect("jobs.jsp");
    }
}