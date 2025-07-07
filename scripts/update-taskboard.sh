#!/bin/bash

# Taskboard Update Script
# Helper script for agents to update the taskboard

ACTION=$1
AGENT=$2
TASK_ID=$3
shift 3
DESCRIPTION=""$@""

TASKBOARD=".claude/tasks/taskboard.md"
DATE=$(date +%Y-%m-%d)

# Create backup
cp "$TASKBOARD" "${TASKBOARD}.bak"

case "$ACTION" in
    "add")
        # Add new task to backlog
        PRIORITY=${PRIORITY:-P2}
        NEW_TASK="### [$TASK_ID] $DESCRIPTION\n- **Priority**: $PRIORITY\n- **Assigned**: @$AGENT\n- **Created**: $DATE\n- **Updated**: $DATE\n- **Status**: Backlog\n"
        
        # Add to appropriate priority section
        if [ "$PRIORITY" = "P1" ]; then
            sed -i '' '/### High Priority (P1)/a\
'"$NEW_TASK" "$TASKBOARD"
        else
            sed -i '' '/### Medium Priority (P2)/a\
'"$NEW_TASK" "$TASKBOARD"
        fi
        echo "✅ Added task $TASK_ID to backlog"
        ;;
    
    "start")
        # Move task to in progress
        # First, extract the task
        TASK_CONTENT=$(sed -n "/### \[$TASK_ID\]/,/^$/p" "$TASKBOARD")
        
        # Remove from current location
        sed -i '' "/### \[$TASK_ID\]/,/^$/d" "$TASKBOARD"
        
        # Update status and add to in progress
        UPDATED_TASK=$(echo "$TASK_CONTENT" | sed "s/Status: .*/Status: In Progress/")
        sed -i '' '/### In Progress/a\
'"$UPDATED_TASK" "$TASKBOARD"
        
        echo "✅ Moved task $TASK_ID to In Progress"
        ;;
    
    "complete")
        # Move task to completed
        TASK_CONTENT=$(sed -n "/### \[$TASK_ID\]/,/^$/p" "$TASKBOARD")
        sed -i '' "/### \[$TASK_ID\]/,/^$/d" "$TASKBOARD"
        
        # Update status and add to completed
        UPDATED_TASK=$(echo "$TASK_CONTENT" | sed "s/Status: .*/Status: Done/" | sed "s/Updated: .*/Updated: $DATE/")
        sed -i '' '/### Recent Completions/a\
'"$UPDATED_TASK" "$TASKBOARD"
        
        echo "✅ Completed task $TASK_ID"
        ;;
    
    "update")
        # Update task description or status
        sed -i '' "/### \[$TASK_ID\]/,/^$/ s/Updated: .*/Updated: $DATE/" "$TASKBOARD"
        if [ -n "$DESCRIPTION" ]; then
            sed -i '' "/### \[$TASK_ID\]/,/^$/ s/Description: .*/Description: $DESCRIPTION/" "$TASKBOARD"
        fi
        echo "✅ Updated task $TASK_ID"
        ;;
    
    *)
        echo "Usage: $0 <action> <agent> <task-id> [description]"
        echo ""
        echo "Actions:"
        echo "  add      - Add new task to backlog"
        echo "  start    - Move task to in progress"
        echo "  complete - Mark task as done"
        echo "  update   - Update task details"
        echo ""
        echo "Environment variables:"
        echo "  PRIORITY - Task priority (P0/P1/P2/P3) for 'add' action"
        echo ""
        echo "Examples:"
        echo "  $0 add architect ARCH-001 'Design authentication system'"
        echo "  $0 start architect ARCH-001"
        echo "  $0 complete architect ARCH-001"
        exit 1
        ;;
esac