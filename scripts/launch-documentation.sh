#!/bin/bash

# Launch script for Documentation Agent

echo "📚 Launching Documentation Agent..."
echo "Role: Documentation integrity and QA verification"
echo ""

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
    echo "Error: Claude CLI is not installed."
    echo "Please install Claude Code from: https://claude.ai/code"
    exit 1
fi

# Check if command file exists
if [ ! -f ".claude/commands/documentation.md" ]; then
    echo "Error: Documentation command file not found at .claude/commands/documentation.md"
    echo "Please run ./scripts/setup-agents.sh first"
    exit 1
fi

# Provide helpful context
echo "The Documentation Agent will help you with:"
echo "  • Reviewing code changes for documentation needs"
echo "  • Updating README and other documentation"
echo "  • Ensuring examples and guides are current"
echo "  • Validating repository structure"
echo "  • Maintaining changelog and release notes"
echo ""
echo "Example commands:"
echo "  - 'Review recent changes and update documentation'"
echo "  - 'Audit all documentation for accuracy'"
echo "  - 'Create documentation for the new feature'"
echo "  - 'Verify all examples in the docs still work'"
echo ""

# Launch Claude with the documentation command
echo "Starting Claude session..."
echo "Run '/documentation' after Claude starts"
echo ""
claude --dangerously-skip-permissions