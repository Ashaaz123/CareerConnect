document.addEventListener("DOMContentLoaded", () => {
    fetchJobs();
});

function fetchJobs() {
    fetch("/JobPortalBackend/JobServlet") // match your servlet URL
        .then(response => response.json())
        .then(data => displayJobs(data))
        .catch(err => console.error("Error fetching jobs:", err));
}

function displayJobs(jobs) {
    const container = document.getElementById("job-list");
    container.innerHTML = ""; // clear previous content

    if (!jobs || jobs.length === 0) {
        container.innerHTML = "<p>No jobs available.</p>";
        return;
    }

    jobs.forEach(job => {
        const jobCard = document.createElement("div");
        jobCard.className = "job-card";
        jobCard.innerHTML = `
            <h3>${job.role}</h3>
            <p><strong>Job Code:</strong> ${job.job_code}</p>
            <p><strong>Department:</strong> ${job.department}</p>
            <p><strong>Seats:</strong> ${job.seats}</p>
            <p><strong>Filled:</strong> ${job.filled}</p>
        `;
        container.appendChild(jobCard);
    });
}