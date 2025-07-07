#!/bin/bash

# Launch script for DevOps Agent

echo "🚀 Launching DevOps Agent..."
echo "Role: Deployment pipelines and infrastructure automation"
echo ""

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
    echo "Error: Claude CLI is not installed."
    echo "Please install Claude Code from: https://claude.ai/code"
    exit 1
fi

# Check if command file exists
if [ ! -f ".claude/commands/devops.md" ]; then
    echo "Error: DevOps command file not found at .claude/commands/devops.md"
    echo "Please run ./scripts/setup-agents.sh first"
    exit 1
fi

# Check for DevOps tools (optional)
echo "Checking DevOps environment..."
if command -v docker &> /dev/null; then
    echo "✓ Docker found"
fi
if command -v kubectl &> /dev/null; then
    echo "✓ Kubectl found"
fi
if command -v terraform &> /dev/null; then
    echo "✓ Terraform found"
fi
if command -v git &> /dev/null; then
    echo "✓ Git found"
fi
echo ""

# Provide helpful context
echo "The DevOps Agent will help you with:"
echo "  • Setting up CI/CD pipelines"
echo "  • Docker containerization"
echo "  • Kubernetes deployments"
echo "  • Infrastructure as Code"
echo "  • Monitoring and logging setup"
echo ""
echo "Example commands:"
echo "  - 'Set up GitHub Actions CI/CD pipeline'"
echo "  - 'Create Dockerfile for Python application'"
echo "  - 'Deploy to Kubernetes with auto-scaling'"
echo "  - 'Set up Terraform for AWS infrastructure'"
echo "  - 'Configure Prometheus monitoring'"
echo ""

# Launch Claude with the devops command
echo "Starting Claude session..."
echo "Run '/devops' after Claude starts"
echo ""
claude --dangerously-skip-permissions