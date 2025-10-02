# 🎯 Caster-Web 專案詳細資訊

## 📋 專案概述
現代化的 React Web 應用程式，採用最新技術棧構建的高效能前端解決方案。

![React](https://img.shields.io/badge/React-19.1.0-61DAFB?logo=react)
![Vite](https://img.shields.io/badge/Vite-7.0.4-646CFF?logo=vite)
![Zustand](https://img.shields.io/badge/Zustand-5.0.7-FF6B6B)
![TailwindCSS](https://img.shields.io/badge/TailwindCSS-4.1.11-06B6D4?logo=tailwindcss)

## ✨ 特色功能
- 🚀 **快速開發** - Vite 提供極速的熱重載開發體驗
- 🎨 **現代化 UI** - Tailwind CSS 原子化設計系統
- 🌍 **多語系支援** - i18next 完整國際化解決方案
- 📱 **響應式設計** - 完美適配各種設備螢幕
- 🔐 **身份驗證** - 完整的使用者認證流程
- 📡 **API 整合** - Axios 統一 API 請求管理
- 🎛 **狀態管理** - Zustand 輕量狀態管理
- 🔔 **通知系統** - React Hot Toast 優雅通知提示

## 🛠 技術棧詳細

### 核心框架
- **[React 19.1.0](https://react.dev/)** - 最新的 React 框架
- **[Vite 7.0.4](https://vitejs.dev/)** - 次世代前端建構工具
- **[React Router 7.7.1](https://reactrouter.com/)** - 宣告式路由管理

### 狀態管理
- **[Zustand 5.0.7](https://zustand.surge.sh/)** - 簡潔的狀態管理解決方案

### 樣式系統
- **[Tailwind CSS 4.1.11](https://tailwindcss.com/)** - 實用優先的 CSS 框架
- **[Sass 1.89.2](https://sass-lang.com/)** - CSS 預處理器

### 國際化
- **[i18next 25.3.4](https://www.i18next.com/)** - 國際化框架
- **[react-i18next 15.6.1](https://react.i18next.com/)** - React 國際化綁定

### 工具庫
- **[Axios 1.11.0](https://axios-http.com/)** - HTTP 客戶端
- **[Lucide React 0.536.0](https://lucide.dev/)** - 美觀的圖示庫
- **[React Hot Toast 2.5.2](https://react-hot-toast.com/)** - 通知組件

## 📁 專案結構
```
src/
├── api/                    # API 請求封裝
├── components/             # 可重用組件
│   ├── Button/            # 按鈕組件
│   ├── Input/             # 輸入框組件
│   ├── LangSwitcher/      # 語言切換器
│   ├── Loading/           # 載入組件
│   └── UserDropdown/      # 使用者下拉選單
├── layout/                # 佈局組件
├── pages/                 # 頁面組件
│   ├── home/              # 首頁
│   ├── login/             # 登入頁
│   └── users/             # 使用者管理
├── stores/                # Zustand 狀態管理
│   ├── useAuthStore.js    # 身份驗證狀態
│   ├── useLangStore.js    # 語言設定狀態
│   ├── useTokenStore.js   # Token 管理
│   └── ...                # 其他狀態
├── style/                 # 全域樣式
├── utils/                 # 工具函數
├── i18n.js               # 國際化配置
├── router.jsx            # 路由配置
└── main.jsx              # 應用程式入口
```

## 🌍 國際化支援

### 支援語言
- 🇹🇼 **繁體中文** (zh-TW) - 預設語言
- 🇺🇸 **English** (en-US)
- 🇯🇵 **日本語** (ja-JP)

### 語言檔案結構
```
public/locales/
├── zh-TW/
│   ├── common.json
│   └── apiErrorToast.json
├── en-US/
│   ├── common.json
│   └── apiErrorToast.json
└── ja-JP/
    ├── common.json
    └── apiErrorToast.json
```

## ⚙️ 環境配置

### 開發環境
```env
# .env
VITE_API_BASE=http://s8_agent.local
```

### 生產環境
自動使用 `https://ag.game588.net/api` 作為預設端點

### API 代理設定
開發模式下的代理配置：
- 有設定 `VITE_API_BASE` → 使用自定義端點
- 無設定 → 使用預設生產端點

## 📦 可用指令
| 指令 | 說明 |
|------|------|
| `npm install` | 安裝依賴套件 |
| `npm run dev` | 啟動開發伺服器 |
| `npm run build` | 建構生產版本 |
| `npm run preview` | 預覽建構結果 |
| `npm run lint` | 執行 ESLint 檢查 |

## 🔧 開發環境要求
- **Node.js** >= 20.19.4
- **npm** (隨 Node.js 安裝)
- 開發伺服器運行於 `http://localhost:5173`

---
*此文件供 Edwin Jarvis Agent 系統參考，了解專案架構與技術細節*