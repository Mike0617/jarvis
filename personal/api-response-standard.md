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
    "items": [...],           // 實際資料陣列
    "pagination": {
      "current_page": 1,      // 當前頁碼
      "last_page": 10,        // 最後一頁
      "per_page": 20,         // 每頁筆數
      "total": 200            // 總筆數
    }
  }
}
```

### 分頁欄位說明
- **current_page**: 當前頁碼，從 1 開始
- **last_page**: 最後一頁頁碼（由 ceil(total/per_page) 計算）
- **per_page**: 每頁資料筆數
- **total**: 符合條件的資料總筆數

### 前端計算
其他分頁資訊可透過這4個基礎值計算：
- 是否有下一頁: `current_page < last_page`
- 本頁起始位置: `(current_page - 1) * per_page + 1`
- 本頁結束位置: `min(current_page * per_page, total)`

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
