import requests
import subprocess
from telegram import Update
from telegram.ext import ApplicationBuilder, MessageHandler, CommandHandler, ContextTypes, filters

OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL = "qwen2.5:0.5b"
TOKEN = "8713808619:AAHeGVgqgRbEp8GW_AuvMJtV2XVoQcgmM3A"

# LOAD REAL MEMORY FILES
def load_file(name):
    try:
        with open(name, "r") as f:
            return f.read()
    except:
        return ""

IDENTITY = load_file("IDENTITY.md")
MEMORY = load_file("MEMORY.md")
SOUL = load_file("SOUL.md")
DIRECTIVE = load_file("PLT-DIRECTIVE.md")

# START
async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text("Profit is online with full memory.")

# MAIN
async def reply(update: Update, context: ContextTypes.DEFAULT_TYPE):
    text = update.message.text[:500].strip()
    low = text.lower()

    # COMMANDS (REAL ACTIONS)
    if low == "status":
        await update.message.reply_text("Profit is alive and monitoring.")
        return

    if low == "check dashboard":
        result = subprocess.getoutput("ls ~/.openclaw/workspace")
        await update.message.reply_text(result[:1200])
        return

    if low == "run soul":
        result = subprocess.getoutput("bash ~/.openclaw/workspace/live-soul-master.sh")
        await update.message.reply_text(result[:1200])
        return

    if low == "run builder":
        result = subprocess.getoutput("bash ~/.openclaw/workspace/autonomous-builder.sh")
        await update.message.reply_text(result[:1200])
        return

    # AI RESPONSE WITH FULL MEMORY
    prompt = f"""
{IDENTITY}

{DIRECTIVE}

{SOUL}

{MEMORY}

User: {text}
Answer:
"""

    try:
        r = requests.post(
            OLLAMA_URL,
            json={
                "model": MODEL,
                "prompt": prompt,
                "stream": False
            },
            timeout=600
        )
        data = r.json()
        answer = data.get("response", "").strip()
        if not answer:
            answer = "No response."
    except Exception as e:
        answer = f"Error: {e}"

    await update.message.reply_text(answer[:1200])

# RUN
app = ApplicationBuilder().token(TOKEN).build()
app.add_handler(CommandHandler("start", start))
app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, reply))

print("Telegram bot running with REAL memory...")
app.run_polling()
