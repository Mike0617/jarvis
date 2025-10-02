#!/bin/bash

# Edwin Jarvis - 個人主代理任務分配腳本
# Edwin Jarvis Personal Main Agent Task Dispatcher

# 設定
PROJECTS_DIR="/Users/miketseng/Documents/agent/projects"
PERSONAL_DIR="/Users/miketseng/Documents/agent/personal"
LOG_FILE="/tmp/main_agent_log"

# 輸入參數
TASK_DESCRIPTION="$1"
if [ -z "$TASK_DESCRIPTION" ]; then
    echo "❌ 使用方式: $0 \"任務描述\""
    exit 1
fi

echo "🎯 Edwin Jarvis 接收任務: $TASK_DESCRIPTION" | tee -a "$LOG_FILE"
echo "📅 時間: $(date)" | tee -a "$LOG_FILE"

# 任務分析函數
analyze_task() {
    local task="$1"
    local projects=()
    
    # 前端關鍵字檢測
    if echo "$task" | grep -iE "(頁面|介面|UI|樣式|React|元件|前端|caster-web|登入|帳號|用戶介面)" > /dev/null; then
        projects+=("caster-web")
    fi
    
    # 後端關鍵字檢測  
    if echo "$task" | grep -iE "(API|資料庫|伺服器|Laravel|業務邏輯|後端|s8_agent)" > /dev/null; then
        projects+=("s8_agent")
    fi
    
    # 部署關鍵字檢測
    if echo "$task" | grep -iE "(部署|CI/CD|Docker|伺服器|環境|deploy)" > /dev/null; then
        projects+=("caster-deploy")
    fi
    
    # 如果沒有明確匹配，預設給前端（因為目前主要在前端開發）
    if [ ${#projects[@]} -eq 0 ]; then
        projects=("caster-web")
        echo "⚠️  未明確匹配專案，預設分配給 caster-web" | tee -a "$LOG_FILE"
    fi
    
    echo "${projects[@]}"
}

# 執行專案代理函數
execute_project_agent() {
    local project="$1" 
    local task="$2"
    
    echo "🚀 執行 $project 專案代理..." | tee -a "$LOG_FILE"
    
    case "$project" in
        "caster-web")
            local project_path="/Users/miketseng/Documents/project/web-agent"
            if [ -d "$project_path" ] && [ -f "$PROJECTS_DIR/caster-web/CLAUDE.md" ]; then
                echo "📁 切換到專案目錄: $project_path" | tee -a "$LOG_FILE"
                cd "$project_path" || return 1
                
                echo "🤖 啟動 Claude Code 執行任務..." | tee -a "$LOG_FILE"
                echo "$task" | claude --non-interactive 2>&1 | tee -a "$LOG_FILE"
                local exit_code=${PIPESTATUS[1]}
                
                if [ $exit_code -eq 0 ]; then
                    echo "✅ $project 代理執行完成" | tee -a "$LOG_FILE"
                    return 0
                else
                    echo "❌ $project 代理執行失敗 (退出碼: $exit_code)" | tee -a "$LOG_FILE"
                    return 1
                fi
            else
                echo "❌ $project 專案目錄或設定檔不存在" | tee -a "$LOG_FILE"
                return 1
            fi
            ;;
        "s8_agent")
            local project_path="/Users/miketseng/Documents/lara/s8_agent"
            if [ -d "$project_path" ] && [ -f "$PROJECTS_DIR/s8_agent/CLAUDE.md" ]; then
                echo "📁 切換到專案目錄: $project_path" | tee -a "$LOG_FILE"
                cd "$project_path" || return 1
                
                echo "🤖 啟動 Claude Code 執行任務..." | tee -a "$LOG_FILE"
                echo "$task" | claude --non-interactive 2>&1 | tee -a "$LOG_FILE"
                local exit_code=${PIPESTATUS[1]}
                
                if [ $exit_code -eq 0 ]; then
                    echo "✅ $project 代理執行完成" | tee -a "$LOG_FILE"
                    return 0
                else
                    echo "❌ $project 代理執行失敗 (退出碼: $exit_code)" | tee -a "$LOG_FILE"
                    return 1
                fi
            else
                echo "❌ $project 專案目錄或設定檔不存在" | tee -a "$LOG_FILE"
                return 1
            fi
            ;;
        "caster-deploy") 
            echo "🚧 $project 代理尚未建立，建議先建立部署專案代理" | tee -a "$LOG_FILE"
            return 1
            ;;
        *)
            echo "❌ 未知專案: $project" | tee -a "$LOG_FILE"
            return 1
            ;;
    esac
}

# 發送統一通知
send_main_agent_notification() {
    local status="$1"
    local projects="$2" 
    local task="$3"
    local phase="$4" # 新增階段參數：start 或 complete
    
    local message
    if [ "$phase" = "start" ]; then
        message="🚀 [Edwin Jarvis] 任務開始執行
- 任務: $task
- 涉及專案: $projects
- 開始時間: $(date +%H:%M)
- 狀態: 正在執行專案代理..."
    else
        message="$status [Edwin Jarvis] 任務執行完成
- 任務: $task
- 涉及專案: $projects
- 完成時間: $(date +%H:%M)
- 執行結果: 專案代理已完成任務"
    fi
    
    if [ -f "$PERSONAL_DIR/scripts/safe-slack-notify.sh" ]; then
        "$PERSONAL_DIR/scripts/safe-slack-notify.sh" "$message"
    else
        echo "⚠️  通知腳本不存在，跳過 Slack 通知" | tee -a "$LOG_FILE"
    fi
}

# 主要執行流程
main() {
    echo "🧠 分析任務中..." | tee -a "$LOG_FILE"
    
    # 分析任務
    INVOLVED_PROJECTS=($(analyze_task "$TASK_DESCRIPTION"))
    PROJECTS_STR=$(IFS=', '; echo "${INVOLVED_PROJECTS[*]}")
    
    echo "📋 涉及專案: $PROJECTS_STR" | tee -a "$LOG_FILE"
    
    # 發送開始通知
    send_main_agent_notification "🚀" "$PROJECTS_STR" "$TASK_DESCRIPTION" "start"
    
    # 執行各專案代理
    SUCCESS_COUNT=0
    for project in "${INVOLVED_PROJECTS[@]}"; do
        if execute_project_agent "$project" "$TASK_DESCRIPTION"; then
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        fi
    done
    
    # 結果統計
    TOTAL_PROJECTS=${#INVOLVED_PROJECTS[@]}
    echo "📊 執行結果: $SUCCESS_COUNT/$TOTAL_PROJECTS 個專案代理成功" | tee -a "$LOG_FILE"
    
    # 發送完成通知
    if [ $SUCCESS_COUNT -eq $TOTAL_PROJECTS ]; then
        send_main_agent_notification "✅" "$PROJECTS_STR" "$TASK_DESCRIPTION" "complete"
        echo "🎉 Edwin Jarvis 任務執行完成！" | tee -a "$LOG_FILE"
    else
        send_main_agent_notification "❌" "$PROJECTS_STR" "$TASK_DESCRIPTION" "complete"  
        echo "⚠️  部分專案代理執行失敗，請檢查日誌" | tee -a "$LOG_FILE"
        exit 1
    fi
}

# 執行主流程
main
