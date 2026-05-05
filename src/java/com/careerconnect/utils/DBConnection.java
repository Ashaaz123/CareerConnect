package com.careerconnect.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    
    // Database credentials
    private static final String DB_URL = "jdbc:mysql://localhost:3306/careerconnect_db";
    private static final String DB_USER = "root"; // Default MySQL username
    private static final String DB_PASSWORD = "admin"; 

    public static Connection getConnection() {
        Connection connection = null;
        try {
            // 1. Load the MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // 2. Establish the connection
            connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            System.out.println("Database connection successful!");
            
        } catch (ClassNotFoundException e) {
            System.out.println("Error: MySQL JDBC Driver not found. Did you add the .jar file to libraries?");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Error: Connection Failed! Check your URL, username, and password.");
            e.printStackTrace();
        }
        return connection;
    }
}
