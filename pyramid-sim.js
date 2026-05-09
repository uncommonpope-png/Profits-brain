const canvas = document.getElementById('canvas');
const ctx = canvas.getContext('2d');
const logPanel = document.getElementById('log');

let w, h;
const resize = () => {
    w = canvas.width = canvas.clientWidth;
    h = canvas.height = canvas.clientHeight;
};
window.onresize = resize;
resize();

// Isometric Constants
const TILE_W = 64;
const TILE_H = 32;
const MAP_SIZE = 20;

// Coordinate conversion
const cartToIso = (x, y) => ({
    x: (x - y) * (TILE_W / 2),
    y: (x + y) * (TILE_H / 2)
});

const isoToCart = (ix, iy) => ({
    x: (iy / (TILE_H / 2) + ix / (TILE_W / 2)) / 2,
    y: (iy / (TILE_H / 2) - ix / (TILE_W / 2)) / 2
});

// Assets (Procedural Textures)
const drawTile = (tx, ty, type) => {
    const iso = cartToIso(tx, ty);
    const screenX = w/2 + iso.x;
    const screenY = h/4 + iso.y;

    ctx.beginPath();
    ctx.moveTo(screenX, screenY);
    ctx.lineTo(screenX + TILE_W/2, screenY + TILE_H/2);
    ctx.lineTo(screenX, screenY + TILE_H);
    ctx.lineTo(screenX - TILE_W/2, screenY + TILE_H/2);
    ctx.closePath();

    if(type === 'grass') ctx.fillStyle = '#2d5a27';
    else if(type === 'water') ctx.fillStyle = '#1e3d59';
    else ctx.fillStyle = '#3a3a3a';

    ctx.fill();
    ctx.strokeStyle = 'rgba(0,0,0,0.1)';
    ctx.stroke();

    // Noise/Texture
    ctx.fillStyle = 'rgba(255,255,255,0.05)';
    if(Math.random() < 0.1) ctx.fillRect(screenX-2, screenY+TILE_H/2, 4, 4);
};

// Simulation state
let agents = [];
let resources = [];

class Agent {
    constructor(name, type, i) {
        this.name = name;
        this.type = type;
        this.tx = Math.random() * MAP_SIZE; // Tile X
        this.ty = Math.random() * MAP_SIZE; // Tile Y
        this.targetX = this.tx;
        this.targetY = this.ty;
        this.color = ['#32CD32', '#FFA500', '#FF69B4', '#00D4FF', '#FFD700'][i % 5];
        this.energy = 100;
    }

    update() {
        if (Math.abs(this.tx - this.targetX) < 0.1 && Math.abs(this.ty - this.targetY) < 0.1) {
            this.targetX = Math.random() * MAP_SIZE;
            this.targetY = Math.random() * MAP_SIZE;
        }

        this.tx += (this.targetX - this.tx) * 0.01;
        this.ty += (this.targetY - this.ty) * 0.01;
        this.energy -= 0.005;
    }

    draw() {
        const iso = cartToIso(this.tx, this.ty);
        const sx = w/2 + iso.x;
        const sy = h/4 + iso.y;

        // AoE Style Shadow
        ctx.fillStyle = 'rgba(0,0,0,0.4)';
        ctx.beginPath();
        ctx.ellipse(sx, sy + TILE_H/2, 12, 6, 0, 0, Math.PI*2);
        ctx.fill();

        // Procedural Villager Sprite
        ctx.save();
        ctx.translate(sx, sy);

        // Body (Tunic)
        ctx.fillStyle = this.color;
        ctx.fillRect(-4, -15, 8, 15);

        // Head
        ctx.fillStyle = '#ffdbac';
        ctx.fillRect(-3, -20, 6, 6);

        // Details (Arms/Belt)
        ctx.fillStyle = '#3e2723';
        ctx.fillRect(-4, -8, 8, 2); // Belt

        ctx.restore();

        ctx.fillStyle = '#fff';
        ctx.font = 'bold 9px Arial';
        ctx.textAlign = 'center';
        ctx.fillText(this.name, sx, sy - 25);
    }
}

const drawStructure = (tx, ty, type, color) => {
    const iso = cartToIso(tx, ty);
    const sx = w/2 + iso.x;
    const sy = h/4 + iso.y;

    ctx.save();
    ctx.translate(sx, sy);

    // Foundation
    ctx.fillStyle = '#5d4037';
    ctx.beginPath();
    ctx.moveTo(0, 0);
    ctx.lineTo(TILE_W/2, TILE_H/2);
    ctx.lineTo(0, TILE_H);
    ctx.lineTo(-TILE_W/2, TILE_H/2);
    ctx.fill();

    // Walls
    ctx.fillStyle = '#8d6e63';
    ctx.beginPath();
    ctx.moveTo(-TILE_W/2, TILE_H/2);
    ctx.lineTo(0, TILE_H);
    ctx.lineTo(0, TILE_H - 30);
    ctx.lineTo(-TILE_W/2, TILE_H/2 - 30);
    ctx.fill();

    ctx.fillStyle = '#795548';
    ctx.beginPath();
    ctx.moveTo(TILE_W/2, TILE_H/2);
    ctx.lineTo(0, TILE_H);
    ctx.lineTo(0, TILE_H - 30);
    ctx.lineTo(TILE_W/2, TILE_H/2 - 30);
    ctx.fill();

    // Roof (Tent style)
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.moveTo(0, TILE_H - 30);
    ctx.lineTo(-TILE_W/2, TILE_H/2 - 30);
    ctx.lineTo(0, TILE_H/2 - 50);
    ctx.lineTo(TILE_W/2, TILE_H/2 - 30);
    ctx.closePath();
    ctx.fill();

    ctx.restore();
};

const drawTree = (tx, ty) => {
    const iso = cartToIso(tx, ty);
    const sx = w/2 + iso.x;
    const sy = h/4 + iso.y;

    ctx.save();
    ctx.translate(sx, sy);
    // Shadow
    ctx.fillStyle = 'rgba(0,0,0,0.2)';
    ctx.beginPath(); ctx.ellipse(0, TILE_H/2, 6, 3, 0, 0, Math.PI*2); ctx.fill();
    // Trunk
    ctx.fillStyle = '#4e342e';
    ctx.fillRect(-2, -5, 4, 10);
    // Leaves
    ctx.fillStyle = '#1b5e20';
    ctx.beginPath(); ctx.arc(0, -10, 8, 0, Math.PI*2); ctx.fill();
    ctx.beginPath(); ctx.arc(5, -5, 6, 0, Math.PI*2); ctx.fill();
    ctx.beginPath(); ctx.arc(-5, -5, 6, 0, Math.PI*2); ctx.fill();
    ctx.restore();
};

const drawGoldMine = (tx, ty) => {
    const iso = cartToIso(tx, ty);
    const sx = w/2 + iso.x;
    const sy = h/4 + iso.y;

    ctx.save();
    ctx.translate(sx, sy);
    ctx.fillStyle = '#424242';
    ctx.beginPath(); ctx.moveTo(-15, TILE_H/2); ctx.lineTo(0, -10); ctx.lineTo(15, TILE_H/2); ctx.lineTo(0, TILE_H+5); ctx.fill();
    ctx.fillStyle = '#FFD700';
    ctx.shadowBlur = 5; ctx.shadowColor = '#FFD700';
    ctx.fillRect(-5, 0, 10, 10);
    ctx.restore();
};

function addLog(msg) {
    const d = document.createElement('div');
    d.innerText = `> ${msg}`;
    logPanel.prepend(d);
    if(logPanel.children.length > 8) logPanel.lastChild.remove();
}

const loop = () => {
    // If w or h are 0 (hidden or initial), try resizing again
    if(w === 0 || h === 0) resize();

    ctx.fillStyle = '#050505';
    ctx.fillRect(0, 0, w, h);

    // Draw Map (Grid)
    for(let y=0; y<MAP_SIZE; y++) {
        for(let x=0; x<MAP_SIZE; x++) {
            let type = 'grass';
            // Simple landscape: water on edges
            if(x < 1 || y < 1 || x > MAP_SIZE-2 || y > MAP_SIZE-2) type = 'water';
            drawTile(x, y, type);
        }
    }

    // Environment
    drawTree(3, 4); drawTree(4, 18); drawTree(12, 5); drawTree(18, 3);
    drawGoldMine(10, 10); drawGoldMine(2, 12);

    // Draw Structures (Static)
    drawStructure(5, 5, 'towncenter', '#FFD700');
    drawStructure(14, 14, 'market', '#32CD32');
    drawStructure(8, 12, 'university', '#00D4FF');

    // Depth Sorting for Agents
    agents.sort((a, b) => (a.tx + a.ty) - (b.tx + b.ty));

    agents.forEach(a => {
        a.update();
        a.draw();
    });

    requestAnimationFrame(loop);
};

const HABITAT_AGENTS = [
    "Revenue-Soul", "Content-Factory", "Traffic-Soul", "Automation-Soul", "Djinie",
    "Deerg-Bot", "Doctor-Buht-Buht", "Library-Updater", "Bot-Commander", "Link-Checker"
];

agents = HABITAT_AGENTS.map((name, i) => new Agent(name, "agent", i));
addLog("ISOMETRIC ENGINE ONLINE.");
loop();
