#!/bin/bash

# Launch script for Developer Agent

echo "👨‍💻 Launching Developer Agent..."
echo "Role: Code implementation and feature development"
echo ""

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
    echo "Error: Claude CLI is not installed."
    echo "Please install Claude Code from: https://claude.ai/code"
    exit 1
fi

# Check if command file exists
if [ ! -f ".claude/commands/developer.md" ]; then
    echo "Error: Developer command file not found at .claude/commands/developer.md"
    echo "Please run ./scripts/setup-agents.sh first"
    exit 1
fi

# Check if virtual environment exists
if [ -d "venv" ]; then
    echo "💡 Tip: Make sure your virtual environment is activated:"
    echo "   source venv/bin/activate"
    echo ""
fi

# Provide helpful context
echo "The Developer Agent will help you with:"
echo "  • Feature implementation"
echo "  • Bug fixes and debugging"
echo "  • Code refactoring"
echo "  • Performance optimization"
echo "  • Writing clean, maintainable code"
echo ""
echo "Example commands:"
echo "  - 'Implement user registration with email verification'"
echo "  - 'Fix the memory leak in the data processing module'"
echo "  - 'Refactor the payment service to use strategy pattern'"
echo "  - 'Add caching to improve API response times'"
echo ""

# Launch Claude with the developer command
echo "Starting Claude session..."
echo "Run '/developer' after Claude starts"
echo ""
claude --dangerously-skip-permissions