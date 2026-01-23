# caster-web 工作流程細節

## 強制流程
Branch → Code → Review → Notify（不可跳步）

## 分支命名
- `feat/` 新功能
- `ref/` 修改/優化
- `fix/` 修復
- `lang/` 語系

## Review Checklist（摘要）
- 路由包含 `/v2/`
- 狀態管理使用 Zustand
- API 呼叫格式正確
- RWD/樣式一致

## 參考
- `projects/caster-web/agents/branch-agent.md`
- `projects/caster-web/agents/code-agent.md`
- `projects/caster-web/agents/review-agent.md`
