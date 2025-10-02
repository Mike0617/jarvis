# 🎯 Edwin Jarvis 使用指南

## 快速開始

### 統一使用方式
```bash
# 所有任務都透過 Edwin Jarvis 主代理執行
/Users/miketseng/Documents/agent/personal/scripts/main-agent-dispatcher.sh "任務描述"
```

### 為什麼要統一管理？
- **智能分析**: Edwin Jarvis 會分析任務並自動分配給正確的專案代理
- **統一通知**: 所有專案的進度都會統一追蹤和通知
- **跨專案協調**: 處理需要多個專案配合的複雜任務
- **標準流程**: 確保所有專案都遵循統一的開發標準

## 🔥 常用指令範例

### 單一專案任務
- "幫我新增 caster-web 的帳號設定頁面"
- "修改登入頁面的樣式"
- "緊急修復 caster-web 的登入 bug"

### 跨專案任務
- "我要做一個完整的用戶管理系統"
- "實作訂單管理功能，包含前後端"
- "建立商品管理的 CRUD 功能"

## 📋 專案路徑
- **caster-web**: `/Users/miketseng/Documents/project/web-agent`
- **s8_agent**: `/Users/miketseng/Documents/lara/s8_agent`

## 🔄 工作流程
1. **下指令** → 2. **主代理分析** → 3. **分配執行** → 4. **統一通知**

## 💡 使用要點
- 用自然語言描述需求，讓主代理分析
- 明確說明功能範圍和優先級
- 跨專案任務直接告訴主代理整體目標

---
*詳細規範請參考 `CLAUDE.md`*