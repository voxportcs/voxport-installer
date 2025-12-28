// --- CANVAS ANIMATION ---
const canvas = document.getElementById('bg-canvas');
const ctx = canvas.getContext('2d');
let particles = [];

function resize() {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
}
resize();
window.addEventListener('resize', resize);

for (let i = 0; i < 80; i++) {
    particles.push({
        x: Math.random() * canvas.width,
        y: Math.random() * canvas.height,
        vx: (Math.random() - 0.5) * 0.5,
        vy: (Math.random() - 0.5) * 0.5,
        size: Math.random() * 2
    });
}

function animate() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.fillStyle = 'rgba(59, 130, 246, 0.6)';
    ctx.strokeStyle = 'rgba(59, 130, 246, 0.15)';

    particles.forEach((p, i) => {
        p.x += p.vx; p.y += p.vy;
        if (p.x < 0 || p.x > canvas.width) p.vx *= -1;
        if (p.y < 0 || p.y > canvas.height) p.vy *= -1;

        ctx.beginPath();
        ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
        ctx.fill();

        for (let j = i + 1; j < particles.length; j++) {
            let p2 = particles[j];
            let d = Math.hypot(p.x - p2.x, p.y - p2.y);
            if (d < 150) {
                ctx.lineWidth = 1 - d / 150;
                ctx.beginPath();
                ctx.moveTo(p.x, p.y);
                ctx.lineTo(p2.x, p2.y);
                ctx.stroke();
            }
        }
    });
    requestAnimationFrame(animate);
}
animate();

// ===============================
// VoxportCS Secure Login Handler
// ===============================

async function login() {
    const username = document.getElementById('user').value.trim();
    const password = document.getElementById('pass').value;

    if (!username || !password) {
        alert('Username and password required');
        return;
    }

    try {
        const res = await fetch('/api/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ username, password })
        });

        if (!res.ok) {
            alert('Invalid username or password');
            return;
        }

        const data = await res.json();

        // Store session (used by core.js)
        sessionStorage.setItem('VoxportCS_session', JSON.stringify({
            token: data.token,
            user: data.user,
            permissions: data.permissions
        }));

        // Redirect to panel
        window.location.href = 'index.html';

    } catch (err) {
        console.error(err);
        alert('Login failed. Check console.');
    }
}

// Auto redirect if already logged in
(function () {
    if (sessionStorage.getItem('VoxportCS_session')) {
        window.location.href = 'index.html';
    }
})();
