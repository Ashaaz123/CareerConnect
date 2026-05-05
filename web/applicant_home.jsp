<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home | CareerConnect</title>
    <link rel="stylesheet" href="style.css">
</head>

<body>
<header>
    <div class="logo">Career<span>Connect</span></div>
    <nav>
        <ul>
            <li><a href="index.jsp" class="active">Home</a></li>
            <li><a href="jobs.jsp">Vacancies</a></li>
            <li><a href="apply.jsp">ATS & Apply</a></li>
        </ul>
    </nav>
</header>
<div class="notification-bar">
    <marquee behavior="scroll" direction="left"><strong>Update:</strong> Recruitment Drive Started!Apply Now to Secure Your Spot!</marquee>
</div>
<section class="hero">
    <div class="hero-content">
        <h1>Shape Your Future</h1>
        <p>The smartest way to find a job. Check your resume score instantly and get hired.</p>
        <div class="hero-buttons">
            <a href="jobs.jsp" class="btn primary-btn">View Openings</a>
            <a href="apply.jsp" class="btn secondary-btn">Check Resume Score</a>
        </div>
    </div>
</section>
<section class="section-container" id="jobs-section">
    <h2 class="section-title">Current Openings</h2>
    <div id="job-list">
        <!-- Jobs will appear here via script.js -->
    </div>
</section>
<section class="section-container">
    <h2 class="section-title">Success Stories & Tips</h2>
    <div class="media-grid">
        <div class="media-card">
            <h3>Expert Advice</h3>
            <video controls>
                <source src="video/career-tips.mp4" type="video/mp4">
            </video>
        </div>
        <div class="media-card">
            <h3>Career Podcast</h3>
            <audio controls>
                <source src="audio/podcast.mp3" type="audio/mpeg">
            </audio>
        </div>
    </div>
</section>
<footer>
    <p>&copy; 2026 CareerConnect. Designed for Excellence.</p>
</footer>
<script src="script.js"></script>
</body>
</html>
