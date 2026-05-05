<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome | CareerConnect Portal</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .gateway-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 80vh;
            gap: 40px;
            padding: 20px;
        }
        .portal-card {
            background: white;
            padding: 50px 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            text-align: center;
            width: 320px;
            transition: all 0.3s ease;
            text-decoration: none;
            color: #333;
            border: 2px solid transparent;
        }
        .portal-card:hover {
            transform: translateY(-10px);
            border-color: #3498db;
            box-shadow: 0 15px 40px rgba(52, 152, 219, 0.2);
        }
        .icon-circle {
            width: 80px;
            height: 80px;
            background: #f0f7ff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 40px;
        }
        .portal-card h2 { color: #2c3e50; margin-bottom: 15px; }
        .portal-card p { color: #666; line-height: 1.6; font-size: 0.95rem; }
    </style>
</head>
<body style="background: #f4f7f6;">

<header>
    <div class="logo" style="text-align: center; width: 100%;">Career<span>Connect</span></div>
</header>

<div class="gateway-wrapper">
    <a href="applicant_home.jsp" class="portal-card">
        <div class="icon-circle">👤</div>
        <h2>Applicant</h2>
        <p>Looking for your dream job? Browse vacancies and submit your smart application here.</p>
        <div style="margin-top: 25px; font-weight: bold; color: #3498db;">Enter Career Portal &rarr;</div>
    </a>

    <a href="admin_login.jsp" class="portal-card">
        <div class="icon-circle">🔐</div>
        <h2>Administrator</h2>
        <p>Access the management dashboard to post new jobs, delete vacancies, and view applicants.</p>
        <div style="margin-top: 25px; font-weight: bold; color: #2c3e50;">Admin Secure Login &rarr;</div>
    </a>
</div>

<footer style="position: fixed; bottom: 0; width: 100%; text-align: center; padding: 20px; background: #2c3e50; color: white;">
    <p>&copy; 2026 CareerConnect | All Rights Reserved</p>
</footer>

</body>
</html>