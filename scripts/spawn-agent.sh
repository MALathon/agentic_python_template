#!/bin/bash

# Spawn a Claude agent in headless mode
# Usage: ./spawn-agent.sh <agent-type> "<task>"

AGENT_TYPE=$1
TASK=$2

if [ -z "$AGENT_TYPE" ] || [ -z "$TASK" ]; then
    echo "Usage: $0 <agent-type> \"<task>\""
    echo "Agent types: architect, developer, tester, reviewer"
    exit 1
fi

# Construct the prompt to load the agent and execute the task
PROMPT="First, load your role by running the /$AGENT_TYPE command. Then complete this task: $TASK"

echo "🚀 Spawning $AGENT_TYPE agent in headless mode..."
echo "📋 Task: $TASK"
echo ""

# Run Claude in headless mode with the agent task
claude -p "$PROMPT" --verbose