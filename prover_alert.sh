#!/bin/bash

# === TELEGRAM CONFIG ===
BOT_TOKEN="YOUR_BOT_TOKEN"
CHAT_ID="ur chat id"

LOG_FILE="/root/prover.log"
COUNT_FILE="/root/.fulfilled_count"

# === FUNCTION: Kirim ke Telegram ===
send_telegram() {
  MESSAGE="$1"
  curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
    -d chat_id="$CHAT_ID" \
    -d text="$MESSAGE" \
    -d parse_mode="HTML" >/dev/null 2>&1
}

# === INIT COUNTER ===
echo 0 > "$COUNT_FILE"

# === FUNCTION: Pantau log ===
watch_log() {
  tail -n 0 -F "$LOG_FILE" | while read -r line; do
    if echo "$line" | grep -q "Proof fulfillment submitted"; then
      TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
      send_telegram "🎯 <b>Proof fulfillment submitted</b>\n🕒 $TIMESTAMP\n<code>${line}</code>"

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
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
    send_telegram "📊 <b>Hourly Summary</b>\n🕒 $TIMESTAMP\n✅ Proofs submitted: <b>$CURRENT</b>"
    echo 0 > "$COUNT_FILE"
  done
}

# === JALANKAN KEDUANYA SECARA PARALEL ===
watch_log &
hourly_summary &
wait
