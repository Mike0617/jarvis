# 系統階層架構文件

本文件記錄系統中的帳號階層、角色和權限設定。

## 階層概覽

系統採用 5 層階層架構（level 0-4），從集團到會員。

---

## Level 0 - 集團層級

### 1. 集團帳號（集團代理）
- **level**: 0
- **role**: agent
- **說明**: 最高階代理，擁有整個系統的管理權限

### 2. 站長帳號（超級員工）
- **level**: 0
- **role**: employee
- **permissions**: `super-employee`
- **說明**: 集團層級的超級管理員，擁有最高系統權限

### 3. 集團員工
- **level**: 0
- **role**: employee
- **說明**: 集團層級的一般員工

---

## Level 1 - 總公司層級

### 1. 總公司帳號（總公司代理）
- **level**: 1
- **role**: agent
- **說明**: 總公司代理帳號（對應前端顯示的「總公司」）

### 2. 總公司員工
- **level**: 1
- **role**: employee
- **說明**: 總公司層級的員工

---

## Level 2 - 分公司層級

### 1. 分公司帳號（分公司代理）
- **level**: 2
- **role**: agent
- **說明**: 分公司代理帳號（對應前端顯示的「分公司」）

### 2. 分公司員工
- **level**: 2
- **role**: employee
- **說明**: 分公司層級的員工

---

## Level 3 - 代理層級

### 1. 代理帳號
- **level**: 3
- **role**: agent
- **說明**: 代理帳號（對應前端顯示的「代理」）

### 2. 代理員工
- **level**: 3
- **role**: employee
- **說明**: 代理層級的員工

---

## Level 4 - 會員層級

### 1. 會員帳號
- **level**: 4
- **role**: user
- **說明**: 一般會員帳號

---

## 重要說明

### 權限控制原則
1. **level 數字越小權限越高**（0 > 1 > 2 > 3 > 4）
2. **同 level 中 agent 權限高於 employee**
3. **super-employee 權限是最高等級的員工權限**

### 前端顯示對應
根據 `personal/project-agents.md` 中的定義：
- Level 1 agent → 顯示為「總公司」
- Level 2 agent → 顯示為「分公司」
- Level 3 agent → 顯示為「代理」

### 資料庫欄位
- **level**: 階層等級（0-4）
- **role**: 角色類型（agent/employee/user）
- **permissions**: 權限名稱（如 super-employee）

---

## 相關檔案
- 會員詳情實作: `${S8_AGENT_PATH}/app/Http/Api/Controllers/Member/MemberDetailController.php`
- 前端顯示: `${CASTER_WEB_PATH}/src/pages/members/detail/BasicInfo.jsx`
- 專案代理規範: `personal/project-agents.md`

---

**更新時間**: 2025-10-22
**更新內容**: 初始建立系統階層文件
