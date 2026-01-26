# caster-web 專案特例

此文件只保留專案特例，通用規範請參考 `personal/CORE.md`。

## 專案資訊
- 路徑：`${CASTER_WEB_PATH}`
- 技術棧：React + Vite + Zustand + SCSS/Tailwind

## 專案特例
- 所有前端路由必須加 `/v2/` 前綴
 - 狀態管理使用 Zustand
 - API 呼叫格式：`api.get('/path', { data })`
 - 錯誤處理使用 `apiErrorToast`

## 強制流程
**必須嚴格依序執行：Branch → Code → Review → Notify**

## Review Checklist（摘要）
- 路由包含 `/v2/` 前綴
- 狀態管理使用 Zustand
- API 呼叫格式正確
- RWD/樣式一致

## 專案細節文件
- `projects/caster-web/docs/standards.md`
- `projects/caster-web/docs/workflow.md`
