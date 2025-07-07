#!/bin/bash

# Launch script for Scrum Master Agent

echo "🏃 Launching Scrum Master Agent..."
echo "Role: Agile facilitation and team empowerment"
echo ""

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
    echo "Error: Claude CLI is not installed."
    echo "Please install Claude Code from: https://claude.ai/code"
    exit 1
fi

# Check if command file exists
if [ ! -f ".claude/commands/scrum.md" ]; then
    echo "Error: Scrum Master command file not found at .claude/commands/scrum.md"
    exit 1
fi

# Provide helpful context
echo "The Scrum Master Agent will help you with:"
echo "  • Facilitating scrum ceremonies"
echo "  • Running effective standups"
echo "  • Sprint planning and retrospectives"
echo "  • Removing team impediments"
echo "  • Tracking team velocity and health"
echo ""
echo "Example commands:"
echo "  - 'Facilitate sprint planning for authentication feature'"
echo "  - 'Run daily standup and identify blockers'"
echo "  - 'Lead retrospective for Sprint 5'"
echo "  - 'Create sprint burndown chart'"
echo "  - 'Help team improve velocity'"
echo ""

# Launch Claude with the scrum command
echo "Starting Claude session..."
echo "Run '/scrum' after Claude starts"
echo ""
claude --dangerously-skip-permissions