#!/bin/bash

# Safe Slack Notification Script
# 防止刷屏機制的 Slack 通知腳本

# 載入環境變數
if [ -f "/Volumes/MAX/agent/.env" ]; then
    export $(cat "/Volumes/MAX/agent/.env" | grep -v '^#' | xargs)
fi

# 基本設定（從環境變數讀取）
WEBHOOK_URL="${SLACK_WEBHOOK_URL}"
DEFAULT_CHANNEL="${SLACK_CHANNEL:-#mike-agent}"
BOT_NAME="${SLACK_BOT_NAME:-Edwin Jarvis}"
ICON_URL="${SLACK_BOT_ICON:-https://i.imgur.com/oNZ4Z8p.png}"

# 檢查必要的環境變數
if [ -z "$WEBHOOK_URL" ]; then
    echo "❌ 錯誤: 未設定 SLACK_WEBHOOK_URL 環境變數"
    echo "請在 /Volumes/MAX/agent/.env 中設定"
    exit 1
fi

# 防刷設定
LOCK_FILE="/tmp/slack_notify_lock"
LAST_NOTIFY_FILE="/tmp/last_slack_notify"
MIN_INTERVAL=60  # 最少間隔 60 秒

# 輸入參數
MESSAGE="$1"
if [ -z "$MESSAGE" ]; then
    echo "❌ 使用方式: $0 \"通知訊息\""
    exit 1
fi

# 檢查是否在冷卻期間
if [ -f "$LAST_NOTIFY_FILE" ]; then
    LAST_TIME=$(cat "$LAST_NOTIFY_FILE")
    CURRENT_TIME=$(date +%s)
    TIME_DIFF=$((CURRENT_TIME - LAST_TIME))
    
    if [ "$TIME_DIFF" -lt "$MIN_INTERVAL" ]; then
        REMAINING=$((MIN_INTERVAL - TIME_DIFF))
        echo "⏳ 通知冷卻中，還需等待 $REMAINING 秒"
        exit 0
    fi
fi

# 檢查並創建鎖文件（防止同時執行）
if [ -f "$LOCK_FILE" ]; then
    echo "🔒 另一個通知正在發送中，跳過此次通知"
    exit 0
fi

# 創建鎖文件
touch "$LOCK_FILE"

# 發送通知
echo "📤 發送 Slack 通知..."
RESPONSE=$(curl -s -X POST -H 'Content-type: application/json' \
    --data "{\"channel\":\"$DEFAULT_CHANNEL\",\"username\":\"$BOT_NAME\",\"icon_url\":\"$ICON_URL\",\"text\":\"$MESSAGE\"}" \
    "$WEBHOOK_URL")

# 檢查發送結果
if [ "$RESPONSE" = "ok" ]; then
    echo "✅ Slack 通知發送成功"
    echo $(date +%s) > "$LAST_NOTIFY_FILE"
else
    echo "❌ Slack 通知發送失敗: $RESPONSE"
fi

# 清除鎖文件
rm -f "$LOCK_FILE"
