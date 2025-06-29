#!/bin/bash

# === TELEGRAM CONFIG ===
BOT_TOKEN="your_bot_token_here"
CHAT_ID="your_chat_id_here"

LOG_FILE="/root/prover.log"
COUNT_FILE="/root/.fulfilled_count"

send_telegram() {
  MESSAGE="$1"
  curl -s -X POST "https://api.telegram.org/bot$BO>
    -d chat_id="$CHAT_ID" \
    -d text="$MESSAGE" >/dev/null 2>&1
}

# === INIT COUNTER ===
echo 0 > "$COUNT_FILE"

# === FUNCTION: Start log watcher ===
watch_log() {
  tail -n 0 -F "$LOG_FILE" | while read -r line; do
    if echo "$line" | grep -q "Proof fulfillment s>
      TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
      send_telegram "🎯 Proof fulfillment submitte>

      # Tambah counter
      COUNT=$(cat "$COUNT_FILE")
      COUNT=$((COUNT + 1))
      echo "$COUNT" > "$COUNT_FILE"
    fi
  done
}

# === FUNCTION: Kirim summary per jam ===
hourly_summary() {
  while true; do
    sleep 3600
    CURRENT=$(cat "$COUNT_FILE")
    send_telegram "📊 Summary @ $(date '+%H:%M')\n>
    echo 0 > "$COUNT_FILE"
  done
}

# === JALANKAN KEDUANYA SECARA PARALEL ===
watch_log &
hourly_summary &
wait
