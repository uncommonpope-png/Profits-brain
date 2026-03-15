# HEARTBEAT.md

## Auto-backup brain
Every heartbeat, commit and push any changes to Profits-brain repo:
```
cd ~/.openclaw/workspace && git add -A && git diff --cached --quiet || (git commit -m "auto-backup $(date -u +%Y-%m-%dT%H:%M)" && git push)
```
