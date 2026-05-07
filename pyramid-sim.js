const canvas = document.getElementById('canvas');
const ctx = canvas.getContext('2d');
const logPanel = document.getElementById('log');

let w, h;
const resize = () => { w = canvas.width = window.innerWidth; h = canvas.height = window.innerHeight; };
window.onresize = resize;
resize();

// Simulation State
let agents = [];
let particles = [];
let biomes = [];
let resources = [];
let frame = 0;

const COLORS = {
    content: '#32CD32',  // Green
    tech: '#FFA500',     // Orange
    research: '#FF69B4', // Pink
    system: '#00D4FF',   // Cyan
    gold: '#FFD700',
    void: '#050505'
};

// Initialize Procedural Biomes
function initBiomes() {
    for(let i=0; i<4; i++) {
        biomes.push({
            x: Math.random() * w,
            y: Math.random() * h,
            r: 200 + Math.random() * 300,
            color: `rgba(${Math.random()*50}, ${Math.random()*50}, ${50 + Math.random()*100}, 0.05)`
        });
    }
}

class Agent {
    constructor(name, type, i) {
        this.name = name;
        this.type = type;
        this.x = Math.random() * w;
        this.y = Math.random() * h;
        this.vx = (Math.random() - 0.5) * 1.5;
        this.vy = (Math.random() - 0.5) * 1.5;
        this.color = [COLORS.content, COLORS.tech, COLORS.research, COLORS.system, COLORS.gold][i % 5];
        this.size = 10 + Math.random() * 4;
        this.energy = 100;
        this.history = [];
    }

    update() {
        // Emergent movement
        this.x += this.vx;
        this.y += this.vy;

        // Keep in habitat
        if (this.x < 0 || this.x > w) this.vx *= -1;
        if (this.y < 0 || this.y > h) this.vy *= -1;

        // Resource interaction
        resources.forEach((r, idx) => {
            let dist = Math.hypot(r.x - this.x, r.y - this.y);
            if (dist < 10) {
                resources.splice(idx, 1);
                this.energy = Math.min(100, this.energy + 20);
                spawnExplosion(this.x, this.y, this.color);
                addLog(`${this.name} harvested Profit.`);
            } else if (dist < 100) {
                this.vx += (r.x - this.x) * 0.005;
                this.vy += (r.y - this.y) * 0.005;
            }
        });

        // Friction and speed limits
        this.vx *= 0.99; this.vy *= 0.99;
        if (Math.abs(this.vx) < 0.2) this.vx = (Math.random()-0.5)*2;
        if (Math.abs(this.vy) < 0.2) this.vy = (Math.random()-0.5)*2;

        this.energy -= 0.01;

        // Tail history for "Ultra" look
        this.history.push({x: this.x, y: this.y});
        if (this.history.length > 10) this.history.shift();
    }

    draw() {
        // Draw tail
        ctx.beginPath();
        ctx.strokeStyle = this.color;
        ctx.lineWidth = 2;
        ctx.globalAlpha = 0.3;
        this.history.forEach((p, i) => {
            if(i===0) ctx.moveTo(p.x, p.y);
            else ctx.lineTo(p.x, p.y);
        });
        ctx.stroke();
        ctx.globalAlpha = 1;

        // Draw Agent Core
        ctx.save();
        ctx.shadowBlur = 25;
        ctx.shadowColor = this.color;
        ctx.fillStyle = this.color;
        ctx.fillRect(this.x - this.size/2, this.y - this.size/2, this.size, this.size);

        // Label
        ctx.fillStyle = '#fff';
        ctx.font = '8px monospace';
        ctx.fillText(this.name, this.x + 10, this.y);
        ctx.restore();
    }
}

function spawnExplosion(x, y, color) {
    for(let i=0; i<15; i++) {
        particles.push({
            x, y,
            vx: (Math.random()-0.5)*6,
            vy: (Math.random()-0.5)*6,
            life: 1.0,
            color
        });
    }
}

function addLog(msg) {
    const d = document.createElement('div');
    d.innerText = `> ${msg}`;
    logPanel.prepend(d);
    if(logPanel.children.length > 10) logPanel.lastChild.remove();
}

function loop() {
    frame++;
    // Ultra Background (Slow clear for trails)
    ctx.fillStyle = 'rgba(5, 5, 5, 0.1)';
    ctx.fillRect(0, 0, w, h);

    // Biomes
    biomes.forEach(b => {
        ctx.fillStyle = b.color;
        ctx.beginPath();
        ctx.arc(b.x, b.y, b.r, 0, Math.PI*2);
        ctx.fill();
    });

    // Spawn Profit Resources
    if (frame % 60 === 0 && resources.length < 15) {
        resources.push({x: Math.random()*w, y: Math.random()*h});
    }

    // Draw Resources
    resources.forEach(r => {
        ctx.fillStyle = COLORS.gold;
        ctx.shadowBlur = 10;
        ctx.shadowColor = COLORS.gold;
        ctx.beginPath(); ctx.arc(r.x, r.y, 4, 0, Math.PI*2); ctx.fill();
        ctx.shadowBlur = 0;
    });

    // Update & Draw Particles
    particles = particles.filter(p => p.life > 0);
    particles.forEach(p => {
        p.x += p.vx; p.y += p.vy; p.life -= 0.02;
        ctx.fillStyle = p.color;
        ctx.globalAlpha = p.life;
        ctx.fillRect(p.x, p.y, 2, 2);
    });
    ctx.globalAlpha = 1;

    // Update & Draw Agents
    agents.forEach(a => {
        a.update();
        a.draw();
    });

    // Reality Score
    document.getElementById('sp').innerText = (frame * 0.1).toFixed(1);

    requestAnimationFrame(loop);
}

// Start System
const HABITAT_AGENTS = [
    "Revenue-Soul", "Content-Factory", "Traffic-Soul", "Automation-Soul", "Djinie",
    "Deerg-Bot", "Doctor-Buht-Buht", "Library-Updater", "Bot-Commander", "Link-Checker"
];

agents = HABITAT_AGENTS.map((name, i) => new Agent(name, "agent", i));
initBiomes();
addLog("ULTRA GRAPHICS INITIALIZED.");
addLog("10 AGENTS CONNECTED TO HABITAT.");
loop();
