# 專案架構（詳細版）

## ERP 後台（caster-web + s8_agent）

### 1) 架構定位
- 前後端分離、多站台共用（caster-web + s8_agent）
- 本地開發：前後端分開跑
- 部署：前端 build 產物部署到 `s8_agent/public/bn/`

### 2) 前後端分工
- 前端：`caster-web`（React + Vite）
- 後端：`s8_agent`（Laravel MVC + API）
- 前端路由：`/v2/*`（由後端提供 SPA 入口）
- API 路由：`/api/*`

### 3) 前端入口（前後分離入口）
- `routes/web.php` 的 `/v2/{any?}` 只負責 **回傳 SPA 入口 view**
- 入口 view：`resources/views/index/bn/main.blade.php`
- `main.blade.php` 是 **前後分離入口模板**（不是 MVC 業務頁面）
  - 載入 Vite 的 JS/CSS（`public/bn/.vite/manifest.json`）
  - 建立 `<div id="root"></div>` 讓 React 接管
  - 由 `web.php` 統一傳入必要變數（例如 `lang/title/folderPrefix`）

### 4) 站台判斷與變數來源（s8_agent）
- `config/app.php`：站台設定來源  
  - `SITE_CODE`、`SITE_NO`、`THE_SITE_FOR`
  - `locale`（tw/cn/vn/en）
  - `site_login_name`
- `bootstrap/Maintain.php`：依 `$_SERVER['SERVER_NAME']` 判斷維護/站台
- `App\Services\DomainService` / `DomainMapping`：依 Request Host 對應站台資料
- `config/session.php`：`SESSION_DOMAIN` 控制 session cookie 網域
> 註：此段屬「站台/網域」維運範圍，通常由網管/維運維護，僅供參考。

### 5) 語系與顯示規則
- 系統語系使用 `config('app.locale')`（tw/cn/vn/en）
- HTML `lang` 需轉成 BCP‑47（`zh-TW/zh-CN/vi/en-US`）
  - 透過 `config('app.locale_map')` 轉換
- 登入畫面標題由 `config('app.site_login_name')` 提供

### 6) 客製化方式
- 主要透過 `.env` 控制站台/語系/顯示名稱
- 不直接在 View 讀 env，由 `web.php` 集中傳入
