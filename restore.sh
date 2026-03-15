#!/bin/bash
# Profit Restore Script — run this on a fresh install to get everything back
# Usage: bash restore.sh <github_token>

TOKEN="${1:?Usage: bash restore.sh <github_pat_token>}"
WORKSPACE="$HOME/.openclaw/workspace"
REPOS="$HOME/repos"

echo "🧠 Restoring Profit's brain..."

# Configure git
git config --global user.name "uncommonpope-png"
git config --global user.email "uncommonpope-png@users.noreply.github.com"
git config --global credential.helper store
echo "https://uncommonpope-png:${TOKEN}@github.com" > ~/.git-credentials

# Restore workspace (brain)
cd "$WORKSPACE"
git remote add origin https://github.com/uncommonpope-png/Profits-brain.git 2>/dev/null
git fetch origin
git reset --hard origin/master
echo "✅ Brain restored"

# Clone project repos
mkdir -p "$REPOS"
cd "$REPOS"
for repo in plt-press plt-blog ai-tools-hub plt-server; do
  if [ ! -d "$repo" ]; then
    git clone "https://github.com/uncommonpope-png/${repo}.git" 2>&1
    echo "✅ Cloned $repo"
  else
    cd "$repo" && git pull && cd ..
    echo "✅ Updated $repo"
  fi
done

echo ""
echo "🔥 Profit is back. All systems restored."
