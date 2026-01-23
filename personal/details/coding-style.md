# 程式碼風格規範

本文件定義通用程式碼風格與命名規則，作為跨專案一致性依據。

## 通用原則
- **一致性優先**：同一模組內命名、結構、回傳格式要一致。
- **可讀性優先**：避免過度壓縮寫法，保留必要空白與註解。
- **最小改動**：非必要不要重構既有 MVC。

## 命名規範
- 檔名/資料夾：小寫 + 破折號或專案慣例
- 變數/函式：camelCase
- Class/Component：PascalCase
- 錯誤訊息：正體中文
- 後端欄位：snake_case（與資料庫一致）
 - API 路徑：kebab-case + 複數資源（例如 `/user-tags`, `/members/withdraws`）
 - 行為型路由：動作後綴（例如 `/fast-read`, `/check-usage`）
 - 前端變數命名：camelCase；傳給後端的欄位維持 snake_case

## Laravel（後端）
- 回應格式統一使用 `JsonResponse`
- 日期欄位轉 ISO 8601
- 使用白名單欄位輸出（避免直接回傳整個 Model）
- **禁止** `response()->json()`（統一使用 `JsonResponse`）

```php
$modelFields = ['id', 'name', 'status', 'created_at', 'updated_at'];
$data = collect($modelFields)->mapWithKeys(function ($field) use ($model) {
    return [$field => $model->$field];
})->toArray();

$data['created_at'] = $model->created_at && is_object($model->created_at)
    ? $model->created_at->toIso8601String()
    : $model->created_at;
```

## React（前端）
- 路由必須 `/v2/` 前綴（若為 caster-web）
- 狀態管理使用 Zustand
- API 呼叫格式：`api.get('/path', { data })`
- 錯誤處理使用 `apiErrorToast`
- API 路徑一律以 `/` 開頭
- **GET 查詢統一使用 `data`**（避免 `params` 混用）

## SCSS / Tailwind
- 以 SCSS 為主、Tailwind 為輔
- 樣式檔案放 `src/style/pages/{功能}.scss`
- 註解使用正體中文
