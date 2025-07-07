#!/bin/bash

# Universal Agent Launch Script
# Usage: ./launch-agent.sh <agent-name>

AGENT=$1

if [ -z "$AGENT" ]; then
    echo "Usage: $0 <agent-name>"
    echo ""
    echo "Available agents:"
    echo "  architect, developer, tester, reviewer, documentation"
    echo "  mlops, devops, project, product, portfolio"
    echo "  research, ux, customer, scrum, triage"
    echo ""
    echo "Example: $0 architect"
    exit 1
fi

# Validate agent name
VALID_AGENTS="architect developer tester reviewer documentation mlops devops project product portfolio research ux customer scrum triage"
if [[ ! " $VALID_AGENTS " =~ " $AGENT " ]]; then
    echo "Error: Unknown agent '$AGENT'"
    echo "Valid agents: $VALID_AGENTS"
    exit 1
fi

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
    echo "Error: Claude CLI is not installed."
    echo "Please install Claude Code from: https://claude.ai/code"
    exit 1
fi

# Check if command file exists
if [ ! -f ".claude/commands/${AGENT}.md" ]; then
    echo "Error: Agent command file not found at .claude/commands/${AGENT}.md"
    exit 1
fi

# Set agent-specific emoji and description
case $AGENT in
    "architect")
        EMOJI="🏛️"
        DESC="System design and architecture"
        ;;
    "developer")
        EMOJI="💻"
        DESC="Implementation and coding"
        ;;
    "tester")
        EMOJI="🧪"
        DESC="Quality assurance and testing"
        ;;
    "reviewer")
        EMOJI="🔍"
        DESC="Code review and quality"
        ;;
    "documentation")
        EMOJI="📚"
        DESC="Technical documentation"
        ;;
    "mlops")
        EMOJI="🤖"
        DESC="ML infrastructure and operations"
        ;;
    "devops")
        EMOJI="🚀"
        DESC="CI/CD and deployment"
        ;;
    "project")
        EMOJI="📋"
        DESC="Project planning and management"
        ;;
    "product")
        EMOJI="📦"
        DESC="Product strategy and requirements"
        ;;
    "portfolio")
        EMOJI="📊"
        DESC="Multi-project oversight"
        ;;
    "research")
        EMOJI="🔬"
        DESC="Technology research and analysis"
        ;;
    "ux")
        EMOJI="🎨"
        DESC="User experience design"
        ;;
    "customer")
        EMOJI="👥"
        DESC="User feedback and validation"
        ;;
    "scrum")
        EMOJI="🏃"
        DESC="Agile facilitation"
        ;;
    "triage")
        EMOJI="🎯"
        DESC="Task orchestration and routing"
        ;;
esac

echo "$EMOJI Launching ${AGENT^} Agent..."
echo "Role: $DESC"
echo ""

# Provide helpful context
echo "The ${AGENT^} Agent will help you with:"

case $AGENT in
    "architect")
        echo "  • System design and architecture decisions"
        echo "  • Design patterns and best practices"
        echo "  • API design and integration planning"
        echo "  • Technology selection and evaluation"
        ;;
    "developer")
        echo "  • Writing clean, maintainable code"
        echo "  • Implementing features with TDD"
        echo "  • Following SOLID principles"
        echo "  • Code refactoring and optimization"
        ;;
    "tester")
        echo "  • Creating comprehensive test suites"
        echo "  • Test-driven development (TDD)"
        echo "  • Test coverage improvement"
        echo "  • Performance and security testing"
        ;;
    "reviewer")
        echo "  • Code quality and standards review"
        echo "  • Security vulnerability detection"
        echo "  • Performance optimization suggestions"
        echo "  • Best practices enforcement"
        ;;
    *)
        echo "  • See .claude/commands/${AGENT}.md for details"
        ;;
esac

echo ""
echo "Starting Claude session..."
echo "Run '/${AGENT}' after Claude starts to load the agent role"
echo ""

# Launch Claude with the agent-specific flag
claude --dangerously-skip-permissions