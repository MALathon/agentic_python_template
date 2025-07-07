#!/bin/bash

# Launch script for Triage Agent

echo "📋 Launching Triage Agent..."
echo "Role: Issue management, prioritization, and task assignment"
echo ""

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
    echo "Error: Claude CLI is not installed."
    echo "Please install Claude Code from: https://claude.ai/code"
    exit 1
fi

# Check if command file exists
if [ ! -f ".claude/commands/triage.md" ]; then
    echo "Error: Triage command file not found at .claude/commands/triage.md"
    echo "Please run ./scripts/setup-agents.sh first"
    exit 1
fi

# Check if task directory exists
if [ -d ".claude/tasks" ]; then
    # Count existing task files
    task_count=$(find .claude/tasks -name "*.md" -not -name "README.md" | wc -l)
    echo "📊 Current task count: $task_count"
else
    echo "⚠️  Warning: Task directory not found at .claude/tasks"
fi
echo ""

# Provide helpful context
echo "The Triage Agent will help you with:"
echo "  • Analyzing and categorizing issues"
echo "  • Prioritizing tasks based on impact and effort"
echo "  • Assigning work to appropriate agents"
echo "  • Tracking project progress"
echo "  • Managing technical debt"
echo ""
echo "Example commands:"
echo "  - 'Triage these issues: [list of bugs and features]'"
echo "  - 'Prioritize the current backlog'"
echo "  - 'Assign tasks for the next sprint'"
echo "  - 'Review and update task progress'"
echo ""

# Launch Claude with the triage command
echo "Starting Claude session..."
echo "Run '/triage' after Claude starts"
echo ""
claude --dangerously-skip-permissions