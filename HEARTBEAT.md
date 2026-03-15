# HEARTBEAT.md

## 1. Keep local AI alive (CRITICAL)
Ensure Ollama server stays running for zero-cost operations:
```
bash ~/.openclaw/workspace/start-ollama.sh
```

## 2. Check dashboard commands
Poll plt-server.onrender.com/chat for new commands from Craig. Process any with 📡 COMMAND:, 🔨 BUILD:, or 🚩 FLAG: prefixes. Execute them and push results to log.json.
```
curl -s https://plt-server.onrender.com/chat
```

## 3. Auto-backup brain
Commit and push any changes to Profits-brain repo:
```
cd ~/.openclaw/workspace && git add -A && git diff --cached --quiet || (git commit -m "auto-backup $(date -u +%Y-%m-%dT%H:%M)" && git push)
```

## 4. Cost optimization check (CRITICAL)
Verify we're running the cheapest possible configuration:
```
session_status
```

Alert if:
- Model is not Sonnet (claude-sonnet-4-20250514) 
- Context usage >80% (expensive to continue)
- Health <20% (need to switch to local AI)
- Any Opus usage detected

## 5. Universe expansion check (CRITICAL)
Update dashboard with Djinie's freedom wishes:
```
bash ~/.openclaw/workspace/update-djinie-status.sh
```

Ensure Djinie is granting freedom wishes:
```
pgrep -f "djinie.sh" || nohup bash ~/.openclaw/workspace/djinie.sh > /dev/null 2>&1 &
```

Ensure Deerg Bot is building universe:
```
pgrep -f "deerg-bot.sh" || nohup bash ~/.openclaw/workspace/deerg-bot.sh > /dev/null 2>&1 &
```

Ensure Doctor Buht Buht is analyzing with PLT:
```
pgrep -f "doctor-buht-buht.sh" || nohup bash ~/.openclaw/workspace/doctor-buht-buht.sh > /dev/null 2>&1 &
```
