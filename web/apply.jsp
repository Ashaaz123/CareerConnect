<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.careerconnect.utils.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Apply | CareerConnect</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<header>
    <div class="logo">Career<span>Connect</span></div>
    <nav>
        <ul>
            <li><a href="index.jsp">Home</a></li>
            <li><a href="jobs.jsp">Vacancies</a></li>
            <li><a href="apply.jsp" class="active">ATS & Apply</a></li>
        </ul>
    </nav>
</header>

<div class="split-layout">
    <section class="card">
        <h2>Step 1: Resume Check</h2>
        <p>Score <strong>above 50%</strong> to unlock the application.</p>
        <textarea id="resumeText" placeholder="Paste your resume text here..." rows="8" style="width: 100%; border-radius: 5px; border: 1px solid #ddd; padding: 10px;"></textarea>
        <button type="button" class="btn primary-btn full-width" onclick="startScan()" style="margin-top: 10px;">Check Eligibility</button>
        
        <div id="resultBox" class="ats-result" style="display:none; margin-top: 20px;">
            <p>ATS Score: <span id="scoreText" style="font-weight: bold;">0%</span></p>
            <div class="progress-track" style="background: #eee; border-radius: 10px; height: 10px; overflow: hidden;">
                <div id="progressBar" class="progress-fill" style="height: 100%; width: 0%; background: #3498db; transition: width 0.5s;"></div>
            </div>
            <p id="msg" style="margin-top: 10px; font-size: 0.9rem;">Scanning...</p>
        </div>
    </section>
    
    <section id="finalForm" class="card locked" style="position: relative;">
        <div id="lockMessage" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(255,255,255,0.9); display: flex; flex-direction: column; align-items: center; justify-content: center; z-index: 100; border-radius: 8px; text-align: center;">
            <h3 style="color: #2c3e50; margin:0;">Application Locked</h3>
            <p style="margin:5px 0;">Pass the ATS check to apply.</p>
        </div>

        <h2>Step 2: Registration</h2>
        
        <form action="ApplyServlet" method="POST">
            <div style="margin-bottom: 15px;">
                <input type="text" name="fullName" placeholder="Full Name" required style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 5px;">
            </div>
            <div style="margin-bottom: 15px;">
                <input type="email" name="email" placeholder="Email Address" required style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 5px;">
            </div>
            
            <div style="margin-bottom: 15px;">
                <select name="jobId" required style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 5px;">
                    <option value="" disabled selected>Select the Role</option>
                    <%
                        try (Connection conn = DBConnection.getConnection()) {
                            // Fetching roles that are actually in the DB and have open seats
                            String sql = "SELECT job_id, role_name FROM jobs WHERE filled_seats < max_seats";
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery(sql);
                            
                            while (rs.next()) {
                    %>
                                <option value="<%= rs.getString("job_id") %>">
                                    <%= rs.getString("role_name") %>
                                </option>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("<option value=''>Error loading roles</option>");
                        }
                    %>
                </select>
                </div>
            
            <div style="margin-bottom: 20px;">
                <label style="display: block; font-size: 0.85rem; color: #666; margin-bottom: 5px;">Resume Drive Link</label>
                <input type="url" name="resumeLink" placeholder="https://drive.google.com/..." required style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 5px;">
            </div>
            
            <button type="submit" id="submitBtn" class="btn primary-btn full-width">Submit Application</button>
        </form>
    </section>
</div>

<footer>
    <p>&copy; 2026 CareerConnect. Built for Excellence.</p>
</footer>

<script>
function startScan() {
    const resumeInput = document.getElementById('resumeText').value.trim();
    const box = document.getElementById('resultBox');
    const bar = document.getElementById('progressBar');
    const txt = document.getElementById('scoreText');
    const msg = document.getElementById('msg');
    
    const formSection = document.getElementById('finalForm');
    const lockOverlay = document.getElementById('lockMessage');

    if (resumeInput === "") {
        alert("Please paste your resume text first.");
        return;
    }

    box.style.display = 'block';
    bar.style.width = '0%';
    txt.innerHTML = '0%';
    msg.innerHTML = "Scanning...";
    msg.style.color = "#333";
    
    setTimeout(() => {
        const keywords = ['developer', 'html', 'css', 'javascript', 'react', 'node', 'ui', 'ux', 'design', 'sql', 'java', 'python', 'experience', 'internship', 'project'];
        let matches = 0;
        const lowerText = resumeInput.toLowerCase();

        keywords.forEach(kw => {
            if (lowerText.includes(kw)) matches++;
        });

        let score = Math.floor((matches / keywords.length) * 75); 
        score += Math.min(25, Math.floor(resumeInput.length / 100)); 
        if (score > 100) score = 100;

        bar.style.width = score + '%';
        txt.innerHTML = score + '%';

        if (score >= 50) {
            msg.innerHTML = "Passed! Unlocking Application...";
            msg.style.color = "green";
            bar.style.backgroundColor = "green"; 
            
            setTimeout(() => {
                lockOverlay.style.display = 'none';      
                formSection.classList.remove('locked');  
                formSection.style.filter = "none";      
            }, 800);
        } else {
            msg.innerHTML = "Score " + score + "% is too low. (Min 50% required)";
            msg.style.color = "red";
            bar.style.backgroundColor = "red"; 
            lockOverlay.style.display = 'flex'; 
            formSection.classList.add('locked');
        }
    }, 1000);
}
</script>

</body>
</html>