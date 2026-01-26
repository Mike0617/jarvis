# s8_agent 工作流程細節

## MVC → API 標準流程
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
