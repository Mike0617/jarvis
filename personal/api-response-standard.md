# API 回應標準格式

所有 API 回應需遵循統一格式，包含以下欄位：

```json
{
  "code": <int>,       // 狀態代碼（業務邏輯碼）
  "message": <string>, // 狀態描述
  "time": <int>,       // 回應時間（Unix timestamp）
  "data": <object>     // 實際資料內容
}

---

📌 規範

成功回應：code = 1

共用錯誤：code = -1

錯誤代碼：從 -2 開始，依 API 文件自行定義與擴充

所有回應必須包含 time 欄位

HTTP status 可依情境不同（200 成功、400/422 驗證錯誤、550 系統錯誤），但結構保持一致


---

👉 這樣一來就非常彈性，代理人/開發者只要知道：  
- `1` 是成功  
- `-1` 是共用錯誤  
- 其他負數代碼依 API 自己決定  

## 分頁格式標準

所有 API 分頁回應統一使用以下格式：

```json
{
  "code": 1,
  "message": "success",
  "time": 1758005045,
  "data": {
    "items": [...],           // 實際資料陣列（依模組命名，如 withdraws, deposits, users）
    "pagination": {
      "current_page": 1,      // 當前頁碼
      "last_page": 10,        // 最後一頁
      "per_page": 20,         // 每頁筆數
      "total": 200            // 總筆數
    }
  }
}
```

### 欄位定義與順序（強制）

**必須按照此順序**：
```php
'pagination' => [
    'current_page' => $paginator->currentPage(),  // 1. 當前頁碼（從 1 開始）
    'last_page' => $paginator->lastPage(),        // 2. 最後一頁（ceil(total/per_page)）
    'per_page' => $paginator->perPage(),          // 3. 每頁筆數
    'total' => $paginator->total(),               // 4. 總筆數
]
```

**順序理由**：頁碼相關欄位 (`current_page`, `last_page`) 放在一起，符合邏輯順序

### ⚠️ 禁止事項
- ❌ `total_pages` - 必須使用 `last_page`
- ❌ `total_count` - 必須使用 `total`
- ❌ 扁平化結構（分頁欄位直接放在根層級）
- ❌ 欄位順序錯誤（如 `per_page` 在 `last_page` 之前）

### 前端計算公式
```javascript
// 是否有下一頁
hasNextPage = current_page < last_page

// 本頁資料範圍
startIndex = (current_page - 1) * per_page + 1
endIndex = Math.min(current_page * per_page, total)
```

### 後端實作範例

#### 方法 1: Response 類別（推薦）
```php
// Controller
$response = app(WithdrawResponse::class);
return json_response()->success($response->paginated($paginator, $options));

// Response 類別
public function paginated($paginator, array $options = [])
{
    return [
        'withdraws' => $this->transformCollection($paginator->getCollection(), $options),
        'pagination' => [
            'current_page' => $paginator->currentPage(),
            'last_page' => $paginator->lastPage(),
            'per_page' => $paginator->perPage(),
            'total' => $paginator->total()
        ]
    ];
}
```

#### 方法 2: Controller 直接組裝
```php
return json_response()->success([
    'users' => $users->map(fn($u) => /* 轉換邏輯 */),
    'pagination' => [
        'current_page' => $users->currentPage(),
        'last_page' => $users->lastPage(),
        'per_page' => $users->perPage(),
        'total' => $users->total(),
    ]
]);
```

## 時間格式標準

所有 API 的時間欄位統一使用以下處理方式：

### 標準格式
- **輸出格式**: ISO 8601 字串格式（含時區）
- **範例**: `"2024-12-13T16:39:57+08:00"`

### 程式碼實作
```php
// 安全處理 Carbon 物件與字串混合情況
$data['created_at'] = $model->created_at && is_object($model->created_at)
    ? $model->created_at->toIso8601String()
    : $model->created_at;

$data['updated_at'] = $model->updated_at && is_object($model->updated_at)
    ? $model->updated_at->toIso8601String()
    : $model->updated_at;
```

### 處理原則
1. **物件檢查**: 先檢查是否為物件（Carbon 實例）
2. **安全轉換**: 是物件才調用 `toIso8601String()`
3. **保持原值**: 已是字串或 null 則直接使用
4. **統一格式**: 確保所有時間欄位使用相同邏輯

### 適用欄位
- `created_at` - 建立時間
- `updated_at` - 更新時間
- `completed_at` - 完成時間
- `deleted_at` - 刪除時間
- 其他自訂時間欄位
