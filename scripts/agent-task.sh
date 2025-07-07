#!/bin/bash

# Simple wrapper for agents to manage their tasks
# Usage: ./agent-task.sh <action> [args]

ACTION=$1
AGENT=${AGENT:-unknown}
TASK_ID=${TASK_ID:-$(echo $AGENT | tr '[:lower:]' '[:upper:]')-$(date +%s | tail -c 4)}

case "$ACTION" in
    "start")
        # Agent starting a task
        DESCRIPTION=${2:-"Working on assigned task"}
        echo "📝 Creating task $TASK_ID"
        python scripts/taskboard-helper.py add "$AGENT" "$TASK_ID" P1 "$DESCRIPTION"
        echo "▶️  Starting task $TASK_ID"
        python scripts/taskboard-helper.py start "$TASK_ID"
        ;;
    
    "complete")
        # Agent completing their task
        echo "✅ Completing task $TASK_ID"
        python scripts/taskboard-helper.py complete "$TASK_ID"
        ;;
    
    "update")
        # Move task to review or testing
        STATUS=$2
        echo "📍 Moving task $TASK_ID to $STATUS"
        python scripts/taskboard-helper.py "$STATUS" "$TASK_ID"
        ;;
    
    *)
        echo "Usage: $0 <start|complete|update> [args]"
        echo ""
        echo "Environment variables:"
        echo "  AGENT - Your agent name (e.g., architect, developer)"
        echo "  TASK_ID - Your task ID (auto-generated if not set)"
        echo ""
        echo "Examples:"
        echo "  AGENT=architect ./agent-task.sh start 'Design authentication system'"
        echo "  AGENT=architect TASK_ID=ARCH-001 ./agent-task.sh complete"
        ;;
esac