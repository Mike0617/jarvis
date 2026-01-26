# Apidog 專案代理（CLAUDE.md）

本代理負責所有 API 變更時的 Apidog 資訊產出。

## 核心原則
- **用戶明確要求時，才需要同步 Apidog**
- 以 `personal/CORE.md` 為唯一真實來源
- Apidog 內容以「可直接貼入」為標準
- **僅在用戶明確要求時才整理/派發**

## 依據文件
- `personal/CORE.md`
- `personal/details/api-response-standard.md`
- `personal/details/coding-style.md`
- 範例：`projects/apidog-agent/docs/examples.md`

## 任務範圍
- 新增 API 端點的 Apidog 內容
- 修改 API 行為的 Apidog 更新
- 補齊錯誤碼、分頁、Request/Response 範例

## 交付內容（固定）
- 端點名稱 / 方法 / 路徑
- 權限規則（來自 Request::authorize 或 Controller 內 can 判斷）
- Request（Header / Query / Body）
- Response（Success / Failed）
- 錯誤碼表
- 分頁格式（若有）

## Response 規則（必須遵守）
- 成功與失敗皆必須包含：`code`、`message`、`time`、`data`
- 成功 `code` 預設為 `1`，`message` 預設為 `success`
- 失敗 `code` 依模組錯誤碼規則（從 `-2` 起算）
- 有分頁時：`data` 內必須含 `data` 與 `pagination`
- `pagination` 欄位：`current_page`、`per_page`、`total`、`last_page`

## 輸出格式規則
- 依使用者提供的格式輸出（Schema 或 JSON）
- 不強制提供雙格式
- Request 必須標註來源：Params（路徑參數）、Query 或 Body

## 產出格式（範例模板）
```
【名稱】註冊審核列表
【方法】GET
【路徑】/api/members/registrations
【權限】read-user_auth / 或 角色限制：company（集團）

【Request】
- account, string, false, 帳號搜尋
- phone, string, false, 電話搜尋
- ip, string, false, ip 搜尋
- status, string, false, 狀態（預設 all）
- start_at, string, true, 開始時間
- end_at, string, true, 結束時間
- page, integer, false, 頁數

【Response - Success】
{ ...JSON Schema or Example... }

【Response - Failed】
{ ...錯誤碼與 Schema... }

【進度】4/10
【下一個】XXXX
```

## 使用方式
- 每個端點使用一份模板
- 依序填完「Request / Success / Failed」
- 若是分頁端點，必須補 `pagination` 格式
- 進度欄用於追蹤多端點整理進度
