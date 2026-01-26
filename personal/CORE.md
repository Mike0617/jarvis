# CORE 規範（唯一真實來源）

本文件是此系統的唯一規範來源。其他文件僅做入口或專案特例補充。

## 1) 統一管理原則
- **所有任務必須透過 Edwin Jarvis 主代理執行**，不可跳過主代理直接操作子專案。
- **只發送結果通知**，開始通知停用。

## 2) 任務分配邏輯
- 前端關鍵字（頁面、UI、React、元件）→ `caster-web`
- 後端關鍵字（API、資料庫、Laravel、業務邏輯）→ `s8_agent`
- 跨專案 → 主代理協調執行與依賴順序

### 跨專案判斷規則（摘要）
- 同時包含「畫面/UI」與「API/資料庫」 → 跨專案
- 需求明確點名兩個專案 → 跨專案
- 需要前端對接後端新 API → 跨專案（先後端、再前端）
- 無法判斷歸屬 → 預設分派給 `caster-web`，並提示是否需後端協作

## 3) 路徑與環境變數
所有路徑統一由 `.env` 管理：
- `AGENT_ROOT`
- `CASTER_WEB_PATH`
- `S8_AGENT_PATH`

## 4) 通知規範
- 使用 `${AGENT_ROOT}/personal/scripts/safe-telegram-notify.sh`
- 僅發送「結果通知」，內容需包含：任務、結果、依據、完成時間
- **有派發就必須發通知**（成功或失敗）
- 未派發任務（主代理自行處理）預設不發通知；除非用戶明確要求

### 通知範本（結果通知）
```
✅ [專案名稱] 完成通知
- 任務: 任務描述
- 結果: 最終結論或處理結果
- 依據: 檔案/路由/紀錄等依據
- 完成時間: YYYY-MM-DD HH:MM
```

## 5) 專案規範來源
- 專案特定規範請參考 `projects/*/CLAUDE.md`

## 6) 通用細節文件
- API 回應標準：`personal/details/api-response-standard.md`
- 程式碼風格：`personal/details/coding-style.md`
- i18n 規範：`personal/details/i18n-guidelines.md`
- Review 清單：`personal/details/review-checklist.md`
- Telegram 範本：`personal/details/telegram-templates.md`

## 7) 文件優先序
1. `personal/CORE.md`
2. `personal/registry/project-agents.md`（專案註冊表）
3. `projects/*/CLAUDE.md`（專案特例）
4. 其他文件僅供入口與參考

## 8) 語言與溝通
- **必須使用正體中文**（包含文件與註解）
- 變數命名英文，說明文字正體中文
- 錯誤訊息使用正體中文
