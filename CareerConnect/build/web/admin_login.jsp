<!DOCTYPE html>
<html>
<head>
    <title>Admin Login | CareerConnect</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .login-box { max-width: 400px; margin: 100px auto; padding: 40px; background: white; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); text-align: center; }
        input { width: 100%; padding: 12px; margin: 10px 0; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
    </style>
</head>
<body style="background-color: #f4f7f6;">
    <div class="login-box">
        <h2 style="color: #2c3e50;">Admin Access</h2>
        <p style="color: #666; margin-bottom: 20px;">Enter credentials to manage applications</p>
        
        <form action="AdminLoginServlet" method="POST">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit" class="btn primary-btn full-width" style="margin-top: 10px;">Login</button>
        </form>

        <% if ("1".equals(request.getParameter("error"))) { %>
            <p style="color: red; margin-top: 15px;">Invalid Username or Password!</p>
        <% } %>
    </div>
</body>
</html>