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
