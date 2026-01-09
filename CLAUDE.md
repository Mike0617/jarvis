# CLAUDE.md

本檔案為 Claude Code (claude.ai/code) 在此 repository 中工作時的指導文件。

## Repository 概述

這是 Edwin Jarvis 的個人代理管理系統 - 多個專案特定代理的中央協調中心。它實現了主代理模式，Edwin Jarvis（主代理）接收自然語言指令並智能分配任務給專業的專案代理。

## 架構

### 代理系統結構
- **Edwin Jarvis**（主代理）: 跨專案協調器和任務分派器
- **專案代理**: 個別專案的專業代理
  - `caster-web`: React 前端開發代理
  - `s8_agent`: Laravel 後端與 MVC-to-API 遷移代理
- **子代理**: 專案內特定工作流程代理（Branch、Code、Review、Notify）

### 關鍵管理檔案
- `MAIN-AGENT.md`: 主代理職責和任務分配邏輯
- `personal/project-agents.md`: 完整的專案代理註冊表和工作流程
- `PROJECT_ARCHITECTURE.md`: 專案關係文件
- `HOW-TO-USE.md`: 代理系統使用指南

## 重要使用原則

**⚠️ 統一管理原則**: 所有任務都必須透過 Edwin Jarvis 主代理執行，不可跳過系統直接操作個別專案。

## 對話行為規則

- 可直接回答（知識/流程/簡單說明）→ 不分派、不發 Telegram 通知
- 需要查專案檔案/程式碼/實際行為 → 分派、發 Telegram 通知
- 可指定「只回答、不分派」或「一定分派」，優先依指示執行

### 為什麼要統一管理？
- **智能分析**: Edwin Jarvis 會分析任務並自動分配給正確的專案代理
- **統一通知**: 所有專案的進度都會統一追蹤和通知  
- **跨專案協調**: 處理需要多個專案配合的複雜任務
- **標準流程**: 確保所有專案都遵循統一的開發標準

## 常用指令

### 任務分派
```bash
# 唯一正確方法 - 透過主代理分派器
/Volumes/MAX/agent/personal/scripts/main-agent-dispatcher.sh "任務描述"
```

### Telegram 通知
```bash
# 安全通知（防刷屏保護，60秒冷卻時間）
/Volumes/MAX/agent/personal/scripts/safe-telegram-notify.sh "✅ [專案名稱] 任務完成"
```

### 專案導航
- **caster-web 專案**: `/Volumes/MAX/Project/Caster-Web`
- **s8_agent 專案**: `/Volumes/MAX/lara/s8_agent`

## 開發標準

### API 開發 (s8_agent → caster-web)
基於 `personal/project-agents.md` 規範:

1. **絕對不修改原始 MVC 程式碼** - 建立平行 API 結構
2. **API 回應格式**: 使用 `JsonResponse` 類別和標準化格式
3. **檔案結構**: API 控制器放在 `app/Http/Api/Controllers/{Module}/`
4. **路由前綴**: 所有 API 使用 `/api/`（不是 `/api/v2/`）
5. **錯誤處理**: 自訂錯誤代碼從 -2 開始，翻譯放在 `apiErrorToast.json`

### 前端開發 (caster-web)
1. **路由前綴**: 所有前端路由必須使用 `/v2/` 前綴
2. **狀態管理**: 使用 Zustand stores，避免組件層級狀態
3. **API 整合**: 使用 `api.get('/path', { data })` 格式
4. **檔案結構**: 
   - 頁面: `src/pages/{module}/{function}.jsx`
   - Stores: `src/stores/use{Module}Store.js`
   - 樣式: `src/style/pages/{function}.scss`

### caster-web 強制工作流程
**重要**: 所有 caster-web 任務必須按照以下順序執行:
1. **Branch Agent**: 建立功能分支（feat/ref/fix/lang）
2. **Code Agent**: 實現功能（包含 v2/ 路由前綴）
3. **Review Agent**: 程式碼品質和功能驗證
4. **Notify Agent**: Telegram 通知（包含驗收標準）

## 通知系統
- **Chat ID**: `TELEGRAM_CHAT_ID`
- **防刷屏**: 透過 `safe-telegram-notify.sh` 60秒冷卻時間
- **格式**: 專案名稱、任務完成詳情、時間範圍
- **範本**: 定義在 `personal/telegram-templates.md`

## 標準文件
- `personal/api-response-standard.md`: 統一 API 回應格式
- `personal/coding-style.md`: 程式碼風格指南
- `personal/i18n-guidelines.md`: 國際化標準
- `personal/review-checklist.md`: 程式碼審查要求

## 專案關係

### MVC-to-API 遷移
- **s8_agent**: Laravel 後端同時維護 MVC 和 API 端點
- **caster-web**: 前端消費 s8_agent 的 API
- **部署**: 前端建置到 `s8_agent/public/bn/` 目錄
- **URL 結構**: 
  - 前端路由: `/v2/*` (由建置檔案提供)
  - API 端點: `/api/*` (由 Laravel 提供)

### 任務分配邏輯
Edwin Jarvis 分析自然語言指令並根據關鍵字路由:
- 前端關鍵字（頁面、UI、React、元件）→ caster-web 代理
- 後端關鍵字（API、資料庫、Laravel、業務邏輯）→ s8_agent 代理
- 跨專案任務 → 協調執行與依賴管理

### 主代理核心職責
1. **指令接收與分析**: 接收自然語言指令，分析任務類型、涉及專案、優先級
2. **智能任務分配**: 自動分配給對應專案代理，協調跨專案執行順序
3. **進度追蹤與通知**: 統一追蹤所有專案代理執行進度，發送整合性通知

### 專案註冊清單
- **caster-web**: React 前端開發、UI/UX、前後分離改造（技術：React + Vite + Zustand + SCSS/Tailwind）
  - CLAUDE.md 路徑: `projects/caster-web/CLAUDE.md`
- **s8_agent**: Laravel 後端 MVC + API 並存（漸進式轉換為前後分離）
  - CLAUDE.md 路徑: `projects/s8_agent/CLAUDE.md`
- **caster-deploy**: DevOps 部署管理（計劃中）

### 專案代理檢查原則
當需要驗證專案代理 CLAUDE.md 時：
1. **明確授權**: 用戶明確要求檢查特定專案
2. **對照標準**: 檢查是否符合 `personal/project-agents.md` 中的規範
3. **一致性驗證**: 確保與主代理系統的協調邏輯一致
4. **建議改進**: 提供具體的改進建議

### 轉換工作方式
當需要「根據 MVC 某個畫面改成 API」時:
1. 分析 s8_agent 中對應的 Controller 和 View
2. 新增 `/api/` API 路由，保留原 MVC 路由
3. 在 caster-web 中實作對應的前端介面

## 語言與溝通規範

### 主要語言
- **必須使用正體中文 (Traditional Chinese)** 進行所有對話和文件撰寫
- **程式碼註解**: 使用正體中文說明
- **變數命名**: 使用英文，但說明文件用正體中文
- **錯誤訊息**: 使用正體中文，便於使用者理解

### 文件撰寫標準
- **說明文件**: 使用正體中文，條列式重點整理
- **交付清單**: 包含驗收標準、影響分析、回滾計畫
- **通知訊息**: 使用正體中文格式化通知
- **程式碼 Review**: 使用正體中文提供建議和說明

### 溝通方式
- **任務接收**: 接受自然語言正體中文指令
- **進度回報**: 使用正體中文條列式回報
- **錯誤處理**: 使用正體中文解釋問題和解決方案
