package com.careerconnect.servlet;

import com.careerconnect.utils.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DeleteApplicationServlet")
public class DeleteApplicationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String appIdStr = request.getParameter("id");

        if (appIdStr != null) {
            int appId = Integer.parseInt(appIdStr);

            try (Connection conn = DBConnection.getConnection()) {
                // Start Transaction: Both delete and decrement must happen together
                conn.setAutoCommit(false);

                try {
                    // 1. Find the Job ID for this application before we delete it
                    String jobId = "";
                    String findJobSql = "SELECT job_id FROM applications WHERE app_id = ?";
                    try (PreparedStatement pstmtFind = conn.prepareStatement(findJobSql)) {
                        pstmtFind.setInt(1, appId);
                        ResultSet rs = pstmtFind.executeQuery();
                        if (rs.next()) {
                            jobId = rs.getString("job_id");
                        }
                    }

                    // 2. Delete the Application
                    String deleteSql = "DELETE FROM applications WHERE app_id = ?";
                    try (PreparedStatement pstmtDelete = conn.prepareStatement(deleteSql)) {
                        pstmtDelete.setInt(1, appId);
                        pstmtDelete.executeUpdate();
                    }

                    // 3. Decrement the filled_seats count in the jobs table
                    if (!jobId.equals("")) {
                        String updateSql = "UPDATE jobs SET filled_seats = filled_seats - 1 WHERE job_id = ? AND filled_seats > 0";
                        try (PreparedStatement pstmtUpdate = conn.prepareStatement(updateSql)) {
                            pstmtUpdate.setString(1, jobId);
                            pstmtUpdate.executeUpdate();
                        }
                    }

                    conn.commit(); // Success! Save changes
                } catch (Exception innerEx) {
                    conn.rollback(); // Error! Undo everything
                    innerEx.printStackTrace();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        // Redirect back to dashboard to see the updated list and counts
        response.sendRedirect("admin_dashboard.jsp");
    }
}