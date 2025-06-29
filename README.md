# 🚨 Succinct Prover Telegram Alert

A lightweight Telegram alert system for Succinct provers. No root needed. Built for Docker + tmux.

## 📌 Features
- Telegram alert for every `Proof fulfillment submitted`
- Hourly summary of proof count
- Uses `tmux` and works fully in the background
- Rootless setup — safe for shared servers

## 🧰 Requirements
- A running Succinct prover Docker container
- A Telegram bot (via @BotFather)
- Your Telegram Chat ID
- Any Linux server

## 🚀 Quick Start

### 1. Configure Telegram Bot
- Create a bot via [@BotFather](https://t.me/BotFather)
- Get your `BOT_TOKEN`
- Send any message to your bot
- Then open this to get your chat ID:
  ```
  https://api.telegram.org/bot<BOT_TOKEN>/getUpdates
  ```

### 2. Edit the script
Open `prover_alert.sh` and update:
```
BOT_TOKEN="your_bot_token"
CHAT_ID="your_chat_id"
```

### 3. Run
```bash
chmod +x prover_alert.sh
tmux new -s logwatch
docker logs -f <your_container_name> 2>&1 | tee -a $HOME/prover.log
```

In a second tmux session:
```bash
tmux new -s alert
$HOME/succinct-prover-alert/prover_alert.sh
```
