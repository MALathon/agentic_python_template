#!/bin/bash

# Launch script for Reviewer Agent

echo "🔍 Launching Reviewer Agent..."
echo "Role: Code review and best practices enforcement"
echo ""

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
    echo "Error: Claude CLI is not installed."
    echo "Please install Claude Code from: https://claude.ai/code"
    exit 1
fi

# Check if command file exists
if [ ! -f ".claude/commands/reviewer.md" ]; then
    echo "Error: Reviewer command file not found at .claude/commands/reviewer.md"
    echo "Please run ./scripts/setup-agents.sh first"
    exit 1
fi

# Check code quality tools
echo "Checking code quality tools..."
command -v black &> /dev/null && echo "✓ black (formatter)" || echo "✗ black not found"
command -v flake8 &> /dev/null && echo "✓ flake8 (linter)" || echo "✗ flake8 not found"
command -v mypy &> /dev/null && echo "✓ mypy (type checker)" || echo "✗ mypy not found"
echo ""

# Provide helpful context
echo "The Reviewer Agent will help you with:"
echo "  • Comprehensive code reviews"
echo "  • Security vulnerability identification"
echo "  • Performance analysis and optimization suggestions"
echo "  • Best practices and design pattern recommendations"
echo "  • Documentation quality assessment"
echo ""
echo "Example commands:"
echo "  - 'Review the authentication module for security issues'"
echo "  - 'Check the API endpoints for best practices'"
echo "  - 'Analyze the data processing pipeline for performance'"
echo "  - 'Review the entire codebase for consistency'"
echo ""

# Launch Claude with the reviewer command
claude code --command reviewer