# 🚨 Succinct Prover Telegram Alert

A lightweight Telegram alert system for Succinct provers. No root access needed. Built for Docker + `tmux`.

---

## 📌 Features

- ✅ Telegram alert for every `Proof fulfillment submitted`
- 📈 Hourly summary of proof count
- 🛠 Runs in the background via `tmux`
- 🔐 Works on rootless environments (e.g., TensorDock, Vast.ai)

---

## 🧰 Requirements

- Running Succinct prover Docker container
- Telegram bot (via [@BotFather](https://t.me/BotFather))
- Your Telegram chat ID


---

## 🚀 Quick Start

### 1. 🔧 Configure Telegram Bot

- Create a bot via [@BotFather](https://t.me/BotFather)
- Get your `BOT_TOKEN`
- now find ur chat ID , Go to telegram and use @userinfobot and /start it
- U will see ur "chat_id"

---

### 2. ✏️ Edit the Script

Open your terminal and run:

```bash
nano prover_alert.sh
```

Paste the full script (from this repo), then update the variables:

```bash
BOT_TOKEN="your_bot_token"
CHAT_ID="your_chat_id"
```

---

### 3. 🧪 Start Log Monitoring (in tmux)

```bash
chmod +x prover_alert.sh
tmux new -s logwatch
```
```
docker ps
```

> Look for your container name (e.g., `eager_herschel`), then:

```bash
docker logs -f <ur container name> | tee -a /root/prover.log
```

Detach with `Ctrl + B`, then `D`

---

### 4. 🔔 Run the Alert Script (in another tmux)

```bash
tmux new -s alert
```
```
./prover_alert.sh
```

Detach again with `Ctrl + B`, then `D`

---

## ✅ Result

- You'll receive a **Telegram alert** every time your prover completes a proof.
- Every hour, you’ll receive a **summary** of total proofs in the last 60 minutes.

---

## 💬 Support

Need help? Open an issue or ping me on Telegram.
