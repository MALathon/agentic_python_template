#!/bin/bash

# Launch script for Tester Agent

echo "🧪 Launching Tester Agent..."
echo "Role: Comprehensive testing and quality assurance"
echo ""

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
    echo "Error: Claude CLI is not installed."
    echo "Please install Claude Code from: https://claude.ai/code"
    exit 1
fi

# Check if command file exists
if [ ! -f ".claude/commands/tester.md" ]; then
    echo "Error: Tester command file not found at .claude/commands/tester.md"
    echo "Please run ./scripts/setup-agents.sh first"
    exit 1
fi

# Check test framework installation
if command -v pytest &> /dev/null; then
    echo "✓ pytest is installed"
else
    echo "⚠️  Warning: pytest not found. Install with: pip install pytest pytest-cov"
fi
echo ""

# Provide helpful context
echo "The Tester Agent will help you with:"
echo "  • Writing comprehensive test suites"
echo "  • Identifying edge cases and test scenarios"
echo "  • Creating unit, integration, and E2E tests"
echo "  • Improving test coverage"
echo "  • Performance and load testing"
echo ""
echo "Example commands:"
echo "  - 'Write unit tests for the UserService class'"
echo "  - 'Create integration tests for the REST API'"
echo "  - 'Identify edge cases for the payment processing system'"
echo "  - 'Set up performance tests for the data pipeline'"
echo ""

# Launch Claude with the tester command
claude code --command tester