# Telegram 訊息範本

## 📌 基本設定
環境變數已配置在 `/Volumes/MAX/agent/.env`：
- `TELEGRAM_BOT_TOKEN`: Telegram Bot Token
- `TELEGRAM_CHAT_ID`: Telegram Chat ID
- `TELEGRAM_MIN_INTERVAL`: 最少間隔秒數（選用，預設 1 秒）

> 註：`LOCK_FILE`、`QUEUE_FILE`、`LAST_NOTIFY_FILE` 為腳本內部設定，**不需要**寫入 `.env`。

## 📌 推薦使用方式

### 🛡️ 佇列式安全腳本（推薦）
```bash
# 使用佇列腳本發送通知（避免通知被略過）
/Volumes/MAX/agent/personal/scripts/safe-telegram-notify.sh "✅ [caster-web] 任務完成
- 完成內容: 修改登入頁面樣式
- 開始時間: 14:30
- 完成時間: 14:45"
```

### ⚠️ 直接 curl（小心程式錯誤造成刷屏）
```bash
# 基本格式（無防護機制，小心程式 bug 造成死亡迴圈）
curl -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  -d "chat_id=${TELEGRAM_CHAT_ID}" \
  --data-urlencode "text=✅ [caster-web] 任務完成\n- 完成內容: 修改登入頁面樣式\n- 開始時間: 14:30\n- 完成時間: 14:45"
```

## 📌 通知類型與快速範本

## 📌 可用變數
- `{{STATUS_ICON}}`: 狀態圖示（🚀/✅/❌）
- `{{PROJECTS}}`: 專案名稱（可多個）
- `{{TASK}}`: 任務描述
- `{{SUBTASKS}}`: 子項目文字（可留空）
- `{{START_TIME}}`: 開始時間（HH:MM）
- `{{END_TIME}}`: 完成時間（HH:MM）
- `{{ESTIMATED_DURATION}}`: 預估用時（HH:MM 或文字）
- `{{DURATION}}`: 實際用時（HH:MM）
- `{{RESULT}}`: 執行結果文字

### 1) 開始通知（含子項目清單）
```
{{STATUS_ICON}} [{{PROJECTS}}] 開始通知
{{TASK}}
{{SUBTASKS}}
預計總用時: {{ESTIMATED_DURATION}} | 開始時間: {{START_TIME}}
```

### 2) 進度通知（含進度與下一步）
```
☑️ [專案名稱] 進度通知
任務名稱/目標
  ☑️ 子項目 A
  ⏭️ 子項目 B（預計用時: 00:45）
  ⬜ 子項目 C
子項目 A 完成用時: 00:30 | 完成時間: YYYY-MM-DD HH:MM
```

### 3) 完成通知（含子項目與用時）
```
{{STATUS_ICON}} [{{PROJECTS}}] 完成通知
{{TASK}}
{{SUBTASKS}}
執行結果: {{RESULT}}
總用時: {{DURATION}} | 完成時間: {{END_TIME}}
```

### 4) 錯誤通知（含完成/剩餘）
```
❌ [專案名稱] 錯誤通知
任務名稱/目標
  ☑️ 子項目 A
  ❌ 子項目 B
  ⬜ 子項目 C
錯誤原因: 具體問題描述
錯誤時間: YYYY-MM-DD HH:MM
```

### Claude 通知（可直接套用上方格式）
```bash
/Volumes/MAX/agent/personal/scripts/safe-telegram-notify.sh "✅ [project-name] 主任務完成
- 子項目: 子項目 A、子項目 B
- 總用時: 01:20
- 完成時間: HH:MM"
```

## 📌 通知格式說明

### 訊息結構
```
✅ [專案名稱] 任務完成/受阻
- 完成內容: 具體做了什麼
- 開始時間: HH:MM
- 完成時間: HH:MM
```

### 專案名稱代碼
- `[caster-web]` - 後台前端
- `[s8-agent]` - 後台後端、後台 MVC

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

> ⚠️ 建議將 Telegram Token/Chat ID 設為環境變數，避免泄漏
