# API 回應格式標準

本文件為通用 API 回應格式規範，適用於後端 API 設計與前端介接。

## 基本結構
回應需包含 `code`、`message`、`data` 三個欄位。

```json
{
  "code": 0,
  "message": "success",
  "data": {}
}
```

- `code`：0 表示成功；負數表示錯誤。
- `message`：對人友善的說明文字（正體中文），主要用於說明 `code`。
- `data`：成功時回傳資料，失敗時可回傳錯誤細節或空物件。

## Laravel 標準回應
必須使用 `App\Http\Responses\JsonResponse`。

```php
// 成功需要傳資料
return (new JsonResponse())->success($data);

// 成功不需要傳資料
return (new JsonResponse())->success();

// 失敗
return (new JsonResponse())->failed($code);
```

## JsonResponse 行為細節（s8_agent 實作）
實際回傳格式包含 `code`、`message`、`time`、`data` 四個欄位。

- `success($data = [])` → HTTP `200`，`code = 1`，`message = "success"`
- `failed($code = -1, $message = "failed", $data = [])` → HTTP `550`
- `userFailed($code = -1, $message = "failed", $data = [])` → HTTP `400`
- `failedValidation($code, $data = [])` → HTTP `422`，`message = "failed validation"`

> 註：以 `app/Http/Responses/JsonResponse.php` 目前實作為準。

## 分頁格式（現行 API）
多數分頁回傳採用以下格式（見 `DepositResponse`、`WithdrawResponse`、`SmsResponse` 等）：  

```json
{
  "data": [],
  "pagination": {
    "current_page": 1,
    "last_page": 10,
    "per_page": 15,
    "total": 150
  }
}
```

### 建議規範（新 API）
- 新 API 列表一律使用 `data` 作為列表 key。
- 舊 API 可保留原本 key，避免大規模回溯修改。

### 變形情況
- 部分回傳以模組名稱作為列表 key，例如：
  - `deposits` + `pagination`
  - `withdraws` + `pagination`
- 有些模組同時回傳額外區塊（例如 `summary`、`parent_info`），但 `pagination` 結構一致。

## Response 類使用判斷
- **建議使用 Response 類**：多個端點重用回應格式、欄位複雜、包含分頁/彙總/權限資訊。
- **可直接在 Controller 回傳**：單一端點、結構簡單且不重用。

## 錯誤碼規則
- 自訂錯誤碼從 **-2** 開始。
- 每個 API 可獨立從 -2 重新編號（不需延續其他 API）。
- 錯誤翻譯需同步更新 `apiErrorToast.json`。

## Request 規範（API）
- 使用 API 專用 Request，**繼承 `BaseRequest`**。
- 在 `prepareForValidation()` 正規化輸入參數。
- 在 `messages()` 回傳錯誤碼（-2 起跳）。
- 新增錯誤碼後，**同步更新** `apiErrorToast.json`。

## 常見注意事項
- **禁止**直接使用 `response()->json()`。
- 日期欄位需轉為 ISO 8601 字串。
- 請避免直接回傳整個 Model（使用白名單欄位）。
