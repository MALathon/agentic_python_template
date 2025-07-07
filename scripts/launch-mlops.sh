#!/bin/bash

# Launch script for MLOps Agent

echo "🤖 Launching MLOps Agent..."
echo "Role: Machine Learning Operations and ML Infrastructure"
echo ""

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
    echo "Error: Claude CLI is not installed."
    echo "Please install Claude Code from: https://claude.ai/code"
    exit 1
fi

# Check if command file exists
if [ ! -f ".claude/commands/mlops.md" ]; then
    echo "Error: MLOps command file not found at .claude/commands/mlops.md"
    echo "Please run ./scripts/setup-agents.sh first"
    exit 1
fi

# Check for common ML tools (optional)
echo "Checking ML environment..."
if command -v python3 &> /dev/null; then
    echo "✓ Python3 found"
fi
if command -v docker &> /dev/null; then
    echo "✓ Docker found"
fi
if command -v kubectl &> /dev/null; then
    echo "✓ Kubectl found"
fi
echo ""

# Provide helpful context
echo "The MLOps Agent will help you with:"
echo "  • Setting up ML training pipelines"
echo "  • Implementing experiment tracking"
echo "  • Deploying models to production"
echo "  • Monitoring model performance"
echo "  • Managing ML infrastructure"
echo ""
echo "Example commands:"
echo "  - 'Set up MLflow experiment tracking for this project'"
echo "  - 'Create a training pipeline for the recommendation model'"
echo "  - 'Deploy the sentiment analysis model to Kubernetes'"
echo "  - 'Implement drift detection for production models'"
echo "  - 'Optimize GPU usage for model training'"
echo ""

# Launch Claude with the mlops command
echo "Starting Claude session..."
echo "Run '/mlops' after Claude starts"
echo ""
claude --dangerously-skip-permissions