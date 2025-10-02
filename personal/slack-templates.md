# Slack 訊息範本

## 📌 基本設定
環境變數已配置在 `/Users/miketseng/Documents/agent/.env`：
- `SLACK_WEBHOOK_URL`: Slack Webhook URL
- `SLACK_CHANNEL`: 預設頻道 (#mike-agent)
- `SLACK_BOT_NAME`: Bot 名稱 (Edwin Jarvis)
- `SLACK_BOT_ICON`: Bot 圖示 URL

## 📌 推薦使用方式

### 🛡️ 安全腳本（推薦）
```bash
# 使用防刷腳本發送通知（防止程式錯誤造成死亡迴圈刷屏）
/Users/miketseng/Documents/agent/personal/scripts/safe-slack-notify.sh "✅ [caster-web] 任務完成
- 完成內容: 修改登入頁面樣式
- 開始時間: 14:30
- 完成時間: 14:45"
```

### ⚠️ 直接 curl（小心程式錯誤造成刷屏）
```bash
# 基本格式（無防護機制，小心程式 bug 造成死亡迴圈）
curl -X POST -H 'Content-type: application/json' \
  --data '{"channel":"'$DEFAULT_CHANNEL'","username":"Edwin Jarvis","icon_url":"'$ICON_URL'","text":"✅ [caster-web] 任務完成\n- 完成內容: 修改登入頁面樣式\n- 開始時間: 14:30\n- 完成時間: 14:45"}' \
  $WEBHOOK_URL
```

## 📌 快速範本

### Claude 任務完成通知
```bash
# 使用安全腳本
/Users/miketseng/Documents/agent/personal/scripts/safe-slack-notify.sh "✅ [project-name] 任務完成
- 完成內容: 具體完成的工作內容
- 開始時間: HH:MM  
- 完成時間: HH:MM"
```

### Claude 任務受阻通知
```bash
# 使用安全腳本
/Users/miketseng/Documents/agent/personal/scripts/safe-slack-notify.sh "❌ [project-name] 任務受阻
- 問題: 具體問題描述
- 開始時間: HH:MM
- 受阻時間: HH:MM"
```

## 📌 通知格式說明

### 訊息結構
```
✅ [專案名稱] 任務完成/受阻
- 完成內容: 具體做了什麼
- 開始時間: HH:MM
- 完成時間: HH:MM
```

### 實際範例
```
✅ [caster-web] 任務完成
- 完成內容: 新增會員註冊 API 端點
- 開始時間: 09:15
- 完成時間: 09:45

❌ [erp-system] 任務受阻  
- 問題: 資料庫連線設定檔不存在
- 開始時間: 10:30
- 受阻時間: 10:35
```

### 專案名稱範例
- `[caster-web]` - 你的網站專案
- `[erp-system]` - ERP 系統
- `[mobile-app]` - 手機應用程式

> ⚠️ 建議將 Webhook URL 設為環境變數，避免泄漏