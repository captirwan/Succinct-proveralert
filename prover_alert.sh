#!/bin/bash

BOT_TOKEN="your_bot_token_here"
CHAT_ID="your_chat_id_here"

LOG_FILE="$HOME/prover.log"
COUNT_FILE="$HOME/.fulfilled_count"
LOCK_FILE="/tmp/prover_alert.lock"

send_telegram() {
  curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage"     -d chat_id="$CHAT_ID"     -d text="$1" >/dev/null 2>&1
}

if [ -f "$LOCK_FILE" ]; then
  echo "Script already running. Exiting."
  exit 1
fi

touch "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

echo 0 > "$COUNT_FILE"

watch_log() {
  LAST_LINE=""
  tail -n 0 -F "$LOG_FILE" | while read -r line; do
    if echo "$line" | grep -q "Proof fulfillment submitted"; then
      if [[ "$line" == "$LAST_LINE" ]]; then
        continue
      fi
      LAST_LINE="$line"
      TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
      send_telegram "🎯 Proof fulfillment submitted!
🕒 $TIMESTAMP"

      COUNT=$(cat "$COUNT_FILE")
      COUNT=$((COUNT + 1))
      echo "$COUNT" > "$COUNT_FILE"
    fi
  done
}

hourly_summary() {
  while true; do
    sleep 3600
    CURRENT=$(cat "$COUNT_FILE")
    JAM=$(date '+%H:%M')
    send_telegram "📊 Summary @ $JAM
⏱️ Last 60 minutes: $CURRENT proof(s)"
    echo 0 > "$COUNT_FILE"
  done
}

watch_log &
hourly_summary &
wait
