# 訊息中心無資料排查清單

## 1. 檢查 announce 表有沒有資料

```sql
SELECT id, user_id, title, type, status, start_at, end_at
FROM announce
WHERE status = 'normal'
ORDER BY created_at DESC
LIMIT 10;
```

**檢查項目**：
- ✅ 有資料嗎？
- ✅ `status` 是 `normal` 嗎？（`delete` 或 `lock` 不會顯示）
- ✅ `type` 是 `normal` 或 `system` 嗎？
- ✅ 時間區間有效嗎？（`start_at` ~ `end_at`）

---

## 2. 檢查 announce_map 表（重要！）

```sql
-- 查看當前登入使用者的 announce_map
SELECT am.id, am.announce_id, am.user_id, am.read, am.created_at, a.title
FROM announce_map am
JOIN announce a ON am.announce_id = a.id
WHERE am.user_id = {你的user_id}
ORDER BY am.created_at DESC
LIMIT 10;
```

**關鍵問題**：
- ❓ `announce_map` 表有沒有對應你當前登入使用者的記錄？
- ❓ 如果沒有，代表公告沒有「發送」給你

---

## 3. 檢查當前登入使用者 ID

**前端檢查**：
打開瀏覽器 Console，執行：
```javascript
// 方法 1: 從 auth store 取得
console.log(useAuthStore.getState()?.user)

// 方法 2: 呼叫 API
fetch('/api/user', {credentials: 'include'})
  .then(r => r.json())
  .then(d => console.log('當前使用者:', d))
```

**記下你的 `user_id`，例如 `26`**

---

## 4. 檢查 MVC 路由是否正常

訪問 MVC 舊版訊息中心：
```
http://s8_agent.local/announce
```

**如果 MVC 也沒資料**：
- 確認你登入的帳號有沒有收到公告
- 檢查 `announce_map` 表是否有對應記錄

**如果 MVC 有資料但 API 沒有**：
- 可能是 API 邏輯問題
- 檢查 API 回應（F12 → Network）

---

## 5. 手動建立測試資料

如果 `announce_map` 沒有資料，可以手動插入測試：

```sql
-- 假設你的 user_id = 26，announce.id = 1 存在
INSERT INTO announce_map (user_id, announce_id, `read`, created_at, updated_at)
VALUES (26, 1, 0, NOW(), NOW());
```

---

## 6. 檢查公告發送邏輯

公告系統的運作方式：
1. 管理員在後台建立公告 → 寫入 `announce` 表
2. 系統排程或即時發送 → 為每個符合條件的使用者建立 `announce_map` 記錄
3. 使用者登入後看到訊息中心 → 查詢自己的 `announce_map`

**可能的問題**：
- ❌ 公告建立了，但沒有發送（`announce_map` 為空）
- ❌ 公告只發送給特定代理商或層級
- ❌ 你的帳號不在發送範圍內

---

## 7. 快速測試 SQL

```sql
-- 檢查系統中有多少公告
SELECT COUNT(*) as total FROM announce WHERE status = 'normal';

-- 檢查系統中有多少公告映射
SELECT COUNT(*) as total FROM announce_map;

-- 檢查某個公告發送給多少人
SELECT announce_id, COUNT(*) as user_count
FROM announce_map
GROUP BY announce_id;

-- 檢查你的帳號收到多少公告
SELECT COUNT(*) FROM announce_map WHERE user_id = {你的user_id};
```

---

## 8. API 測試

**直接測試 API 端點**：
```bash
# 取得公告列表（需要登入）
curl -X GET 'http://s8_agent.local/api/announce' \
  -H 'Cookie: your_session_cookie' \
  -H 'Accept: application/json'
```

**或在瀏覽器 Console**：
```javascript
fetch('/api/announce', {credentials: 'include'})
  .then(r => r.json())
  .then(d => console.log('API 回應:', d))
```

---

## 常見原因排序

1. ⭐ **announce_map 表沒有你的記錄**（最常見）
2. 公告 status 不是 normal
3. 公告已過期（end_at < 現在）
4. 公告類型被篩選掉
5. API 權限問題

---

## 下一步

請依序檢查：
1. 先跑 SQL 確認 `announce` 和 `announce_map` 的資料
2. 確認當前登入的 user_id
3. 檢查 MVC 舊版能不能看到公告
4. 提供檢查結果，我再幫你分析
