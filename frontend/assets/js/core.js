/* ==============================
   VoxportCS Panel Core Engine
   ============================== */

window.Panel = {
    apiBase: '/api',
    user: null,
    token: null,
    permissions: [],
};

/* ------------------------------
   AUTH SESSION HANDLER
--------------------------------*/
Panel.loadSession = function () {
    try {
        const raw = sessionStorage.getItem('VoxportCS_session');
        if (!raw) return false;

        const data = JSON.parse(raw);
        Panel.token = data.token || null;
        Panel.user = data.user || null;
        Panel.permissions = data.permissions || [];
        return true;
    } catch (e) {
        console.error('Session parse failed', e);
        return false;
    }
};

Panel.logout = function () {
    console.log('LOGOUT FUNCTION RUN');
    sessionStorage.clear();
    window.location.replace('login.html');
};

/* ------------------------------
   API FETCH WRAPPER
--------------------------------*/
Panel.api = async function (url, options = {}) {
    const headers = options.headers || {};
    headers['Content-Type'] = 'application/json';

    if (Panel.token) {
        headers['Authorization'] = 'Bearer ' + Panel.token;
    }

    try {
        const res = await fetch(Panel.apiBase + url, {
            ...options,
            headers
        });

        if (res.status === 401) {
            Panel.logout();
            return;
        }

        if (!res.ok) {
            throw new Error('API Error: ' + res.status);
        }

        return await res.json();
    } catch (err) {
        console.error(err);
        alert('System error. Check console.');
        throw err;
    }
};

/* ------------------------------
   PERMISSION CHECK
--------------------------------*/
Panel.can = function (perm) {
    return Panel.permissions.includes(perm) || Panel.permissions.includes('*');
};

/* ------------------------------
   GLOBAL INIT
--------------------------------*/
(function initPanel() {
    const ok = Panel.loadSession();
    if (!ok && !location.href.includes('login.html')) {
        location.href = 'login.html';
    }
})();

document.addEventListener('DOMContentLoaded', function () {
    const btn = document.getElementById('btnLogout');
    if (btn) {
        btn.addEventListener('click', function () {
            console.log('LOGOUT CLICKED');
            Panel.logout();
        });
    }
});
