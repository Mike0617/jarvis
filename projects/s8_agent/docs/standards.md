# s8_agent 專案細節規範

## 核心原則
- MVC 與 API 並存，**絕對不修改原 MVC**

## API 結構
- Controller：`app/Http/Api/Controllers/{Module}/`
- Request：`app/Http/Api/Requests/{Module}/`
- 路由前綴：`/api/`（非 `/api/v2/`）

## 回應格式
- 使用 `JsonResponse`
- 成功：`success($data)`
- 失敗：`failed($code, $message, $data)`

## 錯誤碼與翻譯
- 錯誤碼從 -2 開始
- 翻譯放在 `apiErrorToast.json`

## 範例
- `projects/s8_agent/docs/examples.md`
