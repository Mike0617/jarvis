# Telegram 訊息範本

環境變數請設定於 `${AGENT_ROOT}/.env`：
- `TELEGRAM_BOT_TOKEN`
- `TELEGRAM_CHAT_ID`
- `TELEGRAM_MIN_INTERVAL`

## 推薦使用方式
```bash
${AGENT_ROOT}/personal/scripts/safe-telegram-notify.sh "✅ [專案名稱] 任務完成"
```

## 可用變數
- `{{STATUS_ICON}}`
- `{{PROJECTS}}`
- `{{TASK}}`
- `{{SUBTASKS}}`
- `{{START_TIME}}`
- `{{END_TIME}}`
- `{{DURATION}}`
- `{{RESULT}}`

### 1) 開始通知
```
{{STATUS_ICON}} [{{PROJECTS}}] 開始通知
{{TASK}}
{{SUBTASKS}}
開始時間: {{START_TIME}}
```

### 2) 進度通知
```
☑️ [專案名稱] 進度通知
任務名稱/目標
  ☑️ 子項目 A
  ⏭️ 子項目 B（預計用時: 00:45）
  ⬜ 子項目 C
子項目 A 完成用時: 00:30 | 完成時間: YYYY-MM-DD HH:MM
```

### 3) 完成通知
```
{{STATUS_ICON}} [{{PROJECTS}}] 完成通知
{{TASK}}
{{SUBTASKS}}
執行結果: {{RESULT}}
總用時: {{DURATION}} | 完成時間: {{END_TIME}}
```

### 4) 錯誤通知
```
❌ [專案名稱] 錯誤通知
任務名稱/目標
  ☑️ 子項目 A
  ❌ 子項目 B
  ⬜ 子項目 C
錯誤原因: 具體問題描述
錯誤時間: YYYY-MM-DD HH:MM
```

### 5) 結果通知（固定格式）
```
✅ [專案名稱] 完成通知
- 任務: 任務描述
- 結果: 最終結論或處理結果
- 依據: 檔案/路由/紀錄等依據
- 完成時間: HH:MM
```
