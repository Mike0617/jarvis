# s8_agent 專案特例

此文件只保留專案特例，通用規範請參考 `personal/CORE.md`。

## 專案資訊
- 路徑：`${S8_AGENT_PATH}`
- 技術棧：Laravel 5.3 + PHP 5.6+ + Blade + Bootstrap

## 專案特例
- MVC 與 API 並存，**絕對不修改原 MVC**
- API 路由前綴必須 `/api/`

## API 開發規範（摘要）
- API Controller：`app/Http/Api/Controllers/{Module}/`
- 回應格式：`JsonResponse`
- 錯誤代碼從 -2 開始，翻譯放在 `apiErrorToast.json`

## MVC → API 標準流程（摘要）
1. 分析 MVC Controller 與 View
2. 新增 `/api/` 路由，保留原 MVC
3. 僅改回應格式，不改業務邏輯
4. 建立 Request 驗證與錯誤翻譯
5. 前端對接並驗證

## Review Checklist（摘要）
- 未修改原 MVC
- 使用 `JsonResponse`
- `/api/` 前綴正確
- 錯誤碼與翻譯已補齊

## 專案細節文件
- `projects/s8_agent/docs/standards.md`
- `projects/s8_agent/docs/workflow.md`
