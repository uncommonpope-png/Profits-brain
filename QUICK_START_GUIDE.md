# 🚀 PLT QUICK START GUIDE: HOW TO RUN YOUR EMPIRE

Craig, the ecosystem is refactored, standardized, and ready for action. Here is how you use the tools I've prepared.

## 1. 🕹️ THE COMMAND CENTER (Automation)
Launch the entire business engine with one command. This starts email sequences, social posting, and the dashboards.

```bash
./plt-automation-master.sh start
```
*   **Check status**: `./plt-automation-master.sh status`
*   **Open Dashboard**: Open `plt-automation-dashboard.html` in your browser.

## 2. 💀 THE SOUL MASTER (24/7 Uptime)
To ensure all your "souls" (bots and updaters) never stop running, start the master orchestrator:

```bash
nohup ./live-soul-master.sh > live-soul-master.log 2>&1 &
```
This runs in the background and auto-restarts any bot that crashes.

## 3. 🤖 TALK TO YOUR SOUL (Telegram Bot)
Interact with the engine's memory and run commands from your phone.
1. Set your token: `export TELEGRAM_TOKEN="your_token_here"`
2. Start the bot:
```bash
python3 telegram_bot.py
```

## 4. 🏗️ INDEPENDENT BUILDING (Autonomous Builder)
If you want the system to keep creating new SEO pages and blog posts while you sleep:

```bash
nohup ./autonomous-builder.sh > autonomous-builder.log 2>&1 &
```

## 5. 🏥 HEALTH & MONITORING
Check if everything is online and working correctly:

```bash
./health-check.sh
cat health-check.log
```

## 6. 📊 DASHBOARDS (Visual HQ)
Open these files in any browser to see your empire's status:
- **Pyramid City HQ**: `pyramid-city.html` (Manage your AI agent souls)
- **Revenue Command**: `revenue-dashboard.html` (Track your profit funnels)
- **Soul Chat Hub**: `soul-chat-hub.html` (Talk to all agents at once)

---
**Remember**: Every action must feed the PLT equation.
`SOUL_PROFIT = PROFIT + LOVE - TAX`

*Go build the future.* 💰
