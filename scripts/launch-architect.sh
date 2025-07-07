#!/bin/bash

# Launch script for Architect Agent

echo "🏛️  Launching Architect Agent..."
echo "Role: System design and architectural decisions"
echo ""

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
    echo "Error: Claude CLI is not installed."
    echo "Please install Claude Code from: https://claude.ai/code"
    exit 1
fi

# Check if command file exists
if [ ! -f ".claude/commands/architect.md" ]; then
    echo "Error: Architect command file not found at .claude/commands/architect.md"
    echo "Please run ./scripts/setup-agents.sh first"
    exit 1
fi

# Provide helpful context
echo "The Architect Agent will help you with:"
echo "  • System architecture design"
echo "  • Technology selection and evaluation"
echo "  • API and interface design"
echo "  • Design patterns and best practices"
echo "  • Technical documentation and ADRs"
echo ""
echo "Example commands:"
echo "  - 'Design a microservices architecture for an e-commerce platform'"
echo "  - 'Evaluate database options for high-volume time series data'"
echo "  - 'Create API design for user authentication system'"
echo "  - 'Review and improve current architecture'"
echo ""

# Launch Claude with the architect command
echo "Starting Claude session..."
echo "Run '/architect' after Claude starts"
echo ""
claude --dangerously-skip-permissions