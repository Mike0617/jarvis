# caster-web 專案細節規範

## 路由
- 所有前端路由必須加 `/v2/` 前綴

## 狀態管理
- 使用 Zustand store
- 避免在 component 內保存長期狀態

## API 介接
- 呼叫格式：`api.get('/path', { data })`
- 錯誤處理：`apiErrorToast(模組名, error)`

## 檔案結構
- 頁面：`src/pages/{module}/{function}.jsx`
- Store：`src/stores/use{Module}Store.js`
- 樣式：`src/style/pages/{function}.scss`
- i18n：`public/locales/zh-TW/{module}.json`

## 範例
- `projects/caster-web/docs/examples.md`
