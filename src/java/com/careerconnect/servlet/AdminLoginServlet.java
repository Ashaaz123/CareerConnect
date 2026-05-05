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
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {
            // Retrieve Operation: Check if credentials match our table
            String sql = "SELECT * FROM admin_users WHERE username = ? AND password = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user);
            pstmt.setString(2, pass);
            
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                //Create a session to "remember" the admin is logged in
                HttpSession session = request.getSession();
                session.setAttribute("adminUser", user);
                response.sendRedirect("admin_dashboard.jsp");
            } else {
                //Failure: Send them back to login with an error
                response.sendRedirect("admin_login.jsp?error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin_login.jsp?error=db");
        }
    }
}