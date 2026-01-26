#!/bin/bash

# Safe Telegram Notification Script
# 防止刷屏機制的 Telegram 通知腳本

# 載入環境變數（支援集中管理路徑）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_ROOT_DEFAULT="$(cd "$SCRIPT_DIR/../.." && pwd)"
ENV_FILE="$AGENT_ROOT_DEFAULT/.env"
if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
fi

# 基本設定（從環境變數讀取）
BOT_TOKEN="${TELEGRAM_BOT_TOKEN}"
CHAT_ID="${TELEGRAM_CHAT_ID}"

# 檢查必要的環境變數
if [ -z "$BOT_TOKEN" ] || [ -z "$CHAT_ID" ]; then
    echo "❌ 錯誤: 未設定 TELEGRAM_BOT_TOKEN 或 TELEGRAM_CHAT_ID 環境變數"
    echo "請在 $ENV_FILE 中設定"
    exit 1
fi

# 佇列設定（避免通知被略過）
LOCK_FILE="/tmp/telegram_notify_lock"
QUEUE_FILE="/tmp/telegram_notify_queue"
LAST_NOTIFY_FILE="/tmp/last_telegram_notify"
MIN_INTERVAL="${TELEGRAM_MIN_INTERVAL:-1}"  # 最少間隔 1 秒，避免太密集

# 輸入參數
MESSAGE="$1"
if [ -z "$MESSAGE" ]; then
    echo "❌ 使用方式: $0 \"通知訊息\""
    exit 1
fi

# 先寫入佇列，避免通知被跳過（用 base64 保留多行）
ENCODED_MESSAGE=$(printf '%s' "$MESSAGE" | base64 | tr -d '\n')
echo "$ENCODED_MESSAGE" >> "$QUEUE_FILE"

# 檢查並創建鎖文件（防止同時執行）
if [ -f "$LOCK_FILE" ]; then
    echo "🔒 另一個通知正在發送中，已加入佇列"
    exit 0
fi

# 創建鎖文件
touch "$LOCK_FILE"

# 依序處理佇列
API_URL="https://api.telegram.org/bot${BOT_TOKEN}/sendMessage"
while [ -s "$QUEUE_FILE" ]; do
    NEXT_MESSAGE_ENC=$(sed -n '1p' "$QUEUE_FILE")
    if [ -z "$NEXT_MESSAGE_ENC" ]; then
        break
    fi
    NEXT_MESSAGE=$(printf '%s' "$NEXT_MESSAGE_ENC" | base64 -D)

    echo "📤 發送 Telegram 通知..."
    RESPONSE=$(curl -s -X POST "$API_URL" \
        -d "chat_id=${CHAT_ID}" \
        --data-urlencode "text=${NEXT_MESSAGE}")

    # 檢查發送結果
    if echo "$RESPONSE" | grep -q "\"ok\":true"; then
        echo "✅ Telegram 通知發送成功"
        echo $(date +%s) > "$LAST_NOTIFY_FILE"
    else
        echo "❌ Telegram 通知發送失敗: $RESPONSE"
    fi

    # 移除已處理訊息
    tail -n +2 "$QUEUE_FILE" > "${QUEUE_FILE}.tmp" && mv "${QUEUE_FILE}.tmp" "$QUEUE_FILE"

    # 最少間隔，避免太密集
    if [ -f "$LAST_NOTIFY_FILE" ]; then
        LAST_TIME=$(cat "$LAST_NOTIFY_FILE")
        CURRENT_TIME=$(date +%s)
        TIME_DIFF=$((CURRENT_TIME - LAST_TIME))
        if [ "$TIME_DIFF" -lt "$MIN_INTERVAL" ]; then
            REMAINING=$((MIN_INTERVAL - TIME_DIFF))
            sleep "$REMAINING"
        fi
    fi
done

# 清除鎖文件
rm -f "$LOCK_FILE"
