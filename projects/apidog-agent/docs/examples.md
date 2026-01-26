# Apidog 範例（Schema 格式）

## 註冊審核列表
- 方法：GET
- 路徑：/api/members/registrations
- 權限：read-user_auth

### Request
- account, string, false, 帳號搜尋
- phone, string, false, 電話搜尋
- ip, string, false, ip 搜尋
- status, string, false, 狀態（預設 all）
- start_at, string, true, 開始時間
- end_at, string, true, 結束時間
- page, integer, false, 頁數

### Response - Success（Schema）
```json
{
  "type": "object",
  "properties": {
    "code": {
      "type": "integer",
      "description": "代號"
    },
    "message": {
      "type": "string",
      "description": "api訊息"
    },
    "time": {
      "type": "integer",
      "description": "時間戳"
    },
    "data": {
      "type": "object",
      "properties": {
        "data": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "id": { "type": "integer", "description": "註冊審核ID" },
              "account": { "type": "string", "description": "帳號" },
              "status": { "type": "string", "description": "狀態" },
              "phone": { "type": "string", "description": "電話" },
              "register_ip": { "type": "string", "description": "IP" },
              "repeat_ip_count": { "type": "integer", "description": "近6個月重複IP人數（不含自己）" },
              "register_device": { "type": "string", "description": "裝置資訊" },
              "verification": {
                "type": "object",
                "properties": {
                  "in_blacklist": { "type": "boolean", "description": "是否黑名單" },
                  "risk_level": { "type": "string", "description": "風控等級" }
                },
                "required": ["in_blacklist", "risk_level"],
                "x-apidog-orders": ["in_blacklist", "risk_level"],
                "description": "安全驗證"
              },
              "created_at": { "type": "string", "description": "申請時間" },
              "reject_reason": { "type": "string", "description": "拒絕項目" },
              "note": { "type": "string", "description": "備註" },
              "reject_reason_text": { "type": "string", "description": "自定義拒絕原因" }
            },
            "x-apidog-orders": [
              "id",
              "account",
              "status",
              "phone",
              "register_ip",
              "repeat_ip_count",
              "register_device",
              "verification",
              "created_at",
              "reject_reason",
              "note",
              "reject_reason_text"
            ]
          },
          "description": "審核資料"
        },
        "pagination": {
          "type": "object",
          "properties": {
            "current_page": { "type": "integer", "description": "當前頁數" },
            "per_page": { "type": "integer", "description": "一頁資料" },
            "total": { "type": "integer", "description": "總資料數" },
            "last_page": { "type": "integer", "description": "最後一頁" }
          },
          "required": ["current_page", "per_page", "total", "last_page"],
          "x-apidog-orders": ["current_page", "per_page", "total", "last_page"],
          "description": "頁數資料"
        }
      },
      "required": ["data", "pagination"],
      "x-apidog-orders": ["data", "pagination"],
      "description": "資料"
    }
  },
  "required": ["code", "message", "time", "data"],
  "x-apidog-orders": ["code", "message", "time", "data"]
}
```

### Response - Failed（Schema）
```json
{
  "type": "object",
  "properties": {
    "code": {
      "type": "integer",
      "enum": [-2, -3, -4, -5, -6, -7],
      "x-apidog-enum": [
        { "value": -2, "name": "帳號格式錯誤", "description": "" },
        { "value": -3, "name": "電話號碼格式錯誤", "description": "" },
        { "value": -4, "name": "IP位址格式錯誤", "description": "" },
        { "value": -5, "name": "狀態參數錯誤", "description": "" },
        { "value": -6, "name": "開始時間格式錯誤", "description": "" },
        { "value": -7, "name": "結束時間錯誤", "description": "" }
      ],
      "description": "錯誤代號"
    },
    "message": { "type": "string", "description": "api訊息" },
    "time": { "type": "integer", "description": "時間戳" },
    "data": {
      "type": "array",
      "items": { "type": "string" },
      "description": "資料"
    }
  },
  "required": ["code", "message", "time", "data"],
  "x-apidog-orders": ["code", "message", "time", "data"]
}
```
