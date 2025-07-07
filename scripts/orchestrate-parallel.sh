#!/bin/bash

# Parallel Orchestration Script with iTerm2 and headless support
# Allows agents to run truly in parallel

# Find claude command
if command -v claude &> /dev/null; then
    CLAUDE_CMD="claude"
elif [ -x "${HOME}/.claude/local/claude" ]; then
    CLAUDE_CMD="${HOME}/.claude/local/claude"
else
    echo "Error: Claude CLI not found."
    exit 1
fi

MODE=${1:-headless}  # headless or iterm
shift

function spawn_headless() {
    local agent=$1
    local task=$2
    # Create secure temporary log file
    local logfile=$(mktemp -t "claude-${agent}-XXXXXX.log")
    chmod 600 "$logfile"
    
    echo "🚀 Spawning $agent agent (headless) - Log: $logfile"
    
    # Capitalize agent name
    local agent_name=$(echo "$agent" | sed 's/^./\U&/')
    
    # Create a unique task ID
    local task_id="$(echo $agent | tr '[:lower:]' '[:upper:]')-$(date +%s | tail -c 4)"
    
    # Run in background with output to logfile
    nohup $CLAUDE_CMD -p "You are the $agent_name Agent. First run /${agent} to load your role. 

IMPORTANT: Update the taskboard using these commands:
1. Add your task: python scripts/taskboard-helper.py add $agent $task_id P1 '$task'
2. Start work: python scripts/taskboard-helper.py start $task_id
3. When done: python scripts/taskboard-helper.py complete $task_id

Now complete: $task" --verbose > "$logfile" 2>&1 &
    
    echo "   PID: $! - Agent running in background"
}

function spawn_iterm() {
    local agent=$1
    local task=$2
    
    echo "🖥️  Spawning $agent agent in new iTerm2 window"
    
    # Capitalize agent name
    local agent_name=$(echo "$agent" | sed 's/^./\U&/')
    
    # Create a unique task ID
    local task_id="$(echo $agent | tr '[:lower:]' '[:upper:]')-$(date +%s | tail -c 4)"
    
    # Create AppleScript to open new iTerm window
    osascript <<EOF
tell application "iTerm2"
    create window with default profile
    tell current session of current window
        write text "cd $(pwd)"
        write text "echo '🤖 $agent_name Agent Started'"
        write text "echo 'Task ID: $task_id'"
        write text "$CLAUDE_CMD -p 'You are the $agent_name Agent. First run /${agent} to load your role. IMPORTANT: Update the taskboard using these commands: 1. Add your task: python scripts/taskboard-helper.py add $agent $task_id P1 \"$task\" 2. Start work: python scripts/taskboard-helper.py start $task_id 3. When done: python scripts/taskboard-helper.py complete $task_id. Now complete: $task' --verbose"
    end tell
end tell
EOF
}

function parallel_audit() {
    echo "🔍 Starting Parallel Repository Audit"
    echo "Mode: $MODE"
    echo ""
    
    # Define audit tasks (bash 3 compatible)
    agents=("architect" "reviewer" "tester" "documentation" "devops")
    
    # Spawn all agents
    for agent in "${agents[@]}"; do
        case $agent in
            "architect")
                task="Review repository architecture, .claude directory structure, and design patterns"
                ;;
            "reviewer")
                task="Audit code quality, security, and compliance with project rules"
                ;;
            "tester")
                task="Validate test coverage, test quality, and testing best practices"
                ;;
            "documentation")
                task="Verify documentation completeness and accuracy"
                ;;
            "devops")
                task="Check CI/CD configuration and deployment readiness"
                ;;
        esac
        
        if [ "$MODE" = "iterm" ]; then
            spawn_iterm "$agent" "$task"
        else
            spawn_headless "$agent" "$task"
        fi
        
        sleep 1  # Small delay between spawns
    done
    
    if [ "$MODE" = "headless" ]; then
        echo ""
        echo "📊 All agents spawned in background"
        echo "Monitor logs with: tail -f /tmp/claude-*.log"
        echo ""
        echo "Active agent processes:"
        ps aux | grep "[c]laude -p" | awk '{print $2, $11, $12, $13, $14}'
    else
        echo ""
        echo "✅ All agents spawned in separate iTerm2 windows"
    fi
}

function custom_parallel() {
    local tasks=$1
    echo "🎯 Custom Parallel Execution"
    echo "Tasks: $tasks"
    echo ""
    
    IFS=',' read -ra TASK_LIST <<< "$tasks"
    
    for task in "${TASK_LIST[@]}"; do
        IFS=':' read -r agent task_desc <<< "$task"
        
        if [ "$MODE" = "iterm" ]; then
            spawn_iterm "$agent" "$task_desc"
        else
            spawn_headless "$agent" "$task_desc"
        fi
        
        sleep 0.5
    done
}

# Main execution
case "${1:-help}" in
    "audit")
        parallel_audit
        ;;
    
    "custom")
        custom_parallel "$2"
        ;;
    
    "monitor")
        echo "📊 Monitoring active agents:"
        echo ""
        
        # Show running processes
        echo "Running Claude processes:"
        ps aux | grep "[c]laude -p" | awk '{print "PID:", $2, "Started:", $9}'
        
        echo ""
        echo "Recent logs:"
        ls -lt /tmp/claude-*.log 2>/dev/null | head -10
        ;;
    
    "kill-all")
        echo "🛑 Stopping all Claude agents..."
        pkill -f "claude.*-p.*Agent"
        echo "✅ All agents stopped"
        ;;
    
    *)
        echo "Usage: $0 [headless|iterm] <command> [args]"
        echo ""
        echo "Commands:"
        echo "  audit              - Run parallel audit with all agents"
        echo "  custom <tasks>     - Run custom parallel tasks"
        echo "  monitor            - Show running agents and logs"
        echo "  kill-all           - Stop all running agents"
        echo ""
        echo "Examples:"
        echo "  $0 headless audit"
        echo "  $0 iterm audit"
        echo "  $0 headless custom 'architect:design API,developer:implement auth,tester:write tests'"
        echo "  $0 monitor"
        exit 1
        ;;
esac