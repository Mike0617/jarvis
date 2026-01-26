# Project Agents 管理表

本檔案用來登記所有專案代理人，Edwin Jarvis 可以根據這份清單調度專案代理人。
專案路徑以 `.env` 的路徑變數為準。

---
## 📌 caster-web 專案代理人
- **專案路徑**: ${CASTER_WEB_PATH}
- **代理人路徑**: ../projects/caster-web/
- **專案架構**: 前端專案 (React + Vite + Zustand + SCSS/Tailwind)
- **專案性質**: s8_agent 專案前後分離架構轉換的前端部分
- **用途**:
  - 前端專案開發與維護
  - 處理通知系統、RWD、i18n
  - 與 s8_agent API 介接
- **輸出重點**:
  - 元件驗收清單
  - UI/UX 測試要點
  - API 介接規格
- **通知**: 透過 `telegram-templates.md` 發送到 Telegram

### 🎨 前端開發標準流程

#### 📁 檔案結構標準
- **頁面組件**: `src/pages/{模組}/{功能}.jsx`
- **API 接口**: `src/api/{模組}.js`
- **狀態管理**: `src/stores/use{模組}Store.js`
- **樣式檔案**: `src/style/pages/{功能}.scss`
- **翻譯檔案**: `public/locales/zh-TW/{模組}.json`

#### 🔌 API 整合標準
- **API 調用格式**: `api.get('/path', { data })` (使用 data 而非 params)
- **錯誤處理**: 使用 `apiErrorToast(模組名, error)` 統一處理
- **載入狀態**: 使用 `useLoadingStore` 全域管理
- **狀態管理**: 使用 Zustand store，避免組件內部狀態

#### 🎯 組件開發原則
- **日期處理**: 建立 `formatDate()` 函數處理 PHP DateTime 物件
- **翻譯支援**: 使用 `useTranslation()` 和 `useTranslation('apiErrorToast')`
- **表單處理**: 使用受控組件，狀態存放在 store 中
- **預設值**: 重要篩選條件需要合理的預設值

#### 🛠️ 開發檢查清單
- [ ] 創建對應的 store 管理狀態
- [ ] 建立 API 接口並正確處理回應格式
- [ ] 加入錯誤翻譯到 `apiErrorToast.json`
- [ ] 處理載入和錯誤狀態
- [ ] 實作日期格式化和表格顯示
- [ ] 加入路由配置和權限檢查
- [ ] 測試各種操作和錯誤情況

---
## 📌 s8_agent 專案代理人
- **專案路徑**: ${S8_AGENT_PATH}
- **專案架構**: Laravel MVC + API 並存
- **專案性質**: MVC 與 API 雙軌運行，逐步轉換為前後分離架構
- **API 路徑規則**: 所有 API 路由都使用 `/api/` 前綴 (注意：`/v2/` 是前端路由，不是 API 路由)
- **部署架構**:
  - 前端 build 檔案部署至 `/public/bn/` 目錄，前端路由使用 `/v2/` 指向 build 檔案
  - 同時支援傳統 MVC 頁面和 API 服務
- **用途**:
  - Laravel 後端開發與維護
  - MVC 架構轉換為 API 架構 (漸進式)
  - 業務邏輯處理與資料庫操作
  - 前端靜態檔案服務
- **輸出重點**:
  - API 規格文件
  - 資料庫異動記錄
  - 業務邏輯測試結果
  - 部署腳本與前端 build 整合
- **對應前端**: caster-web 專案

### 🔧 MVC 轉 API 標準流程

當收到「轉 API」或「寫 API」指令時，必須按照以下檢查清單執行：

#### 🎯 核心原則
- **🚫 絕對不修改** 原 MVC 程式碼，保持完全並存
- **📋 直接複製邏輯**: API Controller 完全複製 MVC Controller 的業務邏輯
- **🔄 只調整回應**: 僅將 MVC 的 view 回應改為 JSON 回應格式  
- **📁 獨立檔案結構**: API 檔案完全獨立於 MVC，避免相互干擾
- **🛠️ 統一標準**: 使用 `JsonResponse` 類別和標準錯誤處理

#### 1. 檔案結構 ✅
- [ ] 建立模組資料夾結構 (如：`MemberManagement/`)
- [ ] Controller 放在 `app/Http/Api/Controllers/{模組}/`
- [ ] Request 放在 `app/Http/Api/Requests/{模組}/`
- [ ] 使用語意化命名 (如：`RegistrationReviewController`)

#### 2. API 回應格式 ✅
- [ ] **必須** 使用 `App\Http\Responses\JsonResponse` 類別
- [ ] 成功：`(new JsonResponse())->success($data)`
- [ ] 失敗：`(new JsonResponse())->failed($code, $message, $data)`
- [ ] **禁止** 直接使用 `response()->json()`

#### 3. Request 驗證 ✅
- [ ] 繼承 `BaseRequest`（已包含標準錯誤格式）
- [ ] 為 API 創建專用 Request，使用 `prepareForValidation()` 處理參數
- [ ] 使用 `messages()` 方法定義每個欄位的錯誤 code (-2, -3, -4...)
- [ ] 正確 import `use Illuminate\Support\Facades\Auth;`

#### 4. 程式邏輯 ✅
- [ ] **🚫 絕對不碰** 原 MVC 檔案，連一個字都不改
- [ ] **📋 完整複製** MVC Controller 內的所有業務邏輯
- [ ] **🧹 清理調整** 移除 MVC 特有處理（如 view, parentInfo）
- [ ] **🔄 格式轉換** 將 view 回應改為 `JsonResponse` 格式

#### 5. 路由設定 ✅
- [ ] 使用 `/api/` 前綴（**不是** `/api/v2/`）
- [ ] 使用語意化路由名稱 (如：`users/registration-review`)
- [ ] 在現有 `routes/api.php` 群組內直接添加
- [ ] 路由中不需要 `Api\` 前綴（會自動加上）

#### 6. 錯誤處理 ✅
- [ ] 為新 API 在 `apiErrorToast.json` 中新增錯誤翻譯
- [ ] 使用標準錯誤代碼從 -2 開始
- [ ] 前端使用 `apiErrorToast` 工具處理錯誤

#### 7. 前端整合 ✅
- [ ] 建立 API 接口檔案 `src/api/{模組}.js`
- [ ] API 調用格式：`api.get('/path', { data })`
- [ ] 創建對應的 Zustand store 管理狀態
- [ ] 使用 `useLoadingStore` 管理載入狀態
- [ ] 處理日期格式化和錯誤顯示

#### 8. Code Review & 通知 ✅
- [ ] 檢查所有 import 語句和回應格式
- [ ] 驗證錯誤處理是否符合標準
- [ ] 測試前後端整合
- [ ] 使用 Telegram 通知完成狀態

#### ⚠️ 常見錯誤避免
- **🚫 絕對禁止** 修改原 MVC 程式碼（包括 Controller、Model、View）
- **🚫 不要** 直接使用 `response()->json()`，必須用 `JsonResponse`
- **🚫 不要** 使用 `/api/v2/` 路由前綴（v2 是前端路由）
- **🚫 不要** 修改 `BaseRequest`，建立新的 Request 檔案
- **🚫 不要** 忘記新增錯誤翻譯到 `apiErrorToast.json`
- **🚫 不要** 在組件中直接管理狀態，必須使用 Zustand store
- **🚫 不要** 嘗試「優化」或「重構」MVC 程式碼，保持原樣

---
