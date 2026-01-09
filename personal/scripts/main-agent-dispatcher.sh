#!/bin/bash

# Edwin Jarvis - 個人主代理任務分配腳本
# Edwin Jarvis Personal Main Agent Task Dispatcher

# 設定
PROJECTS_DIR="/Volumes/MAX/agent/projects"
PERSONAL_DIR="/Volumes/MAX/agent/personal"
LOG_FILE="/tmp/main_agent_log"
AGENT_CMD="${AGENT_CMD:-codex}"
TEMPLATE_FILE="/Volumes/MAX/agent/personal/telegram-templates.md"
START_TEMPLATE_KEY="1) 開始通知"
COMPLETE_TEMPLATE_KEY="3) 完成通知"

START_EPOCH=""
START_TIME=""

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
        echo "⚠️  未明確匹配專案，預設分配給 caster-web" | tee -a "$LOG_FILE" >&2
    fi
    
    echo "${projects[@]}"
}

# 判斷是否需要檢查變更（避免回報完成但實際未改檔）
requires_changes() {
    local task="$1"
    echo "$task" | grep -iE "(改|修改|新增|移除|刪除|調整|合併|更新|修正|修復|refactor|refactoring|implement|add|remove|update|fix)" > /dev/null
}

# 讀取指定模板內容（取出 Markdown code block 內文）
get_template_block() {
    local key="$1"
    if [ ! -f "$TEMPLATE_FILE" ]; then
        return
    fi

    awk -v key="$key" '
        $0 ~ "^### " {
            inblock = ($0 ~ key)
            incode = 0
        }
        inblock && $0 ~ "^```" {
            if (!incode) { incode=1; next } else { exit }
        }
        inblock && incode { print }
    ' "$TEMPLATE_FILE"
}

# 格式化耗時（秒 -> HH:MM）
format_duration() {
    local seconds="$1"
    local minutes=$((seconds / 60))
    local hours=$((minutes / 60))
    local mins=$((minutes % 60))
    printf "%02d:%02d" "$hours" "$mins"
}

# 依模板替換變數
render_template() {
    local template="$1"
    local task="$2"
    local projects="$3"
    local start_time="$4"
    local end_time="$5"
    local status_icon="$6"
    local result_text="$7"
    local duration="$8"
    local estimated_duration="$9"

    local output="$template"
    output="${output//\{\{TASK\}\}/$task}"
    output="${output//\{\{PROJECTS\}\}/$projects}"
    output="${output//\{\{START_TIME\}\}/$start_time}"
    output="${output//\{\{END_TIME\}\}/$end_time}"
    output="${output//\{\{STATUS_ICON\}\}/$status_icon}"
    output="${output//\{\{RESULT\}\}/$result_text}"
    output="${output//\{\{DURATION\}\}/$duration}"
    output="${output//\{\{ESTIMATED_DURATION\}\}/$estimated_duration}"
    output="${output//\{\{SUBTASKS\}\}/}"
    printf "%s" "$output"
}

# 執行代理任務（依代理類型選擇非互動模式）
run_agent_task() {
    local task="$1"

    if [ "$AGENT_CMD" = "codex" ]; then
        if [ -n "$CODEX_PROFILE" ]; then
            codex exec -p "$CODEX_PROFILE" "$task"
        else
            codex exec "$task"
        fi
        return $?
    fi

    if [ "$AGENT_CMD" = "claude" ]; then
        echo "$task" | claude -p
        return $?
    fi

    echo "$task" | "$AGENT_CMD"
}

# 執行專案代理函數
execute_project_agent() {
    local project="$1" 
    local task="$2"
    
    echo "🚀 執行 $project 專案代理..." | tee -a "$LOG_FILE"
    
    case "$project" in
        "caster-web")
            local project_path="/Volumes/MAX/Project/Caster-Web"
            if [ -d "$project_path" ] && [ -f "$PROJECTS_DIR/caster-web/CLAUDE.md" ]; then
                echo "📁 切換到專案目錄: $project_path" | tee -a "$LOG_FILE"
                cd "$project_path" || return 1
                
                echo "🤖 啟動 ${AGENT_CMD} 執行任務..." | tee -a "$LOG_FILE"
                run_agent_task "$task" 2>&1 | tee -a "$LOG_FILE"
                local exit_code=${PIPESTATUS[1]}
                
                if [ $exit_code -eq 0 ]; then
                    if requires_changes "$task"; then
                        if git -C "$project_path" rev-parse --is-inside-work-tree > /dev/null 2>&1; then
                            if [ -z "$(git -C "$project_path" status --porcelain)" ]; then
                                echo "⚠️  $project 代理回報完成，但未偵測到檔案變更" | tee -a "$LOG_FILE"
                                return 1
                            fi
                        fi
                    fi
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
            local project_path="/Volumes/MAX/lara/s8_agent"
            if [ -d "$project_path" ] && [ -f "$PROJECTS_DIR/s8_agent/CLAUDE.md" ]; then
                echo "📁 切換到專案目錄: $project_path" | tee -a "$LOG_FILE"
                cd "$project_path" || return 1
                
                echo "🤖 啟動 ${AGENT_CMD} 執行任務..." | tee -a "$LOG_FILE"
                run_agent_task "$task" 2>&1 | tee -a "$LOG_FILE"
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
    local phase="$1"
    local projects="$2"
    local task="$3"
    local success="$4"

    local status_icon="🚀"
    local result_text="專案代理已完成任務"
    local end_time=""
    local duration=""

    if [ "$phase" = "complete" ]; then
        if [ "$success" = "1" ]; then
            status_icon="✅"
            result_text="專案代理已完成任務"
        else
            status_icon="❌"
            result_text="部分專案代理執行失敗"
        fi
        end_time=$(date +%H:%M)
        if [ -n "$START_EPOCH" ]; then
            duration=$(format_duration $(( $(date +%s) - START_EPOCH )))
        else
            duration="00:00"
        fi
    fi

    local template
    if [ "$phase" = "start" ]; then
        template=$(get_template_block "$START_TEMPLATE_KEY")
    else
        template=$(get_template_block "$COMPLETE_TEMPLATE_KEY")
    fi

    local message
    if [ -z "$template" ]; then
        echo "❌ 找不到 Telegram 模板，請檢查 $TEMPLATE_FILE" | tee -a "$LOG_FILE"
        return
    fi

    message=$(render_template "$template" \
        "$task" \
        "$projects" \
        "$START_TIME" \
        "$end_time" \
        "$status_icon" \
        "$result_text" \
        "$duration" \
        "未估")
    
    if [ -f "$PERSONAL_DIR/scripts/safe-telegram-notify.sh" ]; then
        "$PERSONAL_DIR/scripts/safe-telegram-notify.sh" "$message"
    else
        echo "⚠️  通知腳本不存在，跳過 Telegram 通知" | tee -a "$LOG_FILE"
    fi
}

# 主要執行流程
main() {
    echo "🧠 分析任務中..." | tee -a "$LOG_FILE"

    START_EPOCH=$(date +%s)
    START_TIME=$(date +%H:%M)
    
    # 分析任務
    INVOLVED_PROJECTS=($(analyze_task "$TASK_DESCRIPTION"))
    PROJECTS_STR=$(IFS=', '; echo "${INVOLVED_PROJECTS[*]}")
    
    echo "📋 涉及專案: $PROJECTS_STR" | tee -a "$LOG_FILE"
    
    # 發送開始通知
    send_main_agent_notification "start" "$PROJECTS_STR" "$TASK_DESCRIPTION" ""
    
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
        send_main_agent_notification "complete" "$PROJECTS_STR" "$TASK_DESCRIPTION" "1"
        echo "🎉 Edwin Jarvis 任務執行完成！" | tee -a "$LOG_FILE"
    else
        send_main_agent_notification "complete" "$PROJECTS_STR" "$TASK_DESCRIPTION" "0"
        echo "⚠️  部分專案代理執行失敗，請檢查日誌" | tee -a "$LOG_FILE"
        exit 1
    fi
}

# 執行主流程
main
