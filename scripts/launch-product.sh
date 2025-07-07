#\!/bin/bash

# Launch script for '${agent^}' Agent

echo "🚀 Launching '${agent^}' Agent..."
echo "Role: See agent description"
echo ""

# Check if Claude CLI is installed
if \! command -v claude &> /dev/null; then
    echo "Error: Claude CLI is not installed."
    echo "Please install Claude Code from: https://claude.ai/code"
    exit 1
fi

# Check if command file exists
if [ \! -f ".claude/commands/'$agent'.md" ]; then
    echo "Error: '$agent' command file not found at .claude/commands/'$agent'.md"
    exit 1
fi

echo "Starting Claude session..."
echo "Run '/'$agent'' after Claude starts"
echo ""
claude --dangerously-skip-permissions
