# i18n 規範

通用多語系規範，適用前後端與錯誤訊息管理。

## 基本原則
- 文字需支援 i18n，避免硬編在程式碼內
- 錯誤訊息使用正體中文
- key 命名需可讀且穩定

## Frontend（i18next）
- 使用 `useTranslation()`
- 錯誤訊息使用 `useTranslation('apiErrorToast')`
- 建議命名：`module.key`（例如：`user.create.success`）
- 動態載入：使用 `i18next-http-backend`

## 檔案結構（建議）
- `public/locales/zh-TW/{module}.json`
- `public/locales/en/{module}.json`

## 動態載入設定（現況）
- `fallbackLng`：`zh-TW`
- `defaultNS`：`common`
- `ns`：`apiErrorToast`
- `loadPath`：
  - 開發：`/locales/{{lng}}/{{ns}}.json`
  - 正式：`/bn/locales/{{lng}}/{{ns}}.json`

## apiErrorToast
- 每個 API 新增錯誤代碼時，需同步更新翻譯
- 錯誤碼從 -2 開始
